import 'package:flutter/material.dart';
import '../../models/coffee_model.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart';

const Color kPrimaryGreen = Color(0xFF1BAE76);

class MainWrapper extends StatefulWidget {
  final dynamic user;

  const MainWrapper({Key? key, required this.user}) : super(key: key);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  final List<Coffee> _cartItems = [];
  final List<Coffee> _favoriteItems = [];

  void _addToCart(Coffee coffee) {
    setState(() {
      _cartItems.add(coffee);
    });
  }

  void _removeFromCart(Coffee coffee) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == coffee.id);
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });
  }

  void _toggleFavorite(Coffee coffee) {
    setState(() {
      final isExist = _favoriteItems.any((item) => item.id == coffee.id);
      if (isExist) {
        _favoriteItems.removeWhere((item) => item.id == coffee.id);
      } else {
        _favoriteItems.add(coffee);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        favoriteItems: _favoriteItems,
        onAddToCart: _addToCart,
        onToggleFavorite: _toggleFavorite,
      ),

      CartPage(
        cartItems: _cartItems,
        onRemoveItem: _removeFromCart,
        onClearCart: _clearCart,
      ),

      FavoritePage(
        favoriteItems: _favoriteItems,
        onRemoveItem: _toggleFavorite,
      ),

      ProfilePage(user: widget.user),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
