package ctn.informatica.sia;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.services.oauth2.Oauth2;
import com.google.api.services.oauth2.model.Userinfo;

import ctn.informatica.sia.config.AppConfig;
import ctn.informatica.sia.dao.ProfesorDao;
import ctn.informatica.sia.model.Profesor;

@WebServlet("/GoogleCallbackServlet")
public class GoogleCallbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String code = req.getParameter("code");
        String error = req.getParameter("error");

        if (error != null) {
            resp.sendRedirect("/login?error=oauth_denied");
            return;
        }

        if (code == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Falta parámetro 'code'");
            return;
        }

        String clientId = AppConfig.get("google.client.id");
        String clientSecret = AppConfig.get("google.client.secret");
        String redirectUri = AppConfig.get("google.redirect.uri");

        try {
            // --- Paso 1: intercambiar code por tokens ---
            GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                    new NetHttpTransport(),
                    GsonFactory.getDefaultInstance(),
                    "https://oauth2.googleapis.com/token",
                    clientId,
                    clientSecret,
                    code,
                    redirectUri)
                .execute();

            String accessToken = tokenResponse.getAccessToken();
            String refreshToken = tokenResponse.getRefreshToken(); // puede ser null si ya existía
            long expiresInSeconds = tokenResponse.getExpiresInSeconds();

            // --- Paso 2: obtener el email del profesor ---
            Credential credential = new GoogleCredential().setAccessToken(accessToken);

            Oauth2 oauth2 = new Oauth2.Builder(
                    new NetHttpTransport(), GsonFactory.getDefaultInstance(), credential)
                .setApplicationName("CTN-SIA")
                .build();

            Userinfo userInfo = oauth2.userinfo().get().execute();
            String googleEmail = userInfo.getEmail();

            // --- Paso 3: vincular email → profesor en la BD ---
            ProfesorDao profesorDao = new ProfesorDao();
            Profesor profesor = profesorDao.findByGoogleEmail(googleEmail);

            if (profesor == null) {
                resp.sendRedirect("/login?error=profesor_no_encontrado");
                return;
            }

            long expiry = (System.currentTimeMillis() / 1000) + expiresInSeconds;

            profesorDao.updateGoogleTokens(
                profesor.getId(),
                accessToken,
                refreshToken,
                expiry
            );

            // --- Paso 4: crear la HttpSession ---
            HttpSession session = req.getSession(true);
            session.setAttribute("user", profesor);
            session.setAttribute("googleAccessToken", accessToken);
            session.setMaxInactiveInterval(60 * 60);

            resp.sendRedirect("/portal/dashboard");

        } catch (IOException e) {
            e.printStackTrace();
            resp.sendRedirect("/login?error=token_exchange_failed");
        }
    }
}