<%@page import="models.Room"%>
<%@page import="models.Kost"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Kamar - KostHunt</title>
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

        .btn-warning {
            background-color: var(--warning);
            border: none;
            color: var(--white);
        }

        .btn-warning:hover {
            background-color: #d97706;
            transform: translateY(-2px);
            color: var(--white);
        }

        .btn-danger {
            background-color: var(--danger);
            border: none;
            color: var(--white);
        }

        .btn-danger:hover {
            background-color: #dc2626;
            transform: translateY(-2px);
            color: var(--white);
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.75rem;
            border-radius: 0.5rem;
        }

        .table {
            margin-bottom: 0;
            border-collapse: separate;
            border-spacing: 0;
        }

        .table thead th {
            background-color: var(--primary-color);
            color: var(--white);
            border: none;
            padding: 1rem;
            font-weight: 600;
            font-size: 0.875rem;
        }

        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
            font-size: 0.875rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .table tbody tr {
            transition: all 0.3s ease;
        }

        .table tbody tr:hover {
            background-color: var(--light-bg);
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

        .alert-link {
            color: #991b1b;
            text-decoration: underline;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .alert-link:hover {
            color: #7f1d1d;
        }

        .text-muted {
            color: var(--secondary-color) !important;
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

            .table-responsive {
                margin: 0 -1.5rem;
            }

            .table thead th,
            .table tbody td {
                padding: 0.75rem;
            }

            .btn-sm {
                padding: 0.375rem 0.75rem;
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

    <div class="container" style="max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;">
        <%
            Kost kost = (Kost) request.getAttribute("kost");
            List<Room> roomList = (List<Room>) request.getAttribute("roomList");
        %>

        <% if (kost != null) { %>
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h3><i class="fas fa-door-open"></i> Kelola Kamar</h3>
                <a href="<%= request.getContextPath() %>/room/addRoom.jsp?kostId=<%= kost.getId() %>" class="btn btn-primary">
                    <i class="fas fa-plus-circle me-2"></i>
                    Tambah Kamar
                </a>
            </div>
            <div class="card-body">
                <div class="mb-4">
                    <h4 class="text-muted">Kost: <strong><%= kost.getName() %></strong></h4>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th scope="col">#</th>
                                <th scope="col">Nomor Kamar</th>
                                <th scope="col">Tipe Kamar</th>
                                <th scope="col">Harga Kamar</th>
                                <th scope="col" class="text-end">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (roomList != null && !roomList.isEmpty()) { 
                                int counter = 1;
                                for (Room room : roomList) {
                            %>
                            <tr>
                                <th scope="row"><%= counter++ %></th>
                                <td><%= room.getNumber() %></td>
                                <td><%= room.getType() %></td>
                                <td><%= room.getPrice() %></td>
                                <td class="text-end">
                                    <a href="<%= request.getContextPath() %>/editRoom?roomId=<%= room.getId() %>" class="btn btn-warning btn-sm">
                                        <i class="fas fa-edit me-1"></i>
                                        Edit
                                    </a>
                                    <a href="<%= request.getContextPath() %>/deleteRoom?roomId=<%= room.getId() %>&kostId=<%= room.getKostId() %>" 
                                       class="btn btn-danger btn-sm" 
                                       onclick="return confirm('Yakin ingin menghapus kamar ini?');">
                                        <i class="fas fa-trash me-1"></i>
                                        Hapus
                                    </a>
                                </td>
                            </tr>
                            <% }} else { %>
                            <tr>
                                <td colspan="4" class="text-center text-muted py-4">
                                    <i class="fas fa-info-circle me-2"></i>
                                    Belum ada data kamar. Silakan tambahkan.
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <div class="mt-4">
                    <a href="<%= request.getContextPath() %>/ownerDashboard" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>
                        Kembali ke Dashboard
                    </a>
                </div>
            </div>
        </div>
        <% } else { %>
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i>
            Data Kost tidak ditemukan. 
            <a href="<%= request.getContextPath() %>/ownerDashboard" class="alert-link">Kembali ke dashboard</a>
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