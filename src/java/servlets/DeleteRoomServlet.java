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

@WebServlet("/deleteRoom")
public class DeleteRoomServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        // 1. Keamanan: Pastikan hanya owner yang bisa mengakses
        if (session == null || !"Owner".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int roomId = 0;
        int kostId = 0;

        try {
            roomId = Integer.parseInt(request.getParameter("roomId"));
            kostId = Integer.parseInt(request.getParameter("kostId"));

            JDBC db = new JDBC();
            db.connect();

            // 3. Keamanan: Gunakan PreparedStatement untuk query DELETE
            String query = "DELETE FROM Room WHERE id = ?";

            try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
                stmt.setInt(1, roomId);
                stmt.executeUpdate();
                System.out.println("Kamar dengan ID: " + roomId + " berhasil dihapus.");
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                db.disconnect();
            }

        } catch (NumberFormatException e) {
            System.out.println("Error: Parameter ID tidak valid saat menghapus kamar.");
            e.printStackTrace();
        }

        // 4. Alur Pengguna: Redirect kembali ke halaman daftar kamar yang benar
        response.sendRedirect(request.getContextPath() + "/roomList?kostId=" + kostId);
    }
}