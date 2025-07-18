-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 09 Jul 2025 pada 14.58
-- Versi server: 10.4.27-MariaDB
-- Versi PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `astacalarescue`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `admins`
--

CREATE TABLE `admins` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username_akun_admin` varchar(255) NOT NULL,
  `password_akun_admin` varchar(255) NOT NULL,
  `nama_lengkap_admin` varchar(255) NOT NULL,
  `tanggal_lahir_admin` varchar(255) NOT NULL,
  `tempat_lahir_admin` varchar(255) NOT NULL,
  `no_anggota` varchar(255) NOT NULL,
  `no_handphone_admin` varchar(25) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `admins`
--

INSERT INTO `admins` (`id`, `username_akun_admin`, `password_akun_admin`, `nama_lengkap_admin`, `tanggal_lahir_admin`, `tempat_lahir_admin`, `no_anggota`, `no_handphone_admin`, `created_at`, `updated_at`) VALUES
(6, '@udin123', '$2y$12$.L6TwOshUvarVJsG9VI9.O/l58e9jith7hxaTtO7jTLvf3JdyjCyW', 'Udinnnn', '2025-06-10', 'Jakarta', 'A-198-KH', '0972754233', '2025-06-27 03:22:02', '2025-06-27 03:22:02'),
(7, 'rusmaneffendi', '$2y$12$AAB8jS7myg27S5UPTNHOw.p7a4ASu0CA25Bej93lN5MqEsGTY5mqO', 'Rusman Effendi', '2025-06-23', 'Jakarta', 'A-978-RR', '0878736645', '2025-06-27 03:52:57', '2025-06-27 03:52:57'),
(8, 'gibranrajaaulia', '$2y$12$je6jRVI5.0NYzXq6wiRjgObQlCEBSyDadJKwhYh6S48WMsD6sNKyu', 'Gibran Raja Aulia Putranami', '2004-05-27', 'Jakarta', 'A-196-KH', '087876649211', '2025-06-27 21:21:57', '2025-06-27 21:21:57'),
(9, 'ahmadfirdaus', '$2y$12$lNAN4GdLQYq9g1Fb2V3lU.YXfdnfTdbCYjobWwaFt/AgJTA6Ju1zG', 'Ahmad Firdaus', '2025-07-24', 'Jakarta', 'A-600-KH', '087177344', '2025-07-08 07:46:06', '2025-07-08 07:46:06'),
(10, 'amidani', '$2y$12$2mMrCEQosIMW3LmdPa2EuukC8qJNsNs1i6Ev2vll0GmWhjgUlyZD2', 'Ami Dani', '2025-07-26', 'Jakarta', 'AM-019-KH', '087866545', '2025-07-08 07:58:04', '2025-07-08 07:58:04');

-- --------------------------------------------------------

--
-- Struktur dari tabel `beritabencana`
--

CREATE TABLE `beritabencana` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `pblk_judul_bencana` varchar(255) NOT NULL,
  `deskripsi_umum` text NOT NULL,
  `pblk_titik_kordinat_bencana` varchar(255) NOT NULL,
  `pblk_lokasi_bencana` varchar(255) NOT NULL,
  `pblk_skala_bencana` enum('kecil','sedang','besar') NOT NULL,
  `dibuat_oleh_admin_id` bigint(20) UNSIGNED NOT NULL,
  `pblk_foto_bencana` varchar(255) NOT NULL,
  `is_published` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `beritabencana`
--

INSERT INTO `beritabencana` (`id`, `created_at`, `updated_at`, `pblk_judul_bencana`, `deskripsi_umum`, `pblk_titik_kordinat_bencana`, `pblk_lokasi_bencana`, `pblk_skala_bencana`, `dibuat_oleh_admin_id`, `pblk_foto_bencana`, `is_published`) VALUES
(12, '2025-06-27 21:30:04', '2025-07-03 08:15:24', 'Bencana Diterjang Godzilla Desa Dayeuhkolot', 'Bencana ini sangat tidak lazim karena Godzilla menyerang desa dayeuhkolot sehingga beberapa akses jalan hancur dan tidak bisa dilalui, dari data korban yang didapatkan terdapat 10 korban yang mengalami luka parah', '7438748\'749294', 'Jl.Sukapura Dayeuhkolot Kabupaten Bandung', 'sedang', 8, 'foto_bencana/x9WhO0a1DGo866nbCbGQTkdxNO4wXDKoD2Wb5TGu.png', 1),
(14, '2025-07-03 22:14:15', '2025-07-03 22:14:18', 'Meteor Bandung', 'adkmkmdkfjf nuhuhu', '838343\'4838845', 'Bandung dayeuhkolot', 'sedang', 8, 'foto_bencana/ZcIJOJeG7nJIgQCaiqHCQGvV6ASFIVjoweQeBeWZ.jpg', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `forumdiskusi`
--

CREATE TABLE `forumdiskusi` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `berita_bencana_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_05_18_084042_create_penggunas_table', 1),
(5, '2025_05_18_084301_create_admins_table', 1),
(6, '2025_05_18_084352_create_pelaporans_table', 1),
(7, '2025_05_21_064552_add_bukti_surat_perintah_tugas_to_pelaporans_table', 2),
(8, '2025_05_30_164758_create_berita_bencana_table', 3),
(9, '2025_05_30_181501_create_pelaporans_table', 4),
(10, '2025_05_31_092422_create_forum_diskusi_table', 5),
(11, '2025_05_31_165740_create_pesan_forumtable', 6),
(12, '2025_06_02_051202_create_notifikasi_table', 7),
(13, '2025_06_13_163750_create_berita_bencanas_table', 8),
(14, '2025_06_19_065614_create_pelaporan_table', 8),
(15, '2025_07_01_133951_add_status_notifikasi_to_pelaporans_table', 9),
(16, '2025_07_03_141351_add_publish_button_to_table_beritabencana', 10),
(17, '2025_07_05_150013_add_status_verifikasi_to_pelaporans_table', 11);

