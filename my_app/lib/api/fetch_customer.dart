import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/customer.dart';

Future<List<Customer>> fetchCustomers() async {
  final response = await http.get(Uri.parse('http://localhost:8080/api/customers'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Customer.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load customers');
  }
}