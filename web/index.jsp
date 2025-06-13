<%@page import="models.Kost"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="KostHunt - Platform pencarian dan pemasaran kost terbaik di Indonesia">
        <meta name="keywords" content="kost, boarding house, sewa kost, kost murah, kost nyaman">
        <title>KostHunt - Temukan Kost Impianmu</title>
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
                --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
                --shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
                --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
            }

            body {
                font-family: 'Plus Jakarta Sans', sans-serif;
                color: var(--text-color);
                background-color: var(--light-bg);
                line-height: 1.6;
            }

            .navbar {
                background-color: var(--primary-color);
                padding: 1rem 2rem;
                box-shadow: var(--shadow-sm);
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            .navbar-brand {
                font-size: 1.8rem;
                font-weight: 700;
                color: var(--white) !important;
                letter-spacing: -0.5px;
            }

            .nav-link {
                color: var(--white) !important;
                font-weight: 500;
                margin: 0 0.5rem;
                transition: all 0.3s ease;
                position: relative;
            }

            .nav-link::after {
                content: '';
                position: absolute;
                width: 0;
                height: 2px;
                bottom: 0;
                left: 0;
                background-color: var(--white);
                transition: width 0.3s ease;
            }

            .nav-link:hover::after {
                width: 100%;
            }

            .hero-section {
                padding: 8rem 0 6rem;
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
                color: var(--white);
                position: relative;
                overflow: hidden;
            }

            .hero-section::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url('https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2073&q=80') center/cover;
                opacity: 0.1;
            }

            .hero-content {
                position: relative;
                z-index: 1;
            }

            .hero-title {
                font-size: 4rem;
                font-weight: 700;
                margin-bottom: 1.5rem;
                line-height: 1.2;
                animation: fadeInUp 0.8s ease-out;
            }

            .hero-subtitle {
                font-size: 1.25rem;
                opacity: 0.9;
                margin-bottom: 2rem;
                animation: fadeInUp 1s ease-out;
            }

            .search-container {
                background: var(--white);
                padding: 2.5rem;
                border-radius: 1.5rem;
                box-shadow: var(--shadow-lg);
                margin-top: 2rem;
                transition: all 0.3s ease;
                animation: fadeInUp 1.2s ease-out;
            }

            .search-container:hover {
                transform: translateY(-5px);
                box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
            }

            .search-input {
                border: 2px solid #e2e8f0;
                padding: 1.25rem 1.5rem;
                border-radius: 1rem;
                font-size: 1.1rem;
                transition: all 0.3s ease;
            }

            .search-input:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
            }

            .search-button {
                background-color: var(--primary-color);
                color: var(--white);
                border: none;
                padding: 1.25rem 2.5rem;
                border-radius: 1rem;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .search-button:hover {
                background-color: var(--primary-dark);
                transform: translateY(-2px);
            }

            .features-section {
                padding: 8rem 0;
                background-color: var(--white);
            }

            .section-title {
                font-size: 2.75rem;
                font-weight: 700;
                margin-bottom: 4rem;
                text-align: center;
                color: var(--text-color);
                position: relative;
            }

            .section-title::after {
                content: '';
                position: absolute;
                bottom: -1rem;
                left: 50%;
                transform: translateX(-50%);
                width: 80px;
                height: 4px;
                background: var(--primary-color);
                border-radius: 2px;
            }

            .feature-card {
                background: var(--white);
                padding: 3rem 2rem;
                border-radius: 1.5rem;
                box-shadow: var(--shadow);
                transition: all 0.3s ease;
                height: 100%;
                border: 1px solid #e2e8f0;
                position: relative;
                overflow: hidden;
            }

            .feature-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 4px;
                background: var(--primary-color);
                transform: scaleX(0);
                transition: transform 0.3s ease;
            }

            .feature-card:hover {
                transform: translateY(-10px);
                box-shadow: var(--shadow-lg);
            }

            .feature-card:hover::before {
                transform: scaleX(1);
            }

            .feature-icon {
                font-size: 3rem;
                color: var(--primary-color);
                margin-bottom: 1.5rem;
                transition: all 0.3s ease;
            }

            .feature-card:hover .feature-icon {
                transform: scale(1.1);
            }

            .feature-title {
                font-size: 1.5rem;
                font-weight: 600;
                margin-bottom: 1rem;
                color: var(--text-color);
            }

            .feature-text {
                color: var(--secondary-color);
                font-size: 1.1rem;
            }

            .area-kos-container {
                padding: 8rem 0;
                background-color: var(--light-bg);
            }

            .area-kos-container .row {
                margin: -1rem;
            }

            .area-kos-container .col-md-4 {
                padding: 1rem;
            }

            .area-kos {
                position: relative;
                border-radius: 1.5rem;
                overflow: hidden;
                margin-bottom: 2rem;
                box-shadow: var(--shadow);
                transition: all 0.3s ease;
                cursor: pointer;
                aspect-ratio: 16/9;
            }

            .area-kos:hover {
                transform: translateY(-10px);
                box-shadow: var(--shadow-lg);
            }

            .area-kos img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.5s ease;
            }

            .area-kos:hover img {
                transform: scale(1.1);
            }

            .area-kos-text {
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                padding: 2.5rem;
                background: linear-gradient(to top, rgba(0,0,0,0.9), transparent);
                color: var(--white);
                font-size: 1.75rem;
                font-weight: 600;
                transform: translateY(20px);
                opacity: 0;
                transition: all 0.3s ease;
            }

            .area-kos:hover .area-kos-text {
                transform: translateY(0);
                opacity: 1;
            }

            .kost-card {
                background: var(--white);
                border-radius: 1.5rem;
                overflow: hidden;
                box-shadow: var(--shadow);
                transition: all 0.3s ease;
                height: 100%;
                border: 1px solid #e2e8f0;
            }

            .kost-card:hover {
                transform: translateY(-10px);
                box-shadow: var(--shadow-lg);
            }

            .kost-image-container {
                position: relative;
                height: 280px;
                overflow: hidden;
            }

            .kost-image {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.5s ease;
            }

            .kost-card:hover .kost-image {
                transform: scale(1.1);
            }

            .kost-overlay {
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                background: linear-gradient(to top, rgba(0,0,0,0.9), transparent);
                padding: 2.5rem;
                transform: translateY(20px);
                opacity: 0;
                transition: all 0.3s ease;
            }

            .kost-card:hover .kost-overlay {
                transform: translateY(0);
                opacity: 1;
            }

            .kost-name {
                font-size: 1.75rem;
                font-weight: 600;
                margin: 0;
                color: var(--white);
            }

            .kost-details {
                padding: 2rem;
            }

            .kost-address {
                color: var(--secondary-color);
                font-size: 1.1rem;
                margin-bottom: 1rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .kost-price {
                font-size: 1.5rem;
                font-weight: 600;
                color: var(--primary-color);
            }

            .kost-status {
                position: absolute;
                top: 1.5rem;
                right: 1.5rem;
                background: var(--white);
                padding: 0.75rem 1.5rem;
                border-radius: 2rem;
                font-size: 0.875rem;
                font-weight: 500;
                color: var(--success);
                box-shadow: var(--shadow);
                transform: translateY(-10px);
                opacity: 0;
                transition: all 0.3s ease;
            }

            .kost-card:hover .kost-status {
                transform: translateY(0);
                opacity: 1;
            }

            .kost-link {
                text-decoration: none;
                color: inherit;
                display: block;
                height: 100%;
            }

            .kost-link:hover {
                color: inherit;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @media (max-width: 768px) {
                .hero-title {
                    font-size: 2.5rem;
                }

                .hero-section {
                    padding: 6rem 0 4rem;
                }

                .search-container {
                    margin: 1rem;
                    padding: 1.5rem;
                }

                .section-title {
                    font-size: 2rem;
                }

                .feature-card {
                    margin-bottom: 1.5rem;
                }

                .kost-image-container {
                    height: 200px;
                }

                .area-kos-container .row {
                    margin: -0.75rem;
                }

                .area-kos-container .col-md-4 {
                    padding: 0.75rem;
                }
            }

            .animate-fade-in {
                opacity: 0;
                transform: translateY(20px);
                transition: all 0.6s ease-out;
            }

            .animate-fade-in.visible {
                opacity: 1;
                transform: translateY(0);
            }
        </style>
    </head>
    <body>
        <%@ page session="true" %>
        <jsp:include page="header.jsp" />

        <!-- Hero Section -->
        <section class="hero-section">
            <div class="container">
                <div class="row align-items-center hero-content">
                    <div class="col-lg-6">
                        <h1 class="hero-title">Temukan Kost Impianmu</h1>
                        <p class="hero-subtitle">Platform terbaik untuk mencari dan memasarkan kost dengan mudah, aman, dan terpercaya.</p>
                        <form action="index.jsp" method="GET" class="search-container">
                            <div class="input-group">
                                <input type="text" class="form-control search-input" name="search" 
                                       placeholder="Cari kost berdasarkan nama atau lokasi..." 
                                       value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                                <button class="btn search-button" type="submit">
                                    <i class="fas fa-search"></i> Cari
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>

       <!-- Kost List Section -->
        <section class="area-kos-container">
            <div class="container">
                <h2 class="section-title">Daftar Kost Tersedia</h2>
                <div class="row">
                    <%
                        List<Kost> kostList = null;
                        try {
                            String dbUrl = "jdbc:mysql://localhost:3306/kostmanagement";
                            String dbUser = "root";
                            String dbPassword = "";
                            
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                            
                            String query = "SELECT id, name, address, status, price, image_url FROM Kost WHERE status > 0";
                            String searchTerm = request.getParameter("search");
                            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                                query += " AND (name LIKE ? OR address LIKE ?)";
                            }
                            PreparedStatement stmt = conn.prepareStatement(query);
                            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                                String searchPattern = "%" + searchTerm + "%";
                                stmt.setString(1, searchPattern);
                                stmt.setString(2, searchPattern);
                            }
                            ResultSet rs = stmt.executeQuery();
                            
                            while (rs.next()) {
                                String imageUrl = rs.getString("image_url");
                                if (imageUrl == null || imageUrl.trim().isEmpty()) {
                                    imageUrl = "https://placehold.co/600x400/2563eb/FFFFFF?text=" + java.net.URLEncoder.encode(rs.getString("name"), "UTF-8");
                                }
                    %>
                    <div class="col-md-4 animate-fade-in">
                        <a href="kostDetail?id=<%= rs.getInt("id") %>" class="kost-link">
                            <div class="kost-card">
                                <div class="kost-image-container">
                                    <img src="<%= imageUrl %>" alt="<%= rs.getString("name") %>" class="kost-image">
                                    <div class="kost-overlay">
                                        <h3 class="kost-name"><%= rs.getString("name") %></h3>
                                    </div>
                                    <div class="kost-status">
                                        <i class="fas fa-check-circle"></i> Tersedia
                                    </div>
                                </div>
                                <div class="kost-details">
                                    <div class="kost-address">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <%= rs.getString("address") %>
                                    </div>
                                    <div class="kost-price">
                                        Rp <%= String.format("%,d", rs.getInt("price")) %> / bulan
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>
                    <%
                            }
                            rs.close();
                            stmt.close();
                            conn.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                    %>
                    <div class="col-12 text-center">
                        <p>Terjadi kesalahan saat mengambil data kost.</p>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </section>                         
                   
        <!-- Popular Areas Section -->
        <section class="area-kos-container">
            <div class="container">
                <h2 class="section-title">Area Kost Populer</h2>
                <div class="row">
                    <div class="col-md-4 animate-fade-in">
                        <div class="area-kos" onclick="window.location.href='kost/bandung.jsp'">
                            <img src="https://atourin.obs.ap-southeast-3.myhuaweicloud.com/images/destination/bandung/gedung-sate-profile1639291114.png" alt="Kost Bandung">
                            <div class="area-kos-text">Kost Bandung</div>
                        </div>
                    </div>
                    <div class="col-md-4 animate-fade-in">
                        <div class="area-kos" onclick="window.location.href='kost/jogja.jsp'">
                            <img src="https://wallpapercave.com/wp/wp9451651.jpg" alt="Kost Jogja">
                            <div class="area-kos-text">Kost Jogja</div>
                        </div>
                    </div>
                    <div class="col-md-4 animate-fade-in">
                        <div class="area-kos" onclick="window.location.href='kost/solo.jsp'">
                            <img src="https://blog.bankmega.com/wp-content/uploads/2023/01/tempat-wisata-di-kota-solo.jpg" alt="Kost Solo">
                            <div class="area-kos-text">Kost Solo</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>        
                
        <!-- Features Section -->
        <section class="features-section">
            <div class="container">
                <h2 class="section-title">Mengapa Memilih KostHunt?</h2>
                <div class="row">
                    <div class="col-md-4 animate-fade-in">
                        <div class="feature-card">
                            <i class="fas fa-search feature-icon"></i>
                            <h4 class="feature-title">Cari Kost Mudah</h4>
                            <p class="feature-text">Temukan kost sesuai kriteria dengan fitur pencarian yang canggih</p>
                        </div>
                    </div>
                    <div class="col-md-4 animate-fade-in">
                        <div class="feature-card">
                            <i class="fas fa-shield-alt feature-icon"></i>
                            <h4 class="feature-title">Aman & Terpercaya</h4>
                            <p class="feature-text">Semua kost telah diverifikasi untuk keamanan dan kenyamanan Anda</p>
                        </div>
                    </div>
                    <div class="col-md-4 animate-fade-in">
                        <div class="feature-card">
                            <i class="fas fa-map-marker-alt feature-icon"></i>
                            <h4 class="feature-title">Lokasi Strategis</h4>
                            <p class="feature-text">Kost dengan lokasi strategis dekat kampus dan fasilitas umum</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        

        

        <!-- Tenant Dashboard Section -->
        <%
            String user = (String) session.getAttribute("user");
            String userRole = (String) session.getAttribute("role");
            if (user != null && "tenant".equals(userRole)) {
        %>
        <section class="main-container">
            <div class="container">
                <h2>Selamat Datang, <%= user %>!</h2>
                <h3>Temukan Kos Impian Anda</h3>
            </div>
        </section>
        <%
            }
        %>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
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