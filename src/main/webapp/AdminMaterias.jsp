<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
        <title>Admin - Materias</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/sia-base.css" />
</head>
<body>
<header>
    <a href="${pageContext.request.contextPath}/AdminServlet">Volver al Dashboard</a> |
    <a href="${pageContext.request.contextPath}/AdminMateriasServlet">Catálogo de Materias</a>
</header>
<h1>Administrar Materias</h1>

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

<h2>Crear nueva materia</h2>
<form method="post" action="AdminMateriasServlet">
    <input type="hidden" name="action" value="create" />
    <label>Nombre:</label>
    <input type="text" name="nombre" required />
    <label>Categoría:</label>
    <select name="categoria">
        <option value="comun">comun</option>
        <option value="especifico">especifico</option>
    </select>
    <div>
        <label>Especialidades:</label>
        <c:forEach var="e" items="${especialidades}">
            <label><input type="checkbox" name="especialidades" value="${e.id}" /> ${e.nombre}</label>
        </c:forEach>
    </div>
    <button type="submit">Crear</button>
</form>

<hr/>

<form method="post" action="AdminMateriasServlet">
    <input type="hidden" name="action" value="check" />
    <label>From (source) materia:</label>
    <select name="fromId" required>
        <option value="">-- seleccionar --</option>
        <c:forEach var="m" items="${materias}">
            <option value="${m.id}" ${m.id == fromId ? 'selected' : ''}>${m.id} - ${m.nombre} (${m.categoria})</option>
        </c:forEach>
    </select>

    <label>To (target) materia:</label>
    <select name="toId" required>
        <option value="">-- seleccionar --</option>
        <c:forEach var="m" items="${materias}">
            <option value="${m.id}" ${m.id == toId ? 'selected' : ''}>${m.id} - ${m.nombre} (${m.categoria})</option>
        </c:forEach>
    </select>

    <button type="submit">Comprobar conflictos</button>
</form>

<c:if test="${not empty conflicts}">
    <h3>Conflictos detectados (merge BLOQUEADO)</h3>
    <ul>
        <c:forEach var="c" items="${conflicts}">
            <li>${c}</li>
        </c:forEach>
    </ul>
</c:if>

<c:if test="${empty conflicts && not empty fromId && not empty toId}">
    <form method="post" action="AdminMateriasServlet">
        <input type="hidden" name="action" value="merge" />
        <input type="hidden" name="fromId" value="${fromId}" />
        <input type="hidden" name="toId" value="${toId}" />
        <p>No se detectaron conflictos. Puede confirmar el merge.</p>
        <button type="submit">Confirmar Merge</button>
    </form>
</c:if>

<hr/>
<h2>Catálogo</h2>
<table>
    <thead><tr><th>ID</th><th>Nombre</th><th>Categoria</th><th>Especialidades</th><th>Profesores</th><th>Acciones</th></tr></thead>
    <tbody>
    <c:forEach var="m" items="${materias}">
        <tr>
            <td>${m.id}</td>
            <td>${m.nombre}</td>
            <td>${m.categoria}</td>
            <td>
                <c:choose>
                    <c:when test="${not empty materiaEspecialidades[m.id]}">
                        ${fn:join(materiaEspecialidades[m.id], ', ')}
                    </c:when>
                    <c:otherwise>—</c:otherwise>
                </c:choose>
            </td>
            <td><c:out value="${profCounts[m.id] != null ? profCounts[m.id] : 0}" /></td>
            <td>
                <form method="post" action="AdminMateriasServlet" style="display:inline-block;">
                    <input type="hidden" name="action" value="edit" />
                    <input type="hidden" name="materiaId" value="${m.id}" />
                    <button type="submit">Editar</button>
                </form>
                <form method="post" action="AdminMateriasServlet" style="display:inline-block;">
                    <input type="hidden" name="action" value="check" />
                    <input type="hidden" name="fromId" value="${m.id}" />
                    <input type="hidden" name="toId" value="${m.id}" />
                    <button type="submit">Ver conflictos</button>
                </form>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

</body>
</html>
