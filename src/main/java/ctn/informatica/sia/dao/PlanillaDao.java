/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ctn.informatica.sia.dao;

import ctn.informatica.sia.clases.conexion;
import ctn.informatica.sia.model.Planilla;
import ctn.informatica.sia.model.Tarea;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author jonat
 */
public class PlanillaDao extends conexion {

    public ArrayList<Planilla> consultarPlanillas(int userId, int cursoId, int etapaIndex) throws SQLException {
        String sql = "SELECT p.id, nombre, curso_id, materia_id, periodo, etapa, profesor_id, COUNT(DISTINCT t.id) AS tareas_count "
                + "FROM planilla p "
                + "JOIN materia m ON p.materia_id = m.id "
                + "LEFT JOIN tarea t ON t.planilla_id = p.id "
                + "WHERE curso_id = ? AND profesor_id = ? AND etapa = ? AND periodo = 2025 "
                + "GROUP BY p.id, m.nombre, p.curso_id, p.materia_id, p.periodo, p.etapa, p.profesor_id";
        try (Connection con = getCon(); PreparedStatement stm = con.prepareStatement(sql)) {
            stm.setInt(1, cursoId);
            stm.setInt(2, userId);
            stm.setInt(3, etapaIndex);
            ResultSet rs = stm.executeQuery();
            ArrayList<Planilla> planillas = new ArrayList<>();
            while (rs.next()) {
                int id = rs.getInt("id");
                int curso_id = rs.getInt("curso_id");
                int materia_id = rs.getInt("materia_id");
                String nombre = rs.getString("nombre");
                int periodo = rs.getInt("periodo");
                String etapa = rs.getString("etapa");// NOTE might cause problems in the future
                int profesor_id = rs.getInt("profesor_id");
                int tareas_count = rs.getInt("tareas_count");

                String ultimaTarea = consultarUltimaTarea(id);
                Planilla p = new Planilla(id, curso_id, materia_id, nombre, periodo, etapa, profesor_id, tareas_count, ultimaTarea);
                planillas.add(p);
            }
            return planillas;
        }
    }

    public ArrayList<Planilla> consultarPlanillasUser(int userId, int etapaIndex) throws SQLException {
        String sql = "SELECT p.id, nombre, curso_id, materia_id, categoria, periodo, etapa, profesor_id "
                + "FROM planilla p "
                + "JOIN materia m ON p.materia_id = m.id "
                + "WHERE profesor_id = ? AND etapa = ? AND periodo = 2025 "
                + "GROUP BY p.id, m.nombre, p.curso_id, p.materia_id, p.periodo, p.etapa, p.profesor_id";
        try (Connection con = getCon(); PreparedStatement stm = con.prepareStatement(sql)) {
            stm.setInt(1, userId);
            stm.setInt(2, etapaIndex);
            ResultSet rs = stm.executeQuery();
            ArrayList<Planilla> planillas = new ArrayList<>();
            while (rs.next()) {
                int planilla_id = rs.getInt("id");
                int curso_id = rs.getInt("curso_id");
                int materia_id = rs.getInt("materia_id");
                String categoria = rs.getString("categoria");
                String nombre = rs.getString("nombre");
                int periodo = rs.getInt("periodo");
                String etapa = rs.getString("etapa");// NOTE might cause problems in the future
                int profesor_id = rs.getInt("profesor_id");

                Planilla p = new Planilla(planilla_id, curso_id, materia_id, categoria, nombre, periodo, etapa, profesor_id);
                planillas.add(p);
            }
            return planillas;
        }
    }

    public Planilla findById(int id) throws SQLException {// could create an interface
        String sql = "SELECT p.id, nombre, curso_id, materia_id, categoria, periodo, etapa, profesor_id "
                + "FROM planilla p JOIN materia m ON p.materia_id = m.id "
                + "WHERE p.id = ?";
        try (Connection con = getCon(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return fromResultSet(rs);
            }
        }
    }

