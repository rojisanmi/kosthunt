package servlets;

import classes.JDBC;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AddKostServlet")
public class AddKostServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"Owner".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String ownerEmail = (String) session.getAttribute("user");
        String kostName = request.getParameter("name");
        String kostAddress = request.getParameter("address");
        String kostLocation = request.getParameter("location");
        String kostDescription = request.getParameter("description");
        String kostType = request.getParameter("type");
        String kostImageUrl = request.getParameter("image_url");
        String[] facilities = request.getParameterValues("facilities");
        String priceStr = request.getParameter("price");
        
        // Validate price parameter
        double kostPrice = 0;
        if (priceStr != null && !priceStr.trim().isEmpty()) {
            try {
                kostPrice = Double.parseDouble(priceStr.trim());
                if (kostPrice <= 0) {
                    request.setAttribute("errorMessage", "Price must be greater than 0.");
                    request.getRequestDispatcher("/kost/addKost.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid price format. Please enter a valid number.");
                request.getRequestDispatcher("/kost/addKost.jsp").forward(request, response);
                return;
            }
        } else {
            request.setAttribute("errorMessage", "Price is required.");
            request.getRequestDispatcher("/kost/addKost.jsp").forward(request, response);
            return;
        }

        // Validate required fields
        if (kostName == null || kostName.trim().isEmpty() ||
            kostAddress == null || kostAddress.trim().isEmpty() ||
            kostLocation == null || kostLocation.trim().isEmpty() ||
            kostDescription == null || kostDescription.trim().isEmpty() ||
            kostType == null || kostType.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required except image URL and facilities.");
            request.getRequestDispatcher("/kost/addKost.jsp").forward(request, response);
            return;
        }

        int ownerId = -1;
        JDBC db = new JDBC();
        db.connect();

        try {
            // Get owner ID from email
            String getOwnerIdQuery = "SELECT id FROM Users WHERE email = ?";
            PreparedStatement getOwnerIdStmt = db.getConnection().prepareStatement(getOwnerIdQuery);
            getOwnerIdStmt.setString(1, ownerEmail);
            ResultSet rsId = getOwnerIdStmt.executeQuery();
            
            if (rsId.next()) {
                ownerId = rsId.getInt("id");
            }
            rsId.close();
            getOwnerIdStmt.close();
            
            // Insert new kost data
            if (ownerId != -1) {
                String insertQuery = "INSERT INTO Kost (owner_id, name, address, location, description, type, price, image_url, facilities, status, created_at) " +
                                   "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1, NOW())";
                
                PreparedStatement insertStmt = db.getConnection().prepareStatement(insertQuery);
                insertStmt.setInt(1, ownerId);
                insertStmt.setString(2, kostName);
                insertStmt.setString(3, kostAddress);
                insertStmt.setString(4, kostLocation);
                insertStmt.setString(5, kostDescription);
                insertStmt.setString(6, kostType);
                insertStmt.setDouble(7, kostPrice);
                insertStmt.setString(8, kostImageUrl);
                
                // Handle facilities
                String facilitiesStr = "";
                if (facilities != null && facilities.length > 0) {
                    facilitiesStr = String.join(", ", facilities);
                }
                insertStmt.setString(9, facilitiesStr);
                
                int result = insertStmt.executeUpdate();
                insertStmt.close();
                
                if (result > 0) {
                    response.sendRedirect(request.getContextPath() + "/ownerDashboard");
                } else {
                    request.setAttribute("errorMessage", "Failed to add kost. Please try again.");
                    request.getRequestDispatcher("/kost/addKost.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Owner not found. Please try again.");
                request.getRequestDispatcher("/kost/addKost.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/kost/addKost.jsp").forward(request, response);
        } finally {
            db.disconnect();
        }
    }
}