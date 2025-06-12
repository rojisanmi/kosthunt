package servlets;

import classes.JDBC;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.annotation.WebServlet;
import models.*;

@WebServlet("/paymentList")
public class PaymentListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<PaymentInfo> paymentList = new ArrayList<>();
        String query = "SELECT P.id, U.name as tenant_name, P.amount, P.payment_date FROM Payment P "
                     + "JOIN Tenant T ON P.tenant_id = T.id "
                     + "JOIN Users U ON T.user_id = U.id";
        
        JDBC db = new JDBC();
        db.connect();
        try (PreparedStatement stmt = db.getConnection().prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                PaymentInfo payment = new PaymentInfo();
                // ... (set semua field: id, tenantName, amount, paymentDate)
                paymentList.add(payment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }
        
        request.setAttribute("paymentList", paymentList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("paymentList.jsp");
        dispatcher.forward(request, response);
    }
}
