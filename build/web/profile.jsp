<%@page import="models.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Profil Pengguna</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .container { max-width: 700px; margin-top: 50px; }
        .form-control:read-only { background-color: #e9ecef; }
    </style>
</head>
<body>
    <%
        User user = (User) request.getAttribute("profileData");
        String updateStatus = request.getParameter("update");
    %>
    <div class="container">
        <div class="card">
            <div class="card-header">
                <h3>Profil Pengguna</h3>
            </div>
            <div class="card-body">
                <% if ("success".equals(updateStatus)) { %>
                    <div class="alert alert-success">Profil berhasil diperbarui!</div>
                <% } else if ("error".equals(updateStatus)) { %>
                    <div class="alert alert-danger">Gagal memperbarui profil.</div>
                <% } %>
                
                <% if (user != null) { %>
                <form action="profile" method="post" name="profileForm" onsubmit="return validateForm()">
                    <input type="hidden" name="id" value="<%= user.getId() %>">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label">Nama</label>
                        <input type="text" class="form-control" id="name" name="name" value="<%= user.getName() %>" required>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <%-- PERBAIKAN: Menggunakan readonly agar lebih standar --%>
                        <input type="email" class="form-control" id="email" name="email" value="<%= user.getEmail() %>" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="role" class="form-label">Peran</label>
                        <%-- PERBAIKAN: Menggunakan readonly --%>
                        <input type="text" class="form-control" id="role" name="role" value="<%= user.getRole() %>" readonly>
                    </div>
                    
                    <hr>
                    <p class="text-muted">Isi bagian di bawah ini hanya jika Anda ingin mengubah kata sandi.</p>
                    
                    <div class="mb-3">
                        <label for="password" class="form-label">Kata Sandi Baru</label>
                        <%-- PERBAIKAN: Menggunakan placeholder, bukan value --%>
                        <input type="password" class="form-control" id="password" name="password" placeholder="********">
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Simpan Perubahan</button>
                    <% if ("Owner".equals(user.getRole())) { %>
                        <a href="ownerDashboard" class="btn btn-secondary">Kembali ke Dashboard</a>
                    <% } else { %>
                        <a href="tenantDashboard" class="btn btn-secondary">Kembali ke Dashboard</a>
                    <% } %>
                </form>
                <% } else { %>
                    <div class="alert alert-warning">Data profil tidak dapat dimuat.</div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>