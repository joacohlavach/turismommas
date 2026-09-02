-- ============================================================================
-- Base de datos de reseñas — M+ Martin Sacavino Turismo
--
-- Cómo usarlo:
--   1. Entrá a tu proyecto en Supabase.
--   2. Menú lateral → SQL Editor → New query.
--   3. Pegá TODO este archivo y apretá "Run".
--
-- IMPORTANTE: abajo de todo, en el paso 5, tenés que poner tu email.
-- Se puede correr más de una vez sin romper nada.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 1. La tabla de reseñas
-- ----------------------------------------------------------------------------
create table if not exists public.reviews (
  id          uuid        primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),

  -- Nombre de quien deja la reseña. Si lo deja vacío, la web manda "Cliente M+".
  name        text        not null default 'Cliente M+'
                          check (char_length(name) between 1 and 80),

  -- Puntaje de 1 a 5 estrellas.
  rating      smallint    not null check (rating between 1 and 5),

  -- El texto de la reseña. Obligatorio, con un máximo para que nadie
  -- pegue un libro entero.
  body        text        not null check (char_length(body) between 1 and 600),

  -- Foto opcional. Solo se aceptan fotos subidas a nuestro propio storage
  -- o imágenes que ya viven en la web: esto evita que alguien meta un link
  -- raro apuntando a otro lado.
  photo_url   text        check (
                photo_url is null
                or photo_url ~ '^assets/[A-Za-z0-9._-]+$'
                or photo_url ~ '^https://[a-z0-9-]+\.supabase\.co/storage/v1/object/public/review-photos/[A-Za-z0-9._/-]+$'
              ),

  -- false = está pendiente y NO se ve en la web. true = publicada.
  approved    boolean     not null default false,

  -- true solo para las 4 reseñas de ejemplo con las que arranca la web.
  is_seed     boolean     not null default false
);

-- Índice para que la consulta de la web (aprobadas, más nuevas primero)
-- sea instantánea aunque haya miles de reseñas.
create index if not exists reviews_approved_created_idx
  on public.reviews (approved, created_at desc);


-- ----------------------------------------------------------------------------
-- 2. Quién es administrador
--
--    Supabase, por defecto, deja que cualquiera se cree un usuario. Para que
--    tener un usuario NO alcance para tocar las reseñas, mandan los emails
--    que estén cargados en esta tabla — y solo se puede editar desde el
--    panel de Supabase, nunca desde la web.
-- ----------------------------------------------------------------------------
create table if not exists public.admins (
  email text primary key
);

alter table public.admins enable row level security;   -- sin políticas = nadie entra desde la web

-- Esta función corre con permisos elevados: es la única forma de mirar la
-- tabla admins desde una política sin abrirla al público.
create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from public.admins where email = auth.jwt() ->> 'email'
  );
$$;

revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;


-- ----------------------------------------------------------------------------
-- 3. Permisos de las reseñas (Row Level Security)
--
--    Esta es la parte importante: la clave "anon" que va en el código de la
--    web es pública, así que las reglas de abajo son las que definen qué
--    puede hacer realmente un visitante.
-- ----------------------------------------------------------------------------
alter table public.reviews enable row level security;

drop policy if exists "visitantes leen aprobadas"  on public.reviews;
drop policy if exists "admin lee todas"            on public.reviews;
drop policy if exists "visitantes envian resenas"  on public.reviews;
drop policy if exists "admin edita"                on public.reviews;
drop policy if exists "admin borra"                on public.reviews;

-- Un visitante cualquiera SOLO ve las aprobadas.
create policy "visitantes leen aprobadas"
  on public.reviews for select
  to anon
  using (approved = true);

-- Vos, logueado en el panel y cargado en la tabla admins, ves todas.
create policy "admin lee todas"
  on public.reviews for select
  to authenticated
  using (public.is_admin());

-- Un visitante puede mandar una reseña, pero NO puede auto-aprobarse
-- ni hacerse pasar por una reseña de ejemplo.
create policy "visitantes envian resenas"
  on public.reviews for insert
  to anon
  with check (approved = false and is_seed = false);

-- Solo un admin aprueba, oculta o borra.
create policy "admin edita"
  on public.reviews for update
  to authenticated
  using (public.is_admin()) with check (public.is_admin());

create policy "admin borra"
  on public.reviews for delete
  to authenticated
  using (public.is_admin());


-- ----------------------------------------------------------------------------
-- 4. Storage para las fotos que adjuntan los clientes
--
--    Si te da error de permisos en esta sección, creá el bucket a mano:
--    Storage → New bucket → nombre "review-photos" → marcá "Public bucket".
-- ----------------------------------------------------------------------------
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'review-photos',
  'review-photos',
  true,
  5242880,                                        -- 5 MB por archivo
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update
  set public             = excluded.public,
      file_size_limit    = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "visitantes suben fotos de resena" on storage.objects;
drop policy if exists "cualquiera ve fotos de resena"    on storage.objects;

create policy "visitantes suben fotos de resena"
  on storage.objects for insert
  to anon
  with check (bucket_id = 'review-photos');

create policy "cualquiera ve fotos de resena"
  on storage.objects for select
  to public
  using (bucket_id = 'review-photos');


-- ----------------------------------------------------------------------------
-- 5. ⚠️ PONÉ TU EMAIL ACÁ ⚠️
--
--    Tiene que ser exactamente el mismo email del usuario que vas a crear en
--    Supabase (Authentication → Users → Add user). Sin esto, el panel te deja
--    entrar pero no te muestra nada.
-- ----------------------------------------------------------------------------
insert into public.admins (email)
values ('CAMBIAR-POR-TU-EMAIL@ejemplo.com')
on conflict (email) do nothing;


-- ----------------------------------------------------------------------------
-- 6. Las 4 reseñas de ejemplo
--
--    Arrancan publicadas para que la web no se vea vacía el primer día.
--    A medida que entren 4 reseñas reales aprobadas, estas dejan de mostrarse
--    solas (no hace falta borrarlas).
-- ----------------------------------------------------------------------------
insert into public.reviews (name, rating, body, photo_url, approved, is_seed)
select * from (values
  ('Nicolás Ferreyra', 5::smallint,
   'Vinimos ocho amigos por la despedida y no tuvimos que pensar en nada. Traslados, cancha y la fiesta, todo resuelto.',
   'assets/p11.jpg', true, true),

  ('Diego Sosa', 5::smallint,
   'Tres días de golf impecables. Nos consiguieron horarios en dos canchas y un asado que fue el mejor momento del viaje.',
   null, true, true),

  ('Martina Ruiz', 4::smallint,
   'Muy atentos de principio a fin. Nos armaron el fin de semana a medida y estuvieron disponibles todo el tiempo.',
   null, true, true),

  ('Grupo Estadio Español', 5::smallint,
   'Interclub de tenis en Córdoba: organización, comidas y clima de grupo. Volvemos el año que viene.',
   'assets/p16.jpg', true, true)
) as seed(name, rating, body, photo_url, approved, is_seed)
where not exists (select 1 from public.reviews where is_seed = true);
