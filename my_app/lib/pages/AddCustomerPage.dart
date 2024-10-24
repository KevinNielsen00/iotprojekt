import 'package:flutter/material.dart';
import 'package:my_app/widgets/Addcustomerpage/CustomerFormSection.dart';
import '../widgets/appbar/appbar.dart';



class AddCustomerPage extends StatelessWidget {
  const AddCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarFunction("Settings Page"),  
      body: const AddCustomerPageContent(), 
    );
  }
}

class AddCustomerPageContent extends StatelessWidget {

  const AddCustomerPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CreateCustomerForm(),
          SizedBox(height: 16),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}