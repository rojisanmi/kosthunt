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

        String query = "SELECT id, name, email, role, phone FROM Users WHERE email = ?";
        try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    user.setPhone(rs.getString("phone"));
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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        // Handle phone number
        if (phone != null && phone.equals("Belum terdaftar")) {
            phone = null;
        }

        JDBC db = new JDBC();
        db.connect();

        try {
            String query;
            PreparedStatement stmt;

            if (password != null && !password.trim().isEmpty()) {
                // Update dengan password baru
                query = "UPDATE Users SET name = ?, phone = ?, password = ? WHERE id = ?";
                stmt = db.getConnection().prepareStatement(query);
                stmt.setString(1, name);
                stmt.setString(2, phone);
                stmt.setString(3, password);
                stmt.setString(4, id);
            } else {
                // Update tanpa password
                query = "UPDATE Users SET name = ?, phone = ? WHERE id = ?";
                stmt = db.getConnection().prepareStatement(query);
                stmt.setString(1, name);
                stmt.setString(2, phone);
                stmt.setString(3, id);
            }

            int result = stmt.executeUpdate();
            if (result > 0) {
                response.sendRedirect("profile?update=success");
            } else {
                response.sendRedirect("profile?update=error");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("profile?update=error");
        } finally {
            db.disconnect();
        }
    }
}