# Changelog

Semua perubahan penting pada proyek **SIPTATIF (Sistem Informasi Penjadwalan Tugas Akhir Teknik Informatika)** akan didokumentasikan di dalam file ini.

Format pencatatan ini berdasarkan pada panduan [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), dan versi aplikasi mengikuti standar [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.0.0] - 2026-06-07
### 🚀 Fitur Baru & Peningkatan Desain (Major Update)
Pembaruan skala besar ini difokuskan pada perombakan total *User Interface* (UI) menjadi desain **Premium Glassmorphism**, memberikan sensasi visual ala aplikasi *startup unicorn* modern.
- **Global App Theme**: Implementasi tema gradien neon gelap (*Dark Glass Gradient*) dan terang secara dinamis yang menyesuaikan preferensi perangkat pengguna.
- **Dashboard Statistik Animasi**: Merombak grafik *Pie Chart* dan kartu rekapan data agar berefek tembus pandang (*GlassCard*) dengan animasi *zoom-in* dan meluncur.
- **Logbook Timeline Premium**: Layar jejak logbook mahasiswa sekarang memiliki *background* gradien eksklusif dan efek *staggered animation* (muncul satu per satu berurutan dari samping). Dialog pencatatan bimbingan juga dibalut gaya kaca transparan.
- **Chat Room "iMessage" Style**: Gelembung pesan (*bubble chat*) dosen dan mahasiswa tak lagi kaku. Diganti menggunakan *BackdropFilter* agar terlihat melayang di atas *background* gradien.
- **Pemindai Presensi Sidang (Cyberpunk Scanner)**: Layar `QrScannerScreen` dihiasi animasi garis laser hijau dan efek *neon shadow* ungu yang seakan "bernapas", membuat proses presensi terasa sangat futuristik.
- **Generator QR Code**: `QrGeneratorScreen` sekarang menampilkan barcode QR di dalam kartu kaca melayang (*pop-up glass card*) yang elegan.
- **Dynamic App Versioning**: Mengintegrasikan *package* `package_info_plus` ke dalam `main_screen.dart`. Menu "Tentang Aplikasi" kini otomatis membaca dan menampilkan versi aplikasi asli dari *build Gradle* (tanpa *hardcode*).

### 🐛 Perbaikan Bug & Optimasi (Bug Fixes)
- Memperbaiki peringatan linter (`use_build_context_synchronously`) pada aksi tombol di `main_screen.dart` dengan menambahkan pengecekan `!mounted`.
- Mengganti `Container` yang tidak perlu dengan `SizedBox` pada `qr_generator_screen.dart` untuk mengoptimalkan *rendering layout*.
- Menambahkan *modifier* `const` yang hilang pada beberapa *widget tree* di `qr_scanner_screen.dart` untuk menghemat memori.
- Melakukan *Tree-shaking* pada "MaterialIcons" saat proses kompilasi APK, memangkas ukuran *font asset* dari 1.6MB menjadi 18KB (penghematan ruang penyimpanan sebesar 98.9%).

---

## [1.0.0] - Rilis Perdana
### 🚀 Fitur Awal
- Sistem Autentikasi Pengguna (Login/Register).
- Role Management (Admin/Kaprodi, Dosen Pembimbing, Dosen Penguji, Mahasiswa).
- Pengajuan dan Penjadwalan Sidang Tugas Akhir.
- Pencatatan Nilai Sidang Dosen.
- Ruang Diskusi & *Upload* File (Chat Room & File Picker).
- Generator & Scanner QR Code untuk Presensi.
- Sistem Notifikasi.
