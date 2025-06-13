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

@WebServlet("/processPayment")
public class ProcessPaymentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"Tenant".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            double amountPaid = Double.parseDouble(request.getParameter("amount"));
            double expectedAmount = Double.parseDouble(request.getParameter("expectedAmount"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String userEmail = (String) session.getAttribute("user");

            // Validasi: Cek apakah jumlah pembayaran sesuai
            if (amountPaid != expectedAmount) {
                response.sendRedirect("payment.jsp?roomId=" + roomId + "&error=invalid_amount");
                return;
            }

            // Jika sesuai, simpan pembayaran ke database
            JDBC db = new JDBC();
            db.connect();
            try {
                String getTenantIdQuery = "SELECT id FROM tenant WHERE user_id = (SELECT id FROM users WHERE email = ?) AND room_id = ?";
                int tenantId = -1;
                
                try (PreparedStatement stmt = db.getConnection().prepareStatement(getTenantIdQuery)) {
                    stmt.setString(1, userEmail);
                    stmt.setInt(2, roomId);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            tenantId = rs.getInt("id");
                        }
                    }
                }
                
                if(tenantId != -1) {
                    String insertPaymentQuery = "INSERT INTO payment (tenant_id, amount, payment_date) VALUES (?, ?, CURDATE())";
                    try (PreparedStatement stmt = db.getConnection().prepareStatement(insertPaymentQuery)) {
                        stmt.setInt(1, tenantId);
                        stmt.setDouble(2, amountPaid);
                        stmt.executeUpdate();
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                db.disconnect();
            }

            // Arahkan ke dashboard tenant dengan pesan sukses
            response.sendRedirect("tenantDashboard?payment=success");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Data pembayaran tidak valid.");
        }
    }
}