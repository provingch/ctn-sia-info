<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html data-theme="light">
<head>
    <title>Admin - Usuarios</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/sia-base.css" />
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/ctn-logo.svg" />
</head>
<body data-specialty="${empty sessionScope.siaSpecialty ? 'informatica' : sessionScope.siaSpecialty}">
<header class="site-header">
    <div class="header-logo-container">
        <a href="${pageContext.request.contextPath}/AdminServlet" aria-label="Ir a inicio">
            <img class="header-logo" src="${pageContext.request.contextPath}/images/ctn-logo.svg">
        </a>
    </div>
    <div class="header-school-name">Colegio Técnico Nacional</div>
    <c:url var="profileUrl" value="/ProfileServlet" />
    <c:url var="logoutUrl" value="/LogoutServlet" />
    <div class="right-section">
        <div class="manual-container">
            <a class="manual-link" href="${pageContext.request.contextPath}/pdfs/manual.pdf" target="_blank">Manual</a>
        </div>
        <div class="session-dropdown" id="sessionDropdown">
            <button class="session-button" id="sessionButton" aria-haspopup="true" aria-expanded="false" aria-controls="sessionMenu">
                Sesión
                <svg class="dropdown-icon" viewBox="0 0 24 24" fill="currentColor"><path d="M7 10l5 5 5-5z"/></svg>
            </button>
            <nav class="session-menu" id="sessionMenu" role="menu" aria-labelledby="sessionButton">
                <a role="menuitem" class="session-item" href="${profileUrl}">Mi Perfil</a>
                <a role="menuitem" class="session-item session-logout" href="${logoutUrl}">Cerrar Sesión</a>
            </nav>
        </div>
    </div>
</header>
<main>
    <section class="container page-shell">
        <div class="info-bar">
            <span>Administrar usuarios</span>
        </div>

<c:if test="${not empty errors}">
    <div class="errors">
        <ul>
            <c:forEach var="e" items="${errors}">
                <li>${e}</li>
            </c:forEach>
        </ul>
    </div>
</c:if>

<c:if test="${not empty flashMessage}">
    <div class="flash">${flashMessage}</div>
</c:if>

<h2>Crear usuario</h2>
<form method="post" action="AdminUsuariosServlet">
    <input type="hidden" name="action" value="create" />
    <label>Nombre</label>
    <input type="text" name="nombre" required />
    <label>Apellido</label>
    <input type="text" name="apellido" required />
    <label>Usuario</label>
    <input type="text" name="usuario" required />
    <label>Contraseña</label>
    <input type="password" name="contrasenia" placeholder="password por defecto si está vacío" />
    <label>Rol</label>
    <select name="nivel" required>
        <option value="1">Profesor</option>
        <option value="2">Evaluador</option>
        <option value="3">Administrador</option>
    </select>
    <label>CI</label>
    <input type="text" name="ci" />
    <label>Teléfono</label>
    <input type="text" name="telefono" />
    <label>Celular</label>
    <input type="text" name="celular" />
    <label>Correo</label>
    <input type="email" name="correo" />
    <label>Especialidad</label>
    <select name="especialidadId">
        <option value="">-- ninguna --</option>
        <c:forEach var="e" items="${especialidades}">
            <option value="${e.id}">${e.nombre}</option>
        </c:forEach>
    </select>
    <button type="submit">Crear usuario</button>
</form>

<hr/>
<c:if test="${editMode and not empty editProfesor}">
    <h2>Editar usuario</h2>
    <form method="post" action="${pageContext.request.contextPath}/AdminUsuariosServlet">
        <input type="hidden" name="action" value="edit" />
        <input type="hidden" name="profesorId" value="${editProfesor.id}" />
        <label>Nombre</label>
        <input type="text" name="nombre" value="${editProfesor.nombre}" required />
        <label>Apellido</label>
        <input type="text" name="apellido" value="${editProfesor.apellido}" required />
        <label>Usuario</label>
        <input type="text" name="usuario" value="${editProfesor.usuario}" required />
        <label>Contraseña nueva</label>
        <input type="password" name="contrasenia" placeholder="Dejar en blanco para no cambiar" />
        <label>Rol</label>
        <select name="nivel" required>
            <option value="1" ${editProfesor.nivel == 1 ? 'selected' : ''}>Profesor</option>
            <option value="2" ${editProfesor.nivel == 2 ? 'selected' : ''}>Evaluador</option>
            <option value="3" ${editProfesor.nivel == 3 ? 'selected' : ''}>Administrador</option>
        </select>
        <label>CI</label>
        <input type="text" name="ci" value="${editProfesor.ci}" />
        <label>Teléfono</label>
        <input type="text" name="telefono" value="${editProfesor.telefono}" />
        <label>Celular</label>
        <input type="text" name="celular" value="${editProfesor.celular}" />
        <label>Correo</label>
        <input type="email" name="correo" value="${editProfesor.correo}" />
        <label>Especialidad</label>
        <select name="especialidadId">
            <option value="">-- ninguna --</option>
            <c:forEach var="e" items="${especialidades}">
                <option value="${e.id}" ${editProfesor.especialidadId == e.id ? 'selected' : ''}>${e.nombre}</option>
            </c:forEach>
        </select>
        <button type="submit">Guardar cambios</button>
    </form>
    <hr/>
</c:if>

<h2>Usuarios</h2>
<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Usuario</th>
            <th>Rol</th>
            <th>Especialidad</th>
            <th>Acciones</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="profesor" items="${profesores}">
            <tr>
                <td>${profesor.id}</td>
                <td>${profesor.fullName}</td>
                <td>${profesor.usuario}</td>
                <td>
                    <c:choose>
                        <c:when test="${profesor.nivel == 1}">Profesor</c:when>
                        <c:when test="${profesor.nivel == 2}">Evaluador</c:when>
                        <c:when test="${profesor.nivel == 3}">Administrador</c:when>
                        <c:otherwise>Desconocido</c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${not empty profesor.especialidadId}">
                            <c:forEach var="e" items="${especialidades}">
                                <c:if test="${e.id == profesor.especialidadId}">${e.nombre}</c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>--</c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <a href="${pageContext.request.contextPath}/AdminUsuariosServlet?editId=${profesor.id}">Editar</a>
                    <form method="post" action="${pageContext.request.contextPath}/AdminUsuariosServlet" style="display:inline; margin-left:0.5rem;">
                        <input type="hidden" name="action" value="delete" />
                        <input type="hidden" name="profesorId" value="${profesor.id}" />
                        <button type="submit" onclick="return confirm('Eliminar usuario ${profesor.fullName}?');">Eliminar</button>
                    </form>
                    <form method="post" action="${pageContext.request.contextPath}/AdminUsuariosServlet" style="display:inline; margin-left:0.5rem;">
                        <input type="hidden" name="action" value="reset" />
                        <input type="hidden" name="profesorId" value="${profesor.id}" />
                        <button type="submit">Restablecer contraseña</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>
    </section>
</main>
<script src="${pageContext.request.contextPath}/scripts/sia-theme.js?v=163"></script>
<script src="${pageContext.request.contextPath}/scripts/session-dropdown.js?v=163"></script>
</body>
</html>
