package ctn.informatica.sia.google;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

public class GoogleClassroomUtilsTest {

    @Test
    public void testParseCourseKey() {
        assertEquals(1, GoogleClassroomUtils.parseCourseKey("Matemáticas Primero A").get().getNivel());
        assertEquals("A", GoogleClassroomUtils.parseCourseKey("Matemáticas Primero A").get().getSeccion());

        assertEquals(2, GoogleClassroomUtils.parseCourseKey("Historia Segundo B").get().getNivel());
        assertEquals("B", GoogleClassroomUtils.parseCourseKey("Historia Segundo B").get().getSeccion());

        assertEquals(3, GoogleClassroomUtils.parseCourseKey("Ciencias tercero c").get().getNivel());
        assertEquals("C", GoogleClassroomUtils.parseCourseKey("Ciencias tercero c").get().getSeccion());

        assertTrue(GoogleClassroomUtils.isAllowedClassroomCourse("Primero A - Física"));
        assertFalse(GoogleClassroomUtils.isAllowedClassroomCourse("Física Avanzada"));
    }
}
