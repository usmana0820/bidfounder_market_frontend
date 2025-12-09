/// Product model representing a product/item in the marketplace
class Product {
  final String id;
  final String title;
  final String price;
  final dynamic image; // Can be String (URL) or AssetImage
  final String category;
  final String location;
  final String? description;
  final String? condition; // New, Used, Refurbished
  final String? brand;
  final String? model;
  final String? size;
  final String? color;
  final String? sellerId;
  final String? sellerName;
  final String? startBid;
  final String? currentBid;
  final String? bidCount;
  final List<dynamic>? images; // For product detail carousel

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    required this.location,
    this.description,
    this.condition,
    this.brand,
    this.model,
    this.size,
    this.color,
    this.sellerId,
    this.sellerName,
    this.startBid,
    this.currentBid,
    this.bidCount,
    this.images,
  });

  // Convert to Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'category': category,
      'location': location,
      'description': description,
      'condition': condition,
      'brand': brand,
      'model': model,
      'size': size,
      'color': color,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'startBid': startBid,
      'currentBid': currentBid,
      'bidCount': bidCount,
      'images': images,
    };
  }

  // Create from Map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      image: json['image'],
      category: json['category'] ?? '',
      location: json['location'] ?? '',
      description: json['description'],
      condition: json['condition'],
      brand: json['brand'],
      model: json['model'],
      size: json['size'],
      color: json['color'],
      sellerId: json['sellerId'],
      sellerName: json['sellerName'],
      startBid: json['startBid'],
      currentBid: json['currentBid'],
      bidCount: json['bidCount'],
      images: json['images'],
    );
  }

  // Create a copy with updated fields
  Product copyWith({
    String? id,
    String? title,
    String? price,
    dynamic image,
    String? category,
    String? location,
    String? description,
    String? condition,
    String? brand,
    String? model,
    String? size,
    String? color,
    String? sellerId,
    String? sellerName,
    String? startBid,
    String? currentBid,
    String? bidCount,
    List<dynamic>? images,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
      location: location ?? this.location,
      description: description ?? this.description,
      condition: condition ?? this.condition,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      size: size ?? this.size,
      color: color ?? this.color,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      startBid: startBid ?? this.startBid,
      currentBid: currentBid ?? this.currentBid,
      bidCount: bidCount ?? this.bidCount,
      images: images ?? this.images,
    );
  }
}

