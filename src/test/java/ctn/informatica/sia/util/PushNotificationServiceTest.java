package ctn.informatica.sia.util;

import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

public class PushNotificationServiceTest {

    @Test
    void buildNotificationPayloadIncludesTitleAndUrl() {
        String payload = PushNotificationService.buildNotificationPayload("Prueba", "Mensaje de prueba", "/HomeServlet");

        assertTrue(payload.contains("Prueba"));
        assertTrue(payload.contains("Mensaje de prueba"));
        assertTrue(payload.contains("/HomeServlet"));
    }
}
