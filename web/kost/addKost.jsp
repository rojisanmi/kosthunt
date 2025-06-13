<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tambah Kost Baru - KostHunt</title>
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

        .card {
            background: var(--white);
            border: none;
            border-radius: 1rem;
            box-shadow: var(--shadow);
            overflow: hidden;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            animation: fadeIn 0.5s ease-out;
        }

        .card:hover {
            box-shadow: var(--shadow-lg);
        }

        .card-header {
            background: var(--primary-color);
            color: var(--white);
            padding: 1.5rem;
            border-bottom: none;
        }

        .card-header h3 {
            margin: 0;
            font-size: 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .card-body {
            padding: 2rem;
        }

        .form-label {
            font-weight: 500;
            color: var(--text-color);
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }

        .form-control, .form-select {
            padding: 0.75rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 0.75rem;
            font-size: 0.875rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
            transform: translateY(-2px);
        }

        .input-group-text {
            background-color: var(--light-bg);
            border: 2px solid #e2e8f0;
            border-right: none;
            color: var(--secondary-color);
            font-size: 0.875rem;
        }

        .input-group .form-control {
            border-left: none;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 0.75rem;
            font-weight: 600;
            font-size: 0.875rem;
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

        .facilities-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }

        .facility-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
        }

        .facility-item:hover {
            background-color: var(--light-bg);
        }

        .form-check-input {
            width: 1.25rem;
            height: 1.25rem;
            margin-top: 0;
            border: 2px solid #e2e8f0;
            transition: all 0.3s ease;
        }

        .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .form-check-label {
            font-size: 0.875rem;
            color: var(--text-color);
            cursor: pointer;
        }

        .alert {
            border-radius: 0.75rem;
            padding: 1rem;
            margin-bottom: 1.5rem;
            border: none;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            animation: slideIn 0.3s ease-out;
        }

        .alert i {
            font-size: 1.25rem;
        }

        .alert-danger {
            background-color: #fee2e2;
            color: #991b1b;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
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

        @media (max-width: 768px) {
            .container {
                margin: 1rem auto;
            }

            .card-body {
                padding: 1.5rem;
            }

            .facilities-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%@ page session="true" %>
    <%
        String user = (String) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("../login.jsp");
            return;
        }
    %>
    <jsp:include page="../header.jsp" />

    <div class="container" style="max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;">
        <div class="card">
            <div class="card-header">
                <h3><i class="fas fa-plus-circle"></i> Tambah Kost Baru</h3>
            </div>
            <div class="card-body">
                <%
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage != null && !errorMessage.isEmpty()) {
                %>
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= errorMessage %>
                    </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/AddKostServlet" method="post">
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <label for="name" class="form-label">Nama Kost</label>
                            <input type="text" class="form-control" id="name" name="name" required>
                        </div>
                        <div class="col-md-6 mb-4">
                            <label for="type" class="form-label">Tipe Kost</label>
                            <select class="form-select" id="type" name="type" required>
                                <option value="">Pilih Tipe</option>
                                <option value="Putra">Putra</option>
                                <option value="Putri">Putri</option>
                                <option value="Campur">Campur</option>
                            </select>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="address" class="form-label">Alamat Lengkap</label>
                        <textarea class="form-control" id="address" name="address" rows="2" required></textarea>
                    </div>

                    <div class="mb-4">
                        <label for="location" class="form-label">Lokasi (Area)</label>
                        <input type="text" class="form-control" id="location" name="location" required>
                    </div>

                    <div class="mb-4">
                        <label for="description" class="form-label">Deskripsi</label>
                        <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <label for="price" class="form-label">Harga per Bulan</label>
                            <div class="input-group">
                                <span class="input-group-text">Rp</span>
                                <input type="number" class="form-control" id="price" name="price" required min="0">
                            </div>
                        </div>
                        <div class="col-md-6 mb-4">
                            <label for="image_url" class="form-label">URL Gambar</label>
                            <input type="url" class="form-control" id="image_url" name="image_url" placeholder="https://example.com/image.jpg">
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Fasilitas</label>
                        <div class="facilities-container">
                            <div class="facility-item">
                                <input type="checkbox" class="form-check-input" name="facilities" value="Kamar Mandi Dalam" id="facility1">
                                <label class="form-check-label" for="facility1">Kamar Mandi Dalam</label>
                            </div>
                            <div class="facility-item">
                                <input type="checkbox" class="form-check-input" name="facilities" value="AC" id="facility2">
                                <label class="form-check-label" for="facility2">AC</label>
                            </div>
                            <div class="facility-item">
                                <input type="checkbox" class="form-check-input" name="facilities" value="WiFi" id="facility3">
                                <label class="form-check-label" for="facility3">WiFi</label>
                            </div>
                            <div class="facility-item">
                                <input type="checkbox" class="form-check-input" name="facilities" value="Dapur" id="facility4">
                                <label class="form-check-label" for="facility4">Dapur</label>
                            </div>
                            <div class="facility-item">
                                <input type="checkbox" class="form-check-input" name="facilities" value="Parkir" id="facility5">
                                <label class="form-check-label" for="facility5">Parkir</label>
                            </div>
                            <div class="facility-item">
                                <input type="checkbox" class="form-check-input" name="facilities" value="CCTV" id="facility6">
                                <label class="form-check-label" for="facility6">CCTV</label>
                            </div>
                        </div>
                    </div>

                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>
                            Simpan Kost
                        </button>
                        <a href="<%= request.getContextPath() %>/ownerDashboard" class="btn btn-secondary">
                            <i class="fas fa-times me-2"></i>
                            Batal
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Format price input
        document.getElementById('price').addEventListener('input', function(e) {
            let value = e.target.value;
            if (value < 0) e.target.value = 0;
        });

        // Handle facilities checkboxes
        document.querySelectorAll('input[name="facilities"]').forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                let facilities = Array.from(document.querySelectorAll('input[name="facilities"]:checked'))
                    .map(cb => cb.value);
                console.log('Selected facilities:', facilities);
            });
        });

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