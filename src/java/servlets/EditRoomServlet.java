package servlets;

import classes.JDBC;
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
import models.Room;

@WebServlet("/editRoom")
public class EditRoomServlet extends HttpServlet {

    // Metode doGet Anda sudah benar, tidak ada perubahan.
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Room room = null;
        String roomIdParam = request.getParameter("roomId");
        try {
            int roomId = Integer.parseInt(roomIdParam);
            JDBC db = new JDBC();
            db.connect();
            String query = "SELECT * FROM Room WHERE id = ?";
            try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
                stmt.setInt(1, roomId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        room = new Room();
                        room.setId(rs.getInt("id"));
                        room.setNumber(rs.getString("number"));
                        room.setType(rs.getString("type"));
                        room.setKostId(rs.getInt("kost_id"));
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                db.disconnect();
            }
        } catch (NumberFormatException e) {
            System.out.println("Error: Parameter roomId tidak valid: " + roomIdParam);
            e.printStackTrace();
        }
        request.setAttribute("room", room);
        RequestDispatcher dispatcher = request.getRequestDispatcher("room/editRoom.jsp");
        dispatcher.forward(request, response);
    }

    // --- PERBAIKAN TOTAL PADA METODE doPost ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String roomNumber = request.getParameter("roomNumber");
        String roomType = request.getParameter("roomType");
        int roomId = 0;
        int kostId = 0;

        try {
            // Validasi input
            roomId = Integer.parseInt(request.getParameter("roomId"));
            kostId = Integer.parseInt(request.getParameter("kostId"));

            JDBC db = new JDBC();
            db.connect();

            // Gunakan PreparedStatement untuk keamanan
            String query = "UPDATE Room SET number = ?, type = ? WHERE id = ?";
            
            try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
                stmt.setString(1, roomNumber);
                stmt.setString(2, roomType);
                stmt.setInt(3, roomId);
                stmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                db.disconnect();
            }

        } catch (NumberFormatException e) {
            System.out.println("Error: Parameter ID tidak valid saat update.");
            e.printStackTrace();
        }

        // Redirect kembali ke halaman daftar kamar dengan path yang lengkap
        response.sendRedirect(request.getContextPath() + "/roomList?kostId=" + kostId);
    }
}