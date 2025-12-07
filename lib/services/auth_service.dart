import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  final String baseUrl = "https://68fe947f7c700772bb1408b8.mockapi.io/user";

  Future<User?> login(String email, String password) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?email=$email'));

      if (response.statusCode == 200) {
        List<dynamic> users = json.decode(response.body);
        if (users.isNotEmpty) {
          User user = User.fromJson(users[0]);
          if (user.password == password) {
            return user;
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final checkEmail = await http.get(Uri.parse('\$baseUrl?email=\$email'));
      if (checkEmail.statusCode == 200) {
        List<dynamic> users = json.decode(checkEmail.body);
        if (users.isNotEmpty) {
          return false;
        }
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": name,
          "email": email,
          "password": password,
          "role": "customer",
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
