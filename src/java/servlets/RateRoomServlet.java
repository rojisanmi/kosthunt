package servlets;

import classes.JDBC;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/rateRoom")
public class RateRoomServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"Tenant".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            double rating = Double.parseDouble(request.getParameter("rating"));
            int kostId = -1;

            JDBC db = new JDBC();
            db.connect();
            try {
                db.getConnection().setAutoCommit(false);

                String q1 = "UPDATE room SET rating = ? WHERE id = ?";
                try (PreparedStatement stmt = db.getConnection().prepareStatement(q1)) {
                    stmt.setDouble(1, rating);
                    stmt.setInt(2, roomId);
                    stmt.executeUpdate();
                }

                String q2 = "SELECT kost_id FROM room WHERE id = ?";
                try (PreparedStatement stmt = db.getConnection().prepareStatement(q2)) {
                    stmt.setInt(1, roomId);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) kostId = rs.getInt("kost_id");
                    }
                }
                
                if (kostId != -1) {
                    String q3 = "UPDATE kost SET avg_rating = (SELECT AVG(rating) FROM room WHERE kost_id = ? AND rating > 0) WHERE id = ?";
                    try (PreparedStatement stmt = db.getConnection().prepareStatement(q3)) {
                        stmt.setInt(1, kostId);
                        stmt.setInt(2, kostId);
                        stmt.executeUpdate();
                    }
                }
                db.getConnection().commit();
            } catch (SQLException e) { 
                try { db.getConnection().rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
                e.printStackTrace();
            } finally { 
                try { if(db.getConnection() != null) db.getConnection().setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
                db.disconnect(); 
            }
        } catch (Exception e) { e.printStackTrace(); }
        
        response.sendRedirect("tenantDashboard?rating=success");
    }
}