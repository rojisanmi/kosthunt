package servlets;

import classes.JDBC;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/addRoom")
public class AddRoomServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        // Pastikan hanya owner yang bisa mengakses
        if (session == null || !"Owner".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String roomNumber = request.getParameter("roomNumber");
        String roomType = request.getParameter("roomType");
        int kostId = 0;

        try {
            kostId = Integer.parseInt(request.getParameter("kostId"));

            JDBC db = new JDBC();
            db.connect();

            // Gunakan PreparedStatement untuk query INSERT yang aman
            String query = "INSERT INTO Room (kost_id, number, type) VALUES (?, ?, ?)";

            try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
                stmt.setInt(1, kostId);
                stmt.setString(2, roomNumber);
                stmt.setString(3, roomType);
                stmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                db.disconnect();
            }
        } catch (NumberFormatException e) {
            System.out.println("Error: kostId tidak valid saat menambah kamar.");
            e.printStackTrace();
        }
        
        // Setelah berhasil, redirect kembali ke halaman daftar kamar untuk kost yang relevan
        response.sendRedirect(request.getContextPath() + "/roomList?kostId=" + kostId);
    }
}