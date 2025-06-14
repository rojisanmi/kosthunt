-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 14, 2025 at 06:20 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `kostmanagement`
--

-- --------------------------------------------------------

--
-- Table structure for table `kost`
--

CREATE TABLE `kost` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) DEFAULT 0.00,
  `location` varchar(255) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `facilities` text DEFAULT NULL,
  `avg_rating` decimal(3,2) NOT NULL DEFAULT 0.00,
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `address` varchar(255) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kost`
--

INSERT INTO `kost` (`id`, `owner_id`, `name`, `description`, `price`, `location`, `type`, `facilities`, `avg_rating`, `image_url`, `created_at`, `address`, `status`) VALUES
(1, 1, 'Kost A', 'Kost nyaman dengan fasilitas lengkap dan lokasi strategis', 1500000.00, 'Bandung', 'Putri', 'AC, WiFi, Kamar Mandi Dalam, Dapur', 4.50, 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80', '2025-06-12 10:02:23', 'Jl. Kost No.1, Bandung', 3),
(2, 1, 'Kost B', 'Kost nyaman dengan fasilitas lengkap dan lokasi strategis', 1200000.00, 'Solo', 'Putra', 'Kamar Mandi Dalam, AC, WiFi', 4.00, 'uploads/efb01649-1be4-403e-9fa9-9534384f8fbb.png', '2025-06-12 10:02:23', 'Jl. Kost No.2, Solo', 1),
(3, 5, 'Kost Cempaka', 'Kost khusus putri dengan lingkungan tenang dan dekat kampus.', 1800000.00, 'Yogyakarta', 'Putri', 'AC, WiFi, Kamar Mandi Dalam, Meja Belajar, Lemari', 4.70, 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80', '2025-06-13 08:00:00', 'Jl. Cempaka No.10, Yogyakarta', 1),
(4, 5, 'Kost Melati', 'Kost campur dengan fasilitas modern dan akses mudah ke pusat kota.', 2000000.00, 'Jakarta', 'Campur', 'AC, WiFi, Kamar Mandi Dalam, Dapur Umum, Parkir', 4.20, 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80', '2025-06-13 08:30:00', 'Jl. Melati Raya No.5, Jakarta Selatan', 1),
(5, 6, 'Kost Anggrek', 'Kost putra strategis dekat area perkantoran.', 1350000.00, 'Surabaya', 'Putra', 'Kamar Mandi Luar, WiFi, Kasur, Lemari', 3.90, 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80', '2025-06-13 09:00:00', 'Jl. Anggrek No.22, Surabaya', 1),
(6, 6, 'Kost Dahlia', 'Kost eksklusif dengan kamar luas dan pemandangan kota.', 2500000.00, 'Bandung', 'Putri', 'AC, Water Heater, Kamar Mandi Dalam, Dapur Pribadi, Balkon', 4.90, 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80', '2025-06-13 09:15:00', 'Jl. Dahlia Indah No.8, Bandung', 1);

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `id` int(11) NOT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`id`, `tenant_id`, `amount`, `payment_date`) VALUES
(1, 2, 1500000.00, '2025-06-01'),
(2, 2, 1200000.00, '2025-06-05'),
(3, 3, 1800000.00, '2025-04-28'),
(4, 4, 2000000.00, '2025-05-10'),
(5, 2, 1350000.00, '2025-05-12'),
(6, 2, 2500000.00, '2025-06-14');

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `id` int(11) NOT NULL,
  `kost_id` int(11) DEFAULT NULL,
  `number` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `price` decimal(10,2) DEFAULT 0.00,
  `rating` decimal(3,1) DEFAULT 0.0,
  `status` enum('Available','Occupied') NOT NULL DEFAULT 'Available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`id`, `kost_id`, `number`, `type`, `price`, `rating`, `status`) VALUES
(1, 1, '101', 'Single', 1500000.00, 5.0, 'Occupied'),
(2, 1, '102', 'Double', 2000000.00, 4.0, 'Available'),
(3, 2, '201', 'Single', 1200000.00, 5.0, 'Occupied'),
(4, 2, '202', 'Double', 1800000.00, 3.0, 'Available'),
(5, 3, '301', 'Single', 1800000.00, 4.8, 'Occupied'),
(6, 3, '302', 'Double', 2500000.00, 4.5, 'Available'),
(7, 4, '401', 'Single', 2000000.00, 4.3, 'Occupied'),
(8, 4, '402', 'Double', 2800000.00, 4.0, 'Available'),
(9, 5, '501', 'Single', 1350000.00, 4.1, 'Occupied'),
(10, 5, '502', 'Double', 1900000.00, 3.8, 'Available'),
(11, 6, '601', 'Single', 2500000.00, 5.0, 'Occupied'),
(12, 6, '602', 'Double', 3500000.00, 4.7, 'Available');

-- --------------------------------------------------------

--
-- Table structure for table `tenant`
--

CREATE TABLE `tenant` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `room_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tenant`
--

INSERT INTO `tenant` (`id`, `user_id`, `room_id`) VALUES
(1, 2, 1),
(2, 3, 3),
(3, 4, 5),
(4, 7, 7),
(5, 8, 9),
(6, 9, 11);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `role` enum('Owner','Tenant') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `phone`, `role`) VALUES
(1, 'John Doe', 'john.doe@example.com', 'password123', '081234567890', 'Owner'),
(2, 'Jane Smith', 'jane.smith@example.com', 'password456', '081234567891', 'Tenant'),
(3, 'Robert Johnson', 'robert.johnson@example.com', 'password789', '081234567892', 'Tenant'),
(4, 'Alice Brown', 'alice.brown@example.com', 'passabc', '081234567893', 'Tenant'),
(5, 'David Lee', 'david.lee@example.com', 'passdef', '081234567894', 'Owner'),
(6, 'Sarah Wilson', 'sarah.wilson@example.com', 'passghi', '081234567895', 'Owner'),
(7, 'Michael Chen', 'michael.chen@example.com', 'passjkl', '081234567896', 'Tenant'),
(8, 'Emily Davis', 'emily.davis@example.com', 'passmno', '081234567897', 'Tenant'),
(9, 'Daniel White', 'daniel.white@example.com', 'passpqr', '081234567898', 'Tenant'),
(10, 'Olivia Green', 'olivia.green@example.com', 'passtuv', '081234567899', 'Tenant'),
(11, 'William Black', 'william.black@example.com', 'passwxy', '081234567800', 'Tenant'),
(12, 'Sophia Blue', 'sophia.blue@example.com', 'passzab', '081234567801', 'Tenant');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `kost`
--
ALTER TABLE `kost`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner_id` (`owner_id`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tenant_id` (`tenant_id`);

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`id`),
  ADD KEY `kost_id` (`kost_id`);

--
-- Indexes for table `tenant`
--
ALTER TABLE `tenant`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `tenant_fk_room` (`room_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `kost`
--
ALTER TABLE `kost`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `room`
--
ALTER TABLE `room`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `tenant`
--
ALTER TABLE `tenant`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `kost`
--
ALTER TABLE `kost`
  ADD CONSTRAINT `kost_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`);

--
-- Constraints for table `room`
--
ALTER TABLE `room`
  ADD CONSTRAINT `room_ibfk_1` FOREIGN KEY (`kost_id`) REFERENCES `kost` (`id`);

--
-- Constraints for table `tenant`
--
ALTER TABLE `tenant`
  ADD CONSTRAINT `tenant_fk_room` FOREIGN KEY (`room_id`) REFERENCES `room` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tenant_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
