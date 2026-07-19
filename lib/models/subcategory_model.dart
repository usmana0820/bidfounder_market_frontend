/// Subcategory model representing a product subcategory
class Subcategory {
  final int id;
  final int categoryId;
  final String categoryName;
  final String categorySlug;
  final String name;
  final String slug;

  Subcategory({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.categorySlug,
    required this.name,
    required this.slug,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    final category = json['category'] as Map<String, dynamic>? ?? {};
    return Subcategory(
      id: json['id'] as int,
      categoryId: category['id'] as int? ?? 0,
      categoryName: category['name'] as String? ?? '',
      categorySlug: category['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': {
        'id': categoryId,
        'name': categoryName,
        'slug': categorySlug,
      },
      'name': name,
      'slug': slug,
    };
  }
}

/// Subcategories paginated response
class SubcategoriesResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Subcategory> results;

  SubcategoriesResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory SubcategoriesResponse.fromJson(Map<String, dynamic> json) {
    return SubcategoriesResponse(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((item) => Subcategory.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

