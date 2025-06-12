<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tambah Kost Baru - KostHunt</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4A90E2;
            --secondary-color: #357ab7;
            --text-color: #333;
            --light-gray: #f8f9fa;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--light-gray);
            color: var(--text-color);
        }

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

        .container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
        }

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .card-header {
            background-color: white;
            border-bottom: 1px solid #eee;
            padding: 1.5rem;
        }

        .card-header h3 {
            margin: 0;
            color: var(--text-color);
            font-size: 1.5rem;
        }

        .card-body {
            padding: 2rem;
        }

        .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            padding: 0.75rem;
            border-radius: 8px;
            border: 1px solid #ddd;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(74, 144, 226, 0.25);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
        }

        .btn-primary:hover {
            background-color: var(--secondary-color);
        }

        .btn-secondary {
            background-color: #6c757d;
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
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
        }

        .preview-image {
            max-width: 200px;
            max-height: 200px;
            margin-top: 1rem;
            border-radius: 5px;
            display: none;
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
                margin: 1rem;
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

    <div class="container">
        <div class="card">
            <div class="card-header">
                <h3><i class="fas fa-plus-circle"></i> Tambah Kost Baru</h3>
            </div>
            <div class="card-body">
                <%
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage != null && !errorMessage.isEmpty()) {
                %>
                    <div class="alert alert-danger" role="alert">
                        <%= errorMessage %>
                    </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/AddKostServlet" method="post">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="name" class="form-label">Nama Kost</label>
                            <input type="text" class="form-control" id="name" name="name" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="type" class="form-label">Tipe Kost</label>
                            <select class="form-select" id="type" name="type" required>
                                <option value="">Pilih Tipe</option>
                                <option value="Putra">Putra</option>
                                <option value="Putri">Putri</option>
                                <option value="Campur">Campur</option>
                            </select>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="address" class="form-label">Alamat Lengkap</label>
                        <textarea class="form-control" id="address" name="address" rows="2" required></textarea>
                    </div>

                    <div class="mb-3">
                        <label for="location" class="form-label">Lokasi (Area)</label>
                        <input type="text" class="form-control" id="location" name="location" required>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Deskripsi</label>
                        <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="price" class="form-label">Harga per Bulan</label>
                            <div class="input-group">
                                <span class="input-group-text">Rp</span>
                                <input type="number" class="form-control" id="price" name="price" required min="0">
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="image_url" class="form-label">URL Gambar</label>
                            <input type="url" class="form-control" id="image_url" name="image_url" placeholder="https://example.com/image.jpg">
                        </div>
                    </div>

                    <div class="mb-3">
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
                        <button type="submit" class="btn btn-primary">Simpan Kost</button>
                        <a href="<%= request.getContextPath() %>/ownerDashboard" class="btn btn-secondary">Batal</a>
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
                    .map(cb => cb.value)
                    .join(',');
                // You can store this in a hidden input if needed
            });
        });
    </script>
</body>
</html>