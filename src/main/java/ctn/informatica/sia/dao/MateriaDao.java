package ctn.informatica.sia.dao;

import ctn.informatica.sia.clases.conexion;
import ctn.informatica.sia.model.Materia;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class MateriaDao extends conexion {

    private Materia fromResultSet(ResultSet rs) throws SQLException {
        return new Materia(rs.getInt("id"), rs.getString("nombre"), rs.getString("categoria"));
    }

    /**
     * Todas las materias del catálogo.
     */
    public List<Materia> listAll() throws SQLException {
        String sql = "SELECT id, nombre, categoria FROM materia ORDER BY nombre";
        List<Materia> out = new ArrayList<>();
        try (Connection c = getCon(); PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                out.add(fromResultSet(rs));
            }
        }
        return out;
    }

    /**
     * Materias del catálogo asociadas al profesor. Se une directamene con la
     * relación profesor_materia y conserva compatibilidad con planillas ya
     * existentes en la base.
     */
    public List<Materia> listByProfesor(int profesorId) throws SQLException {
        String sql = "SELECT DISTINCT m.id, m.nombre, m.categoria "
                + "FROM ( "
                + "    SELECT pm.materia_id FROM profesor_materia pm WHERE pm.profesor_id = ? "
                + "    UNION "
                + "    SELECT p.materia_id FROM planilla p WHERE p.profesor_id = ? "
                + ") ids "
                + "JOIN materia m ON m.id = ids.materia_id "
                + "ORDER BY m.nombre";
        List<Materia> out = new ArrayList<>();
        try (Connection c = getCon(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, profesorId);
            ps.setInt(2, profesorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(fromResultSet(rs));
                }
            }
        }
        return out;
    }

    /**
     * Materias válidas para un profesor: las 'comun' (aplican a cualquier especialidad)
     * más las 'especifico' de las especialidades de los cursos que el profesor
     * efectivamente tiene asignados (vía planilla -> curso -> especialidad), o las
     * materias que el propio profesor haya registrado en su perfil.
     */
    public List<Materia> listAvailableForProfesor(int profesorId) throws SQLException {
        String sql = "SELECT DISTINCT m.id, m.nombre, m.categoria "
                + "FROM materia m "
                + "WHERE m.categoria = 'comun' "
                + "   OR m.id IN ( "
                + "        SELECT me.materia_id FROM materia_especialidad me "
                + "        WHERE me.especialidad_id IN ( "
                + "            SELECT DISTINCT c.especialidad_id "
                + "            FROM planilla p "
                + "            JOIN curso c ON p.curso_id = c.id "
                + "            WHERE p.profesor_id = ? "
                + "        ) "
                + "   ) "
                + "   OR m.id IN ( "
                + "        SELECT pm.materia_id FROM profesor_materia pm WHERE pm.profesor_id = ? "
                + "   ) "
                + "ORDER BY m.nombre";
        List<Materia> out = new ArrayList<>();
        try (Connection c = getCon(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, profesorId);
            ps.setInt(2, profesorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(fromResultSet(rs));
                }
            }
        }
        return out;
    }

    public boolean linkProfesorMateria(int profesorId, int materiaId) throws SQLException {
        String sql = "INSERT IGNORE INTO profesor_materia (profesor_id, materia_id) VALUES (?, ?)";
        try (Connection c = getCon(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, profesorId);
            ps.setInt(2, materiaId);
            return ps.executeUpdate() > 0;
        }
    }

    public List<String> findNamesByProfesor(int profesorId) throws SQLException {
        String sql = "SELECT DISTINCT m.nombre "
                + "FROM ( "
                + "    SELECT pm.materia_id FROM profesor_materia pm WHERE pm.profesor_id = ? "
                + "    UNION "
                + "    SELECT p.materia_id FROM planilla p WHERE p.profesor_id = ? "
                + ") ids "
                + "JOIN materia m ON m.id = ids.materia_id "
                + "ORDER BY m.nombre";
        List<String> names = new ArrayList<>();
        try (Connection c = getCon(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, profesorId);
            ps.setInt(2, profesorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String name = rs.getString("nombre");
                    if (name != null && !name.trim().isEmpty()) {
                        names.add(name.trim());
                    }
                }
            }
        }
        return names;
    }

    /**
     * Especialidades a las que pertenece una materia (vacío para 'especifico' sin
     * vínculo cargado, o varias filas para 'comun').
     */
    public List<Integer> listEspecialidadIdsForMateria(int materiaId) throws SQLException {
        String sql = "SELECT especialidad_id FROM materia_especialidad WHERE materia_id = ?";
        List<Integer> out = new ArrayList<>();
        try (Connection c = getCon(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, materiaId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(rs.getInt("especialidad_id"));
                }
            }
        }
        return out;
    }

    public boolean linkEspecialidad(int materiaId, int especialidadId) throws SQLException {
        String sql = "INSERT IGNORE INTO materia_especialidad (materia_id, especialidad_id) VALUES (?, ?)";
        try (Connection c = getCon(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, materiaId);
            ps.setInt(2, especialidadId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean unlinkEspecialidad(int materiaId, int especialidadId) throws SQLException {
        String sql = "DELETE FROM materia_especialidad WHERE materia_id = ? AND especialidad_id = ?";
        try (Connection c = getCon(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, materiaId);
            ps.setInt(2, especialidadId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean replaceEspecialidades(int materiaId, List<Integer> especialidadIds) throws SQLException {
        String deleteSql = "DELETE FROM materia_especialidad WHERE materia_id = ?";
        String insertSql = "INSERT IGNORE INTO materia_especialidad (materia_id, especialidad_id) VALUES (?, ?)";
        try (Connection c = getCon()) {
            try (PreparedStatement deletePs = c.prepareStatement(deleteSql)) {
                deletePs.setInt(1, materiaId);
                deletePs.executeUpdate();
            }

            if (especialidadIds == null || especialidadIds.isEmpty()) {
                return true;
            }

            try (PreparedStatement insertPs = c.prepareStatement(insertSql)) {
                for (Integer especialidadId : especialidadIds) {
                    if (especialidadId == null) {
                        continue;
                    }
                    insertPs.setInt(1, materiaId);
                    insertPs.setInt(2, especialidadId);
                    insertPs.addBatch();
                }
                if (especialidadIds.stream().anyMatch(id -> id != null)) {
                    insertPs.executeBatch();
                }
            }
            return true;
        }
    }

    public int create(String nombre, String categoria) throws SQLException {
        String sql = "INSERT INTO materia (nombre, categoria) VALUES (?, ?)";
        try (Connection c = getCon(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, nombre);
            ps.setString(2, categoria == null ? "especifico" : categoria.trim().toLowerCase());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        return -1;
    }

    public boolean updateCategoria(int materiaId, String categoria) throws SQLException {
        String sql = "UPDATE materia SET categoria = ? WHERE id = ?";
        try (Connection c = getCon(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, categoria == null ? "especifico" : categoria.trim().toLowerCase());
            ps.setInt(2, materiaId);
            return ps.executeUpdate() == 1;
        }
    }

    public Materia findByNombre(String nombre) throws SQLException {
        String sql = "SELECT id, nombre, categoria FROM materia WHERE LOWER(nombre) = LOWER(?)";
        try (Connection c = getCon(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, nombre == null ? "" : nombre.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Materia(rs.getInt("id"), rs.getString("nombre"), rs.getString("categoria"));
                }
            }
        }
        return null;
    }
    
    public Materia findById(int id) throws SQLException {
        String sql = "SELECT id, nombre, categoria FROM materia WHERE id = ?";
        try (Connection c = getCon(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Materia(rs.getInt("id"), rs.getString("nombre"), rs.getString("categoria"));
                }
            }
        }
        return null;
    }
}