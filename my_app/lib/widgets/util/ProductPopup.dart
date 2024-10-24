import 'package:flutter/material.dart';
import 'package:my_app/dummy_data.dart';



void showProductPopup(BuildContext context, Product product) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(product.name),
        content: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.description,
                  style: TextStyle(fontSize: 16),
                ),
                
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}

void showClientProductsPopup(BuildContext context, Client client) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Products for ${client.name}'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: client.products.length, 
            itemBuilder: (context, index) {
              Product product = client.products[index];
              return ListTile(
                title: Text(product.name),
                onTap: () {
                  Navigator.of(context).pop(); 
                  showProductPopup(context, product); 
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}