import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../../models/coffee_model.dart';

const Color kPrimaryGreen = Color(0xFF1BAE76);
const Color kWhiteColor = Color(0xFFFFFFFF);

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
  final _imageUrlController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  final String apiUrl = "https://68fe947f7c700772bb1408b8.mockapi.io/coffee";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.coffee != null) {
      _nameController.text = widget.coffee!.name;
      _priceController.text = widget.coffee!.price.toString();
      _imageUrlController.text = widget.coffee!.imageUrl;
      _descriptionController.text = widget.coffee!.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final body = json.encode({
      'name': _nameController.text,
      'price': double.parse(_priceController.text),
      'imageUrl': _imageUrlController.text,
      'description': _descriptionController.text,
    });

    try {
      final response = widget.coffee == null
          ? await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json'}, body: body)
          : await http.put(Uri.parse('$apiUrl/${widget.coffee!.id}'), headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to save');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        title: Text(
          widget.coffee == null ? 'Tambah Produk' : 'Edit Produk',
          style: GoogleFonts.sora(color: kWhiteColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Kopi'),
              validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Harga tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'URL Gambar'),
              validator: (v) => v!.isEmpty ? 'URL tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 3,
              validator: (v) => v!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: kWhiteColor)
                  : Text('Simpan', style: GoogleFonts.sora(color: kWhiteColor, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
