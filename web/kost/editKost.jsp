<%@page import="models.Kost"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Kost - KostHunt</title>
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

        .image-preview {
            width: 100%;
            height: 200px;
            border-radius: 0.75rem;
            object-fit: cover;
            margin-bottom: 1rem;
            border: 2px dashed #e2e8f0;
            transition: all 0.3s ease;
        }

        .image-preview:hover {
            border-color: var(--primary-color);
        }

        .image-upload-container {
            position: relative;
            margin-bottom: 1.5rem;
        }

        .image-upload-label {
            display: block;
            width: 100%;
            padding: 1rem;
            text-align: center;
            background: var(--light-bg);
            border: 2px dashed #e2e8f0;
            border-radius: 0.75rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .image-upload-label:hover {
            border-color: var(--primary-color);
            background: #f1f5f9;
        }

        .image-upload-input {
            display: none;
        }

        .image-upload-icon {
            font-size: 2rem;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .image-upload-text {
            color: var(--secondary-color);
            font-size: 0.875rem;
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
        
        Kost kost = (Kost) request.getAttribute("kost");
        if (kost == null) {
            response.sendRedirect(request.getContextPath() + "/ownerDashboard");
            return;
        }
    %>
    <jsp:include page="../header.jsp" />

    <div class="container" style="max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;">
        <div class="card">
            <div class="card-header">
                <h3><i class="fas fa-edit"></i> Edit Kost: <%= kost.getName() %></h3>
                <p class="mb-0 mt-2" style="opacity: 0.9;"><i class="fas fa-map-marker-alt"></i> <%= kost.getLocation() != null ? kost.getLocation() : "Lokasi belum diatur" %></p>
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

                <form action="<%= request.getContextPath() %>/editKost" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="id" value="<%= kost.getId() %>">
                    
                    <div class="mb-4">
                        <label class="form-label">Foto Kost</label>
                        <div class="image-upload-container">
                            <% if (kost.getImageUrl() != null && !kost.getImageUrl().isEmpty()) { %>
                                <img src="<%= request.getContextPath() %>/<%= kost.getImageUrl() %>" 
                                     alt="<%= kost.getName() %>" 
                                     class="image-preview" 
                                     id="imagePreview">
                            <% } else { %>
                                <img src="https://placehold.co/600x400?text=<%= java.net.URLEncoder.encode(kost.getName(), "UTF-8") %>" 
                                     alt="<%= kost.getName() %>" 
                                     class="image-preview" 
                                     id="imagePreview">
                            <% } %>
                            <label for="image" class="image-upload-label">
                                <i class="fas fa-cloud-upload-alt image-upload-icon"></i>
                                <div class="image-upload-text">
                                    Klik untuk mengubah foto kost<br>
                                    <small>Format: JPG, PNG, atau GIF (Max. 5MB)</small>
                                </div>
                            </label>
                            <input type="file" 
                                   class="image-upload-input" 
                                   id="image" 
                                   name="image" 
                                   accept="image/*"
                                   onchange="previewImage(this)">
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label for="name" class="form-label">Nama Kost</label>
                        <input type="text" class="form-control" id="name" name="name" 
                               value="<%= kost.getName() %>" required>
                    </div>
                    
                    <div class="mb-4">
                        <label for="location" class="form-label">Lokasi Kost</label>
                        <input type="text" class="form-control" id="location" name="location" 
                               value="<%= kost.getLocation() != null ? kost.getLocation() : "" %>" 
                               placeholder="Contoh: Jakarta">
                        <div class="form-text">Masukkan nama kota saja (Contoh: Jakarta, Bandung, Surabaya)</div>
                    </div>
                    
                    <div class="mb-4">
                        <label for="address" class="form-label">Alamat Kost</label>
                        <textarea class="form-control" id="address" name="address" 
                                  rows="3" required><%= kost.getAddress() %></textarea>
                    </div>
                    
                    <div class="mb-4">
                        <label for="description" class="form-label">Deskripsi Kost</label>
                        <textarea class="form-control" id="description" name="description" 
                                  rows="4" required><%= kost.getDescription() != null ? kost.getDescription() : "" %></textarea>
                    </div>
                    
                    <div class="mb-4">
                        <label for="type" class="form-label">Tipe Kost</label>
                        <select class="form-select" id="type" name="type" required>
                            <option value="">Pilih tipe kost</option>
                            <option value="Putra" <%= "Putra".equals(kost.getType()) ? "selected" : "" %>>Putra</option>
                            <option value="Putri" <%= "Putri".equals(kost.getType()) ? "selected" : "" %>>Putri</option>
                            <option value="Campur" <%= "Campur".equals(kost.getType()) ? "selected" : "" %>>Campur</option>
                        </select>
                    </div>
                    
                    <div class="mb-4">
                        <label for="price" class="form-label">Harga per Bulan</label>
                        <div class="input-group">
                            <span class="input-group-text">Rp</span>
                            <input type="number" class="form-control" id="price" name="price" 
                                   value="<%= kost.getPrice() %>" required min="0" step="1000">
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label">Fasilitas</label>
                        <div class="row g-3">
                            <div class="col-md-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="facilities" value="Kamar Mandi Dalam" 
                                           id="facility1" <%= kost.getFacilities() != null && kost.getFacilities().contains("Kamar Mandi Dalam") ? "checked" : "" %>>
                                    <label class="form-check-label" for="facility1">Kamar Mandi Dalam</label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="facilities" value="AC" 
                                           id="facility2" <%= kost.getFacilities() != null && kost.getFacilities().contains("AC") ? "checked" : "" %>>
                                    <label class="form-check-label" for="facility2">AC</label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="facilities" value="WiFi" 
                                           id="facility3" <%= kost.getFacilities() != null && kost.getFacilities().contains("WiFi") ? "checked" : "" %>>
                                    <label class="form-check-label" for="facility3">WiFi</label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="facilities" value="Kasur" 
                                           id="facility4" <%= kost.getFacilities() != null && kost.getFacilities().contains("Kasur") ? "checked" : "" %>>
                                    <label class="form-check-label" for="facility4">Kasur</label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="facilities" value="Lemari" 
                                           id="facility5" <%= kost.getFacilities() != null && kost.getFacilities().contains("Lemari") ? "checked" : "" %>>
                                    <label class="form-check-label" for="facility5">Lemari</label>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="facilities" value="Meja" 
                                           id="facility6" <%= kost.getFacilities() != null && kost.getFacilities().contains("Meja") ? "checked" : "" %>>
                                    <label class="form-check-label" for="facility6">Meja</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>
                            Simpan Perubahan
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
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                }
                reader.readAsDataURL(input.files[0]);
            }
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