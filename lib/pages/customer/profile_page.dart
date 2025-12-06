import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart'; // Import Model User
import '../auth/login_page.dart'; // Import Halaman Login untuk Logout

const Color kPrimaryGreen = Color(0xFF1BAE76);
const Color kWhiteColor = Color(0xFFFFFFFF);
const Color kGreyColor = Color(0xFF808080);

class ProfilePage extends StatelessWidget {
  // Terima data user dari MainWrapper
  final User user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  void _handleLogout(BuildContext context) {
    // Tampilkan dialog konfirmasi
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout", style: GoogleFonts.sora(fontWeight: FontWeight.bold)),
        content: Text("Apakah Anda yakin ingin keluar?", style: GoogleFonts.poppins()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: TextStyle(color: kGreyColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              // Arahkan ke Login dan hapus semua history navigasi
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: Text("Keluar", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Saya",
          style: GoogleFonts.sora(fontWeight: FontWeight.bold, color: kWhiteColor),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryGreen,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: kWhiteColor),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Avatar
              CircleAvatar(
                radius: 60,
                backgroundColor: kPrimaryGreen.withOpacity(0.1),
                child: const Icon(Icons.person, size: 60, color: kPrimaryGreen),
              ),
              const SizedBox(height: 24),

              // 2. Info User (Dinamis dari API)
              _buildProfileInfo(
                context,
                icon: Icons.person_outline,
                label: "Nama Lengkap",
                value: user.name, // Data Nama dari API
              ),
              const SizedBox(height: 16),
              _buildProfileInfo(
                context,
                icon: Icons.email_outlined,
                label: "Email",
                value: user.email, // Data Email dari API
              ),
              const SizedBox(height: 16),
              _buildProfileInfo(
                context,
                icon: Icons.verified_user_outlined,
                label: "Role",
                value: user.role.toUpperCase(), // Data Role dari API
              ),

              const SizedBox(height: 40),

              // 3. Tombol Logout Besar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => _handleLogout(context),
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: Text("LOGOUT", style: GoogleFonts.sora(fontWeight: FontWeight.bold, color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kPrimaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: kPrimaryGreen, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.poppins(fontSize: 12, color: kGreyColor)),
              Text(
                value,
                style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}