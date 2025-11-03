// class CampaignModel {
//   final String id;
//   final String brandId;
//   final String title;
//   final String description;
//   final double budget;
//   final double spent;
//   final String status;

//   CampaignModel({
//     required this.id,
//     required this.brandId,
//     required this.title,
//     required this.description,
//     required this.budget,
//     required this.spent,
//     required this.status,
//   });

//   factory CampaignModel.fromMap(Map<String, dynamic> map) {
//     return CampaignModel(
//       id: map['id'],
//       brandId: map['brand_id'],
//       title: map['title'] ?? '',
//       description: map['description'] ?? '',
//       budget: (map['budget'] ?? 0).toDouble(),
//       spent: (map['spent'] ?? 0).toDouble(),
//       status: map['status'] ?? 'draft',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'brand_id': brandId,
//       'title': title,
//       'description': description,
//       'budget': budget,
//       'spent': spent,
//       'status': status,
//     };
//   }
// }
class CampaignModel {
  final String id; // Supabase UUID (campaign id)
  final String brandId; // References profiles.id of the brand
  final String title;
  final String description;
  final double budget;
  final double spent;
  final String status; // draft, active, completed
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CampaignModel({
    required this.id,
    required this.brandId,
    required this.title,
    required this.description,
    required this.budget,
    required this.spent,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CampaignModel.fromMap(Map<String, dynamic> map) {
    return CampaignModel(
      id: map['id'] ?? '',
      brandId: map['brand_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      budget: (map['budget'] ?? 0).toDouble(),
      spent: (map['spent'] ?? 0).toDouble(),
      status: map['status'] ?? 'draft',
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'brand_id': brandId,
      'title': title,
      'description': description,
      'budget': budget,
      'spent': spent,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  CampaignModel copyWith({
    String? id,
    String? brandId,
    String? title,
    String? description,
    double? budget,
    double? spent,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CampaignModel(
      id: id ?? this.id,
      brandId: brandId ?? this.brandId,
      title: title ?? this.title,
      description: description ?? this.description,
      budget: budget ?? this.budget,
      spent: spent ?? this.spent,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
