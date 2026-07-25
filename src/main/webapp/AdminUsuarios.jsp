<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Admin - Usuarios</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/sia-base.css" />
</head>
<body>
<header>
    <a href="${pageContext.request.contextPath}/AdminServlet">Volver al Dashboard</a> |
    <a href="${pageContext.request.contextPath}/AdminUsuariosServlet">Administrar Usuarios</a>
</header>
<h1>Administrar Usuarios</h1>

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

</body>
</html>
