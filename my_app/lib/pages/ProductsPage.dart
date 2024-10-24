import 'package:flutter/material.dart';
import '../widgets/appbar/appbar.dart';



class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarFunction("Products Page"),  
      body: ProductsPageContent(), 
    );
  }
}

class ProductsPageContent extends StatelessWidget {
  const ProductsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          SizedBox(height: 16),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}