import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/coffee_model.dart';
import 'checkout_page.dart';

const Color kPrimaryGreen = Color(0xFF1BAE76);
const Color kGreyColor = Color(0xFF808080);

class CartPage extends StatelessWidget {
  final List<Coffee> cartItems;
  final Function(Coffee) onRemoveItem;
  final VoidCallback onClearCart;

  const CartPage({
    Key? key, 
    required this.cartItems, 
    required this.onRemoveItem,
    required this.onClearCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hitung Total Harga
    double totalPrice = cartItems.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang Saya"), centerTitle: true, automaticallyImplyLeading: false),
      body: cartItems.isEmpty
          ? Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 80, color: kGreyColor.withOpacity(0.5)),
                const SizedBox(height: 16),
                const Text("Keranjang kosong"),
              ],
            ))
          : Column(
              children: [
                // LIST ITEM
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final coffee = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(coffee.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                          ),
                          title: Text(coffee.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Rp ${coffee.price.toStringAsFixed(0)}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => onRemoveItem(coffee),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // RINGKASAN TOTAL
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Pembayaran", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("Rp ${totalPrice.toStringAsFixed(0)}", style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryGreen)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: kPrimaryGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                  cartItems: cartItems,
                                  onCheckoutSuccess: onClearCart,
                                ),
                              ),
                            );
                          },
                          child: const Text("CHECKOUT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}