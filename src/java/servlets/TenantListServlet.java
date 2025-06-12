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

@WebServlet("/tenantList")
public class TenantListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<TenantInfo> tenantList = new ArrayList<>();
        String query = "SELECT T.id, U.name, U.email, K.name as kost_name FROM Tenant T "
                     + "JOIN Users U ON T.user_id = U.id "
                     + "JOIN Kost K ON T.kost_id = K.id";

        JDBC db = new JDBC();
        db.connect();
        try (PreparedStatement stmt = db.getConnection().prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                TenantInfo tenant = new TenantInfo();
                // ... (set semua field: id, name, email, kostName)
                tenantList.add(tenant);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }
        
        request.setAttribute("tenantList", tenantList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("tenantList.jsp");
        dispatcher.forward(request, response);
    }
}