import 'product_model.dart';

/// Cart item model representing an item in the shopping cart
class CartItem {
  final String id;
  final String productId;
  final String title;
  final String price;
  final dynamic image; // Can be String (URL) or AssetImage
  final String category;
  final String location;
  final String sellerId;
  final String sellerName;
  final int quantity;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    required this.location,
    required this.sellerId,
    required this.sellerName,
    this.quantity = 1,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  // Convert from Product
  factory CartItem.fromProduct(Product product, {int quantity = 1}) {
    return CartItem(
      id: 'cart-${DateTime.now().millisecondsSinceEpoch}-${product.id}',
      productId: product.id,
      title: product.title,
      price: product.price,
      image: product.image,
      category: product.category,
      location: product.location,
      sellerId: product.sellerId ?? '',
      sellerName: product.sellerName ?? '',
      quantity: quantity,
    );
  }

  // Convert to Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'category': category,
      'location': location,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  // Create from Map
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      image: json['image'],
      category: json['category'] ?? '',
      location: json['location'] ?? '',
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      quantity: json['quantity'] ?? 1,
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'])
          : DateTime.now(),
    );
  }

  // Create a copy with updated fields
  CartItem copyWith({
    String? id,
    String? productId,
    String? title,
    String? price,
    dynamic image,
    String? category,
    String? location,
    String? sellerId,
    String? sellerName,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
      location: location ?? this.location,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  // Calculate item total price
  double get itemTotal {
    final priceValue = price.replaceAll(RegExp(r'[£,]'), '');
    return (double.tryParse(priceValue) ?? 0.0) * quantity;
  }
}

