<%@page import="models.Kost"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Owner Dashboard - KostHunt</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            body { margin: 0; padding: 0; font-family: 'Roboto', poppins; background-color: #f4f7f6; }
            .area-header { width: 100%; height: 60px; background-color: #4A90E2; display: flex; align-items: center; padding: 0 20px; box-sizing: border-box; }
            .header { color: white; font-size: 30px; font-weight: bold; }
            .header-nav { margin-left: auto; display: flex; gap: 10px; }
            .nav-button { background-color: white; color: #4A90E2; padding: 8px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; font-weight: bold; text-decoration: none; display: inline-block; text-align: center; }
            .nav-button:hover { background-color: #e0e0e0; }
            .main-container { padding: 20px; }
            .dashboard-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #ddd; padding-bottom: 10px; }
            .dashboard-header h2 { font-size: 28px; color: #333; margin: 0; }
            .btn-add { background-color: #28a745; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold; }
            .kost-container { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; margin-top: 20px; }
            .kost-card { background-color: white; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 8px rgba(0,0,0,0.1); display: flex; flex-direction: column; }
            .kost-card-img { width: 100%; height: 180px; object-fit: cover; }
            .kost-card-body { padding: 15px; flex-grow: 1; }
            .kost-card-body h4 { margin: 0 0 5px 0; font-size: 20px; }
            .kost-card-body p { margin: 0; color: #666; }
            .kost-card-footer { background-color: #f8f9fa; padding: 10px 15px; display: flex; justify-content: flex-end; gap: 10px; }
            .btn-action { text-decoration: none; color: white; padding: 5px 10px; border-radius: 5px; }
            .btn-edit { background-color: #ffc107; } /* Kuning */
            .btn-delete { background-color: #dc3545; } /* Merah */
            .btn-info { background-color: #17a2b8; } /* Biru Info */
        </style>
    </head>
    <body>
        <%
            String user = (String) session.getAttribute("user");
        %>

        <div class="area-header">
            <div class="header">
                <a href="index.jsp" style="text-decoration: none; color: inherit;">KostHunt</a>
            </div>
            <div class="header-nav">
                <% if (user != null) { %>
                    <a href="<%= request.getContextPath() %>/profile" class="nav-button">Profile</a>
                    <a href="<%= request.getContextPath() %>/logout" class="nav-button">Logout</a>
                <% } else {
                    response.sendRedirect("login.jsp");
                } %>
            </div>
        </div>

        <div class="main-container">
            <div class="dashboard-header">
                <h2>Kelola Kost Anda</h2>
                <a href="kost/addKost.jsp" class="btn-add"><i class="bi bi-plus-circle"></i> Tambah Kost</a>
            </div>

            <div class="kost-container">
                <%
                    List<Kost> kostList = (List<Kost>) request.getAttribute("kostList");
                    if (kostList != null && !kostList.isEmpty()) {
                        for (Kost kost : kostList) {
                %>
                <div class="kost-card">
                    <img class="kost-card-img" src="https://placehold.co/600x400/4A90E2/FFFFFF?text=<%= java.net.URLEncoder.encode(kost.getName(), "UTF-8") %>" alt="Foto <%= kost.getName() %>">
                    <div class="kost-card-body">
                        <h4><%= kost.getName() %></h4>
                        <p><%= kost.getAddress() %></p>
                    </div>
                    <div class="kost-card-footer">
                        <a href="<%= request.getContextPath() %>/roomList?kostId=<%= kost.getId() %>" class="btn-action btn-info"><i class="bi bi-door-open"></i> Kelola Kamar</a>
                        <a href="<%= request.getContextPath() %>/editKost?id=<%= kost.getId() %>" class="btn-action btn-edit"><i class="bi bi-pencil-square"></i> Edit</a>
                        <a href="<%= request.getContextPath() %>/deleteKost?id=<%= kost.getId() %>" class="btn-action btn-delete" onclick="return confirm('Apakah Anda yakin ingin menghapus kost ini? Tindakan ini tidak dapat dibatalkan.');"><i class="bi bi-trash3"></i> Hapus</a>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <p>Anda belum memiliki data kos. Silakan klik tombol 'Tambah Kost' untuk memulai.</p>
                <%
                    }
                %>
            </div>
        </div>
    </body>
</html>