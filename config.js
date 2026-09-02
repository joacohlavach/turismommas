/* ============================================================================
   CONEXIÓN CON LA BASE DE RESEÑAS

   Este es el ÚNICO archivo que tenés que tocar para conectar la web con
   Supabase. Lo usan tanto la landing (index.html) como el panel (admin.html).

   Dónde saco estos dos datos:
     Supabase → tu proyecto → Project Settings → API Keys
       SUPABASE_URL       = "Project URL"        (ej: https://abcdefgh.supabase.co)
       SUPABASE_ANON_KEY  = la "Publishable key"  (empieza con "sb_publishable_")

   Mientras queden vacíos, la web sigue andando: muestra las 4 reseñas de
   ejemplo y el formulario avisa que todavía no está conectado.

   ⚠️ La "Publishable key" es pública a propósito: va en el código de la
   página y cualquiera puede verla. Eso NO es un problema — lo que protege
   los datos son los permisos definidos en db/schema.sql.
   La que NUNCA va acá es la "Secret key" (empieza con "sb_secret_").
   ============================================================================ */
window.MM_CONFIG = {
  SUPABASE_URL: 'https://fkojiczilkgguyukwbrr.supabase.co',
  SUPABASE_ANON_KEY: 'sb_publishable_dxPjN5RTpU2HaxDlhMQAMA_eF9O2i-A'
};
