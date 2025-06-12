package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AddKostServlet", urlPatterns = {"/addKost"})
public class AddKostServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get user session
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get form data
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String location = request.getParameter("location");
        String description = request.getParameter("description");
        String type = request.getParameter("type");
        double price = Double.parseDouble(request.getParameter("price"));
        String facilities = request.getParameter("facilities");
        String imageUrl = request.getParameter("image_url");

        // Database connection parameters
        String dbUrl = "jdbc:mysql://localhost:3306/kostmanagement";
        String dbUser = "root";
        String dbPassword = "";

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Create connection
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            
            // Prepare SQL statement
            String sql = "INSERT INTO kost (owner_id, name, address, location, description, price, type, facilities, image_url, status, created_at) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1, NOW())";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, userId);
            stmt.setString(2, name);
            stmt.setString(3, address);
            stmt.setString(4, location);
            stmt.setString(5, description);
            stmt.setDouble(6, price);
            stmt.setString(7, type);
            stmt.setString(8, facilities);
            stmt.setString(9, imageUrl);
            
            // Execute the statement
            int result = stmt.executeUpdate();
            
            // Close resources
            stmt.close();
            conn.close();
            
            if (result > 0) {
                // Success - redirect to owner dashboard
                response.sendRedirect("ownerDashboard.jsp");
            } else {
                // Failed to insert
                request.setAttribute("errorMessage", "Gagal menambahkan kost. Silakan coba lagi.");
                request.getRequestDispatcher("kost/addKost.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Terjadi kesalahan: " + e.getMessage());
            request.getRequestDispatcher("kost/addKost.jsp").forward(request, response);
        }
    }
} 