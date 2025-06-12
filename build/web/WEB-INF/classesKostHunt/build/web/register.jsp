<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Register - KostHunt</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body {
            margin: 0;
            font-family: 'Roboto', 'Poppins', sans-serif;
            background-color: #f4f7f6;
        }
        .area-header {
            width: 100%;
            height: 60px;
            background-color: #4A90E2;
            display: flex;
            align-items: center;
            padding: 0 20px;
            box-sizing: border-box;
        }
        .header {
            color: white;
            font-size: 30px;
            font-weight: bold;
        }
        .container-register {
            padding-top: 50px;
            padding-bottom: 50px;
        }
        .register-card {
            background-color: #ffffff;
            padding: 2.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            width: 100%;
            max-width: 480px;
            margin-left: auto;
            margin-right: auto;
        }
        .register-card h2 {
            margin-bottom: 2rem;
            font-size: 24px;
            text-align: center;
            color: #333;
            font-weight: 500;
        }
        .footer-text a {
            color: #4A90E2;
            text-decoration: none;
            font-weight: 500;
        }
        .form-control, .form-select {
           padding-top: 0.8rem;
           padding-bottom: 0.8rem;
        }
    </style>
</head>
<body>

    <div class="area-header">
        <div class="header">
            <a href="index.jsp" style="text-decoration: none; color: inherit;">KostHunt</a>
        </div>
    </div>

    <div class="container-register">
        <div class="register-card">
            <h2>Daftarkan Akun Anda</h2>
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null && !errorMessage.isEmpty()) {
            %>
                <div class="alert alert-danger"><%= errorMessage %></div>
            <% } %>
            <form action="<%= request.getContextPath() %>/RegisterServlet" method="post" onsubmit="return validatePassword()">
                <div class="mb-3">
                    <label for="name" class="form-label">Nama</label>
                    <input type="text" class="form-control" id="name" name="name" placeholder="Masukkan nama" required />
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email" placeholder="Masukkan email" required />
                </div>

                <%-- PERUBAHAN: Kolom password disederhanakan tanpa ikon mata --%>
                <div class="mb-3">
                    <label for="password" class="form-label">Kata Sandi</label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Masukkan kata sandi" required />
                </div>
                
                <div class="mb-3">
                    <label for="confirm_password" class="form-label">Konfirmasi Kata Sandi</label>
                    <input type="password" class="form-control" id="confirm_password" name="confirm_password" placeholder="Ketik ulang kata sandi" required />
                </div>

                <div class="mb-3">
                    <label for="role" class="form-label">Daftar sebagai</label>
                    <select class="form-select" id="role" name="role" required>
                        <option value="" disabled selected>Pilih Peran</option>
                        <option value="Owner">Owner (Pemilik Kost)</option>
                        <option value="Tenant">Tenant (Pencari Kost)</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary w-100 mt-4">Register</button>
            </form>
            <div class="footer-text mt-3">
                Sudah punya akun? <a href="login.jsp">Masuk di sini</a>
            </div>
        </div>
    </div>
    
    <script>
        function validatePassword() {
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirm_password").value;
            if (password !== confirmPassword) {
                alert("Konfirmasi kata sandi tidak cocok. Silakan coba lagi.");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>