/// Category model representing a product category
class Category {
  final int id;
  final String name;
  final String slug;
  final String? description;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
  });

  /// Convert from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
    };
  }

  /// Get category image asset path based on slug
  String get imageAsset {
    final imageMap = {
      'electronics': 'assets/images/Electronics.jpg',
      'fashion': 'assets/images/Fashion.jpg',
      'home-garden': 'assets/images/Home & Garden.jpg',
      'vehicles-automotive': 'assets/images/Vehicles.jpg',
      'sports-outdoors': 'assets/images/Sports & Outdoors.jpg',
      'toys-kids-baby': 'assets/images/Toys, Kids & Baby.jpg',
      'books-music-media': 'assets/images/Books, Music & Media.jpg',
      'health-beauty': 'assets/images/Health & Beauty.jpg',
      'musical-instruments': 'assets/images/Musical Instruments.jpg',
      'industrial-business': 'assets/images/Industrial & Business.jpg',
      'collectibles-art': 'assets/images/Miscellaneous.jpg',
      'pet-supplies': 'assets/images/Miscellaneous.jpg',
    };
    return imageMap[slug] ?? 'assets/images/Miscellaneous.jpg';
  }
}

/// Categories response model for paginated API responses
class CategoriesResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Category> results;

  CategoriesResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return CategoriesResponse(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((category) => category.toJson()).toList(),
    };
  }
}

