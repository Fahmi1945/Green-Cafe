import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../../models/coffee_model.dart';

const Color kPrimaryGreen = Color(0xFF1BAE76);
const Color kScaffoldBackground = Color(0xFFEFEFEF);
const Color kWhiteColor = Color(0xFFFFFFFF);
const Color kGreyColor = Color(0xFF808080);

class AddEditProductPage extends StatefulWidget {
  final Coffee? coffee;

  const AddEditProductPage({Key? key, this.coffee}) : super(key: key);

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _imageController = TextEditingController();

  bool _isLoading = false;

  final String apiUrl = "https://68fe947f7c700772bb1408b8.mockapi.io/coffee";

  @override
  void initState() {
    super.initState();
    if (widget.coffee != null) {
      _nameController.text = widget.coffee!.name;
      _priceController.text = widget.coffee!.price.toString();
      _descController.text = widget.coffee!.description;
      _imageController.text = widget.coffee!.imageUrl;
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final productData = {
      "name": _nameController.text,
      "price": _priceController.text,
      "description": _descController.text,
      "imageUrl": _imageController.text,
      "rating": "4.5",
    };

    try {
      if (widget.coffee == null) {
        await http.post(
          Uri.parse(apiUrl),
          body: json.encode(productData),
          headers: {"Content-Type": "application/json"},
        );
      } else {
        await http.put(
          Uri.parse('$apiUrl/${widget.coffee!.id}'),
          body: json.encode(productData),
          headers: {"Content-Type": "application/json"},
        );
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.coffee != null;

    return Scaffold(
      backgroundColor: kScaffoldBackground,
      appBar: AppBar(
        title: Text(
          isEdit ? "Edit Produk" : "Tambah Produk",
          style: GoogleFonts.sora(
            fontWeight: FontWeight.bold,
            color: kWhiteColor,
          ),
        ),
        backgroundColor: kPrimaryGreen,
        iconTheme: const IconThemeData(color: kWhiteColor),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Detail Produk",
                style: GoogleFonts.sora(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _nameController,
                label: "Nama Kopi",
                icon: Icons.coffee,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _priceController,
                label: "Harga (Angka)",
                icon: Icons.attach_money,
                isNumber: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _imageController,
                label: "URL Gambar",
                icon: Icons.image,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descController,
                label: "Deskripsi",
                icon: Icons.description,
                maxLines: 4,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _isLoading ? null : _saveProduct,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: kWhiteColor)
                      : Text(
                          "SIMPAN PRODUK",
                          style: GoogleFonts.sora(
                            fontWeight: FontWeight.bold,
                            color: kWhiteColor,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        validator: (value) =>
            value!.isEmpty ? "$label tidak boleh kosong" : null,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: kGreyColor),
          prefixIcon: Icon(icon, color: kPrimaryGreen),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none, // Hilangkan border default
          ),
          filled: true,
          fillColor: kWhiteColor,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}
