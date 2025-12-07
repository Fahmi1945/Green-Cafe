import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../../models/coffee_model.dart';
import '../auth/login_page.dart';
import 'add_edit_product.dart';

const Color kPrimaryGreen = Color(0xFF1BAE76);
const Color kScaffoldBackground = Color(0xFFEFEFEF);
const Color kWhiteColor = Color(0xFFFFFFFF);
const Color kGreyColor = Color(0xFF808080);
const Color kBlackColor = Color(0xFF000000);

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final String apiUrl = "https://68fe947f7c700772bb1408b8.mockapi.io/coffee";
  late Future<List<Coffee>> _coffeeData;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _coffeeData = _fetchCoffeeData();
    });
  }

  Future<List<Coffee>> _fetchCoffeeData() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Coffee.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future<void> _deleteCoffee(String id) async {
    bool confirm =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Hapus Produk",
              style: GoogleFonts.sora(fontWeight: FontWeight.bold),
            ),
            content: Text(
              "Yakin ingin menghapus kopi ini?",
              style: GoogleFonts.poppins(),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "Batal",
                  style: GoogleFonts.poppins(color: kGreyColor),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  "Hapus",
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));
      if (response.statusCode == 200) {
        _refreshData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Produk berhasil dihapus"),
            backgroundColor: kPrimaryGreen,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal menghapus produk"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackground,
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        title: Text(
          "Admin Dashboard",
          style: GoogleFonts.sora(
            color: kWhiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: kWhiteColor),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryGreen,
        child: const Icon(Icons.add, color: kWhiteColor),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditProductPage()),
          );
          if (result == true) _refreshData();
        },
      ),

      body: FutureBuilder<List<Coffee>>(
        future: _coffeeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimaryGreen),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: GoogleFonts.poppins(),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("Belum ada data kopi.", style: GoogleFonts.poppins()),
            );
          }

          final coffees = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: coffees.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final coffee = coffees[index];
              return _buildAdminCard(coffee);
            },
          );
        },
      ),
    );
  }

  Widget _buildAdminCard(Coffee coffee) {
    return Container(
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        // Gambar Kecil (Thumbnail)
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            coffee.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, _) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
        // Nama & Harga
        title: Text(
          coffee.name,
          style: GoogleFonts.sora(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          "Rp ${coffee.price.toStringAsFixed(0)}",
          style: GoogleFonts.poppins(
            color: kPrimaryGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
        // Tombol Aksi (Edit & Hapus)
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditProductPage(coffee: coffee),
                  ),
                );
                if (result == true) _refreshData();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _deleteCoffee(coffee.id),
            ),
          ],
        ),
      ),
    );
  }
}
