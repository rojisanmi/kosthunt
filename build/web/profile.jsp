<%@page import="models.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Profil Pengguna - KostHunt</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary-color: #2563eb;
                --primary-dark: #1d4ed8;
                --secondary-color: #64748b;
                --accent-color: #f59e0b;
                --text-color: #1e293b;
                --light-bg: #f8fafc;
                --white: #ffffff;
                --success: #22c55e;
                --warning: #f59e0b;
                --danger: #ef4444;
                --info: #3b82f6;
                --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
                --shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
                --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
            }

            body {
                margin: 0;
                font-family: 'Plus Jakarta Sans', sans-serif;
                background-color: var(--light-bg);
                color: var(--text-color);
                min-height: 100vh;
            }

            .container {
                
            }

            .profile-card {
                background: var(--white);
                border-radius: 0.75rem;
                box-shadow: var(--shadow);
                overflow: hidden;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                transform: translateY(0);
                animation: fadeIn 0.5s ease-out;
            }

            .profile-card:hover {
                transform: translateY(-5px);
                box-shadow: var(--shadow-lg);
            }

            .card-header {
                background: var(--primary-color);
                color: var(--white);
                padding: 1rem;
                border-bottom: none;
            }

            .card-header h3 {
                margin: 0;
                font-size: 1.25rem;
                font-weight: 600;
            }

            .card-body {
                padding: 1.5rem;
            }

            .form-label {
                font-weight: 500;
                color: var(--text-color);
                margin-bottom: 0.375rem;
                font-size: 0.8125rem;
            }

            .form-control {
                padding: 0.625rem 0.875rem;
                border: 2px solid #e2e8f0;
                border-radius: 0.625rem;
                font-size: 0.8125rem;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
                transform: translateY(-2px);
            }

            .form-control:read-only {
                background-color: var(--light-bg);
                cursor: not-allowed;
            }

            .btn {
                padding: 0.625rem 1.25rem;
                border-radius: 0.625rem;
                font-weight: 600;
                font-size: 0.8125rem;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                position: relative;
                overflow: hidden;
            }

            .btn::after {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                background: rgba(255, 255, 255, 0.2);
                border-radius: 50%;
                transform: translate(-50%, -50%);
                transition: width 0.6s ease, height 0.6s ease;
            }

            .btn:hover::after {
                width: 300px;
                height: 300px;
            }

            .btn-primary {
                background-color: var(--primary-color);
                border: none;
            }

            .btn-primary:hover {
                background-color: var(--primary-dark);
                transform: translateY(-2px);
            }

            .btn-secondary {
                background-color: var(--secondary-color);
                border: none;
                color: var(--white);
            }

            .btn-secondary:hover {
                background-color: #475569;
                transform: translateY(-2px);
                color: var(--white);
            }

            .alert {
                border-radius: 0.625rem;
                padding: 0.75rem;
                margin-bottom: 1.25rem;
                border: none;
                display: flex;
                align-items: center;
                gap: 0.625rem;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                animation: slideIn 0.3s ease-out;
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            .password-section {
                margin-top: 1.5rem;
                padding-top: 1.25rem;
                border-top: 1px solid #e2e8f0;
            }

            .password-section p {
                color: var(--secondary-color);
                font-size: 0.8125rem;
                margin-bottom: 1.25rem;
            }

            .button-group {
                display: flex;
                gap: 0.75rem;
                margin-top: 1.5rem;
            }

            @media (max-width: 768px) {
                .container {
                    margin: 1rem auto;
                }

                .card-body {
                    padding: 1.25rem;
                }
            }
        </style>
    </head>
    <body>
        <%
            User user = (User) request.getAttribute("profileData");
            String updateStatus = request.getParameter("update");
        %>
        <jsp:include page="header.jsp" />
        
        <div class="container" style="max-width: 600px;
                margin: 1.5rem auto;
                padding: 0 1rem;">
            <div class="profile-card">
                <div class="card-header">
                    <h3><i class="fas fa-user-circle me-2"></i>Profil Pengguna</h3>
                </div>
                <div class="card-body">
                    <% if ("success".equals(updateStatus)) { %>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        Profil berhasil diperbarui!
                    </div>
                    <% } else if ("error".equals(updateStatus)) { %>
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        Gagal memperbarui profil.
                    </div>
                    <% } %>

                    <% if (user != null) { %>
                    <form action="profile" method="post" name="profileForm" onsubmit="return validateForm()">
                        <input type="hidden" name="id" value="<%= user.getId() %>">

                        <div class="mb-4">
                            <label for="name" class="form-label">Nama</label>
                            <input type="text" class="form-control" id="name" name="name" value="<%= user.getName() %>" required>
                        </div>
                        <div class="mb-4">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" value="<%= user.getEmail() %>" readonly>
                        </div>
                        <div class="mb-4">
                            <label for="phone" class="form-label">Nomor Telepon</label>
                            <input type="tel" class="form-control" id="phone" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "Belum terdaftar" %>" placeholder="Masukkan nomor telepon Anda">
                            <small class="text-muted">Nomor telepon Anda akan digunakan untuk keperluan komunikasi</small>
                        </div>
                        <div class="mb-4">
                            <label for="role" class="form-label">Peran</label>
                            <input type="text" class="form-control" id="role" name="role" value="<%= user.getRole() %>" readonly>
                        </div>

                        <div class="password-section">
                            <p><i class="fas fa-info-circle me-2"></i>Isi bagian di bawah ini hanya jika Anda ingin mengubah kata sandi.</p>

                            <div class="mb-4">
                                <label for="password" class="form-label">Kata Sandi Baru</label>
                                <input type="password" class="form-control" id="password" name="password" placeholder="********">
                            </div>
                        </div>

                        <div class="button-group">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>
                                Simpan Perubahan
                            </button>
                            <% if ("Owner".equals(user.getRole())) { %>
                            <a href="ownerDashboard" class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i>
                                Kembali ke Dashboard
                            </a>
                            <% } %>
                        </div>
                    </form>
                    <% } else { %>
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        Data profil tidak dapat dimuat.
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function validateForm() {
                const phone = document.getElementById('phone').value;
                const phoneRegex = /^08[0-9]{8,11}$/;
                
                if (phone && !phoneRegex.test(phone)) {
                    alert('Nomor telepon harus dimulai dengan 08 dan diikuti 8-11 digit angka');
                    return false;
                }
                
                return true;
            }

            // Add smooth scrolling
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    document.querySelector(this.getAttribute('href')).scrollIntoView({
                        behavior: 'smooth'
                    });
                });
            });

            // Intersection Observer for animations
            const observerOptions = {
                root: null,
                rootMargin: '0px',
                threshold: 0.1
            };

            const observer = new IntersectionObserver((entries, observer) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('visible');
                        observer.unobserve(entry.target);
                    }
                });
            }, observerOptions);

            document.querySelectorAll('.animate-fade-in').forEach((element) => {
                observer.observe(element);
            });
        </script>
    </body>
</html>