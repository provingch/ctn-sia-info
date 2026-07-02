package ctn.informatica.sia.google;

import ctn.informatica.sia.model.Curso;
import ctn.informatica.sia.model.Profesor;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.http.HttpRequestInitializer;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.services.classroom.Classroom;
import com.google.api.services.classroom.model.Course;
import com.google.api.services.classroom.model.ListCoursesResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

public final class GoogleClassroomService {

    private static final String APPLICATION_NAME = "CTN-SIA";

    private GoogleClassroomService() {
        // helper only
    }

    public static boolean isGoogleConnected(Profesor profesor) {
        return profesor != null
                && profesor.getGcAccessToken() != null
                && !profesor.getGcAccessToken().isBlank();
    }

    public static Optional<GoogleClassroomUtils.CourseKey> parseCourseKey(String courseName) {
        return GoogleClassroomUtils.parseCourseKey(courseName);
    }

    public static Classroom buildClassroomClient(Profesor profesor) {
        HttpRequestInitializer initializer = buildCredential(profesor);
        return new Classroom.Builder(new NetHttpTransport(), GsonFactory.getDefaultInstance(), initializer)
                .setApplicationName(APPLICATION_NAME)
                .build();
    }

    private static HttpRequestInitializer buildCredential(Profesor profesor) {
        GoogleCredential credential = new GoogleCredential().setAccessToken(profesor.getGcAccessToken());
        return credential;
    }

    public static List<Course> listTeacherCourses(Profesor profesor) throws IOException {
        if (!isGoogleConnected(profesor)) {
            return Collections.emptyList();
        }
        Classroom classroom = buildClassroomClient(profesor);
        List<Course> courses = new ArrayList<>();
        String pageToken = null;
        do {
            Classroom.Courses.List request = classroom.courses().list()
                    .setPageSize(100)
                    .setTeacherId("me");
            if (pageToken != null && !pageToken.isBlank()) {
                request.setPageToken(pageToken);
            }
            ListCoursesResponse response = request.execute();
            if (response.getCourses() != null) {
                courses.addAll(response.getCourses());
            }
            pageToken = response.getNextPageToken();
        } while (pageToken != null && !pageToken.isBlank());
        return courses;
    }

    public static List<Course> listAllowedCourses(Profesor profesor, List<Curso> cursos) throws IOException {
        if (cursos == null || cursos.isEmpty()) {
            return Collections.emptyList();
        }
        List<Course> allCourses = listTeacherCourses(profesor);
        if (allCourses.isEmpty()) {
            return Collections.emptyList();
        }
        List<Course> filteredCourses = new ArrayList<>();
        for (Course course : allCourses) {
            String name = course.getName();
            Optional<GoogleClassroomUtils.CourseKey> key = parseCourseKey(name);
            if (key.isEmpty()) {
                continue;
            }
            for (Curso curso : cursos) {
                if (curso.matchesCourseKey(key.get())) {
                    filteredCourses.add(course);
                    break;
                }
            }
        }
        return filteredCourses;
    }
}
