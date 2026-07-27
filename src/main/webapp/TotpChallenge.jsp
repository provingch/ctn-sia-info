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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/ctn-theme.css?v=210">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/ctn-logo.svg">
  </head>
  <body class="login-page">
    <main class="login-main">
      <div class="login-wrapper">
        <div class="login-card">
          <div class="login-logo-container">
            <img class="login-logo" src="${pageContext.request.contextPath}/images/ctn-logo-2.svg" alt="CTN logo">
          </div>
          <div class="login-heading">
            <h1>Verificación en dos pasos</h1>
            <p>Ingresa el código de tu app de autenticación para continuar.</p>
          </div>
          <c:if test="${not empty verifyError}">
            <div class="login-error">${verifyError}</div>
          </c:if>
          <form class="login-form" action="${pageContext.request.contextPath}/TotpServlet" method="post">
            <label for="totpCode">Código de autenticación</label>
            <input class="form-password" type="text" id="totpCode" name="totpCode" maxlength="6" placeholder="123456" required>
            <button class="form-submit" type="submit">Verificar código</button>
          </form>
          <p class="login-info">Usuario: <strong><c:out value="${pendingUsername}"/></strong></p>
          <p class="login-info"><a href="${pageContext.request.contextPath}/index.jsp">Volver al inicio de sesión</a></p>
        </div>
      </div>
    </main>
    <footer class="footer">
      <hr>
      <p>Colegio Técnico Nacional</p>
    </footer>
    <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/vendor/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/vendor/flat-ui/js/flat-ui.js"></script>
  </body>
</html>
