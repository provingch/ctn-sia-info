/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.loginproject.dao;

import com.mycompany.loginproject.clases.conexion;
import com.mycompany.loginproject.model.Profesor;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

/**
 *
 * @author jonat
 */
public class ProfesorDao extends conexion {

    public Profesor findById(int id) {
        final String sql = "SELECT id, nombre, apellido, usuario, contrasenia, ci, telefono, celular, correo FROM profesor WHERE id = ?";
        // Note: the SELECT includes a dummy correo column in case your schema doesn't have it.
        try (Connection c = getCon(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Profesor p = new Profesor();
                    p.setId(rs.getInt("id"));
                    p.setNombre(rs.getString("nombre"));
                    p.setApellido(rs.getString("apellido"));
                    p.setUsuario(rs.getString("usuario"));
                    p.setContrasenia(rs.getString("contrasenia"));
                    int ci = rs.getInt("ci");
                    if (!rs.wasNull()) {
                        p.setCi(ci);
                    }
                    int tel = rs.getInt("telefono");
                    if (!rs.wasNull()) {
                        p.setTelefono(tel);
                    }
                    int cel = rs.getInt("celular");
                    if (!rs.wasNull()) {
                        p.setCelular(cel);
                    }
                    p.setCorreo(rs.getString("correo"));
                    return p;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public boolean update(Profesor p) {
        final String sql = "UPDATE profesor SET nombre = ?, apellido = ?, usuario = ?, contrasenia = ?, ci = ?, telefono = ?, celular = ?, correo = ? WHERE id = ?";
        try (Connection c = getCon(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, p.getNombre());
            ps.setString(2, p.getApellido());
            ps.setString(3, p.getUsuario());
            ps.setString(4, p.getContrasenia());
            if (p.getCi() != null) {
                ps.setInt(5, p.getCi());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            if (p.getTelefono() != null) {
                ps.setInt(6, p.getTelefono());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            if (p.getCelular() != null) {
                ps.setInt(7, p.getCelular());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            ps.setString(8, p.getCorreo());
            ps.setInt(9, p.getId());
            int affected = ps.executeUpdate();
            return affected == 1;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }
}