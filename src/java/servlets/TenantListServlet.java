package servlets;

import classes.JDBC;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class TenantListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = "SELECT U.name, U.email, K.name as kost_name, T.id FROM Tenant T "
                + "JOIN Users U ON T.user_id = U.id "
                + "JOIN Kost K ON T.kost_id = K.id";
        
        JDBC db = new JDBC();
        ResultSet rs = db.getData(query);
        
        request.setAttribute("tenantList", rs);
        RequestDispatcher dispatcher = request.getRequestDispatcher("tenantList.jsp");
        dispatcher.forward(request, response);
    }
}
