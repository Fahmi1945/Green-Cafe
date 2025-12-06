import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/coffee_model.dart';
import '../../services/coffee_service.dart';
import 'detail_page.dart';

const Color kPrimaryGreen = Color(0xFF1BAE76);
const Color kGreyColor = Color(0xFF808080);
const Color kScaffoldBackground = Color(0xFFEFEFEF);
const Color kWhiteColor = Color(0xFFFFFFFF);

class HomePage extends StatefulWidget {
  // Terima Data & Fungsi dari MainWrapper
  final List<Coffee> favoriteItems;
  final Function(Coffee) onAddToCart;
  final Function(Coffee) onToggleFavorite;

  const HomePage({
    Key? key,
    required this.favoriteItems,
    required this.onAddToCart,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CoffeeService _coffeeService = CoffeeService();
  late Future<List<Coffee>> _coffeeData;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData({String? query}) {
    setState(() {
      _coffeeData = _coffeeService.getCoffees(query: query);
    });
  }

  // ... (Kode _onSearchChanged, dispose, _buildHeaderContent, _buildBanner, _buildFilterChips SAMA SEPERTI SEBELUMNYA) ...
  // AGAR SINGKAT, SAYA HANYA TULIS BAGIAN YANG BERUBAH DI BAWAH INI
  // ... (Gunakan kode lama Anda untuk widget helper di atas) ...

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _loadData(query: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryGreen,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeaderContent(context),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: kScaffoldBackground,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_searchController.text.isEmpty) ...[
                        _buildBanner(),
                        _buildFilterChips(),
                      ] else
                        const SizedBox(height: 24),
                      _buildProductGrid(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return FutureBuilder<List<Coffee>>(
      future: _coffeeData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: CircularProgressIndicator(color: kPrimaryGreen),
            ),
          );
        }
        if (snapshot.hasError)
          return Center(child: Text("Error: ${snapshot.error}"));
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return const Center(child: Text("Menu tidak ditemukan."));

        final coffees = snapshot.data!;
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.65,
          ),
          itemCount: coffees.length,
          itemBuilder: (context, index) {
            return _buildProductCard(context, coffees[index]);
          },
        );
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Coffee coffee) {
    // Cek apakah item ini ada di daftar favorit (Data dari MainWrapper)
    final bool isFavorite = widget.favoriteItems.any(
      (item) => item.id == coffee.id,
    );

return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              coffee: coffee,
              initialIsFavorite: isFavorite,
              onToggleFavorite: () => widget.onToggleFavorite(coffee),
              onAddToCart: () => widget.onAddToCart(coffee),
            ),
          ),
        );
      },
      child: Card(
        color: kWhiteColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
              child: Image.network(
                coffee.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, _) => Container(
                  height: 120,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coffee.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rp ${coffee.price.toStringAsFixed(0)}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: kPrimaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TOMBOL LOVE (Panggil fungsi dari MainWrapper)
                  InkWell(
                    onTap: () => widget.onToggleFavorite(coffee),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : kGreyColor,
                      size: 24,
                    ),
                  ),
                  // TOMBOL ADD (Panggil fungsi dari MainWrapper)
                  InkWell(
                    onTap: () {
                      widget.onAddToCart(coffee);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${coffee.name} masuk keranjang!"),
                          backgroundColor: kPrimaryGreen,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: kPrimaryGreen,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: kWhiteColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget Helper Lainnya (Copy Paste dari kode lama Anda) ---
  Widget _buildHeaderContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Green Cafe",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: kWhiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Jl. Gajayana Malang",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: kWhiteColor.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.account_circle, size: 40, color: kWhiteColor),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: "Cari kopi...",
              hintStyle: const TextStyle(color: kGreyColor),
              prefixIcon: const Icon(Icons.search, color: kGreyColor),
              filled: true,
              fillColor: kWhiteColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.asset(
          'assets/images/banner.png',
          width: double.infinity,
          height: 125,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ["Coffee", "Non Coffee", "Food"].map((label) {
          return ChoiceChip(
            label: Text(label),
            selected: label == "Coffee",
            selectedColor: kPrimaryGreen,
          );
        }).toList(),
      ),
    );
  }
}
