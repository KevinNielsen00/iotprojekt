// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

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

  void _submitForm() {
    String customerNumber = customerNumberController.text;
    String company = companyController.text;
    String phone = phoneController.text;
    String email = emailController.text;
    String location = locationController.text;

    // Handle your form submission logic here
    print('Customer Number: $customerNumber');
    print('Company: $company');
    print('Phone: $phone');
    print('Email: $email');
    print('Location: $location');
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