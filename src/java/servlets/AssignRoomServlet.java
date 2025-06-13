package servlets;

import classes.JDBC;
import models.Room;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/assignRoom")
public class AssignRoomServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"Tenant".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp?error=tenant_only");
            return;
        }

        Room roomForPayment = null;
        try {
            // 1. Ambil semua data dari parameter URL yang dikirim dari kostDetail.jsp
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            double roomPrice = Double.parseDouble(request.getParameter("roomPrice"));
            String roomNumber = request.getParameter("roomNumber");
            String userEmail = (String) session.getAttribute("user");
            int userId = -1;

            JDBC db = new JDBC();
            db.connect();

            try {
                // Dapatkan ID pengguna dari email di sesi
                String getUserIdQuery = "SELECT id FROM users WHERE email = ?";
                try (PreparedStatement stmt = db.getConnection().prepareStatement(getUserIdQuery)) {
                    stmt.setString(1, userEmail);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            userId = rs.getInt("id");
                        }
                    }
                }
                
                if (userId != -1) {
                    // Gunakan transaksi agar semua query berhasil atau semua gagal
                    db.getConnection().setAutoCommit(false); 
                    
                    // 2. INSERT data penyewaan baru ke tabel 'tenant'
                    String assignQuery = "INSERT INTO tenant (user_id, room_id) VALUES (?, ?)";
                    try (PreparedStatement stmt = db.getConnection().prepareStatement(assignQuery)) {
                        stmt.setInt(1, userId);
                        stmt.setInt(2, roomId);
                        stmt.executeUpdate();
                    }

                    // 3. UPDATE status kamar menjadi 'Occupied'
                    String updateRoomQuery = "UPDATE room SET status = 'Occupied' WHERE id = ?";
                    try (PreparedStatement stmt = db.getConnection().prepareStatement(updateRoomQuery)) {
                        stmt.setInt(1, roomId);
                        stmt.executeUpdate();
                    }
                    
                    db.getConnection().commit(); // Simpan semua perubahan jika berhasil
                }
                
                // 4. Siapkan objek untuk dikirim ke halaman pembayaran
                roomForPayment = new Room();
                roomForPayment.setId(roomId);
                roomForPayment.setNumber(roomNumber);
                roomForPayment.setPrice(roomPrice);

            } catch (SQLException e) {
                try { db.getConnection().rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
                throw e; // Lemparkan error agar bisa ditangani
            } finally {
                try { if (db.getConnection() != null) db.getConnection().setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
                db.disconnect();
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Gagal memproses penyewaan kamar", e);
        }

        // 5. Teruskan (FORWARD) request ke payment.jsp sambil membawa data kamar
        request.setAttribute("roomForPayment", roomForPayment);
        RequestDispatcher dispatcher = request.getRequestDispatcher("payment.jsp");
        dispatcher.forward(request, response);
    }
}