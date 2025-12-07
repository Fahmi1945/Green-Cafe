import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/coffee_model.dart';
import '../../services/coffee_service.dart';
import 'detail_page.dart';

const Color kPrimaryGreen = Color(0xFF1BAE76);
const Color kGreyColor = Color(0xFF808080);
const Color kScaffoldBackground = Color(0xFFEFEFEF);
const Color kWhiteColor = Color(0xFFFFFFFF);

class HomePage extends StatefulWidget {
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

  String _selectedFilter = "Coffee";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _loadData({String? query}) {
    setState(() {
      _coffeeData = _coffeeService.getCoffees(query: query);
    });
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

        if (snapshot.hasError) {
          return Center(child: Text("Error: \${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text("Menu tidak ditemukan."),
            ),
          );
        }

        final List<Coffee> allCoffees = snapshot.data!;

        final List<Coffee> filteredCoffees = allCoffees.where((item) {
          if (_searchController.text.isNotEmpty) return true;

          return item.category.toLowerCase() == _selectedFilter.toLowerCase();
        }).toList();

        // Cek jika hasil filter kosong
        if (filteredCoffees.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.fastfood_outlined,
                    size: 50,
                    color: kGreyColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada menu di kategori $_selectedFilter",
                    style: const TextStyle(color: kGreyColor),
                  ),
                ],
              ),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.65, // Rasio ini penting agar tidak overflow
          ),
          itemCount: filteredCoffees.length,
          itemBuilder: (context, index) {
            return _buildProductCard(context, filteredCoffees[index]);
          },
        );
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Coffee coffee) {
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
                  child: const Icon(Icons.broken_image, color: Colors.grey),
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
                  InkWell(
                    onTap: () => widget.onToggleFavorite(coffee),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : kGreyColor,
                      size: 24,
                    ),
                  ),
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
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: kGreyColor),
                      onPressed: () {
                        _searchController.clear();
                        _loadData();
                      },
                    )
                  : null,
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
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 125,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(child: Text("Banner Area")),
            );
          },
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
          final isSelected = label == _selectedFilter;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(label),
                selected: isSelected,
                selectedColor: kPrimaryGreen,
                backgroundColor: kWhiteColor,
                labelStyle: TextStyle(
                  color: isSelected ? kWhiteColor : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                showCheckmark: false, // <--- TAMBAHKAN INI UNTUK HAPUS CENTANG
                onSelected: (val) {
                  setState(() {
                    _selectedFilter = label;
                  });
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
