<%@page import="models.Kost"%>
<%@page import="java.util.List"%>
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
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary-color: #4A90E2;
                --secondary-color: #357ab7;
                --text-color: #333;
                --light-gray: #f8f9fa;
            }

            body {
                font-family: 'Poppins', sans-serif;
                color: var(--text-color);
                background-color: var(--light-gray);
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

            .nav-link:hover {
                opacity: 0.8;
            }

            .hero-section {
                padding: 4rem 0;
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                color: white;
            }

            .search-container {
                background: white;
                padding: 2rem;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                margin-top: 2rem;
            }

            .search-input {
                border: 2px solid #eee;
                padding: 0.8rem 1rem;
                border-radius: 5px;
                width: 100%;
                transition: all 0.3s ease;
            }

            .search-input:focus {
                border-color: var(--primary-color);
                box-shadow: none;
            }

            .search-button {
                background-color: var(--primary-color);
                color: white;
                border: none;
                padding: 0.8rem 2rem;
                border-radius: 5px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .search-button:hover {
                background-color: var(--secondary-color);
                transform: translateY(-2px);
            }

            .area-kos-container {
                padding: 3rem 0;
            }

            .area-kos {
                position: relative;
                border-radius: 10px;
                overflow: hidden;
                margin-bottom: 1.5rem;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
            }

            .area-kos:hover {
                transform: translateY(-5px);
            }

            .area-kos img {
                width: 100%;
                height: 200px;
                object-fit: cover;
            }

            .area-kos-text {
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                padding: 1rem;
                background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);
                color: white;
                font-weight: 600;
            }

            .features-section {
                padding: 4rem 0;
                background-color: white;
            }

            .feature-card {
                text-align: center;
                padding: 2rem;
                border-radius: 10px;
                background: var(--light-gray);
                margin-bottom: 1.5rem;
                transition: all 0.3s ease;
            }

            .feature-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }

            .feature-icon {
                font-size: 2.5rem;
                color: var(--primary-color);
                margin-bottom: 1rem;
            }

            @media (max-width: 768px) {
                .navbar {
                    padding: 1rem;
                }

                .hero-section {
                    padding: 2rem 0;
                }

                .search-container {
                    margin: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <%@ page session="true" %>
        <jsp:include page="header.jsp" />

        <!-- Hero Section -->
        <section class="hero-section">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-6">
                        <h1 class="display-4 fw-bold mb-4">Temukan Kost Impianmu</h1>
                        <p class="lead mb-4">Platform terbaik untuk mencari dan memasarkan kost dengan mudah, aman, dan terpercaya.</p>
                    </div>
                    <div class="col-lg-6">
                            <form action="search" method="GET">
                                <div class="input-group mb-3">
                                    <input type="text" class="form-control search-input" name="query" placeholder="Cari kost berdasarkan lokasi...">
                                    <button class="btn search-button" type="submit">
                                        <i class="fas fa-search"></i> Cari
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Features Section -->
        <section class="features-section">
            <div class="container">
                <h2 class="text-center mb-5">Mengapa Memilih KostHunt?</h2>
                <div class="row">
                    <div class="col-md-4">
                        <div class="feature-card">
                            <i class="fas fa-search feature-icon"></i>
                            <h4>Cari Kost Mudah</h4>
                            <p>Temukan kost sesuai kriteria dengan fitur pencarian yang canggih</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="feature-card">
                            <i class="fas fa-shield-alt feature-icon"></i>
                            <h4>Aman & Terpercaya</h4>
                            <p>Semua kost telah diverifikasi untuk keamanan dan kenyamanan Anda</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="feature-card">
                            <i class="fas fa-map-marker-alt feature-icon"></i>
                            <h4>Lokasi Strategis</h4>
                            <p>Kost dengan lokasi strategis dekat kampus dan fasilitas umum</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Popular Areas Section -->
        <section class="area-kos-container">
            <div class="container">
                <h2 class="text-center mb-5">Area Kost Populer</h2>
                <div class="row">
                    <div class="col-md-4">
                        <div class="area-kos" onclick="window.location.href='kost/bandung.jsp'">
                            <img src="https://atourin.obs.ap-southeast-3.myhuaweicloud.com/images/destination/bandung/gedung-sate-profile1639291114.png" alt="Kost Bandung">
                            <div class="area-kos-text">Kost Bandung</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="area-kos" onclick="window.location.href='kost/jogja.jsp'">
                            <img src="https://wallpapercave.com/wp/wp9451651.jpg" alt="Kost Jogja">
                            <div class="area-kos-text">Kost Jogja</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="area-kos" onclick="window.location.href='kost/solo.jsp'">
                            <img src="https://th.bing.com/th/id/R.78135cd5b4b2f9280036f182fe7dd925" alt="Kost Solo">
                            <div class="area-kos-text">Kost Solo</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Kost List Section -->
        <section class="area-kos-container">
            <div class="container">
                <h2 class="text-center mb-5">Daftar Kost Tersedia</h2>
                <div class="row">
                    <%
                        List<Kost> kostList = (List<Kost>) request.getAttribute("kostList");
                        if (kostList != null && !kostList.isEmpty()) {
                            for (Kost kost : kostList) {
                    %>
                    <div class="col-md-4 mb-4">
                        <a href="kostDetail?id=<%= kost.getId() %>" class="area-kos">
                            <img src="https://placehold.co/600x400/4A90E2/FFFFFF?text=<%= java.net.URLEncoder.encode(kost.getName(), "UTF-8") %>" alt="Foto <%= kost.getName() %>">
                            <div class="area-kos-info">
                                <h4><%= kost.getName() %></h4>
                                <p><%= kost.getAddress() %></p>
                            </div>
                        </a>
                    </div>
                    <%
                            }
                        } else {
                    %>
                    <div class="col-12 text-center">
                        <p>Saat ini belum ada data kos yang tersedia.</p>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </section>

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
        </script>
    </body>
</html>

