☕ Green Cafe App

Green Cafe adalah aplikasi mobile pemesanan kopi modern yang dibangun menggunakan Flutter. Aplikasi ini dirancang untuk memberikan pengalaman pengguna yang mulus dalam menjelajahi menu, mengelola pesanan, dan menyimpan item favorit.

Proyek ini mengimplementasikan konsep RESTful API menggunakan MockAPI untuk manajemen data pengguna dan produk, serta menerapkan arsitektur kode yang bersih (clean code) dengan pemisahan logika Admin dan Customer.

📱 Fitur Utama

Aplikasi ini memiliki dua peran pengguna (role) dengan fitur yang berbeda:

🌟 Fitur Umum

Onboarding Screen: Layar sambutan interaktif saat pertama kali membuka aplikasi.

Autentikasi (Login & Register):

Login dengan validasi email & password.

Register akun baru dengan fitur toggle visibility password.

Pemisahan otomatis antara halaman Admin dan Customer berdasarkan role.

👤 Fitur Customer (Pelanggan)

Dashboard: Menampilkan banner promo, kategori (filter), dan daftar produk grid.

Pencarian (Search): Mencari kopi berdasarkan nama secara real-time dari API.

Detail Produk: Melihat gambar besar, deskripsi, dan harga.

Keranjang (Cart): Menambahkan item ke keranjang dan melihat ringkasan belanja.

Checkout & Struk: Simulasi pembayaran dan menampilkan struk digital.

Favorit (Wishlist): Menandai produk kesukaan.

Riwayat Pesanan: Melihat daftar pesanan yang pernah dibuat (lokal).

Profil: Melihat data diri pengguna yang sedang login.

🛠 Fitur Admin

Admin Dashboard: Melihat seluruh daftar produk yang tersedia di server.

CRUD Produk:

Create: Menambah menu kopi baru.

Read: Melihat daftar menu.

Update: Mengedit data menu (harga, nama, gambar, deskripsi).

Delete: Menghapus menu dari server.

🛠 Teknologi yang Digunakan

Framework: Flutter (Dart)

Backend/API: MockAPI.io (Data JSON)

State Management: setState (Lokal & Lifted State)

Networking: http package

Fonts: Google Fonts (Sora & Poppins)

Icons: Material Icons & Cupertino Icons

📂 Struktur Proyek

Proyek ini disusun dengan struktur yang rapi untuk memisahkan logic Admin dan Customer.

lib/
├── models/                  # Model data (Penerjemah JSON)
│   ├── coffee_model.dart
│   ├── user_model.dart
│   └── order_model.dart
│
├── services/                # Logika komunikasi ke API
│   ├── auth_service.dart
│   └── coffee_service.dart
│
├── pages/
│   ├── admin/               # Halaman khusus Admin
│   │   ├── admin_dashboard.dart
│   │   └── add_edit_product.dart
│   │
│   ├── auth/                # Halaman Autentikasi
│   │   ├── login_page.dart
│   │   └── register_page.dart
│   │
│   ├── customer/            # Halaman khusus Customer
│   │   ├── main_wrapper.dart
│   │   ├── home_page.dart
│   │   ├── detail_page.dart
│   │   ├── cart_page.dart
│   │   ├── favorite_page.dart
│   │   ├── profile_page.dart
│   │   ├── checkout_page.dart
│   │   ├── order_success_page.dart
│   │   └── order_history_page.dart
│   │
│   └── intro/               # Halaman Intro
│       └── onboarding_page.dart
│
└── main.dart                # Entry point & Tema Global



🚀 Cara Menjalankan (Installation)

Clone atau Download repositori ini.

Buka terminal di dalam folder proyek.

Jalankan perintah berikut untuk mengunduh dependencies:

flutter pub get



Pastikan Anda memiliki koneksi internet (karena aplikasi menggunakan API & Google Fonts).

Jalankan aplikasi di Emulator atau Device fisik:

flutter run



🔗 Endpoint API

Aplikasi ini menggunakan MockAPI dengan endpoint berikut (Contoh URL):

Base URL: https://68fe947f7c700772bb1408b8.mockapi.io/

Resources:

/coffee: Data produk kopi (Nama, Harga, Gambar, Deskripsi, Kategori).

/user: Data pengguna (Email, Password, Nama, Role).

📸 Screenshots

Onboarding

Login

Home (Customer)

Detail Produk









Keranjang

Checkout

Struk Sukses

Admin Dashboard









👨‍💻 Author

Dikembangkan sebagai tugas Mobile Programming.

Nama: 

$$Fahmi Zidan$$

NIM: 

$$230605110185$$

Kelas: 

$$Mobile Programming D$$