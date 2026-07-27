<%-- 
    Document   : Profile
    Created on : Sep 15, 2025, 6:08:05 PM
    Author     : jonat
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html data-theme="light">

<head>
  <title>Mi Perfil</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/vendor/flat-ui/css/flat-ui.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/ctn-theme.css?v=222">
  <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/ctn-logo.svg">
  <style>
  .inline-form {
    display: inline-block;
    margin: 0;
  }
  .security-status {
    margin: 0.6rem 0 1rem;
    padding: 0.9rem 1rem;
    border-radius: 0.7rem;
    background: #f8fbff;
    color: #22303f;
    border: 1px solid #dbeafe;
    box-shadow: inset 0 1px 0 rgba(255,255,255,0.6);
  }
  .security-status--enabled {
    border-left: 4px solid #3c8dbc;
  }
  .security-status--disabled {
    border-left: 4px solid #d9534f;
  }
  .security-actions {
    display: flex;
    gap: 0.75rem;
    flex-wrap: wrap;
    align-items: center;
  }
  .security-panel-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
    gap: 1rem;
  }
  .totp-setup {
    display: grid;
    gap: 0.75rem;
  }
  .totp-setup-card {
    background: linear-gradient(135deg, #ffffff 0%, #f8fbff 100%);
    border-left-color: #2563eb;
    box-shadow: 0 12px 30px rgba(15, 23, 42, 0.07);
  }
  .totp-setup-card .form-card-header {
    background: linear-gradient(90deg, #eff6ff 0%, #dbeafe 100%);
    color: #0f172a;
    font-weight: 700;
    letter-spacing: 0.01em;
  }
  .totp-setup-box {
    padding: 1rem;
    border-radius: 0.85rem;
    background: linear-gradient(135deg, #f8fbff 0%, #eef6ff 100%);
    border: 1px solid #dbeafe;
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.8);
  }
  .totp-qr {
    display: block;
    max-width: 220px;
    width: 100%;
    margin: 0.85rem auto 0.95rem;
    padding: 0.8rem;
    background: #ffffff;
    border: 1px solid #dbeafe;
    border-radius: 0.9rem;
    box-shadow: 0 10px 25px rgba(15, 23, 42, 0.08);
  }
  .activity-log ul {
    margin: 0;
    padding-left: 1.2rem;
    display: grid;
    gap: 0.6rem;
  }
  .totp-secret {
    word-break: break-all;
    padding: 0.8rem 0.95rem;
    background: #ffffff;
    border: 1px solid #dbeafe;
    border-radius: 0.7rem;
    margin: 0.5rem 0 0;
    color: #1e293b;
    font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
    font-size: 0.92rem;
  }
  </style>
</head>

<body data-specialty="${empty sessionScope.siaSpecialty ? 'informatica' : sessionScope.siaSpecialty}">
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
    <section class="container page-shell">

      <c:if test="${not empty sessionScope.flashMessage}">
        <div class="flash" data-timeout="4000">
          ${sessionScope.flashMessage}
          <button type="button" class="flash-close" aria-label="Cerrar mensaje">&times;</button>
        </div>
        <c:remove var="flashMessage" scope="session"/>
      </c:if>

      <c:if test="${not empty errors}">
        <c:forEach var="err" items="${errors}">
            <div class="flash-errors" data-timeout="4000">
              <c:out value="${err}" />
              <button type="button" class="flash-close" aria-label="Cerrar mensajes de error">&times;</button>
            </div>
        </c:forEach>
        <c:remove var="errors" scope="session"/>
      </c:if>

      <div class="profile-layout">
        <c:url var="HomeUrl" value="/HomeServlet" />
        <div class="profile-shell">
          <aside class="profile-sidebar" aria-label="Navegación de perfil">
            <div class="profile-role-banner">
              <span class="profile-role-label">Rol actual</span>
              <strong><c:out value="${profileRoleLabel}" /></strong>
              <p><c:out value="${profileAccessDescription}" /></p>
            </div>
            <div class="profile-tabs" role="tablist" aria-label="Secciones del perfil">
              <button type="button" class="profile-tab active" data-target="perfil-panel" role="tab" aria-controls="perfil-panel" aria-selected="true">
                <span>Perfil</span>
                <small>Datos personales</small>
              </button>
              <button type="button" class="profile-tab" data-target="seguridad-panel" role="tab" aria-controls="seguridad-panel" aria-selected="false">
                <span>Seguridad</span>
                <small>Contraseña</small>
              </button>
              <c:if test="${showMateriasPanel}">
                <button type="button" class="profile-tab" data-target="materias-panel" role="tab" aria-controls="materias-panel" aria-selected="false">
                  <span>Materias</span>
                  <small>Asignaciones</small>
                </button>
              </c:if>
              <button type="button" class="profile-tab" data-target="registros-panel" role="tab" aria-controls="registros-panel" aria-selected="false">
                <span>Registros</span>
                <small>Actividad</small>
              </button>
            </div>
            <a id="backBtn" class="profile-back-link" href="${HomeUrl}">
              <img class="back-icon" src="${pageContext.request.contextPath}/icons/back-arrow.svg" alt="Atrás">
              <span>Volver al inicio</span>
            </a>
          </aside>
          <div class="profile-content">
          <div class="profile-panels">
            <section id="perfil-panel" class="profile-panel active">
              <c:choose>
                <c:when test="${isStaffProfile}">
                  <form id="profileForm" action="${pageContext.request.contextPath}/ProfileServlet" method="post" data-status-target="profileSaveStatus">
                    <input type="hidden" name="action" value="saveProfile" />
                    <div class="profile-grid profile-grid-layout">
                      <div class="form-card card">
                        <div class="form-card-header">Información Personal</div>
                        <div class="form-field">
                          <label for="nombre">Nombre</label>
                          <c:choose>
                            <c:when test="${canEditAdminOnlyProfileFields}">
                              <input type="text" id="nombre" name="nombre" value="${profesor.nombre}" />
                            </c:when>
                            <c:otherwise>
                              <input type="text" id="nombre" value="${profesor.nombre}" disabled />
                            </c:otherwise>
                          </c:choose>
                        </div>
                        <div class="form-field">
                          <label for="apellido">Apellido</label>
                          <c:choose>
                            <c:when test="${canEditAdminOnlyProfileFields}">
                              <input type="text" id="apellido" name="apellido" value="${profesor.apellido}" />
                            </c:when>
                            <c:otherwise>
                              <input type="text" id="apellido" value="${profesor.apellido}" disabled />
                            </c:otherwise>
                          </c:choose>
                        </div>
                        <div class="form-field">
                          <label for="ci">Cédula</label>
                          <c:choose>
                            <c:when test="${canEditAdminOnlyProfileFields}">
                              <input type="text" id="ci" name="ci" value="${profesor.ci}" />
                            </c:when>
                            <c:otherwise>
                              <input type="text" id="ci" value="${profesor.ci}" disabled />
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </div>
                      <div class="form-card card">
                        <div class="form-card-header">Contacto</div>
                        <div class="form-field">
                          <label for="correo">Correo electrónico</label>
                          <input type="email" id="correo" name="correo" value="${profesor.correo}" />
                        </div>
                        <div class="form-field">
                          <label for="telefono">Teléfono</label>
                          <input class="no-spinner" type="number" id="telefono" name="telefono" value="${profesor.telefono}" />
                        </div>
                        <div class="form-field">
                          <label for="celular">Celular</label>
                          <input class="no-spinner" type="number" id="celular" name="celular" value="${profesor.celular}" />
                        </div>
                      </div>
                      <div class="form-card card">
                        <div class="form-card-header">Cuenta</div>
                        <div class="form-field">
                          <label for="usuario">Usuario</label>
                          <input type="text" id="usuario" name="usuario" value="${profesor.usuario}" />
                        </div>
                      </div>
                      <c:if test="${showGoogleClassroomPanel}">
                        <div class="form-card card">
                          <div class="form-card-header">Google Classroom</div>
                          <c:url var="googleConnectUrl" value="/GoogleLoginServlet" />
                          <c:url var="googleDisconnectUrl" value="/GoogleDisconnectServlet" />
                          <c:choose>
                            <c:when test="${not empty profesor.googleEmail or not empty profesor.gcAccessToken}">
                              <div class="classroom-status classroom-status--connected">Conectado como <strong><c:out value="${profesor.googleEmail}"/></strong></div>
                              <div class="classroom-actions">
                                <a class="btn-primary" href="${pageContext.request.contextPath}${googleConnectUrl}">Reconectar</a>
                                <button class="btn-danger" type="submit" form="googleDisconnectForm">Desconectar</button>
                              </div>
                            </c:when>
                            <c:otherwise>
                              <div class="classroom-status classroom-status--disconnected">No conectado a Google Classroom</div>
                              <a class="btn-primary" href="${pageContext.request.contextPath}${googleConnectUrl}">Conectar ahora</a>
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </c:if>
                      <span id="profileSaveStatus" class="save-status profile-save-status" aria-live="polite">Guardado automático activo.</span>
                    </div>
                  </form>
                  <form id="googleDisconnectForm" action="${pageContext.request.contextPath}${googleDisconnectUrl}" method="post" style="display:none;"></form>
                </c:when>
                <c:when test="${isParentProfile}">
                  <form id="profileForm" action="${pageContext.request.contextPath}/ProfileServlet" method="post" data-status-target="profileSaveStatus">
                    <input type="hidden" name="action" value="saveProfile" />
                    <div class="profile-grid profile-grid-layout">
                      <div class="form-card card">
                        <div class="form-card-header">Información Personal</div>
                        <div class="form-field">
                          <label for="padreNombre">Nombre</label>
                          <c:choose>
                            <c:when test="${canEditAdminOnlyProfileFields}">
                              <input type="text" id="padreNombre" name="nombre" value="${empty profileOwner.nombre ? '' : profileOwner.nombre}" />
                            </c:when>
                            <c:otherwise>
                              <input type="text" id="padreNombre" value="${empty profileOwner.fullName ? sessionScope.user.fullName : profileOwner.fullName}" disabled />
                            </c:otherwise>
                          </c:choose>
                        </div>
                        <div class="form-field">
                          <label for="padreApellido">Apellido</label>
                          <c:choose>
                            <c:when test="${canEditAdminOnlyProfileFields}">
                              <input type="text" id="padreApellido" name="apellido" value="${empty profileOwner.apellido ? '' : profileOwner.apellido}" />
                            </c:when>
                            <c:otherwise>
                              <input type="text" id="padreApellido" value="${empty profileOwner.apellido ? '' : profileOwner.apellido}" disabled />
                            </c:otherwise>
                          </c:choose>
                        </div>
                        <div class="form-field">
                          <label for="padreCI">Cédula</label>
                          <c:choose>
                            <c:when test="${canEditAdminOnlyProfileFields}">
                              <input type="text" id="padreCI" name="ci" value="${empty profileOwner.ci ? '' : profileOwner.ci}" />
                            </c:when>
                            <c:otherwise>
                              <input type="text" id="padreCI" value="${empty profileOwner.ci ? 'No registrada' : profileOwner.ci}" disabled />
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </div>
                      <div class="form-card card">
                        <div class="form-card-header">Contacto</div>
                        <div class="form-field">
                          <label for="correo">Correo electrónico</label>
                          <input type="email" id="correo" name="correo" value="${empty profileOwner.correo ? '' : profileOwner.correo}" />
                        </div>
                        <div class="form-field">
                          <label for="telefono">Teléfono</label>
                          <input type="text" id="telefono" name="telefono" value="${empty profileOwner.telefono ? '' : profileOwner.telefono}" />
                        </div>
                      </div>
                      <div class="form-card card">
                        <div class="form-card-header">Cuenta</div>
                        <div class="form-field">
                          <label for="usuario">Usuario</label>
                          <input type="text" id="usuario" name="usuario" value="${empty profileOwner.usuario ? sessionScope.user.username : profileOwner.usuario}" />
                        </div>
                      </div>
                      <span id="profileSaveStatus" class="save-status profile-save-status" aria-live="polite">Guardado automático activo.</span>
                    </div>
                  </form>
                </c:when>
                <c:otherwise>
                  <div class="profile-grid profile-grid-layout">
                    <div class="form-card card">
                      <div class="form-card-header">Información Personal</div>
                      <div class="profile-role-pill"><c:out value="${profileRoleLabel}" /></div>
                      <div class="form-field">
                        <label>Vista</label>
                        <input type="text" value="Consulta de perfil" disabled />
                      </div>
                      <div class="form-field">
                        <label>Nombre</label>
                        <input type="text" value="${empty profileOwner.fullName ? sessionScope.user.fullName : profileOwner.fullName}" disabled />
                      </div>
                      <div class="form-field">
                        <label>Cédula</label>
                        <input type="text" value="${empty profileOwner.ci ? 'No registrada' : profileOwner.ci}" disabled />
                      </div>
                    </div>
                    <div class="form-card card">
                      <div class="form-card-header">Cuenta</div>
                      <div class="form-field">
                        <label>Usuario</label>
                        <input type="text" value="${empty profileOwner.usuario ? sessionScope.user.username : profileOwner.usuario}" disabled />
                      </div>
                      <div class="form-field">
                        <label>Correo electrónico</label>
                        <input type="email" value="${empty profileOwner.correo ? 'No registrado' : profileOwner.correo}" disabled />
                      </div>
                      <div class="form-field">
                        <label>Teléfono</label>
                        <input type="text" value="${empty profileOwner.telefono ? 'No registrado' : profileOwner.telefono}" disabled />
                      </div>
                    </div>
                    <div class="form-card card">
                      <div class="form-card-header">Acceso</div>
                      <div class="profile-access-card">
                        <strong><c:out value="${profileRoleLabel}" /></strong>
                        <p><c:out value="${profileAccessDescription}" /></p>
                      </div>
                    </div>
                    <div class="form-card card">
                      <div class="form-card-header">Permisos</div>
                      <div class="profile-permissions-list">
                        <c:choose>
                          <c:when test="${isProfessorProfile}">
                            <span>Edición de datos personales</span>
                            <span>Gestión de Google Classroom</span>
                            <span>Visualización de materias y asignaciones</span>
                          </c:when>
                          <c:when test="${isParentProfile}">
                            <span>Consulta de información familiar</span>
                            <span>Vista académica asociada a estudiantes</span>
                          </c:when>
                          <c:otherwise>
                            <span>Consulta de perfil</span>
                            <span>Acceso a seguridad y registros</span>
                          </c:otherwise>
                        </c:choose>
                      </div>
                    </div>
                  </div>
                </c:otherwise>
              </c:choose>
            </section>

            <section id="seguridad-panel" class="profile-panel" hidden>
              <form id="securityForm" action="${pageContext.request.contextPath}/ProfileServlet" method="post" data-status-target="securitySaveStatus">
                <input type="hidden" name="action" value="changePassword" />
                <div class="security-panel-grid">
                  <div class="table-card card">
                    <div class="table-header">Cambiar Contraseña</div>
                    <div class="cell"><strong>Contraseña Actual</strong></div>
                    <div class="cell">
                      <input type="password" name="currentPassword" id="currentPassword" required />
                    </div>
                    <div class="cell"><strong>Nueva Contraseña</strong></div>
                    <div class="cell">
                      <input type="password" name="newPassword" id="newPassword" required />
                    </div>
                    <div class="cell"><strong>Confirmar Contraseña</strong></div>
                    <div class="cell">
                      <input type="password" name="confirmPassword" id="confirmPassword" required />
                    </div>
                    <div class="cell selection-hint" style="grid-column: 1 / -1;">
                      La contraseña debe tener al menos 6 caracteres.
                    </div>
                    <div class="cell" style="grid-column: 1 / -1;">
                      <button class="btn-primary save-button" type="submit">Cambiar Contraseña</button>
                      <span id="securitySaveStatus" class="save-status" aria-live="polite">Listo.</span>
                    </div>
                  </div>

                  <div class="form-card card totp-setup-card">
                    <div class="form-card-header">Seguridad adicional</div>
                    <div class="form-field">
                      <strong>Autenticación de dos factores (2FA)</strong>
                      <c:choose>
                        <c:when test="${totpEnabled}">
                          <div class="security-status security-status--enabled">2FA activado en esta cuenta.</div>
                          <p>Usa tu app de autenticación para generar el código de inicio de sesión.</p>
                        </c:when>
                        <c:otherwise>
                          <div class="security-status security-status--disabled">2FA no está activo.</div>
                          <p>Activa 2FA para proteger tu cuenta con un código extra al iniciar sesión.</p>
                        </c:otherwise>
                      </c:choose>
                    </div>
                    <div class="form-field security-actions">
                      <c:choose>
                        <c:when test="${totpEnabled}">
                          <button class="btn-danger" type="submit" form="disableTotpForm">Desactivar 2FA</button>
                        </c:when>
                        <c:otherwise>
                          <button class="btn-secondary" type="submit" form="prepareTotpForm">Configurar 2FA</button>
                        </c:otherwise>
                      </c:choose>
                    </div>
                    <c:if test="${not empty pendingTotpSecret}">
                      <div class="form-field">
                        <div class="totp-setup-box">
                          <p>Escanea el código QR con tu app de autenticación o copia el secreto manualmente:</p>
                          <c:if test="${not empty totpQrUrl}">
                            <img class="totp-qr" src="${totpQrUrl}" alt="Código QR de 2FA" />
                          </c:if>
                          <div class="totp-secret"><c:out value="${pendingTotpSecret}" /></div>
                        </div>
                      </div>
                      <form id="confirmTotpForm" action="${pageContext.request.contextPath}/ProfileServlet" method="post" style="margin:0;">
                        <input type="hidden" name="action" value="confirmTotp" />
                        <div class="form-field">
                          <label for="totpSetupCode">Código de la app</label>
                          <input type="text" id="totpSetupCode" name="totpSetupCode" maxlength="6" inputmode="numeric" autocomplete="one-time-code" required />
                        </div>
                        <div class="form-field security-actions">
                          <button class="btn-primary" id="confirmTotpButton" type="submit">Confirmar activación</button>
                        </div>
                      </form>
                    </c:if>
                  </div>
                </div>
              </form>

              <form id="prepareTotpForm" action="${pageContext.request.contextPath}/ProfileServlet" method="post" style="margin:0; display:none;">
                <input type="hidden" name="action" value="prepareTotp" />
              </form>
              <form id="disableTotpForm" action="${pageContext.request.contextPath}/ProfileServlet" method="post" style="margin:0; display:none;">
                <input type="hidden" name="action" value="disableTotp" />
              </form>
            </section>

        <c:if test="${showMateriasPanel}">
          <section id="materias-panel" class="profile-panel" hidden>
            <div class="table-card table-card--wide card">
              <div class="table-header">Asignaciones de materias</div>
              <div class="subject-list-grid">
                <c:choose>
                  <c:when test="${empty misAsignaciones}">
                    <p class="empty-state">No hay asignaciones de materias registradas.</p>
                  </c:when>
                  <c:otherwise>
                    <div class="subject-list-header">
                      <span>Materia</span>
                      <span>Curso</span>
                    </div>
                    <c:forEach var="asignacion" items="${misAsignaciones}">
                      <div class="subject-item">
                        <span class="subject-item__name"><c:out value="${asignacion.materiaNombre}" /></span>
                        <span class="subject-item__course"><c:out value="${asignacion.cursoDescripcion}" /></span>
                      </div>
                    </c:forEach>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </section>
        </c:if>

        <section id="registros-panel" class="profile-panel" hidden>
          <div class="activity-log">
            <c:choose>
              <c:when test="${empty activityLog}">
                <p class="empty-state">Aún no hay movimientos registrados.</p>
              </c:when>
              <c:otherwise>
                <ul>
                  <c:forEach var="entry" items="${activityLog}">
                    <li><c:out value="${entry}" /></li>
                  </c:forEach>
                </ul>
              </c:otherwise>
            </c:choose>
          </div>
        </section>
      </div>
    </div>
  </div>
    </section>

    <footer class="footer">
      <hr>
      <p>Colegio Técnico Nacional</p>
    </footer>
  </main>

<script>
(function () {
  const tabs = document.querySelectorAll('.profile-tab');
  const panels = document.querySelectorAll('.profile-panel');
  const storageKey = 'ctn-profile-active-tab';

  function activateTab(tab) {
    tabs.forEach(function (item) {
      item.classList.remove('active');
      item.setAttribute('aria-selected', 'false');
    });
    panels.forEach(function (panel) {
      panel.classList.remove('active');
      panel.hidden = true;
    });
    tab.classList.add('active');
    tab.setAttribute('aria-selected', 'true');
    const target = document.getElementById(tab.dataset.target);
    if (target) {
      target.classList.add('active');
      target.hidden = false;
    }
    try {
      localStorage.setItem(storageKey, tab.dataset.target);
    } catch (e) {
      // ignore localStorage failures
    }
  }

  const savedTarget = (() => {
    try {
      return localStorage.getItem(storageKey);
    } catch (e) {
      return null;
    }
  })();
  const initialTab = Array.from(tabs).find(function (t) {
    return t.dataset.target === savedTarget;
  }) || tabs[0];
  if (initialTab) {
    activateTab(initialTab);
  }

  tabs.forEach(function (tab) {
    tab.addEventListener('click', function () {
      activateTab(tab);
    });
  });
})();
</script>

<script>
(function () {
  const profileForm = document.getElementById('profileForm');
  const securityForm = document.getElementById('securityForm');

  function resolveAjaxPayload(responseText, response) {
    const contentType = response.headers.get('content-type') || '';
    if (contentType.includes('application/json')) {
      try {
        return JSON.parse(responseText);
      } catch (e) {
        return { success: response.ok, message: responseText || 'Operación completada.' };
      }
    }
    return { success: response.ok, message: responseText || 'Operación completada.' };
  }

  function setStatus(el, message, tone) {
    if (!el) return;
    el.textContent = message;
    el.className = 'save-status ' + tone;
  }

  function submitWithFetch(form, statusId, successMessage, isSecurityForm) {
    const statusEl = document.getElementById(statusId);

    const formData = new FormData(form);
    const body = new URLSearchParams();
    for (const [key, value] of formData.entries()) {
      body.append(key, value);
    }
    setStatus(statusEl, 'Guardando...', 'is-saving');

    fetch(form.getAttribute('action'), {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'X-Requested-With': 'XMLHttpRequest'
      },
      body: body
    }).then(async function (response) {
      const responseText = await response.text();
      const payload = resolveAjaxPayload(responseText, response);
      if (!response.ok || !payload.success) {
        throw new Error(payload.message || 'No se pudo guardar la información.');
      }

      if (isSecurityForm) {
        ['currentPassword', 'newPassword', 'confirmPassword'].forEach(function (id) {
          const input = document.getElementById(id);
          if (input) input.value = '';
        });
      }

      setStatus(statusEl, payload.message || successMessage, 'is-success');
    }).catch(function (error) {
      setStatus(statusEl, error.message || 'No se pudo guardar.', 'is-error');
    });
  }

  if (profileForm) {
    let autoSaveTimer;
    const profileStatus = document.getElementById('profileSaveStatus');
    function scheduleProfileSave() {
      clearTimeout(autoSaveTimer);
      autoSaveTimer = setTimeout(function () {
        submitWithFetch(profileForm, 'profileSaveStatus', 'Datos guardados.', false);
      }, 800);
    }

    profileForm.addEventListener('input', function (event) {
      if (!['correo', 'telefono', 'celular', 'usuario', 'especialidadId', 'nombre', 'apellido', 'ci', 'nivel'].includes(event.target.name)) return;
      scheduleProfileSave();
    });

    profileForm.addEventListener('change', function (event) {
      if (!['correo', 'telefono', 'celular', 'usuario', 'especialidadId', 'nombre', 'apellido', 'ci', 'nivel'].includes(event.target.name)) return;
      scheduleProfileSave();
    });

    profileStatus && setStatus(profileStatus, 'Guardado automático activo.', 'is-success');
  }

  if (securityForm) {
    const securityStatus = document.getElementById('securitySaveStatus');
    securityForm.addEventListener('submit', function (event) {
      event.preventDefault();
      submitWithFetch(securityForm, 'securitySaveStatus', 'Contraseña actualizada.', true);
    });
    securityStatus && setStatus(securityStatus, 'Listo para guardar.', 'is-success');
  }

  const confirmTotpButton = document.getElementById('confirmTotpButton');
  const confirmTotpForm = document.getElementById('confirmTotpForm');
  const totpSetupCodeInput = document.getElementById('totpSetupCode');
  const confirmTotpSetupCode = document.getElementById('confirmTotpSetupCode');

  if (confirmTotpButton && confirmTotpForm && totpSetupCodeInput && confirmTotpSetupCode) {
    confirmTotpButton.addEventListener('click', function () {
      confirmTotpSetupCode.value = totpSetupCodeInput.value.trim();
      confirmTotpForm.submit();
    });
  }
})();
</script>

<script>
(function () {
  const nodes = document.querySelectorAll('.flash, .flash-errors');
  if (!nodes.length) return;

  nodes.forEach(function (el) {
    let timeoutMs = parseInt(el.dataset.timeout, 10);
    if (!Number.isFinite(timeoutMs)) timeoutMs = 4000;

    let timer = setTimeout(() => {
      if (el.classList.contains('flash')) el.classList.add('flash--hide');
      else el.classList.add('flash-errors--hide');
    }, timeoutMs);

    el.addEventListener('transitionend', function (ev) {
      if (ev.propertyName === 'opacity' || ev.propertyName === 'max-height') {
        try { el.remove(); } catch (e) {}
      }
    });

    el.addEventListener('mouseenter', () => clearTimeout(timer));

    const closeBtn = el.querySelector('.flash-close');
    if (closeBtn) {
      closeBtn.addEventListener('click', function (e) {
        e.preventDefault();
        clearTimeout(timer);
        if (el.classList.contains('flash')) el.classList.add('flash--hide');
        else el.classList.add('flash-errors--hide');
      });
    }
  });
})();
</script>
  <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/vendor/jquery.min.js"></script>
  <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/flat-ui.js"></script>
  <script src="${pageContext.request.contextPath}/scripts/sia-theme.js?v=164"></script>
</body>

</html>
