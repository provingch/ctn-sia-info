<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html data-theme="light">
<head>
    <title>Admin - Asignaciones</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/vendor/flat-ui/css/flat-ui.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/ctn-theme.css?v=221">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/ctn-logo.svg" />
</head>
<body class="admin-page" data-specialty="${empty sessionScope.siaSpecialty ? 'informatica' : sessionScope.siaSpecialty}">
<c:url var="profileUrl" value="/ProfileServlet" />
<header class="navbar navbar-default navbar-fixed-top ctn-navbar" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#ctnNavbarMenu" aria-expanded="false">
                <span class="sr-only">Abrir navegación</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand ctn-navbar-brand" href="${pageContext.request.contextPath}/AdminServlet" aria-label="Ir a inicio">
                <img class="header-logo" src="${pageContext.request.contextPath}/images/ctn-logo.svg" alt="CTN">
                <span>Colegio Técnico Nacional</span>
            </a>
        </div>
        <div class="collapse navbar-collapse" id="ctnNavbarMenu">
            <ul class="nav navbar-nav navbar-right ctn-navbar-actions">
                <li class="ctn-theme-item"></li>
                <li><a class="manual-link" href="${pageContext.request.contextPath}/pdfs/manual.pdf" target="_blank" rel="noopener noreferrer">Manual</a></li>
                <li class="dropdown">
                    <a href="#" id="sessionButton" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Sesión <span class="caret"></span></a>
                    <ul class="dropdown-menu" id="sessionMenu" role="menu" aria-labelledby="sessionButton">
                        <li><a role="menuitem" href="${profileUrl}">Mi Perfil</a></li>
                        <li><a role="menuitem" class="session-logout" href="${pageContext.request.contextPath}/LogoutServlet">Cerrar Sesión</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</header>
<main>
    <section class="container page-shell">
        <div class="admin-hero">
            <div>
                <span class="admin-eyebrow">Administración</span>
                <h1>Asignaciones</h1>
                <p>Vincula profesores con materias y cursos.</p>
            </div>
            <a class="btn-secondary" href="${pageContext.request.contextPath}/AdminServlet">Volver al panel</a>
        </div>

        <c:if test="${not empty errors}">
            <div class="errors"><ul><c:forEach var="e" items="${errors}"><li>${e}</li></c:forEach></ul></div>
        </c:if>
        <c:if test="${not empty flashMessage}"><div class="flash">${flashMessage}</div></c:if>

        <form class="admin-card admin-form" method="post" action="AdminAsignacionesServlet" id="createForm">
            <div class="admin-card-header"><h2>Crear asignación</h2></div>
            <div class="admin-form-grid">
            <input type="hidden" name="action" value="crear" />
            <label>Profesor</label>
            <select name="profesorId" required>
                <option value="">--Seleccione profesor--</option>
                <c:forEach var="p" items="${profesores}">
                    <option value="${p.id}">${p.apellido} ${p.nombre}</option>
                </c:forEach>
            </select>

            <label>Materia</label>
            <select name="materiaId" required>
                <option value="">--Seleccione materia--</option>
                <c:forEach var="m" items="${materias}">
                    <option value="${m.id}">${m.nombre}</option>
                </c:forEach>
            </select>

            <label>Especialidad</label>
            <select id="selEspecialidad"></select>

            <label>Año</label>
            <select id="selPromocion"></select>

            <label>Sección</label>
            <select id="selSeccion"></select>

            <input type="hidden" name="cursoId" id="cursoIdHidden" />
            </div>
            <button class="btn-primary admin-submit" type="submit" id="createBtn">Crear asignación</button>
        </form>

        <div class="admin-card admin-table-card">
        <div class="admin-card-header"><h2>Asignaciones existentes</h2></div>
        <div class="admin-table-wrap">
        <table class="admin-table">
            <thead>
                <tr><th>ID</th><th>Profesor</th><th>Materia</th><th>Curso</th><th>Acciones</th></tr>
            </thead>
            <tbody>
                <c:forEach var="a" items="${asignaciones}">
                    <tr>
                        <td>${a.id}</td>
                        <td>${a.profesorNombre}</td>
                        <td>${a.materiaNombre}</td>
                        <td>${a.cursoDescripcion}</td>
                        <td>
                            <form class="admin-inline-form" method="post" action="AdminAsignacionesServlet">
                                <input type="hidden" name="action" value="eliminar" />
                                <input type="hidden" name="id" value="${a.id}" />
                                <button class="btn-danger btn-compact" type="submit" onclick="return confirm('Eliminar asignación?');">Eliminar</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        </div>
        </div>

    </section>
    <footer class="footer">
      <hr>
      <p>Colegio Técnico Nacional</p>
    </footer>
