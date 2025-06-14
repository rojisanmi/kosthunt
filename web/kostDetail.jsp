<%@page import="models.Room"%>
<%@page import="models.Kost"%>
<%@page import="models.User"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Ambil data yang sudah disiapkan oleh KostDetailServlet
    Kost kost = (Kost) request.getAttribute("kost");
    User owner = (User) request.getAttribute("owner");
    List<Room> roomList = (List<Room>) request.getAttribute("roomList");
    List<Map<String, Object>> tenantList = (List<Map<String, Object>>) request.getAttribute("tenantList");
    String userRole = (String) session.getAttribute("role");
    // Formatter untuk tanggal (jika diperlukan)
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detail Kost: <%= (kost != null) ? kost.getName() : "Tidak Ditemukan" %> - KostHunt</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #64748b;
            --text-color: #1e293b;
            --light-bg: #f8fafc;
        }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--light-bg);
            color: var(--text-color);
        }
        .price {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        .owner-info-card {
            position: sticky;
            top: 20px; /* Jarak dari atas saat sticky */
        }
        .card {
            border: none;
            border-radius: 0.75rem;
            box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
        }
        .badge-facility {
            font-size: 0.9em;
            font-weight: 500;
        }
        .btn-whatsapp {
            background-color: #25D366;
            border-color: #25D366;
            color: white;
        }
        .btn-whatsapp:hover {
            background-color: #1DAE53;
            border-color: #1DAE53;
            color: white;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <main class="container py-5">
        <% if (kost != null && owner != null) { %>
            <div class="mb-4">
                <div class="d-flex align-items-baseline">
                    <h1 class="fw-bold mb-0"><%= kost.getName() %></h1>
                    <%-- Kode ini menampilkan ikon bintang kuning dan nilai ratingnya --%>
                    <span class="ms-3" style="color: #f59e0b; font-size: 1.2rem;">
                        <i class="fas fa-star"></i>
                        <span class="fw-bold"><%= String.format("%.1f", kost.getAvgRating()) %></span>
                    </span>
                </div>
                <p class="lead text-muted"><i class="fas fa-map-marker-alt fa-fw me-2"></i><%= kost.getAddress() %>, <%= kost.getLocation() %></p>
            </div>
            
            <div class="row g-4">
                <div class="col-lg-8">
                    <img src="<%= (kost.getImageUrl() != null && !kost.getImageUrl().isEmpty()) ? kost.getImageUrl() : "https://placehold.co/1200x800/2563eb/FFFFFF?text=Gambar+Belum+Tersedia" %>" 
                         class="img-fluid rounded shadow-sm mb-4" alt="Foto Kost">

                    <div class="card mb-4">
                        <div class="card-body p-4">
                            <h3 class="border-bottom pb-2 mb-3">Deskripsi Kost</h3>
                            <p style="white-space: pre-wrap;"><%= kost.getDescription() %></p>
                            
                            <h3 class="border-bottom pb-2 mt-4 mb-3">Fasilitas</h3>
                            <div class="d-flex flex-wrap" style="gap: 0.5rem;">
                                <% 
                                    String facilitiesStr = kost.getFacilities();
                                    if (facilitiesStr != null && !facilitiesStr.isEmpty()) {
                                        for (String facility : facilitiesStr.split(",")) {
                                %>
                                    <span class="badge bg-primary-subtle text-primary-emphasis rounded-pill p-2 fs-6"><%= facility.trim() %></span>
                                <% 
                                        }
                                    } else {
                                %>
                                    <p class="text-muted">Tidak ada data fasilitas.</p>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-body p-4">
                             <h3 class="border-bottom pb-2 mb-3">Kamar yang Tersedia</h3>
                             <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th>No. Kamar</th>
                                        <th>Tipe</th>
                                        <th>Harga / Bulan</th>
                                        <th>Status</th>
                                        <th>Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if(roomList != null && !roomList.isEmpty()){
                                        for(Room room : roomList){ %>
                                    <tr>
                                        <td><strong><%= room.getNumber() %></strong></td>
                                        <td><%= room.getType() %></td>
                                        <td>Rp <%= String.format("%,.0f", room.getPrice()) %></td>
                                        <td>
                                            <% if("Available".equals(room.getStatus())) { %>
                                                <span class="badge bg-success">Tersedia</span>
                                            <% } else { %>
                                                <span class="badge bg-danger">Terisi</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if("Available".equals(room.getStatus())) { %>
                                                <a href="<%= request.getContextPath() %>/assignRoom?roomId=<%= room.getId() %>&roomPrice=<%= room.getPrice() %>&roomNumber=<%= java.net.URLEncoder.encode(room.getNumber(), "UTF-8") %>" class="btn btn-primary btn-sm">Sewa Kamar</a>
                                            <% } else { %>
                                                <button class="btn btn-secondary btn-sm" disabled>Terisi</button>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% }} else { %>
                                    <tr>
                                        <td colspan="5" class="text-center text-muted">Belum ada data kamar untuk kost ini.</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <% if ("Owner".equals(userRole) && tenantList != null && !tenantList.isEmpty()) { %>
                    <div class="card mt-4">
                        <div class="card-body p-4">
                            <h3 class="border-bottom pb-2 mb-3">Daftar Penyewa</h3>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead>
                                        <tr>
                                            <th>Nama Penyewa</th>
                                            <th>No. Kamar</th>
                                            <th>Tipe Kamar</th>
                                            <th>Email</th>
                                            <th>No. Telepon</th>
                                            <th>Aksi</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (Map<String, Object> tenant : tenantList) { %>
                                        <tr>
                                            <td><strong><%= tenant.get("name") %></strong></td>
                                            <td><%= tenant.get("roomNumber") %></td>
                                            <td><%= tenant.get("roomType") %></td>
                                            <td><%= tenant.get("email") %></td>
                                            <td>
                                                <% if (tenant.get("phone") != null && !tenant.get("phone").toString().isEmpty()) { %>
                                                    <a href="https://wa.me/<%= tenant.get("phone").toString().replaceAll("[^0-9]", "") %>" 
                                                       class="text-decoration-none" target="_blank">
                                                        <i class="fab fa-whatsapp text-success"></i> <%= tenant.get("phone").toString().replaceAll("[^0-9]", "") %>
                                                    </a>
                                                <% } else { %>
                                                    <span class="text-muted">-</span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <form action="removeTenant" method="POST" class="d-inline" onsubmit="return confirm('Apakah Anda yakin ingin menghapus penyewa ini?');">
                                                    <input type="hidden" name="tenantId" value="<%= tenant.get("id") %>">
                                                    <input type="hidden" name="roomId" value="<%= tenant.get("roomId") %>">
                                                    <input type="hidden" name="returnUrl" value="kostDetail">
                                                    <input type="hidden" name="kostId" value="<%= request.getParameter("id") %>">
                                                    <button type="submit" class="btn btn-danger btn-sm">
                                                        <i class="fas fa-user-minus"></i> Hapus
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>

                <div class="col-lg-4">
                    <div class="card" style="position: sticky; top: 20px;">
                        <div class="card-body p-4 text-center">
                            <span class="text-muted">Mulai dari</span>
                            <h2 class="price mb-0">Rp <%= String.format("%,.0f", kost.getPrice()) %></h2>
                            <span class="text-muted">/ bulan</span>
                            <hr class="my-3">
                            <h5 class="mb-3">Informasi Pemilik</h5>
                            <img src="https://i.pravatar.cc/80" class="rounded-circle mb-2" alt="Foto Pemilik">
                            <p class="mb-1"><strong><%= owner.getName() %></strong></p>
                            <p class="text-muted small"><%= owner.getEmail() %></p>
                            
                            <a href="https://wa.me/<%= (owner.getPhone() != null) ? owner.getPhone().replaceAll("[^0-9]", "") : "" %>" class="btn btn-success w-100 mt-2" target="_blank">
                                <i class="fab fa-whatsapp me-2"></i>Hubungi Pemilik
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        <% } else { %>
            <div class="alert alert-danger text-center p-4">
                <h3 class="mb-2"><i class="fas fa-exclamation-triangle"></i> Kost Tidak Ditemukan</h3>
                <p class="mb-0">Maaf, detail kost yang Anda cari tidak dapat ditemukan.</p>
                <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary mt-3">Kembali ke Beranda</a>
            </div>
        <% } %>
    </main>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>