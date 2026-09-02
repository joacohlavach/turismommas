# Conectar las reseñas a la base de datos

Guía paso a paso. Son unos 15 minutos y no hace falta saber programar.
Todo lo que se usa acá es gratis y no pide tarjeta de crédito.

---

## Qué vas a tener cuando termines

- Las reseñas que dejan los clientes **se guardan de verdad** (hoy se pierden al recargar).
- Ninguna reseña aparece en la web hasta que **vos la aprobás**.
- Un panel propio en `admin.html` para aprobar, ocultar o borrar, que podés usar desde el celular.
- Las 4 reseñas de ejemplo se van solas a medida que entran 4 reales aprobadas.

---

## Paso 1 — Crear el proyecto en Supabase

1. Entrá a **https://supabase.com** y creá una cuenta (podés entrar con GitHub).
2. **New project**.
3. Completá:
   - **Name**: `turismommas` (o el que quieras)
   - **Database Password**: generá una y **guardala en algún lado**. No la vas a necesitar para esto, pero es la contraseña maestra de la base.
   - **Region**: elegí `South America (São Paulo)`, que es la más cerca.
4. **Create new project** y esperá un minuto a que termine de armarse.

---

## Paso 2 — Crear las tablas

1. En el menú de la izquierda: **SQL Editor** → **New query**.
2. Abrí el archivo `db/schema.sql` de este repositorio y copiá **todo** el contenido.
3. Pegalo en el editor.
4. **Antes de ejecutarlo**, buscá casi al final la línea que dice:

   ```sql
   values ('CAMBIAR-POR-TU-EMAIL@ejemplo.com')
   ```

   Cambiala por tu email real. Por ejemplo:

   ```sql
   values ('joaquin.hlavach@icloud.com')
   ```

   > Este email es el que te va a dar permiso de administrador. Tiene que ser
   > **exactamente el mismo** que vas a usar en el Paso 4.

5. Apretá **Run**. Tendría que decir *Success*.

---

## Paso 3 — Copiar los datos de conexión a la web

1. En Supabase: **Project Settings** (el engranaje) → **API**.
2. Vas a ver dos datos:
   - **Project URL** → algo como `https://abcdefgh.supabase.co`
   - **Project API keys** → la clave **`anon` `public`** (es larga y empieza con `eyJ`)
3. Abrí el archivo **`config.js`** de este repositorio y pegá los dos datos:

   ```js
   window.MM_CONFIG = {
     SUPABASE_URL: 'https://abcdefgh.supabase.co',
     SUPABASE_ANON_KEY: 'eyJhbGciOi...(la clave larga)...'
   };
   ```

4. Guardá el archivo y subilo a GitHub (o pedímelo a mí y lo hago).

> **¿Es seguro que esa clave esté a la vista en la web?** Sí. La clave `anon`
> está pensada para eso. Lo que protege los datos son los permisos que quedaron
> definidos en el Paso 2: un visitante solo puede leer reseñas aprobadas y
> mandar una nueva, nada más.
>
> La que **nunca** hay que poner acá es la clave `service_role`.

---

## Paso 4 — Crear tu usuario del panel

1. En Supabase: **Authentication** → **Users** → **Add user** → **Create new user**.
2. Poné:
   - **Email**: el mismo que cargaste en el Paso 2.
   - **Password**: la que vayas a usar para entrar al panel.
   - Marcá **Auto Confirm User** (si no, te pide confirmar por mail).
3. **Create user**.

---

## Paso 5 — Cerrar el registro público (importante)

Por defecto Supabase deja que cualquiera se cree un usuario. No alcanza para
tocar tus reseñas (para eso hay que estar en la tabla `admins`), pero conviene
cerrarlo igual:

1. **Authentication** → **Sign In / Providers** → **Email**.
2. Desactivá **"Allow new users to sign up"**.
3. Guardá.

---

## Paso 6 — Probar

1. Abrí tu web y dejá una reseña de prueba con estrellas y texto.
   Te tiene que decir *"¡Gracias por tu reseña!"* — y **no** aparecer todavía en el carrusel.
2. Andá a `tu-web/admin.html`, entrá con el email y la contraseña del Paso 4.
3. En **Pendientes** tendría que estar tu reseña de prueba. Apretá **Publicar**.
4. Volvé a la web, recargá, y ahí sí tiene que aparecer.

---

## Cómo se usa en el día a día

- **Te dejaron una reseña**: entrás a `admin.html`, la ves en *Pendientes* y decidís.
- **Publicar**: pasa a verse en la web.
- **Ocultar de la web**: la saca sin borrarla, por si después cambiás de idea.
- **Eliminar**: la borra para siempre.
- Las reseñas marcadas como **Ejemplo** son las 4 iniciales. Dejan de mostrarse
  solas cuando haya 4 reales publicadas, pero también las podés ocultar a mano.

---

## Si algo no anda

| Qué pasa | Qué revisar |
|---|---|
| La web muestra siempre las mismas 4 reseñas | `config.js` quedó vacío o mal pegado |
| Entro al panel pero no veo ninguna reseña | Tu email no quedó cargado en la tabla `admins` (Paso 2) |
| No puedo entrar al panel | Revisá el usuario en Authentication → Users |
| No se sube la foto | Storage → que exista el bucket `review-photos` y esté marcado como público |
| "No pudimos enviar tu reseña" | Fijate que el SQL del Paso 2 haya corrido completo |

Los límites del plan gratis de Supabase (500 MB de base y 1 GB de fotos) te
alcanzan para muchísimos años de reseñas.
