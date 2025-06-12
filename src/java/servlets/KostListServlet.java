package servlets;

import classes.JDBC;
import models.Kost; // Import model yang baru dibuat
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; // Import anotasi WebServlet
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// Anotasi ini akan membuat servlet diakses melalui URL /tenantDashboard
@WebServlet("/tenantDashboard")
public class KostListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = "SELECT id, name, address, status FROM Kost";
        List<Kost> kostList = new ArrayList<>();
        JDBC db = new JDBC();
        
        db.connect(); // Buka koneksi

        try {
            PreparedStatement stmt = db.getConnection().prepareStatement(query);
            ResultSet rs = stmt.executeQuery();

            // Ubah ResultSet menjadi List<Kost>
            while (rs.next()) {
                Kost kost = new Kost();
                kost.setId(rs.getInt("id"));
                kost.setName(rs.getString("name"));
                kost.setAddress(rs.getString("address"));
                kost.setStatus(rs.getInt("status"));
                kostList.add(kost);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Penanganan error
        } finally {
            db.disconnect(); // Pastikan koneksi selalu ditutup
        }

        // Kirim list ke JSP
        request.setAttribute("kostList", kostList);
        
        // Arahkan ke file JSP yang benar
        RequestDispatcher dispatcher = request.getRequestDispatcher("tenantDashboard.jsp");
        dispatcher.forward(request, response);
    }
}