package ctn.informatica.sia.dao;

import ctn.informatica.sia.clases.conexion;
import ctn.informatica.sia.model.Alumno;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AlumnoDao extends conexion {

    public List<Alumno> findByCursoId(int cursoId) throws SQLException {
        String sql = "SELECT id, nombre, apellido, curso_id FROM alumno WHERE curso_id = ? ORDER BY apellido, nombre";
        List<Alumno> alumnos = new ArrayList<>();
        try (Connection con = getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, cursoId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Alumno alumno = new Alumno();
                    alumno.setId(rs.getInt("id"));
                    alumno.setNombre(rs.getString("nombre"));
                    alumno.setApellido(rs.getString("apellido"));
                    alumno.setCursoId(rs.getInt("curso_id"));
                    alumnos.add(alumno);
                }
            }
        }
        return alumnos;
    }

    public List<Alumno> findByEspecialidadId(int especialidadId) throws SQLException {
        String sql = "SELECT a.id, a.nombre, a.apellido, a.curso_id, a.google_user_id, a.google_email "
                + "FROM alumno a INNER JOIN curso c ON c.id = a.curso_id "
                + "WHERE c.especialidad_id = ? ORDER BY a.apellido, a.nombre";
        List<Alumno> alumnos = new ArrayList<>();
        try (Connection con = getCon(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, especialidadId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Alumno alumno = new Alumno();
                    alumno.setId(rs.getInt("id"));
                    alumno.setNombre(rs.getString("nombre"));
                    alumno.setApellido(rs.getString("apellido"));
                    alumno.setCursoId(rs.getInt("curso_id"));
                    alumno.setGoogleUserId(rs.getString("google_user_id"));
                    alumno.setGoogleEmail(rs.getString("google_email"));
                    alumnos.add(alumno);
                }
            }
        }
        return alumnos;
    }

    public boolean updateGoogleIdentity(int alumnoId, String googleUserId, String googleEmail) throws SQLException {
        try (Connection con = getCon()) {
            DatabaseMetaData meta = con.getMetaData();
            try (ResultSet columns = meta.getColumns(null, null, "alumno", "google_user_id")) {
                if (!columns.next()) {
                    return false;
                }
            }
            try (ResultSet columns = meta.getColumns(null, null, "alumno", "google_email")) {
                if (!columns.next()) {
                    return false;
                }
            }

            String sql = "UPDATE alumno SET google_user_id = ?, google_email = ? WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, googleUserId);
                ps.setString(2, googleEmail);
                ps.setInt(3, alumnoId);
                return ps.executeUpdate() > 0;
            }
        }
    }
}
