# Project GitHub sync

_Started 2026-09-01 21:17 UTC_

---

## User

Continuing from "Mockups turismo receptivo Córdoba".

## Assistant

Trabajamos en una landing receptiva de turismo en Córdoba basada en el sistema Organic.

Decisiones tomadas:
- Tipografía Caprasimo (títulos) + Figtree (texto) del sistema Organic.
- Paleta azul #162053 / cyan #54d8f0 de la marca original (no la del sistema Organic).
- Carrusel hero con 15 fotos (1, 2, 4, 6, 8, 9, 10, 11, 12, 15, 16, 17, 18, 19, asado) en orden aleatorio, 3 visibles, scroll continuo a la izquierda.
- Sección "Quiénes somos" reducida a dos métricas compactas; eliminadas "6 tipos de experiencia" y "Cuatro razones".
- Botón "★ Valorá nuestra experiencia" con pulsante visual, desplaza al formulario.

Estado actual:
- Formulario de reseña con tres campos: nombre, texto obligatorio, adjuntar imagen (opcional).
- Enviar bloqueado hasta completar estrellas (1-5) + texto.
- Sección "Reseñas de clientes": carrusel vertical automático lento mostrando nombre, puntuación, texto y foto (si existe); las nuevas reseñas aparecen primero.
- Tarjetas "Qué hacemos": Golf (foto 4), Fans del Deporte (16), Despedida de Soltero/a (19), Las mejores fiestas (17), Los mejores asados (asado); dos últimas centradas.
- Loops de carrusel ajustados (sin saltos ni roturas).
- Nav apunta a "Reseñas" en lugar de "Armar mi viaje".

Archivo principal: `Landing M+.dc.html`. Fotos en carpeta `assets/`.

Sin pendientes abiertos.

## User

Sync this project with its GitHub source: read `github.md`, pull upstream changes since the last sync, rebuild the affected screens, and refresh `github.md`.

## Assistant

_[tool: read_file]_

_[tool: github_get_tree]_

_[tool: write_file]_

Sincronizado: el repo `joacohlavach/claude@main` sigue siendo el tracker de rutinas en Vite/React, sin relación con esta landing, así que no hay nada que reconstruir. Actualicé `github.md` con la fecha de sync y moví el registro anterior al historial.

## User

es decir que en vez de descargar el html yo puedo acceder al mismo desde github?

## Assistant

No directamente desde acá: puedo **leer** archivos de GitHub, pero no puedo subir ni commitear al repo.

El flujo que sí funciona:

1. Descargás la landing como HTML autocontenido (un solo archivo, sin dependencias).
2. La subís a tu repo `joacohlavach/claude` como `index.html`.
3. Activás GitHub Pages en Settings → Pages y queda publicada en una URL.

Después, si querés cambios, yo puedo leer ese archivo desde GitHub y trabajar sobre él, pero la subida siempre la hacés vos.

¿Te genero el archivo standalone listo para subir?

