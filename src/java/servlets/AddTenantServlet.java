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

@WebServlet("/addTenant")
public class AddTenantServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tenantEmail = request.getParameter("tenantEmail");
        int kostId = 0;
        
        try {
            kostId = Integer.parseInt(request.getParameter("kostId"));
            
            JDBC db = new JDBC();
            db.connect();
            
            // Query aman dengan subquery menggunakan PreparedStatement
            String query = "INSERT INTO Tenant (user_id, kost_id) VALUES ((SELECT id FROM Users WHERE email = ?), ?)";

            try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
                stmt.setString(1, tenantEmail);
                stmt.setInt(2, kostId);
                stmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                db.disconnect();
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/tenantList"); // Arahkan ke servlet
    }
}