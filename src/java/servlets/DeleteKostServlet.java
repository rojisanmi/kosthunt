package servlets;

import classes.JDBC;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/deleteKost")
public class DeleteKostServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"Owner".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int kostId = Integer.parseInt(request.getParameter("id"));
            JDBC db = new JDBC();
            db.connect();
            Connection conn = db.getConnection();
            
            try {
                // Start transaction
                conn.setAutoCommit(false);
                
                // 1. Delete all tenants associated with rooms in this kost
                String deleteTenantsQuery = "DELETE t FROM tenant t " +
                                          "JOIN room r ON t.room_id = r.id " +
                                          "WHERE r.kost_id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(deleteTenantsQuery)) {
                    stmt.setInt(1, kostId);
                    stmt.executeUpdate();
                }
                
                // 2. Delete all rooms in this kost
                String deleteRoomsQuery = "DELETE FROM room WHERE kost_id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(deleteRoomsQuery)) {
                    stmt.setInt(1, kostId);
                    stmt.executeUpdate();
                }
                
                // 3. Finally, delete the kost itself
                String deleteKostQuery = "DELETE FROM Kost WHERE id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(deleteKostQuery)) {
                    stmt.setInt(1, kostId);
                    stmt.executeUpdate();
                }
                
                // If everything went well, commit the transaction
                conn.commit();
                session.setAttribute("successMessage", "Kost berhasil dihapus beserta semua kamar dan data terkait.");
                
            } catch (SQLException e) {
                // If anything goes wrong, rollback the transaction
                try {
                    conn.rollback();
                    session.setAttribute("errorMessage", "Gagal menghapus kost: " + e.getMessage());
                } catch (SQLException ex) {
                    ex.printStackTrace();
                    session.setAttribute("errorMessage", "Terjadi kesalahan saat rollback: " + ex.getMessage());
                }
            } finally {
                try {
                    // Reset auto-commit to true
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                db.disconnect();
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID Kost tidak valid.");
        }
        
        response.sendRedirect("ownerDashboard");
    }
}