-- --------------------------------------------------------

--
-- Struktur dari tabel `notifikasi`
--

CREATE TABLE `notifikasi` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `judul_notifikasi` varchar(255) NOT NULL,
  `deskripsi_notifikasi` text NOT NULL,
  `waktu_kirim` timestamp NOT NULL DEFAULT current_timestamp(),
  `tipe_notifikasi` enum('balasan_komentar','berita','verifikasi_laporan') NOT NULL,
  `penerima_notifikasi_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pelaporans`
--

CREATE TABLE `pelaporans` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama_team_pelapor` varchar(255) NOT NULL,
  `jumlah_personel` int(11) NOT NULL,
  `informasi_singkat_bencana` varchar(255) NOT NULL,
  `lokasi_bencana` varchar(255) NOT NULL,
  `foto_lokasi_bencana` varchar(255) DEFAULT NULL,
  `titik_kordinat_lokasi_bencana` varchar(255) NOT NULL,
  `skala_bencana` varchar(255) NOT NULL,
  `jumlah_korban` int(11) NOT NULL,
  `bukti_surat_perintah_tugas` varchar(255) DEFAULT NULL,
  `deskripsi_terkait_data_lainya` text DEFAULT NULL,
  `status_verifikasi` enum('PENDING','DITERIMA','DITOLAK') NOT NULL DEFAULT 'PENDING',
  `pelapor_pengguna_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `status_notifikasi` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `pelaporans`
--

