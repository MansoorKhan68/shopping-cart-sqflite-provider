class CartModel {
  late final int? id;
  final String? productId;
  final String? productName;
  final int? initialPrice;
  final int? productPrice;
  final int? quantity;
  final String? unitTag;
  final String? image;

  // Constructor
  CartModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.initialPrice,
    required this.productPrice,
    required this.quantity,
    required this.unitTag,
    required this.image,
  });

  // Convert from Map to CartModel
  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'] as int?,
      productId: map['productId'] as String?,
      productName: map['productName'] as String?,
      initialPrice: map['initialPrice'] as int?,
      productPrice: map['productPrice'] as int?,
      quantity: map['quantity'] as int?,
      unitTag: map['unitTag'] as String?,
      image: map['image'] as String?,
    );
  }

  // Convert CartModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'initialPrice': initialPrice,
      'productPrice': productPrice,
      'quantity': quantity,
      'unitTag': unitTag,
      'image': image,
    };
  }
}
