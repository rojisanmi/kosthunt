package servlets;

import classes.JDBC;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AddTenantServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tenantName = request.getParameter("tenantName");
        String tenantEmail = request.getParameter("tenantEmail");
        int kostId = Integer.parseInt(request.getParameter("kostId"));
        
        String query = "INSERT INTO Tenant (user_id, kost_id) VALUES "
                + "((SELECT id FROM Users WHERE email = '" + tenantEmail + "'), " + kostId + ")";
        
        JDBC db = new JDBC();
        db.runQuery(query);
        
        response.sendRedirect("tenantList.jsp");  // Redirect ke halaman daftar tenant setelah berhasil
    }
}