INSERT INTO `pelaporans` (`id`, `nama_team_pelapor`, `jumlah_personel`, `informasi_singkat_bencana`, `lokasi_bencana`, `foto_lokasi_bencana`, `titik_kordinat_lokasi_bencana`, `skala_bencana`, `jumlah_korban`, `bukti_surat_perintah_tugas`, `deskripsi_terkait_data_lainya`, `status_verifikasi`, `pelapor_pengguna_id`, `created_at`, `updated_at`, `status_notifikasi`) VALUES
(1, 'Astacala Rescue', 6, 'Bencana Gempa Cisompet', 'Garut Cisompet Jawa Barat', 'gempa_cisompet.jpg', '1223424\'342242', 'Sedang', 5, 'bukti.jpg', 'Gempanya parang benerrrrrr', 'DITERIMA', 4, NULL, '2025-07-06 01:34:58', 1),
(3, 'Gemarawana Rescue', 10, 'Banjir Dyeuhkolot Bandung', 'Dyeuhkolot Sukapura Bandung', 'foto9.jpg', '288211\'94747', 'Sedang', 2, 'foto.jpg', 'Bencana parah banget, akses jalan sulit untuk dilewati', 'DITERIMA', 4, NULL, '2025-07-06 01:53:06', 1),
(4, 'Perimatrik Rescue', 6, 'Gempa Bandung', 'Bandung Jawa Barat', 'goks.jpg', '7267683\'8728387', 'Besar', 4, 'dart.jpg', 'Kacaw Men', 'DITERIMA', 1, NULL, '2025-07-06 03:14:25', 1),
(5, 'Perim', 5, 'Gempa Bandung', 'kkkkkkk', 'aaaaaa', '232323\'54456', 'Besar', 3, 'jajja.jpg', 'aaaaaaa', 'PENDING', 1, NULL, '2025-07-01 10:29:09', 1),
(11, 'BPBD Depok', 10, 'Gempa Cisompet Garut', 'Cisompet Garut Jawa Barat', 'foto.jpg', '-7.551574710520868, 107.81053947248678', 'Sedang', 8, 'ahhaa.jpg', 'ssssssss', 'PENDING', 1, NULL, '2025-07-07 02:27:23', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `penggunas`
--

CREATE TABLE `penggunas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username_akun_pengguna` varchar(255) NOT NULL,
  `password_akun_pengguna` varchar(255) NOT NULL,
  `nama_lengkap_pengguna` varchar(255) NOT NULL,
  `tanggal_lahir_pengguna` varchar(255) NOT NULL,
  `tempat_lahir_pengguna` varchar(255) NOT NULL,
  `no_handphone_pengguna` varchar(15) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `penggunas`
--

INSERT INTO `penggunas` (`id`, `username_akun_pengguna`, `password_akun_pengguna`, `nama_lengkap_pengguna`, `tanggal_lahir_pengguna`, `tempat_lahir_pengguna`, `no_handphone_pengguna`, `created_at`, `updated_at`) VALUES
(1, 'mikailgabriel', 'mikail12345', 'Muhammad Mikail Gabriel', '27 Agustus 2003', 'Bekasi', '08786472893725', NULL, '2025-05-19 22:41:37'),
(4, 'saifulrusmayadi', 'saiful12345', 'Saiful Rusmayadi', '08 Januari 2001', 'Jakarta', '087572763645', NULL, NULL),
(5, 'Ayyubi lisdianto', 'ayyub33333', 'Ayyubi Lisdianto', '17 Maret 2002', 'Depok', '08587524369', NULL, '2025-05-19 22:31:26');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pesanforum`
--

CREATE TABLE `pesanforum` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `forum_diskusi_id` bigint(20) UNSIGNED NOT NULL,
  `pengirim_pengguna_id` bigint(20) UNSIGNED NOT NULL,
  `parent_pesan_id` bigint(20) UNSIGNED DEFAULT NULL,
  `isi_pesan` text NOT NULL,
  `waktu_kirim` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('NCE4B8cCuAv74fXSr3fmtCvtRuWH6Ygw8pnYSNMz', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRVh0eHpmc2tVMGM1V1VHZzRrOVVBZ2NlOWdVVXBtcTQwTTBLblU0ZiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJuZXciO2E6MDp7fXM6Mzoib2xkIjthOjA6e319czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjc6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9sb2dpbiI7fX0=', 1751988209);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admins_username_akun_admin_unique` (`username_akun_admin`);

--
-- Indeks untuk tabel `beritabencana`
--
ALTER TABLE `beritabencana`
  ADD PRIMARY KEY (`id`),
  ADD KEY `beritabencana_dibuat_oleh_admin_id_foreign` (`dibuat_oleh_admin_id`);

--
-- Indeks untuk tabel `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indeks untuk tabel `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indeks untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indeks untuk tabel `forumdiskusi`
--
ALTER TABLE `forumdiskusi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `forumdiskusi_berita_bencana_id_foreign` (`berita_bencana_id`);

--
-- Indeks untuk tabel `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indeks untuk tabel `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifikasi_penerima_notifikasi_id_foreign` (`penerima_notifikasi_id`);

--
-- Indeks untuk tabel `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indeks untuk tabel `pelaporans`
--
ALTER TABLE `pelaporans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pelaporans_pelapor_pengguna_id_foreign` (`pelapor_pengguna_id`);

--
-- Indeks untuk tabel `penggunas`
--
ALTER TABLE `penggunas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `penggunas_username_akun_pengguna_unique` (`username_akun_pengguna`);

--
-- Indeks untuk tabel `pesanforum`
--
ALTER TABLE `pesanforum`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pesanforum_forum_diskusi_id_foreign` (`forum_diskusi_id`),
  ADD KEY `pesanforum_pengirim_pengguna_id_foreign` (`pengirim_pengguna_id`),
  ADD KEY `pesanforum_parent_pesan_id_foreign` (`parent_pesan_id`);

--
-- Indeks untuk tabel `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `admins`
--
ALTER TABLE `admins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `beritabencana`
--
ALTER TABLE `beritabencana`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `forumdiskusi`
--
ALTER TABLE `forumdiskusi`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT untuk tabel `notifikasi`
--
ALTER TABLE `notifikasi`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pelaporans`
--
ALTER TABLE `pelaporans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT untuk tabel `penggunas`
--
ALTER TABLE `penggunas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `pesanforum`
--
ALTER TABLE `pesanforum`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `beritabencana`
--
ALTER TABLE `beritabencana`
  ADD CONSTRAINT `beritabencana_dibuat_oleh_admin_id_foreign` FOREIGN KEY (`dibuat_oleh_admin_id`) REFERENCES `admins` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `forumdiskusi`
--
ALTER TABLE `forumdiskusi`
  ADD CONSTRAINT `forumdiskusi_berita_bencana_id_foreign` FOREIGN KEY (`berita_bencana_id`) REFERENCES `beritabencana` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD CONSTRAINT `notifikasi_penerima_notifikasi_id_foreign` FOREIGN KEY (`penerima_notifikasi_id`) REFERENCES `penggunas` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pelaporans`
--
ALTER TABLE `pelaporans`
  ADD CONSTRAINT `pelaporans_pelapor_pengguna_id_foreign` FOREIGN KEY (`pelapor_pengguna_id`) REFERENCES `penggunas` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pesanforum`
--
ALTER TABLE `pesanforum`
  ADD CONSTRAINT `pesanforum_forum_diskusi_id_foreign` FOREIGN KEY (`forum_diskusi_id`) REFERENCES `forumdiskusi` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `pesanforum_parent_pesan_id_foreign` FOREIGN KEY (`parent_pesan_id`) REFERENCES `pesanforum` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `pesanforum_pengirim_pengguna_id_foreign` FOREIGN KEY (`pengirim_pengguna_id`) REFERENCES `penggunas` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
