import 'package:flutter/material.dart';
import '../../models/coffee_model.dart';

const Color kGreyColor = Color(0xFF808080);

class FavoritePage extends StatelessWidget {
  final List<Coffee> favoriteItems;
  final Function(Coffee) onRemoveItem;

  const FavoritePage({
    Key? key,
    required this.favoriteItems,
    required this.onRemoveItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menu Favorit"), centerTitle: true, automaticallyImplyLeading: false),
      body: favoriteItems.isEmpty
          ? Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: kGreyColor.withOpacity(0.5)),
                const SizedBox(height: 16),
                const Text("Belum ada favorit"),
              ],
            ))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final coffee = favoriteItems[index];
                return ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(coffee.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  title: Text(coffee.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Rp ${coffee.price.toStringAsFixed(0)}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => onRemoveItem(coffee), // Hapus dari favorit
                  ),
                );
              },
            ),
    );
  }
}