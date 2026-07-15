# Manual de integración de cursos con Google Classroom

## Objetivo

Este proyecto necesita que los cursos de Google Classroom sigan una convención de nombres simple y consistente para poder detectarlos correctamente y vincularlos con las planillas locales.

## Flujo de administración de integración

Además del flujo de uso del profesor, ahora existe un rol de integración administrativa para corregir manualmente los correos de Google de los alumnos por especialidad antes de sincronizar Classroom.

Usuarios de ejemplo:
- `informatica-itg`
- `electricidad-itg`

Contraseña por defecto:
- `ctn2025`

Al iniciar sesión con ese usuario, la aplicación abre un panel dedicado donde se pueden revisar y actualizar los correos de Google de los alumnos de esa especialidad.

## Estructura recomendada para los nombres de curso

El nombre del curso debe indicar, al menos:

- la materia
- el nivel
- la sección

Formato recomendado:

Materia + Nivel + Sección

Ejemplos válidos:
- Algoritmia 2do A
- Algoritmia 2° A
- Matemática 1A
- Historia 3ro B
- Física 2do B

## Niveles aceptados

El sistema reconoce estos niveles:

- Primero / 1 / 1ro / 1er / 1°
- Segundo / 2 / 2do / 2°
- Tercero / 3 / 3ro / 3°

## Secciones aceptadas

Las secciones reconocidas son:

- A
- B
- C

## Ejemplos de nombres recomendados

- Algoritmia 2do A
- Programación 1ro B
- Matemática 3ro C
- Historia 2° A

## Ejemplos que no son recomendables

- Algoritmia
- 2do
- Curso de práctica
- Laboratorio

## Cómo funciona la detección

El sistema intenta identificar el curso usando:

1. el nombre del curso de Classroom
2. el nivel y la sección que aparecen en ese nombre
3. la coincidencia con los cursos del profesor
4. el ID real del curso de Google Classroom para mantener la asociación estable

Esto significa que lo más importante no es solo el texto exacto, sino la combinación de nivel y sección que representa el curso.

## Reglas de uso

- usar nombres simples y consistentes
- incluir siempre nivel y sección
- evitar cambios frecuentes del nombre
- si el nombre cambia, el sistema puede seguir encontrando el curso por su identidad real en Classroom

## Recomendación práctica

Para que todo funcione de forma limpia, conviene usar una convención fija como esta:

Materia + Nivel + Sección

Ejemplo:

Algoritmia 2do A

## Nota importante

Si un curso tiene el mismo nivel y la misma sección que uno de tus cursos locales, el sistema puede asociarlo correctamente aunque el nombre no sea idéntico al de la planilla.

## Sincronización de alumnos y notas

La integración ahora permite:

- vincular alumnos locales con estudiantes de Google Classroom por correo o nombre
- guardar esa vinculación en la base de datos mediante las columnas `google_user_id` y `google_email` de la tabla `alumno`
- importar tareas desde Classroom hacia la planilla web
- importar calificaciones asignadas en Classroom hacia la planilla web
- que la web también pueda mostrar o reutilizar esa información cuando se vuelve a abrir la planilla

### Pasos recomendados

1. Aplicar la migración de alumnos en la base de datos si la instalación aún no cuenta con las columnas `google_user_id` y `google_email`:
   - `database/migration-classroom-student-link.sql`
2. Iniciar sesión con el usuario de integración correspondiente a la especialidad y corregir los correos de Google de los alumnos desde el panel de integración.
3. Volver a abrir la planilla asociada a un curso de Classroom.
4. Ejecutar la sincronización manual desde la planilla para vincular alumnos y cargar notas.

> La vinculación ya no depende exclusivamente del emparejamiento automático por correo; el flujo de integración administrativa permite corregir manualmente los datos cuando el email local no coincide con el registro de Classroom.
