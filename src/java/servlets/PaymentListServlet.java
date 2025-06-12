package servlets;

import classes.JDBC;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class PaymentListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = "SELECT P.id, U.name as tenant_name, P.amount, P.payment_date FROM Payment P "
                + "JOIN Tenant T ON P.tenant_id = T.id "
                + "JOIN Users U ON T.user_id = U.id";
        
        JDBC db = new JDBC();
        ResultSet rs = db.getData(query);
        
        request.setAttribute("paymentList", rs);
        RequestDispatcher dispatcher = request.getRequestDispatcher("paymentList.jsp");
        dispatcher.forward(request, response);
    }
}
