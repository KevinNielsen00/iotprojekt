class Customer {
  int customerNr;   // matches CustomerNr in Go
  String firm;
  String phoneNr;   // matches PhoneNr in Go
  String mail;
  String location;

  Customer({
    required this.customerNr,
    required this.firm,
    required this.phoneNr,
    required this.mail,
    required this.location,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerNr: json['customer_nr'] ?? 0,    // Map Go field CustomerNr to customerNr
      firm: json['firm'] ?? 'Unknown',
      phoneNr: json['phone_nr'] ?? 'Unknown',  // Map Go field PhoneNr to phoneNr
      mail: json['mail'] ?? 'Unknown',
      location: json['location'] ?? 'Unknown',
    );
  }
}