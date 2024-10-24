import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/product.dart';

Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('http://localhost:8080/api/products'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}