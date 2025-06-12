<%@page import="models.Kost"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tenant Dashboard - KostHunt</title>
        <style>
            body { margin: 0; padding: 0; font-family: 'Roboto', poppins; background-color: #f4f7f6; }
            .area-header { width: 100%; height: 60px; background-color: #4A90E2; overflow: hidden; position: relative; display: flex; align-items: center; padding: 0 20px; box-sizing: border-box; }
            .header { color: white; font-size: 30px; font-weight: bold; }
            .header-nav { margin-left: auto; display: flex; gap: 10px; }
            .nav-button { background-color: white; color: #4A90E2; padding: 8px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; font-weight: bold; text-decoration: none; display: inline-block; text-align: center; }
            .nav-button:hover { background-color: #e0e0e0; }
            .main-container { padding: 20px; }
            .main-container h2 { font-size: 28px; color: #333; }
            .main-container h3 { font-size: 22px; color: #333; margin-top: 30px; border-bottom: 2px solid #ddd; padding-bottom: 10px; }
            .area-kos-container { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; margin-top: 20px; }
            .area-kos { background-color: white; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); cursor: pointer; transition: transform 0.3s ease, box-shadow 0.3s ease; text-decoration: none; color: inherit; }
            .area-kos:hover { transform: translateY(-5px); box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15); }
            .area-kos img { width: 100%; height: 160px; object-fit: cover; }
            .area-kos-info { padding: 15px; }
            .area-kos-info h4 { margin: 0 0 5px 0; font-size: 18px; color: #333; }
            .area-kos-info p { margin: 0; font-size: 14px; color: #777; }
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
                <% } else { %>
                    <a href="login.jsp" class="nav-button">Masuk</a>
                <% } %>
            </div>
        </div>

        <div class="main-container">
            <h2>Selamat Datang, Tenant!</h2>
            <h3>Temukan Kos Impian Anda</h3>

            <div class="area-kos-container">
                <%
                    List<Kost> kostList = (List<Kost>) request.getAttribute("kostList");
                    if (kostList != null && !kostList.isEmpty()) {
                        for (Kost kost : kostList) {
                %>
                <a href="kostDetail.jsp?id=<%= kost.getId() %>" class="area-kos">
                    <img src="https://placehold.co/600x400/4A90E2/FFFFFF?text=<%= java.net.URLEncoder.encode(kost.getName(), "UTF-8") %>" alt="Foto <%= kost.getName() %>">
                    <div class="area-kos-info">
                        <h4><%= kost.getName() %></h4>
                        <p><%= kost.getAddress() %></p>
                    </div>
                </a>
                <%
                        }
                    } else {
                %>
                <p>Saat ini belum ada data kos yang tersedia.</p>
                <%
                    }
                %>
            </div>
        </div>
    </body>
</html>