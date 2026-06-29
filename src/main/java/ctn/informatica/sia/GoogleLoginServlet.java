package ctn.informatica.sia;

import java.io.IOException;
import java.net.URLEncoder;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/GoogleLoginServlet")
public class GoogleLoginServlet extends HttpServlet {

    private static final String CLIENT_ID = System.getenv("GOOGLE_CLIENT_ID");
    private static final String REDIRECT_URI = "https://tu-dominio.com/GoogleCallbackServlet";

    private static final String SCOPES = String.join(" ",
        "https://www.googleapis.com/auth/classroom.courses.readonly",
        "https://www.googleapis.com/auth/classroom.coursework.students",
        "https://www.googleapis.com/auth/classroom.rosters.readonly",
        "email", "profile"
    );

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String authUrl = "https://accounts.google.com/o/oauth2/v2/auth"
            + "?client_id=" + CLIENT_ID
            + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
            + "&response_type=code"
            + "&scope=" + URLEncoder.encode(SCOPES, "UTF-8")
            + "&access_type=offline"      // necesario para obtener refresh_token
            + "&prompt=consent";           // fuerza refresh_token incluso si ya autorizó antes

        resp.sendRedirect(authUrl);
    }
}