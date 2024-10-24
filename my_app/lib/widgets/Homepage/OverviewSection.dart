import 'package:flutter/material.dart';
import 'package:my_app/dummy_data.dart';
import 'package:my_app/widgets/util/ProductPopup.dart'; // Import your ProductPopup file

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Text(
          'Products:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...dummyProducts.map((product) {
          return ListTile(
            title: Text(product.name),
            onTap: () {
              showProductPopup(context, product); // Show product details
            },
          );
        }).toList(),
        SizedBox(height: 16),
        Text(
          'Clients:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...dummyClients.map((client) {
          return ListTile(
            title: Text(client.name),
            onTap: () {
              showClientProductsPopup(context, client); // Show client products
            },
          );
        }).toList(),
      ],
    );
  }
}