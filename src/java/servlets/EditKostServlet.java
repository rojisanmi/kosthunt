package servlets;

import classes.JDBC;
import models.Kost;
import java.io.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.util.UUID;
import java.nio.file.Files;

@WebServlet("/editKost")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 5,    // 5 MB
    maxRequestSize = 1024 * 1024 * 10  // 10 MB
)
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

        String query = "SELECT * FROM Kost WHERE id = ?";

        try (PreparedStatement stmt = db.getConnection().prepareStatement(query)) {
            stmt.setInt(1, kostId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    kost = new Kost();
                    kost.setId(rs.getInt("id"));
                    kost.setName(rs.getString("name"));
                    kost.setAddress(rs.getString("address"));
                    kost.setLocation(rs.getString("location"));
                    kost.setDescription(rs.getString("description"));
                    kost.setPrice(rs.getDouble("price"));
                    kost.setType(rs.getString("type"));
                    kost.setFacilities(rs.getString("facilities"));
                    kost.setImageUrl(rs.getString("image_url"));
                    kost.setStatus(rs.getInt("status"));
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
        String description = request.getParameter("description");
        String type = request.getParameter("type");
        String priceStr = request.getParameter("price");
        String[] facilities = request.getParameterValues("facilities");
        
        // Handle image upload
        String imageUrl = null;
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = UUID.randomUUID().toString() + getFileExtension(filePart.getSubmittedFileName());
            String uploadPath = getServletContext().getRealPath("/uploads");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            
            File file = new File(uploadPath + File.separator + fileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, file.toPath());
            }
            imageUrl = "uploads/" + fileName;
        }

        JDBC db = new JDBC();
        db.connect();

        try {
            // Get current kost data to check if we need to update the image
            String currentImageUrl = null;
            String getCurrentImageQuery = "SELECT image_url FROM Kost WHERE id = ?";
            try (PreparedStatement stmt = db.getConnection().prepareStatement(getCurrentImageQuery)) {
                stmt.setInt(1, id);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        currentImageUrl = rs.getString("image_url");
                    }
                }
            }

            // Prepare the update query
            StringBuilder updateQuery = new StringBuilder("UPDATE Kost SET name = ?, address = ?, location = ?, description = ?, type = ?, price = ?");
            if (imageUrl != null) {
                updateQuery.append(", image_url = ?");
            }
            if (facilities != null) {
                updateQuery.append(", facilities = ?");
            }
            updateQuery.append(" WHERE id = ?");

            try (PreparedStatement stmt = db.getConnection().prepareStatement(updateQuery.toString())) {
                int paramIndex = 1;
                stmt.setString(paramIndex++, name);
                stmt.setString(paramIndex++, address);
                stmt.setString(paramIndex++, location);
                stmt.setString(paramIndex++, description);
                stmt.setString(paramIndex++, type);
                stmt.setDouble(paramIndex++, Double.parseDouble(priceStr));
                
                if (imageUrl != null) {
                    stmt.setString(paramIndex++, imageUrl);
                }
                if (facilities != null) {
                    stmt.setString(paramIndex++, String.join(", ", facilities));
                }
                stmt.setInt(paramIndex, id);
                
                stmt.executeUpdate();
                
                // If we have a new image and there was an old image, delete the old image file
                if (imageUrl != null && currentImageUrl != null && !currentImageUrl.isEmpty()) {
                    File oldImageFile = new File(getServletContext().getRealPath("/") + currentImageUrl);
                    if (oldImageFile.exists()) {
                        oldImageFile.delete();
                    }
                }
            }
            
            session.setAttribute("successMessage", "Kost berhasil diperbarui.");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Gagal memperbarui kost: " + e.getMessage());
        } finally {
            db.disconnect();
        }

        response.sendRedirect("ownerDashboard");
    }

    private String getFileExtension(String fileName) {
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex == -1) {
            return "";
        }
        return fileName.substring(dotIndex);
    }
}