package servlets;

import classes.JDBC;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AddPaymentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int tenantId = Integer.parseInt(request.getParameter("tenantId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        String paymentDate = request.getParameter("paymentDate");
        
        String query = "INSERT INTO Payment (tenant_id, amount, payment_date) VALUES (" 
                + tenantId + ", " + amount + ", '" + paymentDate + "')";
        
        JDBC db = new JDBC();
        db.runQuery(query);
        
        response.sendRedirect("paymentList.jsp");  // Redirect ke halaman daftar pembayaran setelah berhasil
    }
}
