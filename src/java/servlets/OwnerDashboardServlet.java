package servlets;

import classes.JDBC;
import models.Kost;
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
        JDBC db = new JDBC();
        db.connect();

        // Menggunakan JOIN untuk mengambil data kost langsung berdasarkan email owner dalam satu kueri
        String query = "SELECT k.id, k.name, k.address " +
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
                    kostList.add(kost);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace(); // Penanganan error database
        } finally {
            db.disconnect(); // Selalu pastikan koneksi ditutup
        }
        
        request.setAttribute("kostList", kostList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("ownerDashboard.jsp");
        dispatcher.forward(request, response);
    }
}