package servlets;

import classes.JDBC;
import models.Kost;
import models.User;
import models.Room;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/kostDetail")
public class KostDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Kost kost = null;
        User owner = null;
        List<Room> roomList = new ArrayList<>();
        List<Map<String, Object>> tenantList = new ArrayList<>();
        String kostIdParam = request.getParameter("id");
        
        int kostId = 0;

        if (kostIdParam == null || kostIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID Kost tidak ditemukan.");
            return;
        }

        JDBC db = new JDBC();
        db.connect();

        try {
            kostId = Integer.parseInt(kostIdParam);

            // Query untuk detail kost dan owner
            String kostQuery = "SELECT k.*, u.name as owner_name, u.phone as owner_phone, u.email as owner_email " +
                             "FROM kost k JOIN users u ON k.owner_id = u.id WHERE k.id = ?";
            
            try (PreparedStatement kostStmt = db.getConnection().prepareStatement(kostQuery)) {
                kostStmt.setInt(1, kostId);
                try (ResultSet rs = kostStmt.executeQuery()) {
                    if (rs.next()) {
                        kost = new Kost();
                        kost.setId(rs.getInt("id"));
                        kost.setName(rs.getString("name"));
                        kost.setDescription(rs.getString("description"));
                        kost.setPrice(rs.getDouble("price"));
                        kost.setLocation(rs.getString("location"));
                        kost.setType(rs.getString("type"));
                        kost.setFacilities(rs.getString("facilities"));
                        kost.setImageUrl(rs.getString("image_url"));
                        kost.setAddress(rs.getString("address"));
                        kost.setAvgRating(rs.getDouble("avg_rating"));

                        owner = new User();
                        owner.setName(rs.getString("owner_name"));
                        owner.setPhone(rs.getString("owner_phone"));
                        owner.setEmail(rs.getString("owner_email"));
                    }
                }
            }
            
            // Query untuk mengambil daftar kamar dari kost ini
            String roomQuery = "SELECT * FROM room WHERE kost_id = ?";
            try (PreparedStatement roomStmt = db.getConnection().prepareStatement(roomQuery)) {
                roomStmt.setInt(1, kostId);
                try (ResultSet rs = roomStmt.executeQuery()) {
                    while (rs.next()) {
                        Room room = new Room();
                        room.setId(rs.getInt("id"));
                        room.setNumber(rs.getString("number"));
                        room.setType(rs.getString("type"));
                        room.setPrice(rs.getDouble("price"));
                        room.setStatus(rs.getString("status"));
                        roomList.add(room);
                    }
                }
            }

            // Query untuk mengambil informasi tenant
            String tenantQuery = "SELECT t.id as tenant_id, u.name as tenant_name, u.email as tenant_email, " +
                               "u.phone as tenant_phone, r.number as room_number, r.type as room_type " +
                               "FROM tenant t " +
                               "JOIN users u ON t.user_id = u.id " +
                               "JOIN room r ON t.room_id = r.id " +
                               "WHERE r.kost_id = ? AND r.status = 'Occupied'";
            try (PreparedStatement tenantStmt = db.getConnection().prepareStatement(tenantQuery)) {
                tenantStmt.setInt(1, kostId);
                try (ResultSet rs = tenantStmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> tenant = new HashMap<>();
                        tenant.put("id", rs.getInt("tenant_id"));
                        tenant.put("name", rs.getString("tenant_name"));
                        tenant.put("email", rs.getString("tenant_email"));
                        tenant.put("phone", rs.getString("tenant_phone"));
                        tenant.put("roomNumber", rs.getString("room_number"));
                        tenant.put("roomType", rs.getString("room_type"));
                        tenantList.add(tenant);
                    }
                }
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID Kost tidak valid.");
            return;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        request.setAttribute("kost", kost);
        request.setAttribute("owner", owner);
        request.setAttribute("roomList", roomList);
        request.setAttribute("tenantList", tenantList);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("kostDetail.jsp");
        dispatcher.forward(request, response);
    }
}