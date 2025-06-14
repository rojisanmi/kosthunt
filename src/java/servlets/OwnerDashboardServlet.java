package servlets;

import classes.JDBC;
import models.Kost;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ownerDashboard")
public class OwnerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Validasi sesi: pastikan user sudah login dan perannya adalah "Owner"
        if (session == null || session.getAttribute("user") == null || !"Owner".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String ownerEmail = (String) session.getAttribute("user");
        System.out.println("DEBUG: Email yang tersimpan di sesi adalah -> " + ownerEmail);
        List<Kost> kostList = new ArrayList<>();
        List<Map<String, Object>> tenantList = new ArrayList<>();
        List<Map<String, Object>> unpaidTenantList = new ArrayList<>();
        
        JDBC db = new JDBC();
        db.connect();

        // Menggunakan JOIN untuk mengambil data kost langsung berdasarkan email owner dalam satu kueri
        String query = "SELECT k.id, k.name, k.address, k.avg_rating " +
                       "FROM Kost k " +
                       "JOIN Users u ON k.owner_id = u.id " +
                       "WHERE u.email = ?";

        try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
            stmt.setString(1, ownerEmail);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Kost kost = new Kost();
                    kost.setId(rs.getInt("id"));
                    kost.setName(rs.getString("name"));
                    kost.setAddress(rs.getString("address"));
                    kost.setAvgRating(rs.getDouble("avg_rating"));
                    kostList.add(kost);
                }
            }

            // Query untuk mengambil semua tenant dari kost yang dimiliki owner
            String tenantQuery = "SELECT t.id as tenant_id, u.name as tenant_name, u.email as tenant_email, " +
                               "u.phone as tenant_phone, r.number as room_number, r.type as room_type, " +
                               "k.name as kost_name, k.address as kost_address " +
                               "FROM tenant t " +
                               "JOIN users u ON t.user_id = u.id " +
                               "JOIN room r ON t.room_id = r.id " +
                               "JOIN kost k ON r.kost_id = k.id " +
                               "JOIN users o ON k.owner_id = o.id " +
                               "WHERE o.email = ? AND r.status = 'Occupied' " +
                               "ORDER BY k.name, r.number";
            
            try (PreparedStatement tenantStmt = db.getConnection().prepareStatement(tenantQuery)) {
                tenantStmt.setString(1, ownerEmail);
                try (ResultSet rs = tenantStmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> tenant = new HashMap<>();
                        tenant.put("id", rs.getInt("tenant_id"));
                        tenant.put("name", rs.getString("tenant_name"));
                        tenant.put("email", rs.getString("tenant_email"));
                        tenant.put("phone", rs.getString("tenant_phone"));
                        tenant.put("roomNumber", rs.getString("room_number"));
                        tenant.put("roomType", rs.getString("room_type"));
                        tenant.put("kostName", rs.getString("kost_name"));
                        tenant.put("kostAddress", rs.getString("kost_address"));
                        tenantList.add(tenant);
                    }
                }
            }

            // Query untuk mengambil tenant yang belum membayar lebih dari 1 bulan
            String unpaidQuery = "SELECT t.id as tenant_id, u.name as tenant_name, u.email as tenant_email, " +
                               "u.phone as tenant_phone, r.number as room_number, r.type as room_type, " +
                               "k.name as kost_name, k.address as kost_address, " +
                               "MAX(p.payment_date) as last_payment_date, " +
                               "DATEDIFF(CURRENT_DATE, MAX(p.payment_date)) as days_overdue " +
                               "FROM tenant t " +
                               "JOIN users u ON t.user_id = u.id " +
                               "JOIN room r ON t.room_id = r.id " +
                               "JOIN kost k ON r.kost_id = k.id " +
                               "JOIN users o ON k.owner_id = o.id " +
                               "LEFT JOIN payment p ON t.id = p.tenant_id " +
                               "WHERE o.email = ? AND r.status = 'Occupied' " +
                               "GROUP BY t.id, u.name, u.email, u.phone, r.number, r.type, k.name, k.address " +
                               "HAVING MAX(p.payment_date) IS NULL OR DATEDIFF(CURRENT_DATE, MAX(p.payment_date)) >= 30 " +
                               "ORDER BY days_overdue DESC";
            
            try (PreparedStatement unpaidStmt = db.getConnection().prepareStatement(unpaidQuery)) {
                unpaidStmt.setString(1, ownerEmail);
                try (ResultSet rs = unpaidStmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> tenant = new HashMap<>();
                        tenant.put("id", rs.getInt("tenant_id"));
                        tenant.put("name", rs.getString("tenant_name"));
                        tenant.put("email", rs.getString("tenant_email"));
                        tenant.put("phone", rs.getString("tenant_phone"));
                        tenant.put("roomNumber", rs.getString("room_number"));
                        tenant.put("roomType", rs.getString("room_type"));
                        tenant.put("kostName", rs.getString("kost_name"));
                        tenant.put("kostAddress", rs.getString("kost_address"));
                        tenant.put("lastPaymentDate", rs.getDate("last_payment_date"));
                        tenant.put("daysOverdue", rs.getInt("days_overdue"));
                        unpaidTenantList.add(tenant);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace(); // Penanganan error database
        } finally {
            db.disconnect(); // Selalu pastikan koneksi ditutup
        }
        
        request.setAttribute("kostList", kostList);
        request.setAttribute("tenantList", tenantList);
        request.setAttribute("unpaidTenantList", unpaidTenantList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("ownerDashboard.jsp");
        dispatcher.forward(request, response);
    }
}