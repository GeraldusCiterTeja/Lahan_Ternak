# 🐮 Lahan Ternak (Lahan_Ternak)

**Lahan Ternak** adalah aplikasi *mobile* berbasis Flutter yang dirancang untuk memudahkan manajemen peternakan secara umum. Aplikasi ini berfungsi sebagai buku digital untuk mencatat dan mendata hewan ternak, menggantikan pencatatan manual yang rentan hilang atau rusak.

---

## 📱 Fitur Aplikasi

### ✅ Fitur Saat Ini
Fokus utama aplikasi saat ini adalah **Pencatatan Hewan Ternak (Livestock Recording)**:
* **Input Data Ternak**: Menambahkan data hewan baru (ID/Tag, jenis hewan, status).
* **List Data Ternak**: Melihat daftar seluruh hewan yang ada di peternakan.
* **Detail Hewan**: Melihat informasi spesifik dari satu hewan.
* **Manajemen Data**: Mengubah (Update) atau menghapus (Delete) data hewan yang sudah tidak ada.

### 🔜 Rencana Pengembangan (Roadmap)
Fitur-fitur berikut direncanakan untuk pengembangan selanjutnya guna melengkapi ekosistem manajemen peternakan:
* [ ] **Manajemen Kesehatan**: Jadwal vaksinasi, riwayat penyakit, dan pengobatan.
* [ ] **Manajemen Pakan**: Jadwal pemberian pakan dan inventaris stok pakan.
* [ ] **Laporan Keuangan**: Pencatatan biaya operasional dan keuntungan penjualan.
* [ ] **Analitik & Grafik**: Visualisasi pertumbuhan populasi ternak.

---

## 🛠️ Teknologi yang Digunakan

Aplikasi ini dibangun menggunakan kombinasi teknologi berikut:

**Frontend (Mobile App):**
* **Framework**: [Flutter](https://flutter.dev/)
* **Language**: Dart

**Backend & Database:**
* **Database**: MySQL
* **Management Tool**: phpMyAdmin
* **Local Server Environment**: [Laragon](https://laragon.org/) (Apache/Nginx + MySQL)

---

## 🚀 Cara Instalasi & Menjalankan (Getting Started)

Karena aplikasi ini menggunakan database lokal (MySQL via Laragon), Anda perlu menyiapkan sisi server dan aplikasi mobile.

### 1. Persiapan Backend (Database)
1.  Pastikan **Laragon** sudah terinstall dan berjalan (Start All).
2.  Buka **phpMyAdmin** melalui Laragon.
3.  Buat database baru dengan nama `db_lahan_ternak` (atau sesuaikan dengan konfigurasi di kodingan).
4.  Import file SQL database (jika ada file `.sql` di folder project) atau buat tabel sesuai struktur data aplikasi.

### 2. Konfigurasi Koneksi Flutter
Agar aplikasi di Emulator/HP fisik bisa membaca database di Laragon komputer:
1.  Cek IP Address komputer Anda (buka CMD, ketik `ipconfig`). Contoh: `192.168.1.10`.
2.  Buka file konfigurasi API di project Flutter (biasanya di `lib/config/api_config.dart` atau sejenisnya).
3.  Ubah `localhost` menjadi IP Address komputer Anda.
    * *Contoh URL:* `http://192.168.1.10/lahan_ternak_api/`

### 3. Menjalankan Aplikasi Flutter
1.  Buka terminal di root folder proyek.
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Jalankan aplikasi:
    ```bash
    flutter run
    ```

---

## 📂 Struktur Folder Utama

```text
lib/
├── models/         # Model data (sesuai tabel MySQL)
├── screens/        # Halaman UI (Input, List, Detail)
├── services/       # Logika koneksi ke API/Database (HTTP Request)
├── widgets/        # Komponen UI yang dapat digunakan kembali
└── main.dart       # Titik awal aplikasi