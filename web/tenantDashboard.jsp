<%@page import="models.*, java.util.*, java.net.URLEncoder"%>
<%
    List<Map<String, Object>> rentalList = (List<Map<String, Object>>) request.getAttribute("rentalList");
    List<Kost> kostList = (List<Kost>) request.getAttribute("kostList");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <title>Dashboard Tenant - KostHunt</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --text-color: #1e293b;
            --light-bg: #f8fafc;
            --warning-color: #f59e0b; /* Warna bintang terisi */
            --star-empty-color: #cbd5e1; /* Warna bintang kosong */
        }
        body { font-family: 'Poppins', sans-serif; background-color: var(--light-bg); }
        .card { border: none; border-radius: 0.75rem; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
        
        /* PERBAIKAN: CSS untuk rating bintang */
        .rating-stars .star {
            cursor: pointer;
            font-size: 1.75rem;
            color: var(--star-empty-color);
            transition: color 0.2s ease-in-out;
        }
        .rating-stars .star:hover,
        .rating-stars .star.hover,
        .rating-stars .star.selected {
            color: var(--warning-color);
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    <div class="container py-5">
        <h2 class="mb-4 fw-bold">Dashboard Anda</h2>
        
        <% if ("success".equals(request.getParameter("rating"))) { %>
            <div class="alert alert-success">Terima kasih atas rating Anda!</div>
        <% } %>
        
        <% if (rentalList != null && !rentalList.isEmpty()) { %>
            <% for (Map<String, Object> rental : rentalList) { 
                Kost rentedKost = (Kost) rental.get("kost");
                Room rentedRoom = (Room) rental.get("room");
            %>
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0 fw-bold"><%= rentedKost.getName() %></h5>
                    </div>
                    <div class="card-body p-4">
                        <div class="row align-items-center">
                            <div class="col-md-7 border-end">
                                <p class="mb-2"><strong>Kamar Anda:</strong></p>
                                <h4 class="mb-3">Nomor <%= rentedRoom.getNumber() %></h4>
                                <a href="kostDetail?id=<%= rentedKost.getId() %>" class="btn btn-sm btn-outline-primary">Lihat Detail Kost</a>
                            </div>
                            <div class="col-md-5">
                                <form action="rateRoom" method="post">
                                    <%-- PERBAIKAN: Nilai default rating adalah 0 --%>
                                    <input type="hidden" name="roomId" value="<%= rentedRoom.getId() %>">
                                    <input type="hidden" name="rating" id="rating-value-<%= rentedRoom.getId() %>" value="<%= (int) rentedRoom.getRating() %>" required>
                                    
                                    <label class="form-label d-block text-center mb-2">Rating</label>
                                    
                                    <%-- PERBAIKAN: Struktur HTML bintang menggunakan ikon 'far fa-star' (kosong) --%>
                                    <div class="rating-stars d-flex justify-content-center mb-3" data-rating-id="<%= rentedRoom.getId() %>">
                                        <i class="far fa-star star" data-value="1"></i>
                                        <i class="far fa-star star" data-value="2"></i>
                                        <i class="far fa-star star" data-value="3"></i>
                                        <i class="far fa-star star" data-value="4"></i>
                                        <i class="far fa-star star" data-value="5"></i>
                                    </div>

                                    <button type="submit" class="btn btn-primary w-100">Kirim Rating</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <%-- (Kode jika tenant belum sewa tidak berubah) --%>
        <% } %>
    </div>
    
    <script>
        // Fungsi updateStars tidak berubah
        function updateStars(stars, value) {
            stars.forEach(star => {
                if (star.dataset.value <= value) {
                    star.classList.remove('far');
                    star.classList.add('fas');
                    star.classList.add('selected'); // <-- TAMBAHKAN INI
                } else {
                    star.classList.remove('fas');
                    star.classList.add('far');
                    star.classList.remove('selected'); // <-- TAMBAHKAN INI
                }
            });
        }
        
        // Fungsi untuk interaksi mouse
        document.querySelectorAll('.rating-stars').forEach(starContainer => {
            const stars = Array.from(starContainer.children);
            const ratingId = starContainer.dataset.ratingId;
            const ratingInput = document.getElementById('rating-value-' + ratingId);
            let currentRating = ratingInput.value; // Simpan rating yang sudah dipilih

            // Event saat mouse berada di atas bintang
            starContainer.addEventListener('mouseover', e => {
                if(e.target.classList.contains('star')) {
                    const hoverValue = e.target.dataset.value;
                    updateStars(stars, hoverValue);
                }
            });

            // Event saat mouse meninggalkan area bintang
            starContainer.addEventListener('mouseleave', () => {
                updateStars(stars, currentRating); // Kembalikan ke rating yang sudah dipilih/disimpan
            });

            // Event saat bintang diklik
            starContainer.addEventListener('click', e => {
                if(e.target.classList.contains('star')) {
                    currentRating = e.target.dataset.value;
                    ratingInput.value = currentRating; // Set nilai ke input tersembunyi
                    updateStars(stars, currentRating);
                }
            });
        });

        // PERBAIKAN: Inisialisasi bintang saat halaman dimuat
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.rating-stars').forEach(starContainer => {
                const ratingId = starContainer.dataset.ratingId;
                const ratingInput = document.getElementById('rating-value-' + ratingId);
                const initialValue = ratingInput.value;
                const stars = Array.from(starContainer.children);
                updateStars(stars, initialValue);
            });
        });
    </script>
</body>
</html>