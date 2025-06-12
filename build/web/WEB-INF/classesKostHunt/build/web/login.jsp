<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Login</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                margin: 0;
                font-family: 'Roboto', poppins;
                background-color: #ffffff;
            }
            .area-header {
                width: 100%;
                height: 60px;
                background-color: #4A90E2;            
                overflow: hidden;
                position: relative;
            }
            .header {
                color: white;
                text-align: left;
                font-size: 40px;
                padding: 5px 10px;
                font-weight: bold;
            }
            .container {
                display: flex;
                justify-content: center;
                align-items: center;
                height: calc(100vh - 80px);
                background-color: #fff;
            }
            .login-card {
                background-color: #ffffff;
                padding: 40px;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                width: 100%;
                max-width: 400px;
            }
            .login-card h2 {
                margin-bottom: 24px;
                font-size: 22px;
                text-align: center;
            }
            .form-group {
                margin-bottom: 20px;
            }
            .form-group label {
                display: block;
                font-weight: 500;
                margin-bottom: 8px;
            }
            .form-group input {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
            }
            .btn {
                background-color: #3498db;
                color: white;
                border: none;
                padding: 12px;
                width: 100%;
                border-radius: 8px;
                font-size: 16px;
                cursor: pointer;
            }
            .btn:hover {
                background-color: #2980b9;
            }
            .footer-text {
                margin-top: 16px;
                text-align: center;
                font-size: 14px;
            }
            .footer-text a {
                color: #3498db;
                text-decoration: none;
            }
            .footer-text a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>

        <div class="area-header">
            <div class="header">
                <a href="index.jsp" style="text-decoration: none; color: inherit;">KostHunt</a>
            </div>
        </div>

        <div class="container">
            <div class="login-card">
                <h2>Masuk ke Akun Anda</h2>

                <div class="card-body">
                    <%
                        String logoutStatus = request.getParameter("logout");
                        if ("success".equals(logoutStatus)) {
                    %>
                        <div class="alert alert-success" id="logout-alert">Anda telah berhasil logout.</div>
                    <%
                        }
                        String errorMessage = (String) request.getAttribute("errorMessage");
                        if (errorMessage != null && !errorMessage.isEmpty()) {
                    %>
                        <div class="alert alert-danger"><%= errorMessage %></div>
                    <%
                        }
                    %>

                    <form method="POST" action="<%= request.getContextPath() %>/LoginServlet">
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="text" id="email" name="email" placeholder="Masukkan email" required />
                        </div>
                        <div class="form-group">
                            <label for="password">Kata Sandi</label>
                            <input type="password" id="password" name="password" placeholder="Masukkan kata sandi" required />
                        </div>
                        
                        <button type="submit" class="btn">Masuk</button>
                        <div class="footer-text">
                            Belum punya akun? <a href="register.jsp">Daftar sekarang</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <script>
            const logoutAlert = document.getElementById('logout-alert');

            if (logoutAlert) {
                setTimeout(() => {
                    logoutAlert.style.display = 'none'; // Sembunyikan elemen
                }, 1500); 
            }
        </script>
    </body>
</html>