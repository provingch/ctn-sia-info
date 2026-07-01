# Registro de Cambios

Todos los cambios notables de este proyecto serán documentados en este archivo.

El formato se basa en [Mantener un Registro de Cambios](https://keepachangelog.com/es/1.0.0/),
y este proyecto se adhiere a [Versionado Semántico](https://semver.org/spec/v2.0.0.html).

## [v0.0.2.1] - 2026-07-01

### Modificado
- **Mejor manejo de errores**: Se mejoro conexion.java para que se registre correctamente el error y mejorar la trazabilidad [conexion.java (Lineas 42-52)](./src/main/java/ctn/informatica/sia/clases/conexion.java#L42-52)
- **Evitar NPE**: Se modifico UserDao.java para capturar la excepcion SQL y envolverlo en un mensaje correcto y claro [UserDao.java (Lineas 36-37)](./src/main/java/ctn/informatica/sia/dao/UserDao.java#L36-37)

## [v0.0.2] - 2026-07-01

### Añadido
- **Interfaz de Conexión Google Classroom**: Sección en perfil de profesor para conectar/reconectar cuenta de Google Classroom [Profile.jsp (Líneas 144-160)](./src/main/webapp/Profile.jsp#L144-L160)
- **Esquema de Base de Datos para Google OAuth**: Columnas `google_email`, `google_access_token`, `google_refresh_token`, `google_token_expiry` en tabla profesor [db-tables-properties.sql (Líneas 49-52)](./database/db-tables-properties.sql#L49-L52)
- **Métodos de Gestión de Tokens Google**: Métodos `updateGoogleTokens()` y `findByGoogleEmail()` en ProfesorDao para gestionar credenciales OAuth [ProfesorDao.java (Líneas 61-77, 82-95)](./src/main/java/ctn/informatica/sia/dao/ProfesorDao.java#L61-L95)
- **Extracción de Columnas Google OAuth**: Mapeo de columnas Google en método `map()` de ProfesorDao [ProfesorDao.java (Líneas 22-27)](./src/main/java/ctn/informatica/sia/dao/ProfesorDao.java#L22-L27)
- **Preservación de Sesión en Flujo OAuth**: GoogleCallbackServlet preserva la sesión de usuario existente durante el flujo OAuth [GoogleCallbackServlet.java (Líneas 90-110)](./src/main/java/ctn/informatica/sia/GoogleCallbackServlet.java#L90-L110)

### Modificado
- **Resolución Dinámica de Redirect URI**: GoogleLoginServlet ahora resuelve dinámicamente el redirect_uri desde AppConfig o construcción basada en request, eliminando placeholder hardcodeado [GoogleLoginServlet.java (Líneas 52-61)](./src/main/java/ctn/informatica/sia/GoogleLoginServlet.java#L52-L61)
- **Redirects de Callback OAuth**: GoogleCallbackServlet redirige a rutas válidas de la aplicación (ProfileServlet) en lugar de endpoints no-existentes [GoogleCallbackServlet.java (Línea 41)](./src/main/java/ctn/informatica/sia/GoogleCallbackServlet.java#L41)
- **API de Autenticación Google**: Implementada autenticación OAuth2 usando GoogleCredential con access token para obtener información de usuario [GoogleCallbackServlet.java (Líneas 71-77)](./src/main/java/ctn/informatica/sia/GoogleCallbackServlet.java#L71-L77)
- **Consultas SELECT en ProfesorDao**: Todas las queries incluyen las columnas Google OAuth en SELECT [ProfesorDao.java (Líneas 42-44)](./src/main/java/ctn/informatica/sia/dao/ProfesorDao.java#L42-L44)
- **Cambio en CHANGELOG.md**: Reformatado de CHANGELOG.md en español.

### Eliminado
- Placeholder redirect_uri hardcodeado en GoogleLoginServlet
- Inicialización manual de `HttpCredentialsAdapter` que no está disponible en dependencias actuales

## [v0.0.1] - 2026-06-29

### Añadido
- Implementada la integración de autenticación con Google (GoogleAuth).

### Modificado
- Renombrado el paquete principal.
- Excluidos datos personales sensibles del repositorio Git.
- Eliminado el archivo/registro de `dbinsert`.
- Ajustado el flujo de autenticación para usar redirect URI dinámico y rutas válidas en la aplicación.

## [Original Project]
El proyecto fue proporcionado el 18 de junio de 2026
La propuesta de proyecto fue aceptada el 29 de junio de 2026

- This CHANGELOG file to hopefully serve as an evolving example of a
  standardized open source project CHANGELOG.
- CNAME file to enable GitHub Pages custom domain.
- README now contains answers to common questions about CHANGELOGs.
- Good examples and basic guidelines, including proper date formatting.
- Counter-examples: "What makes unicorns cry?".

[@provingch] https://github.com/provingch
[@Sh1b0] https://github.com/Sh1b0
