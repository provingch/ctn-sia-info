package ctn.informatica.sia.google;

import java.text.Normalizer;
import java.util.Locale;
import java.util.Objects;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class GoogleClassroomUtils {

    private static final Pattern LEVEL_PATTERN = Pattern.compile("\\b(primero|segundo|tercero|1(?:ro|er)?|2(?:do)?|3(?:ro)?|1|2|3)\\b", Pattern.CASE_INSENSITIVE);
    private static final Pattern SECTION_PATTERN = Pattern.compile("\\b(a|b|c)\\b", Pattern.CASE_INSENSITIVE);

    private GoogleClassroomUtils() {
        // util class
    }

    public static Optional<CourseKey> parseCourseKey(String courseName) {
        if (courseName == null || courseName.isBlank()) {
            return Optional.empty();
        }
        String normalized = normalize(courseName);
        Integer level = parseLevel(normalized);
        String section = parseSection(normalized);
        if (level == null || section == null) {
            return Optional.empty();
        }
        return Optional.of(new CourseKey(level, section));
    }

    public static boolean isAllowedClassroomCourse(String courseName) {
        return parseCourseKey(courseName).isPresent();
    }

    private static String normalize(String text) {
        String withoutAccents = Normalizer.normalize(text, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "");
        return withoutAccents.replaceAll("[^\\p{Alnum}\\s-]", " ").trim().toLowerCase(Locale.ROOT);
    }

    private static Integer parseLevel(String text) {
        Matcher matcher = LEVEL_PATTERN.matcher(text);
        while (matcher.find()) {
            String token = matcher.group(1).toLowerCase(Locale.ROOT);
            switch (token) {
                case "primero":
                case "1ro":
                case "1er":
                case "1":
                    return 1;
                case "segundo":
                case "2do":
                case "2":
                    return 2;
                case "tercero":
                case "3ro":
                case "3":
                    return 3;
                default:
                    break;
            }
        }
        return null;
    }

    private static String parseSection(String text) {
        Matcher matcher = SECTION_PATTERN.matcher(text);
        while (matcher.find()) {
            String token = matcher.group(1).toUpperCase(Locale.ROOT);
            if (token.equals("A") || token.equals("B") || token.equals("C")) {
                return token;
            }
        }
        return null;
    }

    public static final class CourseKey {
        private final int nivel;
        private final String seccion;

        public CourseKey(int nivel, String seccion) {
            this.nivel = nivel;
            this.seccion = seccion;
        }

        public int getNivel() {
            return nivel;
        }

        public String getSeccion() {
            return seccion;
        }

        @Override
        public int hashCode() {
            return Objects.hash(nivel, seccion);
        }

        @Override
        public boolean equals(Object obj) {
            if (this == obj) return true;
            if (obj == null || getClass() != obj.getClass()) return false;
            CourseKey other = (CourseKey) obj;
            return nivel == other.nivel && seccion.equals(other.seccion);
        }

        @Override
        public String toString() {
            return "CursoKey{nivel=" + nivel + ", seccion='" + seccion + "'}";
        }
    }
}
