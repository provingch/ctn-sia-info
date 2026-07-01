/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ctn.informatica.sia.dao;

import ctn.informatica.sia.clases.conexion;
import ctn.informatica.sia.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author jonat
 */
public class UserDao {

    // Returns a User if credentials match, otherwise null
    public User findByUsernameAndPassword(String username, String password) throws Exception {
        String sql = "select * from profesor where usuario = ? and contrasenia = ?";
        try (Connection con = new conexion().getCon();
                PreparedStatement stm = con.prepareStatement(sql)) {

            stm.setString(1, username);
            stm.setString(2, password);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    String user = rs.getString("usuario");
                    String fullName = rs.getString("nombre") + " " + rs.getString("apellido");
                    int level = rs.getInt("nivel");
                    return new User(id, user, fullName, level);
                }
            }
        } catch (java.sql.SQLException ex) {
            throw new Exception("DB connection/query error", ex);
        }
        return null;
    }
}
