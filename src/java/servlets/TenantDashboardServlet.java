package servlets;

import classes.JDBC;
import models.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/tenantDashboard")
public class TenantDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"Tenant".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("user");
        List<Map<String, Object>> rentalList = new ArrayList<>();
        List<Kost> availableKostList = new ArrayList<>();
        List<Map<String, Object>> paymentHistory = new ArrayList<>();

        JDBC db = new JDBC();
        db.connect();
        try {
            // Query untuk data rental
            String tenantQuery = "SELECT t.id as tenant_id, r.id as room_id, r.number as room_number, r.rating as room_rating, k.id as kost_id, k.name as kost_name, k.address as kost_address FROM tenant t " +
                                 "JOIN room r ON t.room_id = r.id " +
                                 "JOIN kost k ON r.kost_id = k.id " +
                                 "JOIN users u ON t.user_id = u.id " +
                                 "WHERE u.email = ?";
            try (PreparedStatement stmt = db.getConnection().prepareStatement(tenantQuery)) {
                stmt.setString(1, userEmail);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Kost rentedKost = new Kost();
                        rentedKost.setId(rs.getInt("kost_id"));
                        rentedKost.setName(rs.getString("kost_name"));
                        rentedKost.setAddress(rs.getString("kost_address"));
                        
                        Room rentedRoom = new Room();
                        rentedRoom.setId(rs.getInt("room_id"));
                        rentedRoom.setNumber(rs.getString("room_number"));
                        rentedRoom.setRating(rs.getDouble("room_rating"));
                        
                        Map<String, Object> rentalData = new HashMap<>();
                        rentalData.put("kost", rentedKost);
                        rentalData.put("room", rentedRoom);
                        rentalList.add(rentalData);
                    }
                }
            }

            // Query untuk riwayat pembayaran
            String paymentQuery = "SELECT p.id, p.amount, p.payment_date, k.name as kost_name, r.number as room_number " +
                                "FROM payment p " +
                                "JOIN tenant t ON p.tenant_id = t.id " +
                                "JOIN room r ON t.room_id = r.id " +
                                "JOIN kost k ON r.kost_id = k.id " +
                                "JOIN users u ON t.user_id = u.id " +
                                "WHERE u.email = ? " +
                                "ORDER BY p.payment_date DESC";
            try (PreparedStatement stmt = db.getConnection().prepareStatement(paymentQuery)) {
                stmt.setString(1, userEmail);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> payment = new HashMap<>();
                        payment.put("id", rs.getInt("id"));
                        payment.put("amount", rs.getBigDecimal("amount"));
                        payment.put("paymentDate", rs.getDate("payment_date"));
                        payment.put("kostName", rs.getString("kost_name"));
                        payment.put("roomNumber", rs.getString("room_number"));
                        paymentHistory.add(payment);
                    }
                }
            }

            if (rentalList.isEmpty()) { /* ... (kode untuk mengambil availableKostList tidak berubah) ... */ }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }
        
        request.setAttribute("rentalList", rentalList);
        request.setAttribute("kostList", availableKostList);
        request.setAttribute("paymentHistory", paymentHistory);
        RequestDispatcher dispatcher = request.getRequestDispatcher("tenantDashboard.jsp");
        dispatcher.forward(request, response);
    }
}