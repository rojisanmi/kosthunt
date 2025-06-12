package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import classes.JDBC;

public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Debugging: Print out the email and password
        System.out.println("Email: " + email + ", Password: " + password);
        
        String query = "SELECT * FROM Users WHERE email = ? AND password = ?";

        // Use the JDBC class to get the connection
        JDBC db = new JDBC();
        db.connect();  // Establish connection using your JDBC class

        // Check if the connection was successful
        if (!db.isConnected()) {
            System.out.println("Database connection failed: " + db.getMessage());
            request.setAttribute("errorMessage", "Database connection failed.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            // Prepare the query using the connection from the JDBC class
            PreparedStatement stmt = db.getConnection().prepareStatement(query);
            stmt.setString(1, email);
            stmt.setString(2, password);

            // Get the result set
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // If user found, set session attributes
                HttpSession session = request.getSession();
                session.setAttribute("user", rs.getString("email"));
                session.setAttribute("role", rs.getString("role"));
                session.setAttribute("userName", rs.getString("name"));

                // Check if the user is "Owner" or "Tenant"
                String role = rs.getString("role");
                if ("Owner".equals(role)) {
                    System.out.println("Redirecting to ownerDashboard.jsp");
                    response.sendRedirect("ownerDashboard"); // Redirect to Owner's dashboard
                } else if ("Tenant".equals(role)) {
                    System.out.println("Redirecting to tenantDashboard.jsp");
                    response.sendRedirect("tenantDashboard"); // Redirect to Tenant's dashboard
                } else {
                    request.setAttribute("errorMessage", "Invalid user role.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                // No user found with the credentials
                System.out.println("No user found with these credentials.");
                request.setAttribute("errorMessage", "Invalid login credentials.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            // Handle SQL exceptions
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            // Always disconnect after finishing
            db.disconnect();
        }
    }
}
