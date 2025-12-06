import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/coffee_model.dart';

const Color kPrimaryGreen = Color(0xFF1BAE76);
const Color kWhiteColor = Color(0xFFFFFFFF);
const Color kScaffoldBackground = Color(0xFFEFEFEF);

class OrderSuccessPage extends StatelessWidget {
  final List<Coffee> items;
  final double totalPrice;

  const OrderSuccessPage({
    Key? key,
    required this.items,
    required this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryGreen, // Background Hijau
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ikon Sukses
              const Icon(Icons.check_circle, color: kWhiteColor, size: 80),
              const SizedBox(height: 16),
              Text("Pembayaran Berhasil!", style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.bold, color: kWhiteColor)),
              const SizedBox(height: 32),

              // --- KARTU STRUK ---
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text("STRUK PEMBAYARAN", style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                    const SizedBox(height: 8),
                    Text("20 Dec 2025 • 19:30", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
                    const Divider(height: 32, thickness: 1, color: Colors.grey),

                    // List Barang di Struk
                    Column(
                      children: items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(item.name, style: GoogleFonts.poppins(fontSize: 14))),
                            Text("Rp ${item.price.toStringAsFixed(0)}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )).toList(),
                    ),
                    
                    const Divider(height: 32, thickness: 1, color: Colors.grey),
                    
                    // Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("TOTAL BAYAR", style: GoogleFonts.sora(fontWeight: FontWeight.bold)),
                        Text("Rp ${totalPrice.toStringAsFixed(0)}", style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryGreen)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kWhiteColor, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    // Kembali ke Dashboard (Hapus history navigasi)
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text("KEMBALI KE BERANDA", style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: kWhiteColor)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}