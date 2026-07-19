import '../constants/api_endpoints.dart';

/// User model representing a user in the app
/// 
/// Maps to API response structure from GET /users/profile/:
/// {
///   "email": "user@example.com",
///   "phone_number": "923331464646",
///   "full_name": "User Name",
///   "profile_image": "image.jpg"
/// }
/// 
/// Note: The 'id' field is not always present in API responses,
/// so it falls back to email hash or empty string if not provided.
class User {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? profileImage;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.profileImage,
    this.createdAt,
  });

  // Get display name (fallback to email if name is empty)
  String get displayName => fullName.isNotEmpty ? fullName : email;

  // Get full profile image URL from filename
  // If profileImage is already a full URL, return it as is
  // Otherwise, construct the URL using the base URL + media path
  // Tries multiple common paths: /media/, /static/, /uploads/
  String? get profileImageUrl {
    if (profileImage == null || profileImage!.isEmpty) return null;
    
    // If it's already a full URL (starts with http:// or https://), return as is
    if (profileImage!.startsWith('http://') || profileImage!.startsWith('https://')) {
      return profileImage;
    }
    
    // Remove leading slash from profileImage if present to avoid double slashes
    final imagePath = profileImage!.startsWith('/') ? profileImage!.substring(1) : profileImage!;
    
    // Try common Django/media file paths
    // Most common: /media/ (Django default)
    return '${ApiEndpoints.baseUrl}/media/$imagePath';
  }
  
  // Get alternative profile image URLs to try if primary fails
  // Returns a list of possible URLs to try in order
  List<String> get profileImageUrlAlternatives {
    if (profileImage == null || profileImage!.isEmpty) return [];
    
    // If it's already a full URL, return as is
    if (profileImage!.startsWith('http://') || profileImage!.startsWith('https://')) {
      return [profileImage!];
    }
    
    final imagePath = profileImage!.startsWith('/') ? profileImage!.substring(1) : profileImage!;
    
    // Try multiple common paths
    return [
      '${ApiEndpoints.baseUrl}/media/$imagePath',      // Django default
      '${ApiEndpoints.baseUrl}/static/$imagePath',     // Static files
      '${ApiEndpoints.baseUrl}/uploads/$imagePath',    // Uploads folder
      '${ApiEndpoints.baseUrl}/$imagePath',            // Root path
    ];
  }

  // Convert to Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'profile_image': profileImage,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Create from Map (handles both API response and local storage)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // ID can come from various fields or be generated from email if not present
      id: json['id']?.toString() ?? 
          json['user_id']?.toString() ?? 
          json['pk']?.toString() ?? 
          (json['email'] != null ? json['email'].toString().hashCode.toString() : ''),
      // Full name mapping
      fullName: json['full_name']?.toString() ?? 
                json['name']?.toString() ?? 
                json['fullName']?.toString() ?? 
                '',
      // Email mapping
      email: json['email']?.toString() ?? '',
      // Phone number mapping
      phoneNumber: json['phone_number']?.toString() ?? 
                   json['phoneNumber']?.toString(),
      // Profile image mapping
      profileImage: json['profile_image']?.toString() ?? 
                    json['profileImage']?.toString(),
      // Created at mapping
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'].toString())
              : null,
    );
  }

  // Create a copy with updated fields
  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? profileImage,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

