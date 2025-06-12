<%@page import="models.Room"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Data Kamar</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .container { max-width: 600px; margin-top: 50px; }
    </style>
</head>
<body>
    <%
        Room room = (Room) request.getAttribute("room");
    %>
    <div class="container">
        <% if (room != null) { %>
        <div class="card">
            <div class="card-header">
                <h3>Form Edit Kamar Nomor: <%= room.getNumber() %></h3>
            </div>
            <div class="card-body">
                <form action="<%= request.getContextPath() %>/editRoom" method="post">
                    
                    <%-- Input tersembunyi untuk membawa ID --%>
                    <input type="hidden" name="roomId" value="<%= room.getId() %>">
                    <input type="hidden" name="kostId" value="<%= room.getKostId() %>">
                    
                    <%-- Menggunakan class Bootstrap untuk styling form --%>
                    <div class="mb-3">
                        <label for="roomNumber" class="form-label">Nomor Kamar</label>
                        <input type="text" class="form-control" id="roomNumber" name="roomNumber" value="<%= room.getNumber() %>" required>
                    </div>
                    <div class="mb-3">
                        <label for="roomType" class="form-label">Tipe Kamar</label>
                        <select class="form-select" id="roomType" name="roomType" required>
                            <option value="Single" <%= "Single".equals(room.getType()) ? "selected" : "" %>>Single</option>
                            <option value="Double" <%= "Double".equals(room.getType()) ? "selected" : "" %>>Double</option>
                            <option value="VIP (AC + KM Dalam)" <%= "VIP (AC + KM Dalam)".equals(room.getType()) ? "selected" : "" %>>VIP (AC + KM Dalam)</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Simpan Perubahan</button>
                    <a href="<%= request.getContextPath() %>/roomList?kostId=<%= room.getKostId() %>" class="btn btn-secondary">Batal</a>
                </form>
            </div>
        </div>
        <% } else { %>
            <div class="alert alert-danger" role="alert">
                Data kamar tidak ditemukan. Silakan kembali ke <a href="<%= request.getContextPath() %>/ownerDashboard" class="alert-link">dashboard</a>.
            </div>
        <% } %>
    </div>
</body>
</html>