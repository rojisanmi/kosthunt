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

@WebServlet("/addPayment")
public class AddPaymentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int tenantId = Integer.parseInt(request.getParameter("tenantId"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            String paymentDate = request.getParameter("paymentDate"); // Asumsi format YYYY-MM-DD

            JDBC db = new JDBC();
            db.connect();
            String query = "INSERT INTO Payment (tenant_id, amount, payment_date) VALUES (?, ?, ?)";

            try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
                stmt.setInt(1, tenantId);
                stmt.setDouble(2, amount);
                stmt.setString(3, paymentDate);
                stmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                db.disconnect();
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/paymentList"); // Arahkan ke servlet
    }
}