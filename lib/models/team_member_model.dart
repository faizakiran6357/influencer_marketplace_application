class TeamMemberModel {
  final String id;
  final String brandId;
  final String userId;
  final String role;

  TeamMemberModel({
    required this.id,
    required this.brandId,
    required this.userId,
    required this.role,
  });

  factory TeamMemberModel.fromMap(Map<String, dynamic> map) {
    return TeamMemberModel(
      id: map['id'],
      brandId: map['brand_id'],
      userId: map['user_id'],
      role: map['role'] ?? 'manager',
    );
  }
}
