<%@page import="models.Kost"%>
<%@page import="models.User"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Ambil data yang sudah disiapkan oleh KostDetailServlet
    Kost kost = (Kost) request.getAttribute("kost");
    User owner = (User) request.getAttribute("owner");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detail Kost: <%= (kost != null) ? kost.getName() : "Tidak Ditemukan" %> - KostHunt</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
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
            font-family: 'Roboto', 'Poppins', sans-serif;
            background-color: var(--light-gray);
        }
        .price {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--primary-color);
        }
        .owner-info {
            background: #e9ecef;
            padding: 1.5rem;
            border-radius: 10px;
        }
        .contact-button {
            background-color: #25D366; /* Warna WhatsApp */
            border-color: #25D366;
            color: white;
            font-weight: 500;
        }
        .contact-button:hover {
            background-color: #1DAE53;
            border-color: #1DAE53;
        }
    </style>
</head>
<body>
    <%-- Memasukkan header.jsp yang sudah kita perbaiki --%>
    <jsp:include page="header.jsp" />

    <div class="container py-5">
        <% if (kost != null && owner != null) { %>
            <div class="mb-4">
                <h1 class="fw-bold"><%= kost.getName() %></h1>
                <p class="lead text-muted"><i class="fas fa-map-marker-alt fa-fw me-2"></i><%= kost.getAddress() %>, <%= kost.getLocation() %></p>
            </div>
            
            <div class="row g-4">
                <div class="col-lg-8">
                    <img src="<%= (kost.getImageUrl() != null && !kost.getImageUrl().isEmpty()) ? kost.getImageUrl() : "https://placehold.co/1200x800/4A90E2/FFFFFF?text=Gambar+Belum+Tersedia" %>" class="img-fluid rounded shadow-sm mb-4" alt="Foto Kost <%= kost.getName() %>">
                    
                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-4">
                            <h3 class="border-bottom pb-2 mb-3">Deskripsi Kost</h3>
                            <p style="white-space: pre-wrap;"><%= kost.getDescription() %></p>
                            
                            <h3 class="border-bottom pb-2 mt-4 mb-3">Fasilitas</h3>
                            <div class="d-flex flex-wrap">
                                <% 
                                    String facilitiesStr = kost.getFacilities();
                                    if (facilitiesStr != null && !facilitiesStr.isEmpty()) {
                                        for (String facility : facilitiesStr.split(",")) {
                                %>
                                    <span class="badge bg-primary-subtle text-primary-emphasis rounded-pill p-2 m-1 fs-6"><%= facility.trim() %></span>
                                <% 
                                        }
                                    } else {
                                %>
                                    <p>Tidak ada data fasilitas.</p>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm sticky-top" style="top: 20px;">
                        <div class="card-body p-4 text-center">
                            <span class="text-muted">Mulai dari</span>
                            <h2 class="price mb-0">Rp <%= String.format("%,.0f", kost.getPrice()) %></h2>
                            <span class="text-muted">/ bulan</span>
                            <hr>
                            <h5 class="mb-3">Informasi Pemilik</h5>
                            <p class="mb-1"><i class="fas fa-user fa-fw me-2"></i><strong><%= owner.getName() %></strong></p>
                            <p class="text-muted"><%= owner.getEmail() %></p>
                            
                            <a href="https://wa.me/<%= (owner.getPhone() != null) ? owner.getPhone().replaceAll("[^0-9]", "") : "" %>" class="btn contact-button w-100 mt-3" target="_blank">
                                <i class="fab fa-whatsapp"></i> Hubungi Pemilik
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        <% } else { %>
            <div class="alert alert-danger text-center">
                <h3>Kost Tidak Ditemukan</h3>
                <p>Maaf, detail kost yang Anda cari tidak dapat ditemukan. Mungkin sudah dihapus atau link tidak valid.</p>
                <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary">Kembali ke Beranda</a>
            </div>
        <% } %>
    </div>
</body>
</html>