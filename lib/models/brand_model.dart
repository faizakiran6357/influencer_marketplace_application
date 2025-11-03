// class BrandModel {
//   final String id;
//   final String name;
//   final String email;
//   final String? profileImage;
//   final String? bio;
//   final String? website;

//   BrandModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     this.profileImage,
//     this.bio,
//     this.website,
//   });

//   factory BrandModel.fromMap(Map<String, dynamic> map) {
//     return BrandModel(
//       id: map['id'],
//       name: map['name'] ?? '',
//       email: map['email'] ?? '',
//       profileImage: map['profile_image'],
//       bio: map['bio'],
//       website: map['website'],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'email': email,
//       'profile_image': profileImage,
//       'bio': bio,
//       'website': website,
//     };
//   }

//   BrandModel copyWith({
//     String? name,
//     String? email,
//     String? profileImage,
//     String? bio,
//     String? website,
//   }) {
//     return BrandModel(
//       id: id,
//       name: name ?? this.name,
//       email: email ?? this.email,
//       profileImage: profileImage ?? this.profileImage,
//       bio: bio ?? this.bio,
//       website: website ?? this.website,
//     );
//   }
// }
class BrandModel {
  final String id; // same as profiles.id
  final String name;
  final String email;
  final String role; // 'brand'
  final String? bio;
  final String? website;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BrandModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.bio,
    this.website,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  /// ✅ Create a BrandModel from Supabase row (profiles table)
  factory BrandModel.fromMap(Map<String, dynamic> map) {
    return BrandModel(
      id: map['id'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'brand',
      bio: map['bio'],
      website: map['website'],
      profileImage: map['profile_image'],
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'])
          : null,
    );
  }

  /// ✅ Convert BrandModel to map for updating/inserting in Supabase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'bio': bio,
      'website': website,
      'profile_image': profileImage,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// ✅ For editing or copying an existing BrandModel
  BrandModel copyWith({
    String? name,
    String? email,
    String? role,
    String? bio,
    String? website,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BrandModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
