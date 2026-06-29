/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ctn.informatica.sia.dao;

import ctn.informatica.sia.clases.conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 *
 * @author jonat
 */
public class RegistroDao extends conexion {
    /**
     * Returns a map alumnoId -> registroId for the given planilla and alumnoIds set.
     * If an alumno does not have a registro in this planilla it won't be present in the map.
     */
    public Map<Integer,Integer> getRegistroIdsForPlanilla(int planillaId, Set<Integer> alumnoIds) throws SQLException {
        if (alumnoIds == null || alumnoIds.isEmpty()) return Collections.emptyMap();

        StringBuilder sql = new StringBuilder("SELECT id, alumno_id FROM registro WHERE planilla_id = ? AND alumno_id IN (");
        // append placeholders
        String placeholders = alumnoIds.stream().map(x -> "?").collect(Collectors.joining(","));
        sql.append(placeholders).append(")");

        Map<Integer,Integer> result = new HashMap<>();
        try (Connection con = getCon(); PreparedStatement stm = con.prepareStatement(sql.toString())) {
            int idx = 1;
            stm.setInt(idx++, planillaId);
            for (Integer a : alumnoIds) stm.setInt(idx++, a);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    int registroId = rs.getInt("id");
                    int alumnoId = rs.getInt("alumno_id");
                    result.put(alumnoId, registroId);
                }
            }
        }
        return result;
    }
}