    public Planilla findByCompositeKey(int cursoId, int materiaId, int etapa) throws SQLException {
        String sql = "SELECT p.id, nombre, curso_id, materia_id, categoria, periodo, etapa, profesor_id "
                + "FROM planilla p JOIN materia m ON p.materia_id = m.id "
                + "WHERE curso_id = ? AND materia_id = ? AND periodo = 2025 AND etapa = ?";// TODO add periodo functionality
        try (Connection con = getCon(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cursoId);
            ps.setInt(2, materiaId);
            ps.setInt(3, etapa);
            try (ResultSet rs = ps.executeQuery()) {
                return fromResultSet(rs);
            }
        }
    }

    public String consultarUltimaTarea(int planillaId) throws SQLException {
        String sql = "SELECT * FROM tarea WHERE planilla_id = ? ORDER BY id DESC LIMIT 1";
        try (Connection con = getCon(); PreparedStatement stm = con.prepareStatement(sql)) {
            stm.setInt(1, planillaId);
            ResultSet rs = stm.executeQuery();
            ArrayList<Tarea> tareas = new ArrayList<>();
            if (rs.next()) {
                return rs.getString("titulo");
            }
            return "";
        }
    }

    public Planilla fromResultSet(ResultSet rs) throws SQLException {
        if (rs.next()) {
            int planilla_id = rs.getInt("id");
            int curso_id = rs.getInt("curso_id");
            int materia_id = rs.getInt("materia_id");
            String categoria = rs.getString("categoria");
            String nombre = rs.getString("nombre");
            int periodo = rs.getInt("periodo");
            String etapa = rs.getString("etapa");// NOTE might cause problems in the future
            int profesor_id = rs.getInt("profesor_id");

            Planilla p = new Planilla(planilla_id, curso_id, materia_id, categoria, nombre, periodo, etapa, profesor_id);
            return p;
        } else {
            return null;
        }
    }

    public static class PlanillaInfo {

        private final Planilla planilla;
        private final String materiaNombre;

        public PlanillaInfo(Planilla planilla, String materiaNombre) {
            this.planilla = planilla;
            this.materiaNombre = materiaNombre;
        }

        public Planilla getPlanilla() {
            return planilla;
        }

        public String getMateriaNombre() {
            return materiaNombre;
        }
    }

    public List<PlanillaInfo> findPlanillasByCourse(int especialidadId, int promocion, String seccion, int periodo) throws SQLException, ClassNotFoundException {
        List<PlanillaInfo> out = new ArrayList<>();

        // SQL: join planilla -> curso -> materia
        String sql = "SELECT p.id AS planilla_id, p.curso_id, p.materia_id, p.periodo, p.etapa, p.profesor_id, m.nombre AS materia_nombre "
                + "FROM planilla p "
                + "JOIN curso c ON p.curso_id = c.id "
                + "JOIN materia m ON p.materia_id = m.id "
                + "WHERE c.especialidad_id = ? AND c.promocion = ? AND c.seccion = ? AND p.periodo = ? "
                + "ORDER BY m.nombre";

        try (Connection con = getCon(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, especialidadId);
            ps.setInt(2, promocion);
            ps.setString(3, seccion);
            ps.setInt(4, periodo);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Planilla p = new Planilla();
                    p.setId(rs.getInt("planilla_id"));
                    p.setCursoId(rs.getInt("curso_id"));
                    p.setMateriaId(rs.getInt("materia_id"));
                    p.setPeriodo(rs.getInt("periodo"));
                    p.setEtapa(rs.getString("etapa"));
                    p.setProfesorId(rs.getInt("profesor_id"));
                    String materiaNombre = rs.getString("materia_nombre");
                    out.add(new PlanillaInfo(p, materiaNombre));
                }
            }
        }
        return out;
    }

    // optional: convenience to load planilla + tareas in one call
//    public Planilla findByIdWithTareas(int id) throws SQLException {
//        Planilla p = findById(id);
//        if (p != null) {
//            TareaDao tdao = new TareaDao();
//            p.setTareas(tdao.findByPlanillaId(id));
//        }
//        return p;
//    }
}
