package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet; // Import ResultSet for the verify query
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import classes.JDBC; // Ensure this import is present

@WebServlet("/removeTenant")
public class RemoveTenantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String ownerEmail = (String) session.getAttribute("user"); // Use "user" as per OwnerDashboardServlet

        if (ownerEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String tenantId = request.getParameter("tenantId");
        String roomId = request.getParameter("roomId");
        String kostId = request.getParameter("kostId"); // Ensure kostId is also retrieved for redirection
        String returnUrl = request.getParameter("returnUrl"); // This tells us where to redirect

        if (tenantId == null || roomId == null) {
            session.setAttribute("errorMessage", "Data penyewa tidak lengkap.");
            response.sendRedirect("ownerDashboard");
            return;
        }

        JDBC db = new JDBC(); // <--- Create an instance of JDBC
        Connection conn = null; // Initialize connection variable

        try {
            db.connect(); // Connect using the instance
            if (!db.isConnected()) {
                session.setAttribute("errorMessage", "Gagal terhubung ke database. Silakan coba lagi.");
                response.sendRedirect("ownerDashboard");
                return;
            }
            conn = db.getConnection(); // <--- Get the connection from the instance

            // Verify that the room belongs to the owner
            String verifyQuery = "SELECT k.id FROM kost k " +
                                 "JOIN room r ON k.id = r.kost_id " +
                                 "JOIN users o ON k.owner_id = o.id " +
                                 "WHERE o.email = ? AND r.id = ?";

            try (PreparedStatement verifyStmt = conn.prepareStatement(verifyQuery)) {
                verifyStmt.setString(1, ownerEmail);
                verifyStmt.setString(2, roomId);

                try (ResultSet rs = verifyStmt.executeQuery()) {
                    if (!rs.next()) { // No room found belonging to this owner
                        session.setAttribute("errorMessage", "Anda tidak memiliki akses untuk menghapus penyewa ini.");
                        response.sendRedirect("ownerDashboard");
                        return;
                    }
                }
            }

            // Begin transaction
            conn.setAutoCommit(false);
            try {
                // First, delete payment records for this tenant
                String deletePaymentQuery = "DELETE FROM payment WHERE tenant_id = ?";
                try (PreparedStatement deletePaymentStmt = conn.prepareStatement(deletePaymentQuery)) {
                    deletePaymentStmt.setString(1, tenantId);
                    deletePaymentStmt.executeUpdate();
                }

                // Then delete tenant from tenant table
                String removeTenantQuery = "DELETE FROM tenant WHERE id = ?";
                try (PreparedStatement removeStmt = conn.prepareStatement(removeTenantQuery)) {
                    removeStmt.setString(1, tenantId);
                    int affectedRows = removeStmt.executeUpdate();
                    if (affectedRows == 0) {
                        session.setAttribute("errorMessage", "Data penyewa tidak ditemukan.");
                        response.sendRedirect("ownerDashboard");
                        return;
                    }
                }

                // Finally update room status to Available
                String updateRoomQuery = "UPDATE room SET status = 'Available' WHERE id = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateRoomQuery)) {
                    updateStmt.setString(1, roomId);
                    int affectedRows = updateStmt.executeUpdate();
                    if (affectedRows == 0) {
                        session.setAttribute("errorMessage", "Data kamar tidak ditemukan.");
                        response.sendRedirect("ownerDashboard");
                        return;
                    }
                }

                // Commit transaction
                conn.commit();
                session.setAttribute("successMessage", "Penyewa berhasil dihapus dan kamar telah tersedia kembali.");

                // Redirect back to the appropriate page
                if (returnUrl != null && returnUrl.equals("kostDetail")) {
                    response.sendRedirect("kostDetail?id=" + kostId); // Use the retrieved kostId
                } else {
                    response.sendRedirect("ownerDashboard");
                }
            } catch (SQLException e) {
                // Rollback transaction on error
                conn.rollback();
                session.setAttribute("errorMessage", "Terjadi kesalahan saat menghapus data. Silakan coba lagi.");
                response.sendRedirect("ownerDashboard");
            } finally {
                // IMPORTANT: Reset auto-commit to true after the transaction
                if (conn != null) {
                    try {
                        conn.setAutoCommit(true);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Terjadi kesalahan sistem. Silakan coba lagi nanti.");
            response.sendRedirect("ownerDashboard");
        } finally {
            db.disconnect(); // <--- Always disconnect the JDBC instance
        }
    }
}