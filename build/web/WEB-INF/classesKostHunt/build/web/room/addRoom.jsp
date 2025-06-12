<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tambah Kamar Baru</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .container { max-width: 600px; margin-top: 50px; }
    </style>
</head>
<body>
    <%
        // Ambil kostId dari URL parameter untuk disertakan dalam form
        String kostId = request.getParameter("kostId");
    %>
    <div class="container">
        <div class="card">
            <div class="card-header">
                <h3>Form Tambah Kamar Baru</h3>
            </div>
            <div class="card-body">
                <form action="<%= request.getContextPath() %>/addRoom" method="post">
                    
                    <%-- Input tersembunyi untuk membawa kostId ke servlet --%>
                    <input type="hidden" name="kostId" value="<%= kostId %>">
                    
                    <div class="mb-3">
                        <label for="roomNumber" class="form-label">Nomor Kamar</label>
                        <input type="text" class="form-control" id="roomNumber" name="roomNumber" placeholder="Contoh: 101, A2, B-03" required>
                    </div>
                    
                    <%-- Menggunakan dropdown untuk konsistensi dengan form edit --%>
                    <div class="mb-3">
                        <label for="roomType" class="form-label">Tipe Kamar</label>
                        <select class="form-select" id="roomType" name="roomType" required>
                            <option value="" disabled selected>Pilih tipe kamar</option>
                            <option value="Single">Single</option>
                            <option value="Double">Double</option>
                            <option value="VIP (AC + KM Dalam)">VIP (AC + KM Dalam)</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Simpan Kamar</button>
                    <%-- Tombol Batal akan kembali ke halaman daftar kamar untuk kost yang sama --%>
                    <a href="<%= request.getContextPath() %>/roomList?kostId=<%= kostId %>" class="btn btn-secondary">Batal</a>
                </form>
            </div>
        </div>
    </div>
</body>
</html>