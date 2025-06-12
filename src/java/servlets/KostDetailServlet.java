package servlets;

import classes.JDBC;
import models.Kost;
import models.User;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/kostDetail")
public class KostDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Kost kost = null;
        User owner = null;
        String kostIdParam = request.getParameter("id");

        if (kostIdParam == null || kostIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID Kost tidak ditemukan.");
            return;
        }

        JDBC db = new JDBC();
        db.connect();

        String query = "SELECT k.*, u.name as owner_name, u.phone as owner_phone, u.email as owner_email " +
                       "FROM kost k " +
                       "JOIN users u ON k.owner_id = u.id " +
                       "WHERE k.id = ?";

        try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
            stmt.setInt(1, Integer.parseInt(kostIdParam));
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    // Mengisi objek Kost dari database
                    kost = new Kost();
                    kost.setId(rs.getInt("id"));
                    kost.setName(rs.getString("name"));
                    kost.setDescription(rs.getString("description"));
                    kost.setPrice(rs.getDouble("price"));
                    kost.setLocation(rs.getString("location"));
                    kost.setType(rs.getString("type"));
                    kost.setFacilities(rs.getString("facilities"));
                    kost.setImageUrl(rs.getString("image_url"));
                    kost.setAddress(rs.getString("address"));
                    
                    // Mengisi objek User (sebagai owner) dari database
                    owner = new User();
                    owner.setName(rs.getString("owner_name"));
                    owner.setPhone(rs.getString("owner_phone"));
                    owner.setEmail(rs.getString("owner_email"));
                }
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID Kost tidak valid.");
            return;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        // Mengirim objek ke JSP
        request.setAttribute("kost", kost);
        request.setAttribute("owner", owner);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("kostDetail.jsp");
        dispatcher.forward(request, response);
    }
}