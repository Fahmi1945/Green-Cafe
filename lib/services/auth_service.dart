import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  // GANTI DENGAN URL MOCKAPI 'USER' ANDA
  final String baseUrl = "https://68fe947f7c700772bb1408b8.mockapi.io/user";

  Future<User?> login(String email, String password) async {
    try {
      // Cari user berdasarkan email
      final response = await http.get(Uri.parse('$baseUrl?email=$email'));

      if (response.statusCode == 200) {
        List<dynamic> users = json.decode(response.body);

        if (users.isNotEmpty) {
          // User ketemu, sekarang cek password
          User user = User.fromJson(users[0]);
          
          if (user.password == password) {
            return user; // Login Sukses, kembalikan data user
          }
        }
      }
      return null; // Login Gagal (Email/Pass salah)
    } catch (e) {
      print("Error login: $e");
      return null;
    }
  }
}