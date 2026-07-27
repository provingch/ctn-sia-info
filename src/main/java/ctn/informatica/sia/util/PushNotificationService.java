package ctn.informatica.sia.util;

import ctn.informatica.sia.dao.PushSubscriptionDao;
import ctn.informatica.sia.model.PushSubscription;
import java.io.IOException;
import java.security.GeneralSecurityException;
import java.sql.SQLException;
import java.util.List;
import nl.martijndwars.webpush.Notification;
import nl.martijndwars.webpush.PushService;
import org.apache.http.HttpResponse;
import org.jose4j.lang.JoseException;

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
        String publicKey = resolveVapidPublicKey();
        String privateKey = resolveVapidPrivateKey();
        if (publicKey.isBlank() || privateKey.isBlank()) {
            return false;
        }

        try {
            PushService pushService = new PushService(publicKey, privateKey, "mailto:soporte@ctn.edu.ar");
            Notification notification = new Notification(
                    subscription.getEndpoint(),
                    subscription.getP256dh(),
                    subscription.getAuth(),
                    payload
            );
            HttpResponse response = pushService.send(notification);
            int status = response.getStatusLine().getStatusCode();
            if (status == 404 || status == 410) {
                new PushSubscriptionDao().deleteById(subscription.getId());
                return false;
            }
            return status >= 200 && status < 300;
        } catch (GeneralSecurityException | IOException | JoseException | InterruptedException | java.util.concurrent.ExecutionException ex) {
            return false;
        }
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
