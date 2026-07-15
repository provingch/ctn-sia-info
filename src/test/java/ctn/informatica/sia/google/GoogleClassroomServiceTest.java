package ctn.informatica.sia.google;

import ctn.informatica.sia.model.Alumno;
import com.google.api.services.classroom.model.Student;
import com.google.api.services.classroom.model.UserProfile;
import com.google.api.services.classroom.model.Name;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class GoogleClassroomServiceTest {

    @Test
    void shouldMatchStudentByNameAndEmail() {
        Alumno local = new Alumno();
        local.setId(10);
        local.setNombre("Ana");
        local.setApellido("Pérez");
        local.setGoogleEmail("ana.perez@example.com");

        Student classroomStudent = new Student();
        classroomStudent.setUserId("student-123");
        UserProfile profile = new UserProfile();
        Name name = new Name();
        name.setFullName("Ana Pérez");
        profile.setName(name);
        profile.setEmailAddress("ana.perez@example.com");
        classroomStudent.setProfile(profile);

        Optional<Alumno> match = GoogleClassroomService.findBestStudentMatch(List.of(local), classroomStudent);

        assertTrue(match.isPresent());
        assertEquals(10, match.get().getId());
    }
}
