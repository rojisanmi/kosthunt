# KostHunt

Aplikasi manajemen kos sederhana berbasis Java Servlet, JSP, dan MySQL. KostHunt membantu Owner mengelola data kos, kamar, dan tenant; sekaligus memudahkan Tenant melakukan pencarian, pemesanan, dan pembayaran.

## ✨ Fitur Utama

1. Autentikasi & otorisasi (Owner/Tenant)
   - Login
   - Logout
   - Register

2. Manajemen Owner
   - Tambah / edit / hapus Kost
   - Tambah / edit / hapus Room
   - Kelola Tenant (assign/remove)
   - View daftar tenant
   - Lihat proses pembayaran tenant

3. Fitur Tenant
   - Lihat daftar Kost
   - Detail Kos dan kamar
   - Search kos berdasarkan lokasi / nama
   - Rate Room
   - Payment flow / konfirmasi pembayaran

4. Dashboard terpisah
   - `ownerDashboard` untuk pemilik
   - `tenantDashboard` untuk penghuni

5. Database: MySQL
   - Tabel utama `Users`, `Kost`, `Room`, `TenantInfo`, `PaymentInfo`, etc.

## 🛠️ Teknologi

- Java Servlet (HttpServlet)
- JSP (Java Server Pages)
- Apache Tomcat / J2EE container
- JDBC (koneksi database MySQL)
- MySQL
- HTML/CSS/JavaScript (JSP frontend)

## 📁 Struktur Proyek

- `src/java/models`: Entity model (Kost, Room, User, TenantInfo, PaymentInfo)
- `src/java/servlets`: Logika kontrol (LoginServlet, AddKostServlet, EditRoomServlet, dll.)
- `web/`: JSP tampilan + konfigurasi web (`web.xml`)
- `src/conf`: Manifest dan metadata
- `kostmanagement.sql`: Basis data schema + seed data (opsional)

## 🚀 Setup & Run

1. Clone / salin folder `kosthunt` ke environment Anda.
2. Jalankan MySQL, buat database (misal: `kosthuntdb`).
3. Restore SQL schema dari `kostmanagement.sql`.
4. Buka `src/java/classes/JDBC.java`, atur `url`, `user`, `password` MySQL.
5. Deploy ke Tomcat (copy project WAR/ folder ke `webapps`), atau dari IDE (NetBeans, Eclipse).
6. Akses:
   - `http://localhost:8080/kosthunt/login.jsp`
   - `http://localhost:8080/kosthunt/register.jsp`

## 🧾 Database (contoh tabel)

- `Users`: `id`, `name`, `email`, `password`, `role`, ...
- `Kost`: `id`, `ownerId`, `name`, `description`, `price`, `location`, `facilities`, `status`, `avgRating`
- `Room`: `id`, `kostId`, `name`, `price`, `status`, `tenantId`
- `TenantInfo`, `PaymentInfo` untuk manajemen data tindak lanjut

## 🔐 Keamanan & Peningkatan

- Saat ini password belum di-hash (plain text) -> sebaiknya ditingkatkan dengan bcrypt/sha.
- Validasi input masih terbatas; perlu sanitasi / proteksi SQL injection.
- Bisa dikembangkan API RESTful, Vue/React frontend, pagination, upload gambar.

## 🧩 Alur (Workflow)

1. User register -> role `Owner` atau `Tenant`.
2. Login -> redirect ke `ownerDashboard` atau `tenantDashboard`.
3. Owner menambah Kost, digitalisasi detail dan kamar.
4. Tenant mencari Kost, memilih kamar, bayar via `ProcessPaymentServlet`.
5. Owner konfirmasi pembayaran via `PaymentListServlet`.

## 💡 Catatan Spesifik

- `KostListServlet` membaca data kos untuk `tenantDashboard`.
- `LoginServlet` menggunakan `Users` table dan mengeset session attribute `role`.
- View JSP di `web/` (utama) dan `web/room` / `web/kost` untuk CRUD.

---

**Selamat!** README ini mendeskripsikan secara detail dan memberikan pemula dan maintainer panduan lengkap untuk menjalankan dan mengembangkan aplikasi KostHunt.
