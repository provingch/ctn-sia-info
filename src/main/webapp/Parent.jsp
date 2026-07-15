<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html data-theme="light">
<head>
    <title>CTNPortal - Padres</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/sia-base.css">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/ctn-logo.svg">
</head>
<body data-specialty="${empty sessionScope.siaSpecialty ? 'informatica' : sessionScope.siaSpecialty}">
<header class="site-header">
    <div class="header-logo-container">
        <a href="${pageContext.request.contextPath}/ParentServlet" aria-label="Ir a inicio">
            <img class="header-logo" src="${pageContext.request.contextPath}/images/ctn-logo.svg">
        </a>
    </div>
    <div class="header-school-name">Colegio Técnico Nacional</div>
    <div class="right-section">
        <div class="session-dropdown" id="sessionDropdown">
            <button class="session-button" id="sessionButton" aria-haspopup="true" aria-expanded="false" aria-controls="sessionMenu">
                Sesión
            </button>
            <nav class="session-menu" id="sessionMenu" role="menu" aria-labelledby="sessionButton">
                <a role="menuitem" class="session-item" href="${pageContext.request.contextPath}/LogoutServlet">Cerrar Sesión</a>
            </nav>
        </div>
    </div>
</header>
<main>
    <section class="container page-shell">
        <div class="titleblock">
            <div class="tb-left">
                <div class="tb-logo">CTN</div>
                <div class="tb-name">
                    <h1>Colegio Técnico Nacional</h1>
                    <span>Seguimiento de hijos</span>
                </div>
            </div>
            <div class="tb-right">
                <div class="tb-cell"><b>Usuario</b>${sessionScope.user.fullName}</div>
                <div class="tb-cell"><b>Rol</b>Padre</div>
                <div class="tb-cell"><b>Estado</b>En línea</div>
                <div class="tb-cell"><b>Fecha</b><c:out value="${nowFormatted}" /></div>
            </div>
        </div>
        <div class="info-bar">
            <span>Bienvenido/a ${sessionScope.user.fullName}</span>
        </div>

        <div class="top-section planilla-hero hero-shell">
            <div class="planilla-hero__header">
                <div class="planilla-hero__info">
                    <span class="badge"><span class="dot"></span>Padres</span>
                    <h1>Notas de mis hijos</h1>
                    <p class="planilla-subtitle">Resumen de materias, notas y tareas por alumno.</p>
                </div>
            </div>
        </div>

        <c:if test="${empty hijos}">
            <div class="empty-state empty-state-card">No hay hijos asociados a este usuario padre.</div>
        </c:if>

        <c:if test="${not empty hijos}">
            <c:forEach var="entry" items="${summaryByEspecialidad}">
                <div class="section-block card">
                    <div class="section-heading"><c:out value="${entry.key}" /></div>
                    <table class="grade-table">
                        <thead>
                        <tr>
                            <th>Alumno</th>
                            <th>Materia</th>
                            <th>Puntos</th>
                            <th>Nota</th>
                            <th>Porcentaje</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${entry.value}">
                            <c:url var="detailUrl" value="/ParentServlet">
                                <c:param name="alumnoId" value="${item.alumnoId}" />
                                <c:param name="materiaId" value="${item.materiaId}" />
                                <c:param name="planillaId" value="${item.planillaId}" />
                            </c:url>
                            <tr>
                                <td><a href="${detailUrl}"><c:out value="${item.alumnoNombre}" /></a></td>
                                <td><a href="${detailUrl}"><c:out value="${item.materiaNombre}" /></a></td>
                                <td><c:out value="${item.puntos}" /> / <c:out value="${item.totalPosible}" /></td>
                                <td><c:out value="${item.nota}" /></td>
                                <td><c:out value="${item.porcentaje}" />%</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:forEach>
        </c:if>

        <c:if test="${not empty tareasPorAlumno}">
            <div class="section-block card">
                <div class="section-heading">Detalle de tareas</div>
                <table class="grade-table">
                    <thead>
                    <tr>
                        <th>Tarea</th>
                        <th>Fecha</th>
                        <th>Puntos</th>
                        <th>Total</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="grade" items="${tareasPorAlumno}">
                        <tr>
                            <td><c:out value="${grade.tareaTitulo}" /></td>
                            <td><c:out value="${grade.fecha}" /></td>
                            <td><c:out value="${grade.puntos}" /></td>
                            <td><c:out value="${grade.total}" /></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </section>
</main>
<script>
(function () {
  const dropdown = document.getElementById('sessionDropdown');
  if (!dropdown) return;

  const button = document.getElementById('sessionButton');
  const menu = document.getElementById('sessionMenu');

  function openMenu() {
    dropdown.classList.add('open');
    button.classList.add('open');
    button.setAttribute('aria-expanded', 'true');
  }
  function closeMenu() {
    dropdown.classList.remove('open');
    button.classList.remove('open');
    button.setAttribute('aria-expanded', 'false');
  }

  button.addEventListener('click', function (e) {
    e.stopPropagation();
    if (dropdown.classList.contains('open')) closeMenu();
    else openMenu();
  });

  document.addEventListener('click', function (e) {
    if (!dropdown.contains(e.target)) closeMenu();
  });

  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') closeMenu();
  });

  menu.addEventListener('click', function (e) {
    const t = e.target;
    if (t.matches('a')) {
      closeMenu();
    }
  });
})();
</script>
<script src="${pageContext.request.contextPath}/scripts/sia-theme.js"></script>
</body>
</html>
