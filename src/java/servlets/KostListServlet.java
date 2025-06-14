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

// @WebServlet("/tenantDashboard")
public class KostListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = "SELECT id, name, address, status FROM Kost";
        List<Kost> kostList = new ArrayList<>();
        JDBC db = new JDBC();
        
        db.connect();
        // PERBAIKAN: Menggunakan try-with-resources
        try (PreparedStatement stmt = db.getConnection().prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Kost kost = new Kost();
                kost.setId(rs.getInt("id"));
                kost.setName(rs.getString("name"));
                kost.setAddress(rs.getString("address"));
                // Asumsi ada setStatus di model Kost
                // kost.setStatus(rs.getInt("status")); 
                kostList.add(kost);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        request.setAttribute("kostList", kostList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("tenantDashboard.jsp");
        dispatcher.forward(request, response);
    }
}