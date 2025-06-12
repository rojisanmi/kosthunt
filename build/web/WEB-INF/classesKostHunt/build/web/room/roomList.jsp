<%@page import="models.Room"%>
<%@page import="models.Kost"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Kelola Kamar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <%
        Kost kost = (Kost) request.getAttribute("kost");
        List<Room> roomList = (List<Room>) request.getAttribute("roomList");
    %>
    <div class="container mt-4">

        <%-- PERBAIKAN 1: Tambahkan blok 'if' untuk memeriksa apakah 'kost' ada --%>
        <% if (kost != null) { %>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <a href="<%= request.getContextPath() %>/ownerDashboard" class="btn btn-secondary"><i class="bi bi-arrow-left"></i> Kembali ke Dashboard</a>
                <h2 class="mt-2">Kelola Kamar untuk: <strong><%= kost.getName() %></strong></h2>
            </div>
            
            <%-- PERBAIKAN 2: Arahkan ke addRoom.jsp dan gunakan contextPath --%>
            <%-- Untuk 'Tambah', mengarah ke JSP bisa diterima karena formnya kosong --%>
            <a href="<%= request.getContextPath() %>/room/addRoom.jsp?kostId=<%= kost.getId() %>" class="btn btn-primary"><i class="bi bi-plus-circle"></i> Tambah Kamar</a>
        </div>

        <div class="card">
            <div class="card-body">
                <table class="table table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th scope="col">#</th>
                            <th scope="col">Nomor Kamar</th>
                            <th scope="col">Tipe Kamar</th>
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
                            <td class="text-end">
                                <a href="<%= request.getContextPath() %>/editRoom?roomId=<%= room.getId() %>" class="btn btn-warning btn-sm"><i class="bi bi-pencil-square"></i> Edit</a>
                                <a href="<%= request.getContextPath() %>/deleteRoom?roomId=<%= room.getId() %>&kostId=<%= room.getKostId() %>" class="btn btn-danger btn-sm" onclick="return confirm('Yakin ingin menghapus kamar ini?');"><i class="bi bi-trash3"></i> Hapus</a>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr>
                            <td colspan="4" class="text-center text-muted">Belum ada data kamar. Silakan tambahkan.</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- Penutup untuk blok 'if' --%>
        <% } else { %>
            <div class="alert alert-danger" role="alert">
                Data Kost tidak ditemukan. Silakan kembali ke <a href="<%= request.getContextPath() %>/ownerDashboard">dashboard</a>.
            </div>
        <% } %>
    </div>
</body>
</html>