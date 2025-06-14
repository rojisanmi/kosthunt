<%@page import="models.Kost"%>
<%@page import="java.util.List"%>
<%@page import="java.net.URLEncoder"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<Kost> kostList = (List<Kost>) request.getAttribute("kostList");
    int totalPages = (request.getAttribute("totalPages") != null) ? (Integer) request.getAttribute("totalPages") : 0;
    int currentPage = (request.getAttribute("currentPage") != null) ? (Integer) request.getAttribute("currentPage") : 1;
    int totalItems = (request.getAttribute("totalItems") != null) ? (Integer) request.getAttribute("totalItems") : 0;

    String query = (String) request.getAttribute("query");
    String location = (String) request.getAttribute("location");
    String priceRange = (String) request.getAttribute("priceRange");
    String type = (String) request.getAttribute("type");
    String sortBy = (String) request.getAttribute("sortBy");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Hasil Pencarian - KostHunt</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #2563eb;
            --primary-dark: #1d4ed8;
            --text-color: #1e293b;
            --text-muted: #64748b;
            --light-bg: #f8fafc;
            --white: #ffffff;
            --border-color: #e2e8f0;
            --shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
        }
        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--light-bg);
            color: var(--text-color);
        }
        .search-filters {
            background: var(--white);
            padding: 1.5rem;
            border-radius: 0.75rem;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(37, 99, 235, 0.25);
        }
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            font-weight: 500;
        }
        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
        }
        .kost-card {
            background: var(--white);
            border: none;
            border-radius: 0.75rem;
            box-shadow: var(--shadow);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .kost-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }
        .kost-card .card-img-top {
            height: 200px;
            object-fit: cover;
        }
        .kost-card .card-body {
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }
        .kost-card .card-title { font-weight: 600; color: var(--text-color); }
        .kost-card .card-text { color: var(--text-muted); }
        .kost-card .kost-price { font-size: 1.25rem; font-weight: 600; color: var(--primary-color); }
        .kost-card .btn-outline-primary { border-color: var(--primary-color); color: var(--primary-color); font-weight: 500; }
        .kost-card .btn-outline-primary:hover { background-color: var(--primary-color); color: var(--white); }
        .no-results { background: var(--white); padding: 3rem; border-radius: 0.75rem; box-shadow: var(--shadow); }
        .no-results i { color: var(--primary-color); opacity: 0.5; }
    </style>
<body>
    <jsp:include page="header.jsp" />

    <div class="container py-5">
        <h2 class="mb-4 fw-bold">Hasil Pencarian</h2>

        <div class="search-filters">
            <form action="search" method="GET" class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label for="query" class="form-label">Cari Nama/Alamat</label>
                    <input type="text" class="form-control" name="query" placeholder="Contoh: Kost Mawar" value="<%= (query != null) ? query : "" %>">
                </div>
                <div class="col-md-3">
                    <label for="location" class="form-label">Lokasi</label>
                    <input type="text" class="form-control" name="location" placeholder="Contoh: Depok" value="<%= (location != null) ? location : "" %>">
                </div>
                <div class="col-md-3">
                    <label for="price_range" class="form-label">Rentang Harga</label>
                    <select class="form-select" name="price_range">
                        <option value="">Semua Harga</option>
                        <option value="0-1000000" <%= "0-1000000".equals(priceRange) ? "selected" : "" %>>Rp 0 - 1 Juta</option>
                        <option value="1000000-2000000" <%= "1000000-2000000".equals(priceRange) ? "selected" : "" %>>Rp 1 - 2 Juta</option>
                        <option value="2000000-3000000" <%= "2000000-3000000".equals(priceRange) ? "selected" : "" %>>Rp 2 - 3 Juta</option>
                        <option value="3000000-999999999" <%= "3000000-999999999".equals(priceRange) ? "selected" : "" %>>Rp 3 Juta+</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">&nbsp;</label>
                    <button type="submit" class="btn btn-primary w-100">Cari</button>
                </div>
            </form>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <span class="text-muted">Menampilkan <%= (kostList != null ? kostList.size() : 0) %> dari <%= totalItems %> hasil</span>
            <form action="search" method="GET" style="width: 250px;">
                <input type="hidden" name="query" value="<%= (query != null) ? query : "" %>">
                <input type="hidden" name="location" value="<%= (location != null) ? location : "" %>">
                <input type="hidden" name="price_range" value="<%= (priceRange != null) ? priceRange : "" %>">
                
                <select class="form-select" name="sort_by" onchange="this.form.submit()">
                    <option value="">Urutkan...</option>
                    <option value="price_asc" <%= "price_asc".equals(sortBy) ? "selected" : "" %>>Harga Terendah</option>
                    <option value="price_desc" <%= "price_desc".equals(sortBy) ? "selected" : "" %>>Harga Tertinggi</option>
                </select>
            </form>
        </div>

        <div class="row">
            <% if (kostList == null || kostList.isEmpty()) { %>
                <div class="col-12 text-center p-5 bg-white rounded shadow-sm">
                    <h4>Tidak ada hasil ditemukan</h4>
                    <p>Coba ubah kata kunci pencarian Anda.</p>
                </div>
            <% } else { for (Kost kost : kostList) { %>
                <div class="col-lg-4 col-md-6 mb-4">
                     <div class="card h-100">
                        <img src="<%= (kost.getImageUrl() != null && !kost.getImageUrl().isEmpty()) ? kost.getImageUrl() : "https://placehold.co/600x400/e2e8f0/64748b?text=No+Image" %>" class="card-img-top" alt="<%= kost.getName() %>" style="height: 200px; object-fit: cover;">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title"><%= kost.getName() %></h5>
                            <p class="card-text text-muted small mb-3"><i class="fas fa-map-marker-alt fa-fw"></i> <%= kost.getAddress() %></p>
                            <div class="d-flex align-items-center mb-3">
                                <i class="fas fa-star text-warning me-1"></i>
                                <span class="text-muted small">
                                    <%= String.format("%.1f", kost.getAvgRating()) %>
                                </span>
                            </div>
                            <div class="mt-auto">
                                <p class="card-text fw-bold fs-5 text-primary">Rp <%= String.format("%,.0f", kost.getPrice()) %> / bulan</p>
                                <a href="kostDetail?id=<%= kost.getId() %>" class="btn btn-outline-primary w-100">Lihat Detail</a>
                            </div>
                        </div>
                    </div>
                </div>
            <% }} %>
        </div>

        <% if (totalPages > 1) { %>
            <nav class="d-flex justify-content-center mt-4">
                <ul class="pagination">
                    <% for (int i = 1; i <= totalPages; i++) { 
                        String params = String.format("query=%s&location=%s&price_range=%s&sort_by=%s", 
                            URLEncoder.encode(query != null ? query : "", "UTF-8"),
                            URLEncoder.encode(location != null ? location : "", "UTF-8"),
                            URLEncoder.encode(priceRange != null ? priceRange : "", "UTF-8"),
                            URLEncoder.encode(sortBy != null ? sortBy : "", "UTF-8")
                        );
                    %>
                        <li class="page-item <%= (i == currentPage) ? "active" : "" %>"><a class="page-link" href="search?page=<%= i %>&<%= params %>"><%= i %></a></li>
                    <% } %>
                </ul>
            </nav>
        <% } %>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>