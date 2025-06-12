<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hasil Pencarian - KostHunt</title>
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

            .search-filters {
                background: white;
                padding: 1.5rem;
                border-radius: 10px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-bottom: 2rem;
            }

            .kost-card {
                background: white;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
                margin-bottom: 2rem;
                height: 100%;
            }

            .kost-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            }

            .kost-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
            }

            .kost-details {
                padding: 1.5rem;
            }

            .kost-price {
                color: var(--primary-color);
                font-size: 1.25rem;
                font-weight: 600;
            }

            .kost-features {
                display: flex;
                flex-wrap: wrap;
                gap: 0.5rem;
                margin-top: 1rem;
            }

            .feature-badge {
                background: var(--light-gray);
                padding: 0.5rem 1rem;
                border-radius: 20px;
                font-size: 0.875rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .no-results {
                text-align: center;
                padding: 3rem;
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .sort-options {
                margin-bottom: 1rem;
            }

            .pagination {
                margin-top: 2rem;
                justify-content: center;
            }

            @media (max-width: 768px) {
                .navbar {
                    padding: 1rem;
                }
                .kost-features {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>
        <%@ page session="true" %>
        <%
            String user = (String) session.getAttribute("user");
            String searchQuery = request.getParameter("query");
            String location = request.getParameter("location");
            String priceRange = request.getParameter("price_range");
            String type = request.getParameter("type");
            String sortBy = request.getParameter("sort_by");
            String pageStr = request.getParameter("page");
            int page = pageStr != null ? Integer.parseInt(pageStr) : 1;
            int itemsPerPage = 9;
            
            // Database connection parameters
            String dbUrl = "jdbc:mysql://localhost:3306/kostmanagement";
            String dbUser = "root";
            String dbPassword = "";
            
            List<Map<String, String>> kostList = new ArrayList<>();
            int totalItems = 0;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                
                // Build the base query
                StringBuilder sql = new StringBuilder("SELECT k.*, u.name as owner_name, u.phone as owner_phone FROM kost k JOIN users u ON k.owner_id = u.id WHERE 1=1");
                List<String> params = new ArrayList<>();
                
                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    sql.append(" AND (k.name LIKE ? OR k.description LIKE ?)");
                    params.add("%" + searchQuery + "%");
                    params.add("%" + searchQuery + "%");
                }
                
                if (location != null && !location.trim().isEmpty()) {
                    sql.append(" AND k.location LIKE ?");
                    params.add("%" + location + "%");
                }
                
                if (priceRange != null && !priceRange.trim().isEmpty()) {
                    String[] range = priceRange.split("-");
                    if (range.length == 2) {
                        sql.append(" AND k.price BETWEEN ? AND ?");
                        params.add(range[0]);
                        params.add(range[1]);
                    }
                }
                
                if (type != null && !type.trim().isEmpty()) {
                    sql.append(" AND k.type = ?");
                    params.add(type);
                }
                
                // Get total count for pagination
                String countSql = "SELECT COUNT(*) FROM (" + sql.toString() + ") as count_table";
                PreparedStatement countStmt = conn.prepareStatement(countSql);
                for (int i = 0; i < params.size(); i++) {
                    countStmt.setString(i + 1, params.get(i));
                }
                ResultSet countRs = countStmt.executeQuery();
                if (countRs.next()) {
                    totalItems = countRs.getInt(1);
                }
                countRs.close();
                countStmt.close();
                
                // Add sorting
                if (sortBy != null && !sortBy.trim().isEmpty()) {
                    switch (sortBy) {
                        case "price_asc":
                            sql.append(" ORDER BY k.price ASC");
                            break;
                        case "price_desc":
                            sql.append(" ORDER BY k.price DESC");
                            break;
                        case "name_asc":
                            sql.append(" ORDER BY k.name ASC");
                            break;
                        case "name_desc":
                            sql.append(" ORDER BY k.name DESC");
                            break;
                        default:
                            sql.append(" ORDER BY k.created_at DESC");
                    }
                } else {
                    sql.append(" ORDER BY k.created_at DESC");
                }
                
                // Add pagination
                sql.append(" LIMIT ? OFFSET ?");
                params.add(String.valueOf(itemsPerPage));
                params.add(String.valueOf((page - 1) * itemsPerPage));
                
                PreparedStatement stmt = conn.prepareStatement(sql.toString());
                for (int i = 0; i < params.size(); i++) {
                    stmt.setString(i + 1, params.get(i));
                }
                
                ResultSet rs = stmt.executeQuery();
                
                while (rs.next()) {
                    Map<String, String> kost = new HashMap<>();
                    kost.put("id", rs.getString("id"));
                    kost.put("name", rs.getString("name"));
                    kost.put("description", rs.getString("description"));
                    kost.put("price", rs.getString("price"));
                    kost.put("location", rs.getString("location"));
                    kost.put("type", rs.getString("type"));
                    kost.put("image_url", rs.getString("image_url"));
                    kost.put("facilities", rs.getString("facilities"));
                    kost.put("owner_name", rs.getString("owner_name"));
                    kost.put("owner_phone", rs.getString("owner_phone"));
                    kostList.add(kost);
                }
                
                rs.close();
                stmt.close();
                conn.close();
                
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
        %>

        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg">
            <div class="container">
                <a class="navbar-brand" href="index.jsp" style="text-decoration: none; color: inherit;">KostHunt</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <% if (user != null) { %>
                            <li class="nav-item">
                                <a class="nav-link" href="profile.jsp">
                                    <i class="fas fa-user"></i> Profile
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="logout.jsp">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                                </a>
                            </li>
                        <% } else { %>
                            <li class="nav-item">
                                <a class="nav-link" href="login.jsp">
                                    <i class="fas fa-sign-in-alt"></i> Masuk
                                </a>
                            </li>
                        <% } %>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="container py-5">
            <!-- Search Filters -->
            <div class="search-filters">
                <form action="search.jsp" method="GET" class="row g-3">
                    <div class="col-md-4">
                        <input type="text" class="form-control" name="query" placeholder="Cari kost..." value="<%= searchQuery != null ? searchQuery : "" %>">
                    </div>
                    <div class="col-md-3">
                        <input type="text" class="form-control" name="location" placeholder="Lokasi" value="<%= location != null ? location : "" %>">
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" name="price_range">
                            <option value="">Rentang Harga</option>
                            <option value="0-1000000" <%= "0-1000000".equals(priceRange) ? "selected" : "" %>>Rp 0 - 1 Juta</option>
                            <option value="1000000-2000000" <%= "1000000-2000000".equals(priceRange) ? "selected" : "" %>>Rp 1 - 2 Juta</option>
                            <option value="2000000-3000000" <%= "2000000-3000000".equals(priceRange) ? "selected" : "" %>>Rp 2 - 3 Juta</option>
                            <option value="3000000-999999999" <%= "3000000-999999999".equals(priceRange) ? "selected" : "" %>>Rp 3 Juta+</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-search"></i> Cari
                        </button>
                    </div>
                </form>
            </div>

            <!-- Sort Options -->
            <div class="sort-options">
                <form action="search.jsp" method="GET" class="row g-3">
                    <input type="hidden" name="query" value="<%= searchQuery != null ? searchQuery : "" %>">
                    <input type="hidden" name="location" value="<%= location != null ? location : "" %>">
                    <input type="hidden" name="price_range" value="<%= priceRange != null ? priceRange : "" %>">
                    <input type="hidden" name="type" value="<%= type != null ? type : "" %>">
                    <div class="col-md-3">
                        <select class="form-select" name="sort_by" onchange="this.form.submit()">
                            <option value="">Urutkan berdasarkan</option>
                            <option value="price_asc" <%= "price_asc".equals(sortBy) ? "selected" : "" %>>Harga: Rendah ke Tinggi</option>
                            <option value="price_desc" <%= "price_desc".equals(sortBy) ? "selected" : "" %>>Harga: Tinggi ke Rendah</option>
                            <option value="name_asc" <%= "name_asc".equals(sortBy) ? "selected" : "" %>>Nama: A-Z</option>
                            <option value="name_desc" <%= "name_desc".equals(sortBy) ? "selected" : "" %>>Nama: Z-A</option>
                        </select>
                    </div>
                </form>
            </div>

            <!-- Search Results -->
            <div class="row">
                <% if (kostList.isEmpty()) { %>
                    <div class="col-12">
                        <div class="no-results">
                            <i class="fas fa-search fa-3x mb-3"></i>
                            <h3>Tidak ada hasil yang ditemukan</h3>
                            <p>Coba ubah filter pencarian Anda atau <a href="index.jsp">kembali ke beranda</a></p>
                        </div>
                    </div>
                <% } else { 
                    for (Map<String, String> kost : kostList) { 
                %>
                    <div class="col-md-4">
                        <div class="kost-card">
                            <img class="kost-image" src="<%= kost.get("image_url") != null && !kost.get("image_url").isEmpty() ? kost.get("image_url") : "https://via.placeholder.com/600x400?text=No+Image" %>" alt="<%= kost.get("name") %>">
                            <div class="kost-details">
                                <h3><%= kost.get("name") %></h3>
                                <p class="text-muted"><i class="fas fa-map-marker-alt"></i> <%= kost.get("location") %></p>
                                <p class="kost-price">Rp <%= String.format("%,.0f", Double.parseDouble(kost.get("price"))) %> / bulan</p>
                                
                                <div class="kost-features">
                                    <% 
                                    String[] facilities = kost.get("facilities").split(",");
                                    for (String facility : facilities) {
                                        if (!facility.trim().isEmpty()) {
                                    %>
                                        <span class="feature-badge">
                                            <i class="fas fa-check"></i>
                                            <%= facility.trim() %>
                                        </span>
                                    <% }} %>
                                </div>
                                
                                <a href="kostDetail.jsp?id=<%= kost.get("id") %>" class="btn btn-primary w-100 mt-3">
                                    Lihat Detail
                                </a>
                            </div>
                        </div>
                    </div>
                <% }} %>
            </div>

            <!-- Pagination -->
            <% if (totalPages > 1) { %>
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <% if (page > 1) { %>
                            <li class="page-item">
                                <a class="page-link" href="search.jsp?page=<%= page-1 %>&query=<%= searchQuery != null ? searchQuery : "" %>&location=<%= location != null ? location : "" %>&price_range=<%= priceRange != null ? priceRange : "" %>&type=<%= type != null ? type : "" %>&sort_by=<%= sortBy != null ? sortBy : "" %>">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>
                        <% } %>
                        
                        <% for (int i = 1; i <= totalPages; i++) { %>
                            <li class="page-item <%= i == page ? "active" : "" %>">
                                <a class="page-link" href="search.jsp?page=<%= i %>&query=<%= searchQuery != null ? searchQuery : "" %>&location=<%= location != null ? location : "" %>&price_range=<%= priceRange != null ? priceRange : "" %>&type=<%= type != null ? type : "" %>&sort_by=<%= sortBy != null ? sortBy : "" %>">
                                    <%= i %>
                                </a>
                            </li>
                        <% } %>
                        
                        <% if (page < totalPages) { %>
                            <li class="page-item">
                                <a class="page-link" href="search.jsp?page=<%= page+1 %>&query=<%= searchQuery != null ? searchQuery : "" %>&location=<%= location != null ? location : "" %>&price_range=<%= priceRange != null ? priceRange : "" %>&type=<%= type != null ? type : "" %>&sort_by=<%= sortBy != null ? sortBy : "" %>">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        <% } %>
                    </ul>
                </nav>
            <% } %>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html> 