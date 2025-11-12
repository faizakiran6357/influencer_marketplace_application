
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // Influencer or Brand
  final String? bio;
  final String? website;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.bio,
    this.website,
    this.profileImage,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      bio: data['bio'],
      website: data['website'],
      profileImage: data['profile_image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'bio': bio,
      'website': website,
      'profile_image': profileImage,
    };
  }
}
