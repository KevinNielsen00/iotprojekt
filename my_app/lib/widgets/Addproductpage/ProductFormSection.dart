import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateProductForm extends StatefulWidget {
  const CreateProductForm({Key? key}) : super(key: key);

  @override
  _CreateProductFormState createState() => _CreateProductFormState();
}

class _CreateProductFormState extends State<CreateProductForm> {
  List<dynamic> customers = [];
  String? selectedCustomer;
  final TextEditingController productNumberController = TextEditingController();
  final TextEditingController meterIdController = TextEditingController();
  final TextEditingController oilTypeController = TextEditingController();
  final TextEditingController barrelTypeController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/customers'));
    if (response.statusCode == 200) {
      setState(() {
        customers = json.decode(response.body);
      });
    } else {
      print('Failed to load customers');
    }
  }

  Future<void> _submitForm() async {
    if (selectedCustomer == null || productNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer and provide the product number')),
      );
      return;
    }

    Map<String, dynamic> productData = {
      'customer_nr': int.parse(selectedCustomer!),  // Parse customer number
      'product_nr': productNumberController.text,
      'meter_id': int.parse(meterIdController.text),
      'oil_type': oilTypeController.text,
      'barrel_type': barrelTypeController.text,
      'height': double.parse(heightController.text),
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/products'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(productData),
      );

      if (response.statusCode == 201) {
        print('Product created successfully');
        _clearForm();
      } else {
        print('Failed to create product. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error submitting form: $error');
    }
  }

  void _clearForm() {
    productNumberController.clear();
    meterIdController.clear();
    oilTypeController.clear();
    barrelTypeController.clear();
    heightController.clear();
    setState(() {
      selectedCustomer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Add Product',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          value: selectedCustomer,
          items: customers.map<DropdownMenuItem<String>>((customer) {
            return DropdownMenuItem<String>(
              value: customer['customer_nr'].toString(),
              child: Text(customer['firm']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCustomer = value;
            });
          },
          decoration: const InputDecoration(labelText: 'Select Customer'),
        ),
        const SizedBox(height: 10),
        buildInputField('Product Nr', productNumberController),
        buildInputField('Meter ID', meterIdController),
        buildInputField('Oil Type', oilTypeController),
        buildInputField('Barrel Type', barrelTypeController),
        buildInputField('Height', heightController),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Create Product'),
        ),
      ],
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}