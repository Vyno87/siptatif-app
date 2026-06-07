# SIPTATIF (Sistem Informasi Penjadwalan Tugas Akhir Teknik Informatika)

SIPTATIF adalah aplikasi mobile modern berbasis **Flutter** yang dikembangkan untuk mendigitalisasi dan memfasilitasi seluruh rangkaian proses Tugas Akhir mahasiswa, mulai dari pendaftaran judul proposal, bimbingan digital, pendaftaran sidang, sistem penilaian, hingga pengesahan Yudisium.

> **Dikembangkan Oleh Ahmad Novy Mufasir Untuk Universitas Pamulang**

Aplikasi ini menggunakan desain antarmuka premium **Glassmorphism** untuk memberikan *user experience* terbaik dan dihubungkan ke backend lokal (`json-server`) sebagai representasi *database real-time*.

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

## ⚙️ Stack Teknologi
- **Frontend:** Flutter (Dart) dengan arsitektur `Provider` untuk *State Management*.
- **Desain UI:** *Glassmorphism styling* (blur efek kaca), mode gelap/terang dinamis, navigasi berbasis *drawer* pintar, serta indikator visual untuk tiap peran.
- **Backend (Mocking):** `json-server` (Node.js) untuk menyimpan data ke `db.json` dengan API interaktif (GET, POST, PUT, DELETE).

---

## 🚀 Cara Penggunaan & Testing Aplikasi

1. **Jalankan JSON-Server (Backend)**
   ```bash
   cd backend
   npm run api
   ```
   *Pastikan berjalan di port localhost:3000*

2. **Jalankan Aplikasi Flutter**
   ```bash
   flutter run
   ```

3. **Akun Pengujian (Testing)**
   Aplikasi memiliki akun-akun pengujian berikut yang siap digunakan:
   - **Admin / Koordinator:** `admin@siptatif.com` | Password: `admin12`
   - **Dosen (Budi):** `budi@siptatif.com` | Password: `dosen123`
   - **Dosen (Siti):** `siti@siptatif.com` | Password: `dosen123`
   - **Mahasiswa (Farhan):** `farhan@siptatif.com` | Password: `mhs`

---

## 🤝 Kontribusi
Aplikasi ini dirancang sebagai purwarupa (*prototype*). Anda bebas mengembangkan modul-modul lain di masa depan. Silakan diskusikan di menu *Issues* sebelum melakukan *Pull Request* besar-besaran.
