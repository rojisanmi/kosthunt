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

            .card-body {
                padding: 2rem;
            }

            .price {
                font-size: 2rem;
                font-weight: 700;
                color: var(--primary-color);
                margin: 0.5rem 0;
            }

            .owner-info {
                background: var(--light-bg);
                padding: 1.5rem;
                border-radius: 1rem;
                transition: all 0.3s ease;
            }

            .owner-info:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow);
            }

            .contact-button {
                background-color: #25D366;
                border: none;
                color: var(--white);
                font-weight: 600;
                padding: 0.75rem 1.5rem;
                border-radius: 0.75rem;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                position: relative;
                overflow: hidden;
            }

            .contact-button::after {
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

            .contact-button:hover {
                background-color: #1DAE53;
                transform: translateY(-2px);
            }

            .contact-button:hover::after {
                width: 300px;
                height: 300px;
            }

            .badge {
                padding: 0.5rem 1rem;
                font-weight: 500;
                font-size: 0.875rem;
                transition: all 0.3s ease;
            }

            .badge:hover {
                transform: translateY(-2px);
            }

            .img-fluid {
                border-radius: 1rem;
                transition: all 0.3s ease;
            }

            .img-fluid:hover {
                transform: scale(1.02);
            }

            .alert {
                border-radius: 1rem;
                padding: 1.5rem;
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

            .btn-primary {
                background-color: var(--primary-color);
                border: none;
                padding: 0.75rem 1.5rem;
                border-radius: 0.75rem;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                background-color: var(--primary-dark);
                transform: translateY(-2px);
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

                .price {
                    font-size: 1.5rem;
                }

                .contact-button {
                    padding: 0.5rem 1rem;
                }
            }
        </style>
    </head>
    <body>
        <%-- Memasukkan header.jsp yang sudah kita perbaiki --%>
        <jsp:include page="header.jsp" />

        <div class="container" style="max-width: 1200px;
                margin: 2rem auto;
                padding: 0 1rem;">
            <% if (kost != null && owner != null) { %>
            <div class="mb-4 animate-fade-in">
                <h1 class="fw-bold"><%= kost.getName() %></h1>
                <p class="lead text-muted"><i class="fas fa-map-marker-alt fa-fw me-2"></i><%= kost.getAddress() %>, <%= kost.getLocation() %></p>
            </div>

            <div class="row g-4">
                <div class="col-lg-8">
                    <img src="<%= (kost.getImageUrl() != null && !kost.getImageUrl().isEmpty()) ? kost.getImageUrl() : "https://placehold.co/1200x800/2563eb/FFFFFF?text=Gambar+Belum+Tersedia" %>" 
                         class="img-fluid rounded shadow-sm mb-4" 
                         alt="Foto Kost <%= kost.getName() %>">

                    <div class="card">
                        <div class="card-body">
                            <h3 class="border-bottom pb-2 mb-3">Deskripsi Kost</h3>
                            <p style="white-space: pre-wrap;"><%= kost.getDescription() %></p>

                            <h3 class="border-bottom pb-2 mt-4 mb-3">Fasilitas</h3>
                            <div class="d-flex flex-wrap">
                                <% 
                                    String facilitiesStr = kost.getFacilities();
                                    if (facilitiesStr != null && !facilitiesStr.isEmpty()) {
                                        for (String facility : facilitiesStr.split(",")) {
                                %>
                                <span class="badge bg-primary-subtle text-primary-emphasis rounded-pill m-1"><%= facility.trim() %></span>
                                <% 
                                        }
                                    } else {
                                %>
                                <p class="text-muted">Tidak ada data fasilitas.</p>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card" style="position: sticky; top: 100px; z-index: 1020;">
                        <div class="card-body text-center">
                            <span class="text-muted">Mulai dari</span>
                            <h2 class="price">Rp <%= String.format("%,.0f", kost.getPrice()) %></h2>
                            <span class="text-muted">/ bulan</span>
                            <hr>
                            <h5 class="mb-3">Informasi Pemilik</h5>
                            <p class="mb-1"><i class="fas fa-user fa-fw me-2"></i><strong><%= owner.getName() %></strong></p>
                            <p class="text-muted"><%= owner.getEmail() %></p>

                            <a href="https://wa.me/<%= (owner.getPhone() != null) ? owner.getPhone().replaceAll("[^0-9]", "") : "" %>" 
                               class="btn contact-button w-100 mt-3" 
                               target="_blank">
                                <i class="fab fa-whatsapp me-2"></i>
                                Hubungi Pemilik
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <% } else { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <div>
                    <h3 class="mb-2">Kost Tidak Ditemukan</h3>
                    <p class="mb-0">Maaf, detail kost yang Anda cari tidak dapat ditemukan. Mungkin sudah dihapus atau link tidak valid.</p>
                </div>
            </div>
            <div class="text-center mt-4">
                <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary">
                    <i class="fas fa-home me-2"></i>
                    Kembali ke Beranda
                </a>
            </div>
            <% } %>
        </div>
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