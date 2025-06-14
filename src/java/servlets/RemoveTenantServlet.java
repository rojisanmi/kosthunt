package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import classes.JDBC;

@WebServlet("/removeTenant")
public class RemoveTenantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String ownerEmail = (String) session.getAttribute("email");
        
        if (ownerEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String tenantId = request.getParameter("tenantId");
        String roomId = request.getParameter("roomId");
        String returnUrl = request.getParameter("returnUrl");

        if (tenantId == null || roomId == null) {
            response.sendRedirect("ownerDashboard.jsp");
            return;
        }

        try (Connection conn = JDBC.getConnection()) {
            // Verify that the room belongs to the owner
            String verifyQuery = "SELECT k.id FROM kost k " +
                               "JOIN room r ON k.id = r.kost_id " +
                               "JOIN users o ON k.owner_id = o.id " +
                               "WHERE o.email = ? AND r.id = ?";
            
            try (PreparedStatement verifyStmt = conn.prepareStatement(verifyQuery)) {
                verifyStmt.setString(1, ownerEmail);
                verifyStmt.setString(2, roomId);
                
                if (!verifyStmt.executeQuery().next()) {
                    response.sendRedirect("ownerDashboard.jsp");
                    return;
                }
            }

            // Begin transaction
            conn.setAutoCommit(false);
            try {
                // Remove tenant from room
                String removeTenantQuery = "UPDATE tenant SET room_id = NULL WHERE id = ?";
                try (PreparedStatement removeStmt = conn.prepareStatement(removeTenantQuery)) {
                    removeStmt.setString(1, tenantId);
                    removeStmt.executeUpdate();
                }

                // Update room status to Available
                String updateRoomQuery = "UPDATE room SET status = 'Available' WHERE id = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateRoomQuery)) {
                    updateStmt.setString(1, roomId);
                    updateStmt.executeUpdate();
                }

                // Commit transaction
                conn.commit();
                
                // Redirect back to the appropriate page
                if (returnUrl != null && returnUrl.equals("kostDetail")) {
                    response.sendRedirect("kostDetail?id=" + request.getParameter("kostId"));
                } else {
                    response.sendRedirect("ownerDashboard.jsp");
                }
            } catch (SQLException e) {
                // Rollback transaction on error
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
} 