</main>

<!-- Dump cursos to JS for cascaded selector -->
<script>
const CURSOS = [
    <c:forEach var="cu" items="${cursos}" varStatus="s">
        {"id": ${cu.id}, "especialidad": "<c:out value='${cu.especialidad}'/>", "promocion": ${cu.promocion}, "seccion": "<c:out value='${cu.seccion}'/>"}<c:if test="${!s.last}">,</c:if>
    </c:forEach>
];

function uniqueEspecialidades() {
    const seen = new Set();
    const out = [];
    CURSOS.forEach(c => { if (!seen.has(c.especialidad)) { seen.add(c.especialidad); out.push(c.especialidad); } });
    return out;
}

function populateEspecialidad() {
    const sel = document.getElementById('selEspecialidad');
    sel.innerHTML = '';
    sel.appendChild(new Option('--Seleccione especialidad--',''));
    uniqueEspecialidades().forEach(e => sel.appendChild(new Option(e,e)));
}

function populatePromocion() {
    const esp = document.getElementById('selEspecialidad').value;
    const sel = document.getElementById('selPromocion');
    sel.innerHTML = '';
    sel.appendChild(new Option('--Seleccione año--',''));
    if (!esp) return;
    const promos = [...new Set(CURSOS.filter(c=>c.especialidad===esp).map(c=>c.promocion))].sort((a,b)=>a-b);
    promos.forEach(p => sel.appendChild(new Option(p,p)));
}

function populateSeccion() {
    const esp = document.getElementById('selEspecialidad').value;
    const promo = parseInt(document.getElementById('selPromocion').value);
    const sel = document.getElementById('selSeccion');
    sel.innerHTML = '';
    sel.appendChild(new Option('--Seleccione sección--',''));
    if (!esp || !promo) return;
    const secciones = [...new Set(CURSOS.filter(c=>c.especialidad===esp && c.promocion===promo).map(c=>c.seccion))];
    secciones.forEach(s => sel.appendChild(new Option(s,s)));
    updateHiddenCursoId();
}

function updateHiddenCursoId() {
    const esp = document.getElementById('selEspecialidad').value;
    const promo = parseInt(document.getElementById('selPromocion').value);
    const seccion = document.getElementById('selSeccion').value;
    const hidden = document.getElementById('cursoIdHidden');
    hidden.value = '';
    if (!esp || !promo || !seccion) return;
    const found = CURSOS.find(c => c.especialidad===esp && c.promocion===promo && c.seccion===seccion);
    if (found) hidden.value = found.id;
}

document.addEventListener('DOMContentLoaded', function(){
    populateEspecialidad();
    document.getElementById('selEspecialidad').addEventListener('change', function(){ populatePromocion(); document.getElementById('selSeccion').innerHTML=''; updateHiddenCursoId(); });
    document.getElementById('selPromocion').addEventListener('change', function(){ populateSeccion(); });
    document.getElementById('selSeccion').addEventListener('change', updateHiddenCursoId);
    document.getElementById('createForm').addEventListener('submit', function(e){ if (!document.getElementById('cursoIdHidden').value) { e.preventDefault(); alert('Seleccione una combinación válida de especialidad/año/sección que corresponda a un curso real.'); } });
});
</script>
  <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/vendor/jquery.min.js"></script>
  <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/flat-ui.js"></script>
  <script src="${pageContext.request.contextPath}/scripts/sia-theme.js?v=164"></script>
</body>
</html>
