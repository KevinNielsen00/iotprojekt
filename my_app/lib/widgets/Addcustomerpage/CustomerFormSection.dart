// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateCustomerForm extends StatefulWidget {
  const CreateCustomerForm({Key? key}) : super(key: key);

  @override
  _CreateCustomerFormState createState() => _CreateCustomerFormState();
}

class _CreateCustomerFormState extends State<CreateCustomerForm> {
  final TextEditingController customerNumberController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  Future<void> _submitForm() async {
    String customerNumber = customerNumberController.text;
    String company = companyController.text;
    String phone = phoneController.text;
    String email = emailController.text;
    String location = locationController.text;

    // Validate that CustomerNr and Firm are provided
    if (customerNumber.isEmpty || company.isEmpty) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer Number and Firm are required')),
      );
      return;
    }

    // Create a JSON object from the form data
    Map<String, dynamic> customerData = {
      'customer_nr': int.parse(customerNumber),  // Convert customer number to an integer
      'firm': company,
      'phone_nr': phone,
      'mail': email,
      'location': location,
    };

    // Proceed with the API request
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/customers'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(customerData),
      );

      if (response.statusCode == 201) {
        print('Customer created successfully');
        _clearForm();
      } else {
        // Provide more specific error handling based on status code
        String errorMessage = 'Failed to create customer. Status code: ${response.statusCode}';
        if (response.statusCode == 400) {
          errorMessage = 'Bad request. Please check your input.';
        } else if (response.statusCode == 500) {
          errorMessage = 'Server error. Please try again later.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
        print(errorMessage);
      }
    } catch (error) {
      print('Error submitting form: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  void _clearForm() {
    customerNumberController.clear();
    companyController.clear();
    phoneController.clear();
    emailController.clear();
    locationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Opret kunde',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        buildInputField('Kunde Nr', customerNumberController),
        const SizedBox(height: 10),
        buildInputField('Firma', companyController),
        const SizedBox(height: 10),
        buildInputField('TLF', phoneController),
        const SizedBox(height: 10),
        buildInputField('Mail', emailController),
        const SizedBox(height: 10),
        buildInputField('Lokation', locationController),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Opret'),
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