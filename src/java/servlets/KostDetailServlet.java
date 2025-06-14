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
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/kostDetail")
public class KostDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Kost kost = null;
        User owner = null;
        List<Room> roomList = new ArrayList<>();
        String kostIdParam = request.getParameter("id");
        
        // PERBAIKAN: Deklarasikan kostId di luar try agar bisa diakses oleh kedua query
        int kostId = 0;

        if (kostIdParam == null || kostIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID Kost tidak ditemukan.");
            return;
        }

        JDBC db = new JDBC();
        db.connect();

        try {
            kostId = Integer.parseInt(kostIdParam); // Parsing ID di sini

            // Query untuk detail kost dan owner
            String kostQuery = "SELECT k.*, u.name as owner_name, u.phone as owner_phone, u.email as owner_email " +
                             "FROM kost k JOIN users u ON k.owner_id = u.id WHERE k.id = ?";
            
            // PERBAIKAN: Gunakan nama variabel yang berbeda (kostStmt)
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
            // PERBAIKAN: Gunakan nama variabel yang berbeda (roomStmt)
            try (PreparedStatement roomStmt = db.getConnection().prepareStatement(roomQuery)) {
                roomStmt.setInt(1, kostId);
                try (ResultSet rs = roomStmt.executeQuery()) {
                    while (rs.next()) {
                        Room room = new Room();
                        room.setId(rs.getInt("id"));
                        room.setNumber(rs.getString("number"));
                        room.setType(rs.getString("type"));
                        // PERBAIKAN: Sekarang method ini sudah ada di Room.java
                        room.setPrice(rs.getDouble("price"));
                        room.setStatus(rs.getString("status"));
                        roomList.add(room);
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
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("kostDetail.jsp");
        dispatcher.forward(request, response);
    }
}