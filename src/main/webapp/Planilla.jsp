<%-- 
    Document   : Planillas
    Created on : Aug 10, 2025, 5:17:28 PM
    Author     : jonat
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html data-theme="light">

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><c:out value="${not empty pageTitle ? pageTitle : planilla.nombre}" /></title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/vendor/flat-ui/css/flat-ui.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/ctn-theme.css?v=202">
  <script src="${pageContext.request.contextPath}/scripts/planilla.js?v=164"></script>
  <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/ctn-logo.svg">
</head>

<body data-specialty="${not empty cursoSpecialty ? cursoSpecialty : (empty sessionScope.siaSpecialty ? 'informatica' : sessionScope.siaSpecialty)}">
  <c:url var="profileUrl" value="/ProfileServlet" />
  <c:url var="logoutUrl" value="/LogoutServlet" />
  <header class="navbar navbar-default navbar-fixed-top ctn-navbar" role="navigation">
    <div class="container-fluid">
      <div class="navbar-header">
        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#ctnNavbarMenu" aria-expanded="false">
          <span class="sr-only">Abrir navegación</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand ctn-navbar-brand" href="${pageContext.request.contextPath}/HomeServlet" aria-label="Ir a inicio">
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
              <li><a role="menuitem" class="session-logout" href="${logoutUrl}">Cerrar Sesión</a></li>
            </ul>
          </li>
        </ul>
      </div>
    </div>
  </header>


  <main>
    <div class="wrap">
    <section class="container">
        <div class="info-bar">
        <span>Bienvenido/a ${sessionScope.user.fullName}</span>
        <span>
          <c:out value="${nowFormatted}" />
        </span>
      </div>

      <div class="top-section planilla-hero" data-specialty="${fn:escapeXml(curso.especialidad)}">
        <div class="planilla-hero__header">
          <div class="planilla-hero__info">
            <span class="badge"><span class="dot"></span><span id="badgeSpecialtyName">${curso.especialidad}</span></span>
            <h1><c:out value="${not empty pageTitle ? pageTitle : planilla.nombre}" /></h1>
            <p class="planilla-subtitle">${curso.especialidad} ${curso.getCurso()}.<sup>o</sup> "${curso.seccion}" - ${planilla.etapa} etapa</p>
          </div>
          <div class="planilla-hero__actions">
            <%-- create a URL back to HomeServlet preserving cursoId + etapa --%>
            <c:url var="backUrl" value="/HomeServlet">
                <c:param name="cursoId" value="${cursoId}" />
                <c:param name="etapa" value="${etapa}" />
            </c:url>

            <div class="btn-row">
              <a id="backBtn" class="btn-secondary" href="${backUrl}">
                <img class="back-icon" src="${pageContext.request.contextPath}/icons/back-arrow.svg" alt="Atrás">
                Atrás
              </a>
              <c:url var="downloadUrl" value="/ExportPlanillaServlet">
                  <c:param name="planillaId" value="${planilla.id}" />
              </c:url>

              <a id="downloadBtn" class="btn-primary" href="${downloadUrl}">
                <img class="download-icon" src="${pageContext.request.contextPath}/icons/download-icon.svg" alt="Descargar">
                Descargar
              </a>
            </div>
          </div>
        </div>

        <div class="planilla-toolbar">
          <form action="" method="get">
            <input type="hidden" name="cursoId" value="${cursoId}" />
            <input type="hidden" name="materiaId" value="${materiaId}" />

            <label for="etapaSelect">Etapa</label>
            <select class="selEtapa" id="etapaSelect" name="etapa" onchange="this.form.submit()">
              <option value="">--Seleccione una etapa--</option>
              <option value="1" ${ etapa == 1? "selected" : ""}>primera etapa</option>
              <option value="2" ${ etapa == 2? "selected" : ""}>segunda etapa</option>
            </select>
          </form>

          <span id="date-range"><i><b>Desde:</b> -- <b>Hasta:</b> --</i></span>
        </div>
      </div>

      <form method="post" action="${pageContext.request.contextPath}/PlanillaServlet">
        <input type="hidden" name="cursoId" value="${cursoId}" />
        <input type="hidden" name="materiaId" value="${materiaId}" />
        <input type="hidden" name="etapa" value="${etapa}" />


        <div class="planilla-info-bar">
          <div class="grade-ranges-container">
            <span class="five-highlight">${gradeRanges['5'][0]} a ${gradeRanges['5'][1]}</span>
            <span class="four-highlight">${gradeRanges['4'][0]} a ${gradeRanges['4'][1]}</span>
            <span class="three-highlight">${gradeRanges['3'][0]} a ${gradeRanges['3'][1]}</span>
            <span class="two-highlight">${gradeRanges['2'][0]} a ${gradeRanges['2'][1]}</span>
            <span class="one-highlight">${gradeRanges['2'][0] - 1} y menos</span>

            <label class="freeze-toggle" title="Fijar columnas # y Alumno">
              <input type="checkbox" id="freezeCheckbox" data-ignore-dirty/>
              Inmovilizar alumnos
            </label>
          </div>
          <div class="escala-info">
            Escala: (Total de Puntos ${totalPossiblePoints}) - Porcentaje de Exigencia: ${exigencia}&percnt;
          </div>
          <button class="btn-primary save-button">
            <img class="save-icon" src="${pageContext.request.contextPath}/icons/save.svg">
            Guardar Cambios
          </button>
        </div>

        <c:set var="taskColumns" value="" />
        <c:forEach var="t" items="${tareas}">
          <c:set var="taskColumns" value="${taskColumns} 110px" />
        </c:forEach>

        <div class="table-container">
          <div class="table-responsive">
            <div class="table" style="grid-template-columns: 40px 260px 140px${taskColumns};">
              <div class="table-row">
                <div class="table-heading">
                  Tareas - ${planilla.nombre}
                </div>
              </div>
              <div class="table-row">
                <div class="cell col-index">#</div>
                <div class="cell col-alumno">Alumno</div>
                <div class="cell">Total de Puntos (${totalPossiblePoints})</div>
                <c:forEach var="t" items="${tareas}">
                  <div class="cell">
                    <c:choose>
                      <c:when test="${not empty t.googleCourseworkUrl}">
                        <a class="tarea-edit-link"
                           href="${t.googleCourseworkUrl}"
                           target="_blank"
                           rel="noopener noreferrer"
                           title="${t.tooltipText}">
                          <c:out value="${t.titulo}" /> (TP:<c:out value="${t.total}" />)
                        </a>
                      </c:when>
                      <c:otherwise>
                        <a class="tarea-edit-link"
                           href="${pageContext.request.contextPath}/TareaServlet?planillaId=${planilla.id}&amp;tareaId=${t.id}&amp;etapa=${etapa}"
                           title="${t.tooltipText}">
                          <c:out value="${t.titulo}" /> (TP:<c:out value="${t.total}" />)
                        </a>
                      </c:otherwise>
                    </c:choose>
                    <div class="task-meta">
                      <c:if test="${not empty t.fechaInicio}">Inicio: <c:out value="${t.fechaInicio}" /></c:if>
                    </div>
                  </div>
                </c:forEach>
              </div>

              <c:forEach var="row" items="${rows}" varStatus="rs">
                <div class="table-row">
                  <div class="cell col-index">${rs.index + 1}</div>
                  <div class="cell col-alumno">${row.alumnoNombre}</div>
                  <div class="cell row-summary">
                    <div>Total: <span class="row-total">${row.total}</span> (<span class="row-porcentaje">${row.porcentaje}</span>%)</div>
                    <div>Nota: <span class="row-nota">${row.nota}</span></div>
                  </div>
                  <c:forEach var="t" items="${tareas}">
                    <div class="cell">
                      <input class="no-spinner"
                             type="number"
                             min="0"
                             max="${t.total}"
                             data-max="${t.total}"
                             name="grade_${row.alumnoId}_${t.id}"
                             value="${row.grades[t.id] != null ? row.grades[t.id] : ''}" />
                    </div>
                  </c:forEach>
                </div>
              </c:forEach>

            </div>
          </div>
        </div>
      </form>

    </section>

    <section class="container">
      <table class="grade-table">
        <thead>
          <tr>
            <td colspan="3" class="text-uppercase">Escala: (TP: ${totalPossiblePoints})</td>
          </tr>
        </thead>
        <tbody>
          <tr>
            <th>DESDE</th>
            <th>HASTA</th>
            <th>NOTA</th>
          </tr>
          <tr class="five-color">
            <td>${gradeRanges['5'][0]}</td>
            <td>${gradeRanges['5'][1]}</td>
            <td>5</td>
          </tr>
          <tr class="four-color">
            <td>${gradeRanges['4'][0]}</td>
            <td>${gradeRanges['4'][1]}</td>
            <td>4</td>
          </tr>
          <tr class="three-color">
            <td>${gradeRanges['3'][0]}</td>
            <td>${gradeRanges['3'][1]}</td>
            <td>3</td>
          </tr>
          <tr class="two-color">
            <td>${gradeRanges['2'][0]}</td>
            <td>${gradeRanges['2'][1]}</td>
            <td>2</td>
          </tr>
          <tr class="one-color">
            <td>${gradeRanges['2'][0] - 1}</td>
            <td>y menos</td>
            <td>1</td>
          </tr>
        </tbody>
        <tfoot>
          <tr>
            <td colspan="3">Exigencia: ${exigencia}&percnt;</td>
          </tr>
        </tfoot>
      </table>
    </section>

    <footer class="footer">
      <hr>
      <p>Colegio Técnico Nacional</p>
    </footer>

    </div>

  </main>

  <c:if test="${not empty gradeRanges}">
    <script>
      window.planillaGradeRanges = {
        <c:forEach var="entry" items="${gradeRanges}" varStatus="loop">
          "${fn:escapeXml(entry.key)}":[${entry.value[0]},${entry.value[1]}]<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
      };
    </script>
  </c:if>
  <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/vendor/jquery.min.js"></script>
  <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/flat-ui.js"></script>
  <script src="${pageContext.request.contextPath}/scripts/sia-theme.js?v=164"></script>
</body>

</html>
