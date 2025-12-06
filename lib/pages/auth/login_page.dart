import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../customer/main_wrapper.dart';
import '../admin/admin_dashboard.dart';

// --- KONSTANTA WARNA (Sesuai main.dart) ---
const Color kPrimaryGreen = Color(0xFF1BAE76);
const Color kScaffoldBackground = Color(0xFFEFEFEF);
const Color kWhiteColor = Color(0xFFFFFFFF);
const Color kGreyColor = Color(0xFF808080);
const Color kBlackColor = Color(0xFF000000);

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email dan Password harus diisi"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Panggil Service Login
    User? user = await _authService.login(
      _emailController.text,
      _passController.text,
    );

    if (mounted) {
      setState(() => _isLoading = false);

      if (user != null) {
        // --- LOGIKA PEMISAH ROLE ---
        if (user.role == 'admin') {
          // Ke Halaman Admin
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashboard()),
          );
        } else {
          // Ke Halaman Customer
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainWrapper(user: user)),
          );
        }
      } else {
        // Tampilkan Error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email atau Password salah!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Latar belakang hijau penuh (Branding)
      backgroundColor: kPrimaryGreen,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo atau Ikon (Opsional)
              const Icon(
                Icons.coffee_rounded,
                size: 80,
                color: kWhiteColor,
              ),
              const SizedBox(height: 24),
              
              // Kartu Login
              Card(
                color: kWhiteColor, // Pastikan kartu putih
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "GREEN CAFE",
                        style: GoogleFonts.sora(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryGreen, // Judul Hijau
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Silakan masuk untuk melanjutkan",
                        style: GoogleFonts.poppins(
                          color: kGreyColor,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Input Email
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: GoogleFonts.poppins(color: kGreyColor),
                          prefixIcon: const Icon(Icons.email, color: kPrimaryGreen),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: kPrimaryGreen, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Input Password
                      TextField(
                        controller: _passController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: GoogleFonts.poppins(color: kGreyColor),
                          prefixIcon: const Icon(Icons.lock, color: kPrimaryGreen),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: kPrimaryGreen, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Tombol Login
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryGreen,
                            foregroundColor: kWhiteColor, // Warna teks tombol putih
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          onPressed: _isLoading ? null : _handleLogin,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: kWhiteColor,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "LOGIN",
                                  style: GoogleFonts.sora(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}