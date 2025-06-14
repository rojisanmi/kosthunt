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
        // PERBAIKAN: Gunakan List untuk menampung banyak data sewa
        List<Map<String, Object>> rentalList = new ArrayList<>();
        List<Kost> availableKostList = new ArrayList<>();

        JDBC db = new JDBC();
        db.connect();

        try {
            String tenantQuery = "SELECT t.id as tenant_id, r.id as room_id, r.number as room_number, k.* FROM tenant t " +
                                 "JOIN room r ON t.room_id = r.id " +
                                 "JOIN kost k ON r.kost_id = k.id " +
                                 "JOIN users u ON t.user_id = u.id " +
                                 "WHERE u.email = ?";

            try (PreparedStatement stmt = db.getConnection().prepareStatement(tenantQuery)) {
                stmt.setString(1, userEmail);
                try (ResultSet rs = stmt.executeQuery()) {
                    // PERBAIKAN: Gunakan 'while' untuk membaca semua baris, bukan 'if'
                    while (rs.next()) {
                        Kost rentedKost = new Kost();
                        rentedKost.setId(rs.getInt("id"));
                        rentedKost.setName(rs.getString("name"));
                        rentedKost.setAddress(rs.getString("address"));
                        
                        Room rentedRoom = new Room();
                        rentedRoom.setId(rs.getInt("room_id"));
                        rentedRoom.setNumber(rs.getString("room_number"));

                        Map<String, Object> rentalData = new HashMap<>();
                        rentalData.put("kost", rentedKost);
                        rentalData.put("room", rentedRoom);
                        rentalList.add(rentalData);
                    }
                }
            }

            // Jika setelah query, rentalList masih kosong, berarti tenant belum sewa
            if (rentalList.isEmpty()) {
                String allKostQuery = "SELECT * FROM kost WHERE status = 1 ORDER BY created_at DESC";
                try(PreparedStatement allStmt = db.getConnection().prepareStatement(allKostQuery);
                    ResultSet allRs = allStmt.executeQuery()) {
                    while(allRs.next()){
                        Kost kost = new Kost();
                        kost.setId(allRs.getInt("id"));
                        kost.setName(allRs.getString("name"));
                        kost.setAddress(allRs.getString("address"));
                        kost.setPrice(allRs.getDouble("price"));
                        kost.setImageUrl(allRs.getString("image_url"));
                        kost.setAvgRating(allRs.getDouble("avg_rating"));
                        availableKostList.add(kost);
                    }
                }
            }
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