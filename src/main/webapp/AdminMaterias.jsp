<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html data-theme="light">
<head>
        <title>Admin - Materias</title>
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
            <span>Administrar materias</span>
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
<c:if test="${editMode and not empty editMateria}">
    <h2>Editar materia</h2>
    <form method="post" action="${pageContext.request.contextPath}/AdminMateriasServlet">
        <input type="hidden" name="action" value="edit" />
        <input type="hidden" name="materiaId" value="${editMateria.id}" />
        <label>Nombre:</label>
        <input type="text" value="${editMateria.nombre}" disabled />
        <label>Categoría:</label>
        <select name="categoria">
            <option value="">-- no cambiar --</option>
            <option value="comun" ${editMateria.categoria eq 'comun' ? 'selected' : ''}>comun</option>
            <option value="especifico" ${editMateria.categoria eq 'especifico' ? 'selected' : ''}>especifico</option>
        </select>
        <div>
            <label>Especialidades:</label>
            <c:forEach var="e" items="${especialidades}">
                <c:set var="isChecked" value="false" />
                <c:forEach var="selectedId" items="${editEspecialidadIds}">
                    <c:if test="${selectedId == e.id}">
                        <c:set var="isChecked" value="true" />
                    </c:if>
                </c:forEach>
                <label><input type="checkbox" name="especialidades" value="${e.id}" ${isChecked ? 'checked' : ''} /> ${e.nombre}</label>
            </c:forEach>
        </div>
        <button type="submit">Guardar cambios</button>
    </form>
    <hr/>
</c:if>

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
                    <c:when test="${not empty materiaEspecialidadesTexto[m.id]}">
                        <c:out value="${materiaEspecialidadesTexto[m.id]}" />
                    </c:when>
                    <c:otherwise>—</c:otherwise>
                </c:choose>
            </td>
            <td><c:out value="${profCounts[m.id] != null ? profCounts[m.id] : 0}" /></td>
            <td>
                <a href="${pageContext.request.contextPath}/AdminMateriasServlet?editId=${m.id}">Editar</a>
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
