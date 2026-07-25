<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Admin - Materias</title>
    <link rel="stylesheet" href="/styles/general.css" />
</head>
<body>
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
    <thead><tr><th>ID</th><th>Nombre</th><th>Categoria</th></tr></thead>
    <tbody>
    <c:forEach var="m" items="${materias}">
        <tr><td>${m.id}</td><td>${m.nombre}</td><td>${m.categoria}</td></tr>
    </c:forEach>
    </tbody>
</table>

</body>
</html>
