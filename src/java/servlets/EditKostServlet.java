package servlets;

import classes.JDBC;
import models.Kost;
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
import javax.servlet.http.HttpSession;

@WebServlet("/editKost")
public class EditKostServlet extends HttpServlet {

    // Metode ini untuk MENAMPILKAN form edit dengan data yang sudah ada
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"Owner".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int kostId = Integer.parseInt(request.getParameter("id"));
        Kost kost = null;
        JDBC db = new JDBC();
        db.connect();

        String query = "SELECT id, name, address, location FROM Kost WHERE id = ?";

        try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
            stmt.setInt(1, kostId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    kost = new Kost();
                    kost.setId(rs.getInt("id"));
                    kost.setName(rs.getString("name"));
                    kost.setAddress(rs.getString("address"));
                    kost.setLocation(rs.getString("location"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        request.setAttribute("kost", kost);
        RequestDispatcher dispatcher = request.getRequestDispatcher("kost/editKost.jsp");
        dispatcher.forward(request, response);
    }

    // Metode ini untuk MENYIMPAN perubahan dari form
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"Owner".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String location = request.getParameter("location");

        JDBC db = new JDBC();
        db.connect();

        String query = "UPDATE Kost SET name = ?, address = ?, location = ? WHERE id = ?";

        try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
            stmt.setString(1, name);
            stmt.setString(2, address);
            stmt.setString(3, location);
            stmt.setInt(4, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        // Setelah berhasil update, kembalikan ke dashboard
        response.sendRedirect("ownerDashboard");
    }
}