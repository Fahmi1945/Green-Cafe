# ☕ Green Cafe App

Green Cafe adalah aplikasi mobile pemesanan kopi modern yang dibangun menggunakan **Flutter**. Aplikasi ini dirancang untuk memberikan pengalaman pengguna yang mulus dalam menjelajahi menu, mengelola pesanan, dan menyimpan item favorit.

Proyek ini mengimplementasikan konsep **RESTful API** menggunakan **MockAPI** untuk manajemen data pengguna dan produk, serta menerapkan **clean code architecture** dengan pemisahan logika **Admin** dan **Customer**.

---

## 📱 Fitur Utama

Aplikasi ini memiliki dua peran pengguna (*role*) dengan fitur yang berbeda.

### 🌟 Fitur Umum

- **Onboarding Screen**  
  Layar sambutan interaktif saat pertama kali membuka aplikasi.

- **Autentikasi (Login & Register)**
  - Login dengan validasi email & password.
  - Register akun baru dengan toggle visibility password.
  - Pemisahan otomatis antara halaman Admin dan Customer berdasarkan role yang diterima dari API.

---

### 👤 Fitur Customer (Pelanggan)

- **Dashboard**
  - Menampilkan banner promo.
  - Menampilkan kategori untuk filter.
  - Menampilkan daftar produk dalam bentuk grid.

- **Pencarian (Search)**
  - Mencari kopi berdasarkan nama secara real-time dari API.

- **Detail Produk**
  - Menampilkan gambar besar, deskripsi, dan harga produk.

- **Keranjang (Cart)**
  - Menambahkan item ke keranjang.
  - Melihat ringkasan belanja sebelum checkout.

- **Checkout & Struk**
  - Simulasi proses pembayaran.
  - Menampilkan struk digital setelah pesanan berhasil.

- **Favorit (Wishlist)**
  - Menandai produk kesukaan untuk disimpan di daftar favorit.

- **Riwayat Pesanan**
  - Melihat daftar pesanan yang pernah dibuat (disimpan secara lokal).

- **Profil**
  - Melihat data diri pengguna yang sedang login.

---

### 🛠 Fitur Admin

- **Admin Dashboard**
  - Melihat seluruh daftar produk kopi yang tersedia di server.

- **CRUD Produk**
  - **Create**: Menambah menu kopi baru.
  - **Read**: Melihat daftar menu kopi.
  - **Update**: Mengedit data menu (harga, nama, gambar, deskripsi).
  - **Delete**: Menghapus menu dari server (MockAPI).

---

## 🧰 Teknologi yang Digunakan

- **Framework**: Flutter (Dart)
- **Backend/API**: MockAPI.io (format data JSON)
- **State Management**: `setState` (local & lifted state)
- **Networking**: `http` package
- **Fonts**: Google Fonts (Sora & Poppins)
- **Icons**: Material Icons & Cupertino Icons

---

## 📂 Struktur Proyek

Struktur folder disusun untuk memisahkan logic Admin dan Customer secara rapi.

```bash
lib/
├── models/                  # Model data (penerjemah JSON)
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
└── main.dart                # Entry point & tema global
