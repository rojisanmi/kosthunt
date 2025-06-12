<%@page import="models.Kost"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Edit Data Kost</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .container { max-width: 600px; margin-top: 50px; }
    </style>
</head>
<body>
    <%
        // Mengambil objek 'kost' yang dikirim oleh EditKostServlet
        Kost kost = (Kost) request.getAttribute("kost");
        if (kost == null) {
            // Jika tidak ada data kost (misal, ID tidak ditemukan),
            // kembalikan ke dashboard untuk mencegah error.
            response.sendRedirect(request.getContextPath() + "/ownerDashboard");
            return;
        }
    %>
    <div class="container">
        <div class="card">
            <div class="card-header">
                <h3>Form Edit Kost: <%= kost.getName() %></h3>
            </div>
            <div class="card-body">
                <form action="<%= request.getContextPath() %>/editKost" method="post">
                    
                    <input type="hidden" name="id" value="<%= kost.getId() %>">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Nama Kost</label>
                        <input type="text" class="form-control" id="name" name="name" value="<%= kost.getName() %>" required>
                    </div>
                    <div class="mb-3">
                        <label for="address" class="form-label">Alamat Kost</label>
                        <textarea class="form-control" id="address" name="address" rows="3" required><%= kost.getAddress() %></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">Simpan Perubahan</button>
                    <a href="<%= request.getContextPath() %>/ownerDashboard" class="btn btn-secondary">Batal</a>
                </form>
            </div>
        </div>
    </div>
</body>
</html>