class Product {
  int productID;      // matches ProductID in Go
  int customerNr;     // matches CustomerNr in Go
  int meterID;        // matches MeterID in Go
  String productNr;   // matches ProductNr in Go
  String oilType;
  String barrelType;
  double height;      // Use double in Dart for float32

  Product({
    required this.productID,
    required this.customerNr,
    required this.meterID,
    required this.productNr,
    required this.oilType,
    required this.barrelType,
    required this.height,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productID: json['product_id'] ?? 0,      // Map Go field ProductID to productID
      customerNr: json['customer_nr'] ?? 0,    // Map Go field CustomerNr to customerNr
      meterID: json['meter_id'] ?? 0,          // Map Go field MeterID to meterID
      productNr: json['product_nr'] ?? 'Unknown',
      oilType: json['oil_type'] ?? 'Unknown',
      barrelType: json['barrel_type'] ?? 'Unknown',
      height: (json['height'] ?? 0.0).toDouble(),  // Handle float32 to double conversion
    );
  }

  get firm => null;
}