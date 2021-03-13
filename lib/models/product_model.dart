import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String name;
  String description;
  num price;
  num discount;
  List<dynamic> imageList;
  String category;
  num quantity;
  List<dynamic> sizes;
  List<dynamic> colors;
  DocumentReference refernce;

  Product(
      {this.name,
      this.description,
      this.price,
      this.discount,
      this.imageList,
      this.category,
      this.quantity,
      this.sizes,
      this.colors});

  Product.fromMap(Map<String, dynamic> map, {this.refernce})
      : name = map['name'],
        description = map['description'],
        price = map['price'],
        discount = map['discount'],
        category = map['category'],
        quantity = map['quantity'],
        sizes = map['sizes'],
        colors = map['colors'],
        imageList = map['imageurlList'];

  Product.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, refernce: snapshot.reference);
}
