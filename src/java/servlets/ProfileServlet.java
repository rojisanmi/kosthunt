package servlets;

import classes.JDBC;
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
import javax.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    // Untuk menampilkan halaman profil
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String email = (String) session.getAttribute("user");
        User user = null;
        JDBC db = new JDBC();
        db.connect();

        String query = "SELECT id, name, email, role FROM Users WHERE email = ?";
        try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.disconnect();
        }

        request.setAttribute("profileData", user);
        RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
        dispatcher.forward(request, response);
    }

    // Untuk memproses update profil
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String password = request.getParameter("password");

        JDBC db = new JDBC();
        db.connect();

        try {
            // Update nama
            String updateNameQuery = "UPDATE Users SET name = ? WHERE id = ?";
            try (PreparedStatement stmt = db.getConnection().prepareStatement(updateNameQuery)) {
                stmt.setString(1, name);
                stmt.setInt(2, id);
                stmt.executeUpdate();
            }

            // Jika kolom password diisi, update juga passwordnya
            if (password != null && !password.isEmpty()) {
                String updatePasswordQuery = "UPDATE Users SET password = ? WHERE id = ?";
                try (PreparedStatement stmt = db.getConnection().prepareStatement(updatePasswordQuery)) {
                    stmt.setString(1, password);
                    stmt.setInt(2, id);
                    stmt.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("profile?update=error");
            return;
        } finally {
            db.disconnect();
        }
        
        // Redirect dengan pesan sukses
        response.sendRedirect("profile?update=success");
    }
}