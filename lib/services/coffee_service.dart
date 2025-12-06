import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coffee_model.dart';

class CoffeeService {
  final String baseUrl = "https://68fe947f7c700772bb1408b8.mockapi.io/coffee";

  Future<List<Coffee>> getCoffees({String? query}) async {
    String url = baseUrl;
    if (query != null && query.isNotEmpty) {
      url += "?name=$query"; 
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Coffee.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data dari API');
    }
  }
}