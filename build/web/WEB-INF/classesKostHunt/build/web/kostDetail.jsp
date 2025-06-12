<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.*" %>

<%
    String user = (String) session.getAttribute("user");
    String kostId = request.getParameter("id");
    Map<String, Object> kostDetail = new HashMap<>();
    Map<String, String> owner = new HashMap<>();
    
    if (kostId != null && !kostId.isEmpty()) {
        try {
            // Database connection parameters
            String dbUrl = "jdbc:mysql://localhost:3306/kostmanagement";
            String dbUser = "root";
            String dbPassword = "";
            
            // Load the JDBC driver
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                throw new Exception("MySQL JDBC Driver tidak ditemukan. Pastikan file mysql-connector-java.jar ada di folder lib: " + e.getMessage());
            }
            
            // Try to establish connection
            Connection conn = null;
            try {
                conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            } catch (SQLException e) {
                throw new Exception("Gagal terhubung ke database. Pastikan MySQL server berjalan dan kredensial benar: " + e.getMessage());
            }
            
            // Get kost details
            String sql = "SELECT k.*, u.name as owner_name, u.phone as owner_phone, u.email as owner_email " +
                        "FROM kost k " +
                        "JOIN users u ON k.owner_id = u.id " +
                        "WHERE k.id = ?";
            
            PreparedStatement stmt = null;
            ResultSet rs = null;
            
            try {
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, kostId);
                rs = stmt.executeQuery();
                
                if (rs.next()) {
                    kostDetail.put("nama", rs.getString("name"));
                    kostDetail.put("alamat", rs.getString("address"));
                    kostDetail.put("harga", rs.getDouble("price"));
                    kostDetail.put("tipe", rs.getString("type"));
                    kostDetail.put("ketersediaan", rs.getInt("status"));
                    kostDetail.put("deskripsi", rs.getString("description"));
                    
                    // Parse facilities string into list
                    String facilitiesStr = rs.getString("facilities");
                    List<String> facilities = new ArrayList<>();
                    if (facilitiesStr != null && !facilitiesStr.isEmpty()) {
                        String[] facilityArray = facilitiesStr.split(",");
                        for (String facility : facilityArray) {
                            facilities.add(facility.trim());
                        }
                    }
                    kostDetail.put("fasilitas", facilities);
                    
                    // Add image
                    String imageUrl = rs.getString("image_url");
                    List<String> images = new ArrayList<>();
                    if (imageUrl != null && !imageUrl.isEmpty()) {
                        images.add(imageUrl);
                    } else {
                        images.add("https://via.placeholder.com/600x400?text=No+Image");
                    }
                    kostDetail.put("gambar", images);
                    
                    // Owner information
                    owner.put("name", rs.getString("owner_name"));
                    owner.put("phone", rs.getString("owner_phone"));
                    owner.put("email", rs.getString("owner_email"));
                    
                    // Add map URL
                    kostDetail.put("map_embed_url", "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3965.250410712975!2d106.82292721471701!3d-6.363990895393081!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2e69ec06917c5b73%3A0x6b6c006b6b6c006b!2sDepok!5e0!3m2!1sid!2sid!4v1700000000000!5m2!1sid!2sid");
                } else {
                    // Kost not found
                    kostDetail.put("nama", "Kost Tidak Ditemukan");
                    kostDetail.put("alamat", "N/A");
                    kostDetail.put("harga", 0);
                    kostDetail.put("tipe", "N/A");
                    kostDetail.put("ketersediaan", 0);
                    kostDetail.put("deskripsi", "Maaf, detail kost yang Anda cari tidak ditemukan.");
                    kostDetail.put("fasilitas", new ArrayList<String>());
                    kostDetail.put("gambar", new ArrayList<String>() {{ add("https://via.placeholder.com/600x400?text=Kost+Not+Found"); }});
                }
            } catch (SQLException e) {
                throw new Exception("Error saat mengambil data kost: " + e.getMessage());
            } finally {
                // Close resources
                if (rs != null) try { rs.close(); } catch (SQLException e) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                if (conn != null) try { conn.close(); } catch (SQLException e) {}
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Handle error appropriately
            kostDetail.put("nama", "Error");
            kostDetail.put("deskripsi", "Terjadi kesalahan: " + e.getMessage());
        }
    } else {
        // No ID provided
        kostDetail.put("nama", "Error");
        kostDetail.put("deskripsi", "ID Kost tidak ditemukan.");
    }
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detail Kost <%= kostDetail.get("nama") %> - KostHunt</title>
    
    <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css"/>
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
            margin: 0;
            background-color: var(--light-gray);
            color: var(--text-color);
            line-height: 1.6;
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

        .nav-link {
            color: white !important;
            font-weight: 500;
            margin: 0 0.5rem;
            transition: all 0.3s ease;
        }

        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 2rem;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .gallery {
            margin-bottom: 2rem;
        }

        .gallery img {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 10px;
        }

        .kost-info {
            margin-top: 2rem;
        }

        .price {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--primary-color);
            margin: 1rem 0;
        }

        .features-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1rem;
            margin: 1rem 0;
        }

        .feature-item {
            background: var(--light-gray);
            padding: 0.8rem;
            border-radius: 5px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .owner-info {
            background: var(--light-gray);
            padding: 1.5rem;
            border-radius: 10px;
            margin-top: 2rem;
        }

        .contact-button {
            background-color: var(--primary-color);
            color: white;
            padding: 1rem 2rem;
            border: none;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 1rem;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .contact-button:hover {
            background-color: var(--secondary-color);
            transform: translateY(-2px);
            color: white;
        }

        .map-container {
            margin-top: 2rem;
            border-radius: 10px;
            overflow: hidden;
        }

        .map-container iframe {
            width: 100%;
            height: 400px;
            border: none;
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
                margin: 1rem;
            }

            .gallery img {
                height: 300px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <!-- Main Content -->
    <div class="container">
        <h1 class="mb-4"><%= kostDetail.get("nama") %></h1>
        
        <!-- Image Gallery -->
        <div class="gallery">
            <div class="slick-carousel">
                <% 
                List<String> images = (List<String>) kostDetail.get("gambar");
                for (String image : images) { 
                %>
                    <div>
                        <img src="<%= image %>" alt="<%= kostDetail.get("nama") %>">
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Kost Information -->
        <div class="kost-info">
            <div class="row">
                <div class="col-md-8">
                    <h2>Deskripsi</h2>
                    <p><%= kostDetail.get("deskripsi") %></p>

                    <h3>Fasilitas</h3>
                    <div class="features-list">
                        <% 
                        List<String> facilities = (List<String>) kostDetail.get("fasilitas");
                        for (String facility : facilities) { 
                        %>
                            <div class="feature-item">
                                <i class="fas fa-check"></i>
                                <span><%= facility %></span>
                            </div>
                        <% } %>
                    </div>

                    <div class="map-container">
                        <h3>Lokasi</h3>
                        <iframe src="<%= kostDetail.get("map_embed_url") %>" allowfullscreen></iframe>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="price">
                        Rp <%= String.format("%,.0f", kostDetail.get("harga")) %> / bulan
                    </div>

                    <div class="owner-info">
                        <h3>Informasi Pemilik</h3>
                        <p><i class="fas fa-user"></i> <%= owner.get("name") %></p>
                        <p><i class="fas fa-phone"></i> <%= owner.get("phone") != null ? owner.get("phone") : "Tidak tersedia" %></p>
                        <p><i class="fas fa-envelope"></i> <%= owner.get("email") %></p>
                        
                        <% if (user != null) { %>
                            <% if (owner.get("phone") != null && !owner.get("phone").trim().isEmpty()) { %>
                                <a href="https://wa.me/<%= owner.get("phone").replaceAll("[^0-9]", "") %>" 
                                   class="contact-button" target="_blank">
                                    <i class="fab fa-whatsapp"></i> Hubungi via WhatsApp
                                </a>
                            <% } else { %>
                                <p class="text-muted">Nomor WhatsApp tidak tersedia</p>
                            <% } %>
                        <% } else { %>
                            <a href="login.jsp" class="contact-button">
                                <i class="fas fa-sign-in-alt"></i> Login untuk menghubungi pemilik
                            </a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript" src="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
    <script>
        $(document).ready(function(){
            $('.slick-carousel').slick({
                dots: true,
                infinite: true,
                speed: 500,
                slidesToShow: 1,
                slidesToScroll: 1,
                autoplay: true,
                autoplaySpeed: 3000
            });
        });
    </script>
</body>
</html>