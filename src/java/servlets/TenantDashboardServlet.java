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

        JDBC db = new JDBC();
        db.connect();
        try {
            // PERBAIKAN: Mengambil r.rating secara eksplisit
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
                        rentedRoom.setRating(rs.getDouble("room_rating")); // Mengisi data rating
                        
                        Map<String, Object> rentalData = new HashMap<>();
                        rentalData.put("kost", rentedKost);
                        rentalData.put("room", rentedRoom);
                        rentalList.add(rentalData);
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
        RequestDispatcher dispatcher = request.getRequestDispatcher("tenantDashboard.jsp");
        dispatcher.forward(request, response);
    }
}