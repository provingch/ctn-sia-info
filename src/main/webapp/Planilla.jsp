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
  <title><c:out value="${not empty pageTitle ? pageTitle : planilla.nombre}" /></title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/sia-base.css?v=163">
  <script src="${pageContext.request.contextPath}/scripts/planilla.js?v=163"></script>
  <script src="${pageContext.request.contextPath}/scripts/session-dropdown.js?v=163"></script>
  <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/ctn-logo.svg">
</head>

<body data-specialty="${empty sessionScope.siaSpecialty ? 'informatica' : sessionScope.siaSpecialty}">
  <header class="site-header">
    <div class="header-logo-container">
      <a href="${pageContext.request.contextPath}/HomeServlet" aria-label="Ir a inicio">
        <img class="header-logo" src="${pageContext.request.contextPath}/images/ctn-logo.svg">
      </a>
    </div>
    <div class="header-school-name">
      Colegio Técnico Nacional
    </div>
    <c:url var="profileUrl" value="/ProfileServlet" />
    <c:url var="logoutUrl" value="/LogoutServlet" />

    <div class="right-section">
      <div class="manual-container">
        <a class="manual-link" href="${pageContext.request.contextPath}/pdfs/manual.pdf" target="_blank">Manual</a>
      </div>

      <div class="session-dropdown" id="sessionDropdown">
        <button
          class="session-button"
          id="sessionButton"
          aria-haspopup="true"
          aria-expanded="false"
          aria-controls="sessionMenu">
          Sesión
          <svg class="dropdown-icon" viewBox="0 0 24 24" fill="currentColor">
            <path d="M7 10l5 5 5-5z"/>
          </svg>
        </button>

        <nav class="session-menu" id="sessionMenu" role="menu" aria-labelledby="sessionButton">
          <a role="menuitem" class="session-item" href="${profileUrl}">Mi Perfil</a>
          <a role="menuitem" class="session-item session-logout" href="${logoutUrl}">Cerrar Sesión</a>
        </nav>
      </div>
    </div>
  </header>


  <main>
    <div class="wrap">
    <section class="container">
      <div class="titleblock">
        <div class="tb-left">
          <div class="tb-logo">CTN</div>
          <div class="tb-name">
            <h1 style="font-size:15px;">Colegio Técnico Nacional</h1>
            <span>SISTEMA DE INFORMES ACADÉMICOS</span>
          </div>
        </div>
        <div class="tb-right">
          <div class="tb-cell"><b>Curso</b>${curso.getCurso()}.<sup>o</sup> "${curso.seccion}"</div>
          <div class="tb-cell"><b>Especialidad</b><span id="tbSpecialtyName">${curso.especialidad}</span></div>
          <div class="tb-cell"><b>Docente</b>${sessionScope.user.fullName}</div>
          <div class="tb-cell"><b>Fecha</b><span>${nowFormatted}</span></div>
        </div>
      </div>

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
            <div class="table" style="grid-template-columns: 40px 260px 140px${taskColumns} minmax(110px, 1fr);">
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
                <div class="cell empty-fill"></div>
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
                  <div class="cell empty-fill"></div>
                </div>
              </c:forEach>

            </div>
          </div>
        </div>
      </form>

    </section>

    <footer class="footer">
      <hr>
      <p>Colegio Técnico Nacional</p>
    </footer>

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
  <script src="${pageContext.request.contextPath}/scripts/sia-theme.js?v=163"></script>
</body>

</html>