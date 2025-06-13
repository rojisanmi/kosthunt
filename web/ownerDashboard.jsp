<%@page import="models.Kost"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Owner Dashboard - KostHunt</title>
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

            .main-container {
                padding: 2rem;
                max-width: 1400px;
                margin: 0 auto;
            }

            .dashboard-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
                padding-bottom: 1rem;
                border-bottom: 2px solid rgba(0, 0, 0, 0.1);
            }

            .dashboard-header h2 {
                font-size: 1.75rem;
                font-weight: 700;
                color: var(--text-color);
                margin: 0;
            }

            .btn-add {
                background-color: var(--primary-color);
                color: var(--white);
                padding: 0.75rem 1.5rem;
                border-radius: 0.75rem;
                font-weight: 600;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                border: none;
                font-size: 0.875rem;
                position: relative;
                overflow: hidden;
            }

            .btn-add::after {
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

            .btn-add:hover::after {
                width: 300px;
                height: 300px;
            }

            .btn-add:hover {
                background-color: var(--primary-dark);
                transform: translateY(-2px);
                color: var(--white);
            }

            .kost-container {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
                gap: 1.5rem;
                margin-top: 1.5rem;
            }

            .kost-card {
                background-color: var(--white);
                border-radius: 1rem;
                overflow: hidden;
                box-shadow: var(--shadow);
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                display: flex;
                flex-direction: column;
                height: 100%;
                transform: translateY(0);
                animation: fadeIn 0.5s ease-out;
            }

            .kost-card:hover {
                transform: translateY(-5px);
                box-shadow: var(--shadow-lg);
            }

            .kost-card-img {
                width: 100%;
                height: 200px;
                object-fit: cover;
                transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            .kost-card:hover .kost-card-img {
                transform: scale(1.05);
            }

            .kost-card-body {
                padding: 1.25rem;
                flex-grow: 1;
            }

            .kost-card-body h4 {
                margin: 0 0 0.5rem 0;
                font-size: 1.25rem;
                font-weight: 600;
                color: var(--text-color);
            }

            .kost-card-body p {
                margin: 0;
                color: var(--secondary-color);
                font-size: 0.875rem;
                line-height: 1.5;
            }

            .kost-card-footer {
                background-color: var(--light-bg);
                padding: 1rem;
                display: flex;
                justify-content: flex-end;
                gap: 0.75rem;
                border-top: 1px solid rgba(0, 0, 0, 0.1);
            }

            .btn-action {
                text-decoration: none;
                color: var(--white);
                padding: 0.5rem 1rem;
                border-radius: 0.5rem;
                font-size: 0.875rem;
                font-weight: 500;
                display: inline-flex;
                align-items: center;
                gap: 0.375rem;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                position: relative;
                overflow: hidden;
            }

            .btn-action::after {
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

            .btn-action:hover::after {
                width: 300px;
                height: 300px;
            }

            .btn-action:hover {
                transform: translateY(-2px);
                color: var(--white);
            }

            .btn-info {
                background-color: var(--info);
            }

            .btn-info:hover {
                background-color: #2563eb;
            }

            .btn-edit {
                background-color: var(--warning);
            }

            .btn-edit:hover {
                background-color: #d97706;
            }

            .btn-delete {
                background-color: var(--danger);
            }

            .btn-delete:hover {
                background-color: #dc2626;
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

            .empty-state {
                text-align: center;
                padding: 3rem;
                background-color: var(--white);
                border-radius: 1rem;
                box-shadow: var(--shadow);
                margin-top: 2rem;
                animation: fadeIn 0.5s ease-out;
            }

            .empty-state p {
                color: var(--secondary-color);
                font-size: 1rem;
                margin-bottom: 1.5rem;
            }

            @media (max-width: 768px) {
                .main-container {
                    padding: 1rem;
                }

                .dashboard-header {
                    flex-direction: column;
                    gap: 1rem;
                    align-items: flex-start;
                }

                .kost-container {
                    grid-template-columns: 1fr;
                }

                .kost-card-footer {
                    flex-wrap: wrap;
                }

                .btn-action {
                    flex: 1;
                    justify-content: center;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="main-container">
            <div class="dashboard-header">
                <h2>Kelola Kost Anda</h2>
                <a href="kost/addKost.jsp" class="btn-add">
                    <i class="fas fa-plus"></i>
                    Tambah Kost
                </a>
            </div>

            <div class="kost-container">
                <%
                    List<Kost> kostList = (List<Kost>) request.getAttribute("kostList");
                    if (kostList != null && !kostList.isEmpty()) {
                        for (Kost kost : kostList) {
                %>
                <div class="kost-card">
                    <img class="kost-card-img" src="https://placehold.co/600x400/2563eb/FFFFFF?text=<%= java.net.URLEncoder.encode(kost.getName(), "UTF-8") %>" alt="Foto <%= kost.getName() %>">
                    <div class="kost-card-body">
                        <h4><%= kost.getName() %></h4>
                        <p><%= kost.getAddress() %></p>
                    </div>
                    <div class="kost-card-footer">
                        <a href="<%= request.getContextPath() %>/roomList?kostId=<%= kost.getId() %>" class="btn-action btn-info">
                            <i class="fas fa-door-open"></i>
                            Kelola Kamar
                        </a>
                        <a href="<%= request.getContextPath() %>/editKost?id=<%= kost.getId() %>" class="btn-action btn-edit">
                            <i class="fas fa-pencil-alt"></i>
                            Edit
                        </a>
                        <a href="<%= request.getContextPath() %>/deleteKost?id=<%= kost.getId() %>" class="btn-action btn-delete" 
                           onclick="return confirm('Apakah Anda yakin ingin menghapus kost ini? Tindakan ini tidak dapat dibatalkan.');">
                            <i class="fas fa-trash-alt"></i>
                            Hapus
                        </a>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="empty-state">
                    <p>Anda belum memiliki data kos. Silakan klik tombol 'Tambah Kost' untuk memulai.</p>
                    <a href="kost/addKost.jsp" class="btn-add">
                        <i class="fas fa-plus"></i>
                        Tambah Kost
                    </a>
                </div>
                <%
                    }
                %>
            </div>
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