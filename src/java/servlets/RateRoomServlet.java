package servlets;

import classes.JDBC;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/rateRoom")
public class RateRoomServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"Tenant".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            double rating = Double.parseDouble(request.getParameter("rating"));
            int kostId = -1;

            JDBC db = new JDBC();
            db.connect();

            try {
                // Gunakan transaksi untuk memastikan semua query berhasil
                db.getConnection().setAutoCommit(false);

                // 1. Update rating di tabel 'room'
                String updateRoomRatingQuery = "UPDATE room SET rating = ? WHERE id = ?";
                try (PreparedStatement stmt = db.getConnection().prepareStatement(updateRoomRatingQuery)) {
                    stmt.setDouble(1, rating);
                    stmt.setInt(2, roomId);
                    stmt.executeUpdate();
                }

                // 2. Dapatkan kost_id dari kamar yang di-rate
                String getKostIdQuery = "SELECT kost_id FROM room WHERE id = ?";
                try (PreparedStatement stmt = db.getConnection().prepareStatement(getKostIdQuery)) {
                    stmt.setInt(1, roomId);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            kostId = rs.getInt("kost_id");
                        }
                    }
                }
                
                // 3. Hitung ulang rata-rata rating dan update tabel 'kost'
                if (kostId != -1) {
                    String updateAvgRatingQuery = "UPDATE kost k SET k.avg_rating = " +
                                                  "(SELECT AVG(r.rating) FROM room r WHERE r.kost_id = ? AND r.rating > 0) " +
                                                  "WHERE k.id = ?";
                    try (PreparedStatement stmt = db.getConnection().prepareStatement(updateAvgRatingQuery)) {
                        stmt.setInt(1, kostId);
                        stmt.setInt(2, kostId);
                        stmt.executeUpdate();
                    }
                }

                db.getConnection().commit(); // Simpan semua perubahan

            } catch (SQLException e) {
                try { db.getConnection().rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
                e.printStackTrace();
            } finally {
                try { if(db.getConnection() != null) db.getConnection().setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
                db.disconnect();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Arahkan kembali ke dashboard dengan pesan sukses
        response.sendRedirect("tenantDashboard?rating=success");
    }
}