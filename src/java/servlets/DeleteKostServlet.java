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

@WebServlet("/deleteKost")
public class DeleteKostServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"Owner".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int kostId = Integer.parseInt(request.getParameter("id"));
            JDBC db = new JDBC();
            db.connect();
            
            // PENTING: Untuk aplikasi nyata, Anda harus menghapus data terkait dulu
            // (kamar, tenant, pembayaran) sebelum menghapus kost.
            // Di sini kita langsung hapus untuk simplifikasi.
            String query = "DELETE FROM Kost WHERE id = ?";
            
            try {
                PreparedStatement stmt = db.getConnection().prepareStatement(query);
                stmt.setInt(1, kostId);
                stmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                db.disconnect();
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        
        response.sendRedirect("ownerDashboard");
    }
}