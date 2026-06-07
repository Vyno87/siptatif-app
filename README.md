# SIPTATIF (Sistem Informasi Penjadwalan Tugas Akhir Teknik Informatika)

SIPTATIF adalah aplikasi mobile modern berbasis **Flutter** yang dikembangkan untuk mendigitalisasi dan memfasilitasi seluruh rangkaian proses Tugas Akhir mahasiswa, mulai dari pendaftaran judul proposal, bimbingan digital, pendaftaran sidang, sistem penilaian, hingga pengesahan Yudisium.

> **Dikembangkan Oleh Ahmad Novy Mufasir Untuk Universitas Pamulang**

Aplikasi ini menggunakan desain antarmuka premium **Glassmorphism** untuk memberikan *user experience* terbaik dan telah terhubung secara global (*Cloud-based*) melalui infrastruktur **Vercel Serverless** dan **MongoDB Atlas**.

---

## 👥 Multi-Role Akses (Hak Akses Pengguna)
Sistem ini memfasilitasi tiga peran pengguna yang saling terintegrasi:
1. **Koordinator / Admin:** Bertugas mengelola data utama, menetapkan dosen, menyetujui judul, menjadwalkan sidang, hingga mengesahkan kelulusan yudisium.
2. **Dosen (Pembimbing & Penguji):** Dosen memiliki layar *dashboard* khusus untuk melihat mahasiswa bimbingannya, menyetujui logbook progres, memasukkan nilai sidang digital, dan memvalidasi dokumen yudisium.
3. **Mahasiswa:** Menggunakan aplikasi untuk mendaftar judul TA, mengisi jurnal bimbingan harian (logbook), memantau jadwal sidang, melihat nilai, dan mendaftar kelulusan yudisium.

---

## ✨ Fitur Utama

### 1. Manajemen Pendaftaran Tugas Akhir
- **Pengajuan Judul:** Mahasiswa dapat mendaftarkan usulan judul TA dan calon dosen pembimbing beserta dokumen pendukung.
- **Validasi Berkas:** Admin dapat memberikan status (Diterima / Ditolak / Direvisi) beserta catatan mendetail langsung ke mahasiswa.

### 2. Logbook Digital Bimbingan
- **Catatan Bimbingan:** Mahasiswa tidak perlu lagi logbook fisik. Mereka dapat merekam progres bimbingan TA di aplikasi.
- **Persetujuan Pembimbing:** Dosen pembimbing dapat menyetujui atau meminta revisi catatan logbook milik mahasiswa perwaliannya secara *real-time*.

### 3. Pendaftaran & Penjadwalan Sidang
- **Pengajuan Ujian:** Mahasiswa yang sudah menyelesaikan bimbingan bisa mengirimkan form pengajuan pendaftaran sidang.
- **Sistem Penjadwalan Pintar:** Admin mengatur ruangan, waktu, tanggal, dan dosen penguji. Terdapat sistem pengecekan bentrok (konflik) agar dosen penguji tidak terjadwal di dua ruangan pada waktu yang bersamaan.

### 4. Sistem Penilaian Digital (Borang Elektronik)
- Dosen penguji dan pembimbing langsung memasukkan nilai sidang secara *live* melalui aplikasi.
- Sistem akan otomatis menjumlahkan, mencari rata-rata, dan menetapkan predikat kelulusan mahasiswa.

### 5. Manajemen Yudisium (Finalisasi Kelulusan)
- Fitur penutup di mana mahasiswa yang telah lulus sidang dapat mengunggah **Dokumen Revisi Final**.
- Melibatkan persetujuan berlapis: Dosen pembimbing memvalidasi dokumen revisi -> Admin mengesahkan Kelulusan Yudisium.
- Tampilan eksklusif perayaan kelulusan dan cetak dokumen Berita Acara untuk mahasiswa yang berhasil lulus.

---

## ⚙️ Stack Teknologi (Cloud Architecture)
- **Frontend:** Flutter (Dart) dengan arsitektur `Provider` untuk *State Management*.
- **Desain UI:** *Glassmorphism styling* (blur efek kaca), mode gelap/terang dinamis, navigasi berbasis *drawer* pintar, serta indikator visual.
- **Backend API:** **Vercel Serverless Functions** (Node.js & Express). Skalabel dan tanpa perlu mengatur server fisik.
- **Database:** **MongoDB Atlas** (NoSQL). Cepat, aman, dan bisa diakses dari mana saja.

---

## 🚀 Cara Penggunaan & Testing Aplikasi

1. **Unduh atau Jalankan Aplikasi Flutter**
   Karena *database* sudah berbasis *Cloud*, Anda tidak perlu menjalankan *server* lokal lagi. Cukup jalankan aplikasi:
   ```bash
   flutter run
   ```
   Atau pasang *file* `app-release.apk` langsung ke HP Android Anda.

2. **Akun Pengujian (Testing)**
   Aplikasi memiliki akun-akun pengujian berikut yang siap digunakan:
   - **Admin / Koordinator:** `admin@siptatif.com` | Password: `admin12`
   - **Dosen (Budi):** `budi@siptatif.com` | Password: `dosen123`
   - **Dosen (Siti):** `siti@siptatif.com` | Password: `dosen123`
   - **Mahasiswa (Farhan):** `farhan@siptatif.com` | Password: `mhs`

---

## ☁️ Deployment Info
Aplikasi ini di-*hosting* di:
- **API URL:** `https://siptatif-app-iota.vercel.app`
- **Database:** `Cluster0.nr0mnpe.mongodb.net` (siptatif_db)

---

## 🤝 Kontribusi
Aplikasi ini dirancang sebagai sistem terintegrasi yang siap pakai. Anda bebas mengembangkan modul-modul lain di masa depan. Silakan diskusikan di menu *Issues* sebelum melakukan *Pull Request* besar-besaran.
