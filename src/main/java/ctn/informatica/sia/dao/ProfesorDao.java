package ctn.informatica.sia.dao;

import ctn.informatica.sia.clases.conexion;
import ctn.informatica.sia.model.Profesor;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

public class ProfesorDao extends conexion {

    // ── helper para mapear un ResultSet a Profesor ──────────────────────────
    private Profesor map(ResultSet rs) throws SQLException {
        Profesor p = new Profesor();
        p.setId(rs.getInt("id"));
        p.setNombre(rs.getString("nombre"));
        p.setApellido(rs.getString("apellido"));
        p.setUsuario(rs.getString("usuario"));
        p.setContrasenia(rs.getString("contrasenia"));

        int ci = rs.getInt("ci");
        if (!rs.wasNull()) p.setCi(ci);

        int tel = rs.getInt("telefono");
        if (!rs.wasNull()) p.setTelefono(tel);

        int cel = rs.getInt("celular");
        if (!rs.wasNull()) p.setCelular(cel);

        p.setCorreo(rs.getString("correo"));
        return p;
    }

    // ── findById ─────────────────────────────────────────────────────────────
    public Profesor findById(int id) {
        final String sql = "SELECT id, nombre, apellido, usuario, contrasenia, "
                         + "ci, telefono, celular, correo "
                         + "FROM profesor WHERE id = ?";
        try (Connection c = getCon();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // ── findByGoogleEmail ─────────────────────────────────────────────────────
    // Busca al profesor cuyo correo coincide con el email de Google.
    // Ajusta el nombre de columna si en tu tabla se llama distinto.
    public Profesor findByGoogleEmail(String email) {
        final String sql = "SELECT id, nombre, apellido, usuario, contrasenia, "
                         + "ci, telefono, celular, correo "
                         + "FROM profesor WHERE correo = ?";
        try (Connection c = getCon();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // ── updateGoogleTokens ────────────────────────────────────────────────────
    // Guarda los tokens OAuth en la BD.
    // Requiere que la tabla tenga columnas: google_access_token, google_refresh_token, google_token_expiry
    public boolean updateGoogleTokens(int profesorId,
                                      String accessToken,
                                      String refreshToken,
                                      long expiryEpochSeconds) {
        final String sql = "UPDATE profesor "
                         + "SET google_access_token = ?, "
                         + "    google_refresh_token = ?, "
                         + "    google_token_expiry  = ? "
                         + "WHERE id = ?";
        try (Connection c = getCon();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, accessToken);
            if (refreshToken != null) {
                ps.setString(2, refreshToken);
            } else {
                ps.setNull(2, Types.VARCHAR);
            }
            ps.setLong(3, expiryEpochSeconds);
            ps.setInt(4, profesorId);
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // ── update ────────────────────────────────────────────────────────────────
    public boolean update(Profesor p) {
        final String sql = "UPDATE profesor "
                         + "SET nombre = ?, apellido = ?, usuario = ?, "
                         + "    contrasenia = ?, ci = ?, telefono = ?, "
                         + "    celular = ?, correo = ? "
                         + "WHERE id = ?";
        try (Connection c = getCon();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, p.getNombre());
            ps.setString(2, p.getApellido());
            ps.setString(3, p.getUsuario());
            ps.setString(4, p.getContrasenia());

            if (p.getCi() != null)       ps.setInt(5, p.getCi());
            else                          ps.setNull(5, Types.INTEGER);

            if (p.getTelefono() != null)  ps.setInt(6, p.getTelefono());
            else                          ps.setNull(6, Types.INTEGER);

            if (p.getCelular() != null)   ps.setInt(7, p.getCelular());
            else                          ps.setNull(7, Types.INTEGER);

            ps.setString(8, p.getCorreo());
            ps.setInt(9, p.getId());

            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }
}