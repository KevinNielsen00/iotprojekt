class Client {
  final String name;
  final List<Product> products;

  Client({required this.name, required this.products});
}

List<Client> dummyClients = [
  Client(name: 'Client A', products: [dummyProducts[0], dummyProducts[1]]),
  Client(name: 'Client B', products: [dummyProducts[2]]),
  
];

class Product {
  final String name;
  final String description;

  Product(this.name, this.description);
}

final List<Product> dummyProducts = [
  Product('Product 1', 'Description of Product 1'),
  Product('Product 2', 'Description of Product 2'),
  Product('Product 3', 'Description of Product 3'), 
];