package servlets;

import classes.JDBC;
import models.Kost;
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

@WebServlet("/roomList")
public class RoomListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int kostId = Integer.parseInt(request.getParameter("kostId"));
        List<Room> roomList = new ArrayList<>();
        Kost kost = new Kost();
        kost.setId(kostId);

        JDBC db = new JDBC();
        db.connect();

        try {
            // Ambil nama Kost untuk ditampilkan di judul halaman
            String getKostNameQuery = "SELECT name FROM Kost WHERE id = ?";
            try (PreparedStatement stmt = db.getConnection().prepareStatement(getKostNameQuery)) {
                stmt.setInt(1, kostId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        kost.setName(rs.getString("name"));
                    }
                }
            }
            
            // Ambil daftar kamar untuk kost tersebut
            String getRoomsQuery = "SELECT id, number, type, kost_id FROM Room WHERE kost_id = ?";
            try (PreparedStatement stmt = db.getConnection().prepareStatement(getRoomsQuery)) {
                stmt.setInt(1, kostId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Room room = new Room();
                        room.setId(rs.getInt("id"));
                        room.setNumber(rs.getString("number"));
                        room.setType(rs.getString("type"));
                        // PERBAIKAN ADA DI SINI:
                        room.setKostId(rs.getInt("kost_id"));
                        roomList.add(room);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        request.setAttribute("kost", kost);
        request.setAttribute("roomList", roomList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("room/roomList.jsp");
        dispatcher.forward(request, response);
    }
}