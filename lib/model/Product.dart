class ProductModel {

  String id;
  String name;
  String description;
  String category;
  double price;
  List images;
  List sizes;

  ProductModel.fromDocument(Map product) {
    id = product['id'];
    name = product['name'];
    description = product['description'];
    price = product['price'] + 0.0;
    images = product['images'];
    sizes = product['sizes'];
  }

  Map<String, dynamic> toResumedMap () {
    return {
      'name': name,
      'description': description,
      'price': price
    };
  }

}