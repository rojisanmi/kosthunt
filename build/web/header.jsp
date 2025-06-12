<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
<<<<<<< HEAD
    String user = (String) session.getAttribute("user");
    Map<String, String> userData = new HashMap<>();
    
    if (user != null) {
        try {
            // Database connection parameters
            String dbUrl = "jdbc:mysql://localhost:3306/kostmanagement";
            String dbUser = "root";
            String dbPassword = "";
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            
            String sql = "SELECT name, role FROM users WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, user);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                userData.put("name", rs.getString("name"));
                userData.put("role", rs.getString("role"));
            }
            
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
=======
    // Mengambil data dari SESI, bukan dari database lagi
    String userEmail = (String) session.getAttribute("user");
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("role");
>>>>>>> 73b55e00d26a1a1089f3788d990673763496fd5e
%>
<style>
    :root {
        --primary-color: #4A90E2;
        --secondary-color: #357ab7;
        --text-color: #333;
        --light-gray: #f8f9fa;
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
    }
    .dropdown-menu {
        border: none;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .dropdown-item i {
        margin-right: 0.5rem;
        color: var(--primary-color);
    }
</style>

<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/index.jsp">KostHunt</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <%-- PERBAIKAN: Menggunakan variabel userEmail untuk pengecekan --%>
                <% if (userEmail != null) { %>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user"></i> 
                            <%-- PERBAIKAN: Menampilkan userName dari sesi --%>
                            <%= (userName != null) ? userName : userEmail %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li>
                                <a class="dropdown-item" href="<%= request.getContextPath() %>/profile">
                                    <i class="fas fa-user-circle"></i> Profile
                                </a>
                            </li>
                            <%-- PERBAIKAN: Mengecek userRole dari sesi --%>
                            <% if ("Owner".equals(userRole)) { %>
                                <li>
                                    <a class="dropdown-item" href="<%= request.getContextPath() %>/ownerDashboard">
                                        <i class="fas fa-home"></i> Dashboard
                                    </a>
                                </li>
                            <% } %>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <a class="dropdown-item" href="<%= request.getContextPath() %>/logout">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                                </a>
                            </li>
                        </ul>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/login.jsp">
                            <i class="fas fa-sign-in-alt"></i> Masuk
                        </a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>