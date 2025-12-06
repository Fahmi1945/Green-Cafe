import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/coffee_model.dart';
import 'order_success_page.dart';

const Color kPrimaryGreen = Color(0xFF1BAE76);
const Color kScaffoldBackground = Color(0xFFEFEFEF);
const Color kWhiteColor = Color(0xFFFFFFFF);
const Color kGreyColor = Color(0xFF808080);

class CheckoutPage extends StatelessWidget {
  final List<Coffee> cartItems;
  final VoidCallback onCheckoutSuccess;

  const CheckoutPage({
    Key? key,
    required this.cartItems,
    required this.onCheckoutSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double subtotal = cartItems.fold(0, (sum, item) => sum + item.price);
    double tax = subtotal * 0.10;
    double total = subtotal + tax;

    return Scaffold(
      backgroundColor: kScaffoldBackground,
      appBar: AppBar(
        title: Text("Konfirmasi Pesanan", style: GoogleFonts.sora(fontWeight: FontWeight.bold, color: kWhiteColor)),
        backgroundColor: kPrimaryGreen,
        iconTheme: const IconThemeData(color: kWhiteColor),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. LOKASI GERAI (Ganti dari Alamat Pengiriman)
            Text("Lokasi Pemesanan", style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: kPrimaryGreen.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.storefront, color: kPrimaryGreen), // Ikon Toko
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Green Cafe - Malang", style: GoogleFonts.sora(fontWeight: FontWeight.bold)),
                      Text("Meja: - (Pesan di Tempat)", style: GoogleFonts.poppins(color: kGreyColor, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. RINGKASAN PESANAN
            Text("Ringkasan Pesanan", style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: cartItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text("${item.name} (x1)", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                      ),
                      Text("Rp ${item.price.toStringAsFixed(0)}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    ],
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // 3. METODE PEMBAYARAN (Tunai)
            Text("Metode Pembayaran", style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: kWhiteColor, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const Icon(Icons.payments_outlined, color: kPrimaryGreen), // Ikon Uang
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tunai / Cash", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      Text("Bayar di Kasir", style: GoogleFonts.poppins(fontSize: 12, color: kGreyColor)),
                    ],
                  ),
                  const Spacer(),
                  Radio(value: true, groupValue: true, onChanged: (val) {}, activeColor: kPrimaryGreen),
                ],
              ),
            ),
          ],
        ),
      ),

      // 4. BOTTOM BAR
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSummaryRow("Subtotal", subtotal),
            const SizedBox(height: 8),
            _buildSummaryRow("Pajak (10%)", tax),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total", style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Rp ${total.toStringAsFixed(0)}", style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryGreen)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  onCheckoutSuccess();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderSuccessPage(
                        items: cartItems,
                        totalPrice: total,
                      ),
                    ),
                  );
                },
                child: Text("KONFIRMASI PESANAN", style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: kWhiteColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(color: kGreyColor)),
        Text("Rp ${value.toStringAsFixed(0)}", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ],
    );
  }
}