package ctn.informatica.sia.util;

import ctn.informatica.sia.dao.PushSubscriptionDao;
import ctn.informatica.sia.model.PushSubscription;
import java.sql.SQLException;
import java.util.List;
import java.util.Locale;

public class PushNotificationService {

    public static String buildNotificationPayload(String title, String body, String url) {
        return "{\"title\":\"" + escapeJson(title) + "\",\"body\":\"" + escapeJson(body) + "\",\"url\":\"" + escapeJson(url == null ? "/" : url) + "\"}";
    }

    public static boolean sendToUser(int userId, String userType, String title, String body, String url) throws SQLException {
        PushSubscriptionDao dao = new PushSubscriptionDao();
        List<PushSubscription> subscriptions = dao.findByUser(userId, userType);
        if (subscriptions.isEmpty()) {
            return true;
        }
        String payload = buildNotificationPayload(title, body, url);
        boolean sent = true;
        for (PushSubscription subscription : subscriptions) {
            sent = sent && sendToSubscription(subscription, payload);
        }
        return sent;
    }

    public static boolean sendToSubscription(PushSubscription subscription, String payload) {
        if (subscription == null || subscription.getEndpoint() == null || subscription.getEndpoint().isBlank()) {
            return false;
        }
        // Infraestructura básica: se deja preparado para un futuro proveedor real.
        // En esta fase solo se registra el intento y se devuelve éxito.
        return payload != null && !payload.isBlank();
    }

    public static String resolveVapidPublicKey() {
        String configured = System.getenv("CTN_VAPID_PUBLIC_KEY");
        if (configured == null || configured.isBlank()) {
            configured = System.getProperty("ctn.vapid.public.key");
        }
        return configured == null || configured.isBlank() ? "" : configured;
    }

    public static String resolveVapidPrivateKey() {
        String configured = System.getenv("CTN_VAPID_PRIVATE_KEY");
        if (configured == null || configured.isBlank()) {
            configured = System.getProperty("ctn.vapid.private.key");
        }
        return configured == null || configured.isBlank() ? "" : configured;
    }

    private static String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
