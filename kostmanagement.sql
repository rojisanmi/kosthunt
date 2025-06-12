-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 12, 2025 at 05:27 PM
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
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `address` varchar(255) NOT NULL,
  `status` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kost`
--

INSERT INTO `kost` (`id`, `owner_id`, `name`, `description`, `price`, `location`, `type`, `facilities`, `image_url`, `created_at`, `address`, `status`) VALUES
(1, 1, 'Kost A', 'Kost nyaman dengan fasilitas lengkap dan lokasi strategis', 1500000.00, 'Jl. Kost No.1, Depok', 'Putri', 'AC, WiFi, Kamar Mandi Dalam, Dapur', 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80', '2025-06-12 10:02:23', 'Jl. Kost No.1, Depok', 3),
(2, 1, 'Kost B', 'Kost nyaman dengan fasilitas lengkap dan lokasi strategis', 1200000.00, 'Jl. Kost No.2, Depok', 'Putra', 'AC, WiFi, Kamar Mandi Dalam, Dapur', 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80', '2025-06-12 10:02:23', 'Jl. Kost No.2, Depok', 1),
(3, 1, 'Kost C', 'sasa', 100000.00, 'sas', 'Putra', 'Kamar Mandi Dalam, Dapur', '', '2025-06-12 11:35:04', 'kottol5', 1),
(4, 5, 'Kost D', 'ewe', 1000000.00, 'sas', 'Campur', 'Kamar Mandi Dalam, AC', '', '2025-06-12 11:55:33', 'ewew', 1),
(5, 6, 'Kost Banjir', 'deket telkom', 2000000.00, 'mantaplah pokoknya', 'Putra', 'Kamar Mandi Dalam, AC, WiFi, Dapur, Parkir, CCTV', 'https://example.com/image.jpg', '2025-06-12 12:17:53', 'Jl. Sukabirus', 1),
(6, 1, 'Kost Banjir', 'ewe', 1999999.00, 'mantaplah pokoknya', 'Putra', 'Kamar Mandi Dalam, Dapur', 'https://example.com/image.jpg', '2025-06-12 12:32:27', 'ewe', 1);

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
(1, 1, 500000.00, '2025-05-01'),
(2, 2, 600000.00, '2025-05-01');

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
  `status` enum('Available','Occupied') NOT NULL DEFAULT 'Available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`id`, `kost_id`, `number`, `type`, `price`, `status`) VALUES
(1, 1, '101', 'Single', 1500000.00, 'Available'),
(2, 1, '102', 'Double', 2000000.00, 'Available'),
(3, 2, '201', 'Single', 1200000.00, 'Available'),
(4, 2, '202', 'Double', 1800000.00, 'Available'),
(6, 3, '69', 'Double', 0.00, 'Available');

-- --------------------------------------------------------

--
-- Table structure for table `tenant`
--

CREATE TABLE `tenant` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `kost_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tenant`
--

INSERT INTO `tenant` (`id`, `user_id`, `kost_id`) VALUES
(1, 2, 1),
(2, 3, 2);

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
(4, 'admin', 'admin@gmail.com', 'admin123', '081234567893', 'Tenant'),
(5, 'admin3', 'admin3@gmail.com', '123', NULL, 'Owner'),
(6, 'ewe', 'ewe@ewe.com', 'ewe', NULL, 'Owner');

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
  ADD KEY `kost_id` (`kost_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `room`
--
ALTER TABLE `room`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tenant`
--
ALTER TABLE `tenant`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
  ADD CONSTRAINT `tenant_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `tenant_ibfk_2` FOREIGN KEY (`kost_id`) REFERENCES `kost` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
