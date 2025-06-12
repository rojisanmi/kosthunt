<%@page import="models.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Profil Pengguna</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4A90E2;
            --secondary-color: #357ab7;
            --text-color: #333;
            --light-gray: #f8f9fa;
        }

        body { 
            background-color: var(--light-gray);
            font-family: 'Poppins', sans-serif;
        }
        .form-control:read-only { background-color: #e9ecef; }
        
        .navbar {
            background-color: var(--primary-color);
            padding: 1rem 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            font-size: 1.8rem;
            font-weight: 700;
            color: white !important;
        }

        .nav-link {
            color: white !important;
            font-weight: 500;
            margin: 0 0.5rem;
            transition: all 0.3s ease;
        }

        .nav-link:hover {
            opacity: 0.8;
        }

        .dropdown-menu {
            border: none;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .dropdown-item {
            padding: 0.5rem 1rem;
            color: var(--text-color);
        }

        .dropdown-item:hover {
            background-color: var(--light-gray);
        }

        .dropdown-item i {
            margin-right: 0.5rem;
            color: var(--primary-color);
        }
    </style>
</head>
<body>
    <%@ page session="true" %>
    <jsp:include page="header.jsp" />

    <%
        User user = (User) request.getAttribute("profileData");
        String updateStatus = request.getParameter("update");
    %>
    <div class="container" style="max-width: 700px; margin-top: 50px;">
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>