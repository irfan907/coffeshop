import 'package:firebase_auth/firebase_auth.dart';

class ProductModel {
  String? uid;
  String? name;
  String? price;
  String? description;
  String? volume;
  String? picture;

  ProductModel({
    this.uid,
    this.name,
    this.price,
    this.description,
    this.volume,
    this.picture,
  });

  // DATA FROM SERVER
  factory ProductModel.fromMap(map) {
    return ProductModel(
      uid: map['uid'],
      name: map['name'],
      price: map['price'],
      description: map['description'],
      volume: map['volume'],
      picture: map['picture'],
    );
  }

  // SENDING DATA TO SERVER
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'price': price,
      'description': description,
      'volume': volume,
      'picture': picture
    };
  }
}
