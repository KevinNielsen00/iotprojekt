import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../models/customer.dart';
import 'package:my_app/api/fetch_customer.dart';
import 'package:my_app/api/fetch_product.dart';

class MyTableSection extends StatefulWidget {
  const MyTableSection({super.key});

  @override
  _MyTableSectionState createState() => _MyTableSectionState();
}

class _MyTableSectionState extends State<MyTableSection> {
  List<Product> allProducts = [];
  List<Customer> allCustomers = [];
  List<dynamic> displayedItems = [];
  TextEditingController searchController = TextEditingController();
  bool showProducts = true;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch API data instead of hardcoded lists
  }

  void _fetchData() async {
    try {
      List<Product> products = await fetchProducts();
      List<Customer> customers = await fetchCustomers();

      setState(() {
        allProducts = products;
        allCustomers = customers;
        displayedItems = allProducts; // Default to products
      });
    } catch (error) {
      // Handle the error (e.g., show an error message)
      print('Error fetching data: $error');
    }
  }

  String _findFirmForProduct(int customerNr) {
    // Find the corresponding customer by CustomerNr and return the firm
    final customer = allCustomers.firstWhere(
      (customer) => customer.customerNr == customerNr,
      orElse: () => Customer(customerNr: -1, firm: 'Unknown', phoneNr: '', mail: '', location: '')
    );
    return customer.firm;
  }

  void _searchItems(String query) {
    List<dynamic> results = [];
    if (query.isEmpty) {
      results = showProducts ? allProducts : allCustomers;
    } else {
      results = (showProducts ? allProducts : allCustomers).where((item) {
        if (showProducts) {
          Product product = item as Product;
          String firm = _findFirmForProduct(product.customerNr); // Get the firm's name for the product
          return product.productNr.toLowerCase().contains(query.toLowerCase()) ||
                 product.oilType.toLowerCase().contains(query.toLowerCase()) ||
                 firm.toLowerCase().contains(query.toLowerCase());  // Add search by firm's name
        } else {
          Customer customer = item as Customer;
          return customer.customerNr.toString().contains(query) || 
                 customer.firm.toLowerCase().contains(query.toLowerCase()) ||
                 customer.mail.toLowerCase().contains(query.toLowerCase());
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
          content: Text('Customer: ${customer.customerNr}\nFirm: ${customer.firm}\nEmail: ${customer.mail}'),
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
                    const DataColumn(label: Text('Customer Number')),
                    const DataColumn(label: Text('Firm')),
                    const DataColumn(label: Text('Oil Type')),
                    const DataColumn(label: Text('Barrel Type')),
                    const DataColumn(label: Text('Height')),
                  ]
                : [
                    const DataColumn(label: Text('Customer Number')),
                    const DataColumn(label: Text('Firm')),
                    const DataColumn(label: Text('Phone Number')),
                    const DataColumn(label: Text('Email')),
                    const DataColumn(label: Text('Location')),
                    const DataColumn(label: Text('Actions')),
                  ],
            rows: displayedItems.map((item) {
              if (showProducts) {
                Product product = item as Product;
                String firm = _findFirmForProduct(product.customerNr); // Find the firm's name for the product
                return DataRow(cells: [
                  DataCell(Text(product.productNr.toString())),
                  DataCell(Text(product.customerNr.toString())),
                  DataCell(Text(firm)), // Display the firm of the product
                  DataCell(Text(product.oilType)),
                  DataCell(Text(product.barrelType)),
                  DataCell(Text(product.height.toString())),
                ]);
              } else {
                Customer customer = item as Customer;
                return DataRow(cells: [
                  DataCell(Text(customer.customerNr.toString())),
                  DataCell(Text(customer.firm)),
                  DataCell(Text(customer.phoneNr)),
                  DataCell(Text(customer.mail)),
                  DataCell(Text(customer.location)),
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