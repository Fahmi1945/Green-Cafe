import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:projek_flutter/pages/auth/login_page.dart';

void main() {
  runApp(const MyApp());
}

const MaterialColor kPrimaryGreen = MaterialColor(0xFF1BAE76, <int, Color>{
  50: Color(0xFFE4F7EF),
  100: Color(0xFFBBEBDA),
  200: Color(0xFF8DE0C2),
  300: Color(0xFF5FD5AA),
  400: Color(0xFF3BCC97),
  500: Color(0xFF1BAE76), // Warna utama Anda
  600: Color(0xFF18A66E),
  700: Color(0xFF149C63),
  800: Color(0xFF109259),
  900: Color(0xFF098047),
});

// Ini adalah warna latar belakang Anda (#EFEFEF)
const Color kScaffoldBackground = Color(0xFFEFEFEF);
// Ini adalah warna abu-abu untuk ikon/teks non-aktif (#808080)
const Color kGreyColor = Color(0xFF808080);
// Ini adalah warna teks utama Anda (#000000)
const Color kBlackColor = Color(0xFF000000);
// Ini adalah warna kartu/konten Anda (#FFFFFF)
const Color kWhiteColor = Color(0xFFFFFFFF);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Green Cafe',

      // --- Di sinilah kita mengatur TEMA UTAMA Anda ---
      theme: ThemeData(
        // 1. Palet Warna
        primarySwatch: kPrimaryGreen,
        primaryColor: kPrimaryGreen,
        scaffoldBackgroundColor:
            kScaffoldBackground, // Latar belakang abu-abu pudar
        cardColor: kWhiteColor, // Latar belakang kartu produk
        // 2. Tema Font (Poppins & Sora)
        textTheme: TextTheme(
          // Font Judul (Misal: "Green Cafe", "Coffe Latte") - Pakai Sora
          headlineLarge: GoogleFonts.sora(
            fontWeight: FontWeight.bold,
            color: kBlackColor,
          ),
          headlineMedium: GoogleFonts.sora(
            fontWeight: FontWeight.w600,
            color: kBlackColor,
          ),
          titleLarge: GoogleFonts.sora(
            fontWeight: FontWeight.bold,
            color: kBlackColor,
          ),
          titleMedium: GoogleFonts.sora(
            fontWeight: FontWeight.w600,
            color: kBlackColor,
            fontSize: 16,
          ),
          titleSmall: GoogleFonts.sora(
            fontWeight: FontWeight.w600,
            color: kBlackColor,
            fontSize: 14,
          ),

          // Font Body (Misal: "Rp 20.000", "Jl. Gajayana") - Pakai Poppins
          bodyLarge: GoogleFonts.poppins(color: kBlackColor, fontSize: 16),
          bodyMedium: GoogleFonts.poppins(color: kBlackColor, fontSize: 14),
          bodySmall: GoogleFonts.poppins(
            color: kGreyColor,
            fontSize: 12,
          ), // Teks abu-abu kecil
        ),

        // 3. Tema AppBar (Header Hijau)
        appBarTheme: AppBarTheme(
          backgroundColor: kPrimaryGreen,
          elevation: 0, // Header tanpa bayangan
          // Teks dan ikon di AppBar berwarna putih
          titleTextStyle: GoogleFonts.sora(
            color: kWhiteColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: kWhiteColor),
        ),

        // 4. Tema Bottom Navigation Bar (Sesuai Desain)
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: kWhiteColor, // Latar belakang putih
          selectedItemColor: kPrimaryGreen, // Ikon & Teks aktif (Dashboard)
          unselectedItemColor: kGreyColor, // Ikon & Teks non-aktif (Cart, dll)
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed, // Tipe standar
          elevation: 2, // Beri sedikit bayangan
        ),

        // 5. Tema Tombol (Tombol '+' hijau)
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kPrimaryGreen,
        ),

        cardTheme: CardThemeData(
          color: kWhiteColor,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
