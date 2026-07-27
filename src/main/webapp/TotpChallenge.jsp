<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Optional"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html data-theme="light">
  <head>
    <title>Verificación 2FA</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/vendor/flat-ui/css/flat-ui.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/ctn-theme.css?v=222">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/ctn-logo.svg">
    <style>
      .totp-container {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
        background: var(--bg-secondary, #f5f7fa);
        padding: 0;
        margin: 0;
      }
      .totp-content {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 2rem 1rem;
      }
      .totp-card {
        background: var(--bg-primary, #ffffff);
        border-radius: 0.5rem;
        box-shadow: 0 4px 20px rgba(15, 23, 42, 0.1);
        border-top: 4px solid #a41f3d;
        padding: 3rem 2rem;
        max-width: 500px;
        width: 100%;
      }
      html[data-theme="dark"] .totp-card {
        background: var(--bg-primary, #1e293b);
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
      }
      .totp-logo-container {
        text-align: center;
        margin-bottom: 2rem;
      }
      .totp-logo {
        width: 80px;
        height: 80px;
      }
      .totp-heading h1 {
        font-size: 1.75rem;
        font-weight: 700;
        margin: 1.5rem 0 0.75rem;
        color: var(--text-primary, #0f172a);
        text-align: center;
      }
      html[data-theme="dark"] .totp-heading h1 {
        color: var(--text-primary, #e2e8f0);
      }
      .totp-heading p {
        color: var(--text-secondary, #64748b);
        text-align: center;
        margin: 0 0 1.5rem;
        font-size: 0.95rem;
      }
      html[data-theme="dark"] .totp-heading p {
        color: var(--text-secondary, #cbd5e1);
      }
      .totp-error {
        background: #fee2e2;
        border: 1px solid #fca5a5;
        border-left: 4px solid #dc2626;
        color: #991b1b;
        padding: 0.75rem 1rem;
        border-radius: 0.4rem;
        margin-bottom: 1.5rem;
        font-size: 0.9rem;
      }
      html[data-theme="dark"] .totp-error {
        background: #7f1d1d;
        border-color: #991b1b;
        border-left-color: #ef4444;
        color: #fca5a5;
      }
      .totp-form {
        display: grid;
        gap: 1.25rem;
      }
      .totp-form label {
        display: block;
        font-weight: 600;
        margin-bottom: 0.5rem;
        color: var(--text-primary, #0f172a);
        font-size: 0.95rem;
      }
      html[data-theme="dark"] .totp-form label {
        color: var(--text-primary, #e2e8f0);
      }
      .totp-form input {
        width: 100%;
        padding: 0.75rem 1rem;
        border: 1px solid #dbeafe;
        border-radius: 0.4rem;
        font-size: 1rem;
        font-family: monospace;
        letter-spacing: 0.1em;
        text-align: center;
      }
      html[data-theme="dark"] .totp-form input {
        background: #1e293b;
        border-color: #334155;
        color: #e2e8f0;
      }
      .totp-form input:focus {
        outline: none;
        border-color: #3b82f6;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
      }
      .totp-submit {
        background: #a41f3d;
        color: #ffffff;
        padding: 0.85rem 1.5rem;
        border: none;
        border-radius: 0.4rem;
        font-size: 1rem;
        font-weight: 600;
        cursor: pointer;
        transition: background 0.2s ease;
        width: 100%;
      }
      .totp-submit:hover {
        background: #8b1930;
      }
      .totp-submit:active {
        background: #6d0f24;
      }
      .totp-info {
        background: #eff6ff;
        border: 1px solid #dbeafe;
        border-radius: 0.4rem;
        padding: 0.75rem 1rem;
        margin-top: 1.5rem;
        font-size: 0.9rem;
        color: #0f172a;
      }
      html[data-theme="dark"] .totp-info {
        background: #1e3a8a;
        border-color: #1e40af;
        color: #e0f2fe;
      }
      .totp-link {
        color: #2563eb;
        text-decoration: none;
        font-weight: 500;
      }
      html[data-theme="dark"] .totp-link {
        color: #60a5fa;
      }
      .totp-link:hover {
        text-decoration: underline;
      }
      .totp-footer {
        text-align: center;
        margin-top: 1.5rem;
        padding-top: 1.5rem;
        border-top: 1px solid #e2e8f0;
      }
      html[data-theme="dark"] .totp-footer {
        border-top-color: #334155;
      }
      .totp-footer a {
        color: #2563eb;
        text-decoration: none;
        font-size: 0.9rem;
      }
      html[data-theme="dark"] .totp-footer a {
        color: #60a5fa;
      }
      .totp-footer a:hover {
        text-decoration: underline;
      }
    </style>
  </head>
  <body class="totp-container">
    <header class="navbar navbar-default navbar-fixed-top ctn-navbar" role="navigation">
      <div class="container-fluid">
        <div class="navbar-header">
          <a class="navbar-brand ctn-navbar-brand" href="${pageContext.request.contextPath}/index.jsp" aria-label="Ir a inicio">
            <img class="header-logo" src="${pageContext.request.contextPath}/images/ctn-logo.svg" alt="CTN">
            <span>Colegio Técnico Nacional</span>
          </a>
        </div>
        <div class="navbar-collapse">
          <ul class="nav navbar-nav navbar-right ctn-navbar-actions">
            <li class="ctn-theme-item"></li>
          </ul>
        </div>
      </div>
    </header>

    <div class="totp-content">
      <div class="totp-card">
        <div class="totp-logo-container">
          <img class="totp-logo" src="${pageContext.request.contextPath}/images/ctn-logo-2.svg" alt="CTN logo">
        </div>
        <div class="totp-heading">
          <h1>Verificación en dos pasos</h1>
          <p>Ingresa el código de tu app de autenticación para continuar.</p>
        </div>
        <c:if test="${not empty verifyError}">
          <div class="totp-error">${verifyError}</div>
        </c:if>
        <form class="totp-form" action="${pageContext.request.contextPath}/TotpServlet" method="post">
          <div>
            <label for="totpCode">Código de autenticación</label>
            <input type="text" id="totpCode" name="totpCode" maxlength="6" placeholder="123456" required autofocus>
          </div>
          <button class="totp-submit" type="submit">Verificar código</button>
        </form>
        <div class="totp-info">
          <strong>Usuario:</strong> <c:out value="${pendingUsername}"/>
        </div>
        <div class="totp-footer">
          <a href="${pageContext.request.contextPath}/index.jsp">Volver al inicio de sesión</a>
        </div>
      </div>
    </div>

    <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/vendor/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/flat-ui.js"></script>
    <script src="${pageContext.request.contextPath}/scripts/dark-mode.js"></script>
  </body>
</html>
