import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../models/customer.dart';

class MyTableSection extends StatefulWidget {
  const MyTableSection({super.key});

  @override
  _MyTableSectionState createState() => _MyTableSectionState();
}

class _MyTableSectionState extends State<MyTableSection> {
  List<Product> allProducts = [
    Product(productNr: 1, customer: "John", firm: "Firm A", type1: "Type X", type2: "Type Y"),
  ];

  List<Customer> allCustomers = [
    Customer(customerId: 1, name: "Jane", firm: "Firm B"),
   
  ];

  List<dynamic> displayedItems = [];
  TextEditingController searchController = TextEditingController();
  bool showProducts = true;

  @override
  void initState() {
    super.initState();
    displayedItems = allProducts; // all products
  }

  void _searchItems(String query) {
    List<dynamic> results = [];
    if (query.isEmpty) {
      results = showProducts ? allProducts : allCustomers;
    } else {
      results = (showProducts ? allProducts : allCustomers).where((item) {
        if (showProducts) {
          Product product = item as Product;
          return product.customer.toLowerCase().contains(query.toLowerCase()) ||
                 product.firm.toLowerCase().contains(query.toLowerCase());
        } else {
          Customer customer = item as Customer;
          return customer.name.toLowerCase().contains(query.toLowerCase()) ||
                 customer.firm.toLowerCase().contains(query.toLowerCase());
        }
      }).toList();
    }

    setState(() {
      displayedItems = results;
    });
  }

  void _switchTable() {
    setState(() {
      showProducts = !showProducts;
      displayedItems = showProducts ? allProducts : allCustomers;
    });
  }

  void _showCustomerPopup(BuildContext context, Customer customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Customer Details'),
          content: Text('Customer: ${customer.name}\nFirm: ${customer.firm}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Table Section',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: _switchTable,
              child: Text(showProducts ? 'Show Customers' : 'Show Products'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search',
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: (value) => _searchItems(value),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: showProducts
                ? [
                    const DataColumn(label: Text('Product Number')),
                    const DataColumn(label: Text('Customer')),
                    const DataColumn(label: Text('Firm')),
                    const DataColumn(label: Text('Type 1')),
                    const DataColumn(label: Text('Type 2')),
                  ]
                : [
                    const DataColumn(label: Text('Customer ID')),
                    const DataColumn(label: Text('Customer Name')),
                    const DataColumn(label: Text('Firm')),
                    const DataColumn(label: Text('Actions')),
                  ],
            rows: displayedItems.map((item) {
              if (showProducts) {
                Product product = item as Product;
                return DataRow(cells: [
                  DataCell(Text(product.productNr.toString())),
                  DataCell(Text(product.customer)),
                  DataCell(Text(product.firm)),
                  DataCell(Text(product.type1)),
                  DataCell(Text(product.type2)),
                ]);
              } else {
                Customer customer = item as Customer;
                return DataRow(cells: [
                  DataCell(Text(customer.customerId.toString())),
                  DataCell(Text(customer.name)),
                  DataCell(Text(customer.firm)),
                  DataCell(
                    ElevatedButton(
                      onPressed: () => _showCustomerPopup(context, customer),
                      child: const Text('Details'),
                    ),
                  ),
                ]);
              }
            }).toList(),
          ),
        ),
      ],
    );
  }
}