<%@page import="models.Room"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Data ini dikirim dari AssignRoomServlet, JSP tidak mengambil data dari DB
    Room roomForPayment = (Room) request.getAttribute("roomForPayment");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Konfirmasi Pembayaran - KostHunt</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Roboto', 'Poppins', sans-serif; background-color: #f4f7f6; }
        .payment-card { max-width: 500px; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="container py-5">
        <div class="row">
            <div class="col-md-10 mx-auto col-lg-7">
                <% if (roomForPayment != null) { %>
                <div class="card shadow-sm payment-card">
                    <div class="card-header text-center p-4">
                        <h3 class="fw-bold mb-0">Konfirmasi Pembayaran Sewa</h3>
                    </div>
                    <div class="card-body p-4">
                        <p class="text-center text-muted">Anda akan menyewa Kamar Nomor <strong><%= roomForPayment.getNumber() %></strong>.</p>
                        <div class="alert alert-info text-center">
                            Total Tagihan Bulan Pertama
                            <h2 class="fw-bold mb-0">Rp <%= String.format("%,.0f", roomForPayment.getPrice()) %></h2>
                        </div>
                        
                        <% if ("invalid_amount".equals(request.getParameter("error"))) { %>
                            <div class="alert alert-danger">Jumlah pembayaran tidak sesuai dengan tagihan!</div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/processPayment" method="post" class="mt-4">
                            <input type="hidden" name="roomId" value="<%= roomForPayment.getId() %>">
                            <input type="hidden" name="expectedAmount" value="<%= roomForPayment.getPrice() %>">
                            <div class="mb-3">
                                <label for="amount" class="form-label">Masukkan Jumlah Pembayaran Sesuai Tagihan</label>
                                <input type="number" class="form-control" id="amount" name="amount" placeholder="Contoh: 1500000" required>
                            </div>
                            <button class="w-100 btn btn-lg btn-primary mt-3" type="submit">Bayar Sekarang</button>
                        </form>
                    </div>
                </div>
                <% } else { %>
                    <div class="alert alert-danger">Gagal memproses data kamar untuk pembayaran. Silakan coba lagi.</div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>