<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    String user = (String) session.getAttribute("user");
    Map<String, String> userData = new HashMap<String, String>();
    
    if (user != null) {
        try {
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
        transition: all 0.3s ease;
    }

    .nav-link:hover {
        opacity: 0.8;
    }

    .dropdown-menu {
        border: none;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .dropdown-item {
        padding: 0.5rem 1rem;
        color: var(--text-color);
    }

    .dropdown-item:hover {
        background-color: var(--light-gray);
    }

    .dropdown-item i {
        margin-right: 0.5rem;
        color: var(--primary-color);
    }
</style>

<!-- Navigation -->
<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/index.jsp" style="text-decoration: none; color: inherit;">KostHunt</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <% if (user != null) { %>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user"></i> <%= userData.get("name") != null ? userData.get("name") : user %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="<%= request.getContextPath() %>/profile">
                                <i class="fas fa-user-circle"></i> Profile
                            </a></li>
                            <% if ("Owner".equals(userData.get("role"))) { %>
                                <li><a class="dropdown-item" href="<%= request.getContextPath() %>/ownerDashboard">
                                    <i class="fas fa-home"></i> Dashboard
                                </a></li>
                            <% } %>
                            <% if ("Tenant".equals(userData.get("role"))) { %>
                                <li><a class="dropdown-item" href="<%= request.getContextPath() %>/tenantDashboard">
                                    <i class="fas fa-home"></i> Dashboard
                                </a></li>
                            <% } %>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="<%= request.getContextPath() %>/logout.jsp">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a></li>
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