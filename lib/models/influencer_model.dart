// class InfluencerModel {
//   final String id;
//   final String? email;
//   final String? name;
//   final String? bio;
//   final String? niche;
//   final String? instagramUrl;
//   final String? tiktokUrl;
//   final String? youtubeUrl;
//   final double? pricePerPost;
//   final int? followers;
//   final int? engagementRate;
//   final String? profileImage;

//   InfluencerModel({
//     required this.id,
//     this.email,
//     this.name,
//     this.bio,
//     this.niche,
//     this.instagramUrl,
//     this.tiktokUrl,
//     this.youtubeUrl,
//     this.pricePerPost,
//     this.followers,
//     this.engagementRate,
//     this.profileImage,
//   });

//   factory InfluencerModel.fromMap(Map<String, dynamic> map) => InfluencerModel(
//         id: map['id'],
//         email: map['email'],
//         name: map['name'],
//         bio: map['bio'],
//         niche: map['niche'],
//         instagramUrl: map['instagram_url'],
//         tiktokUrl: map['tiktok_url'],
//         youtubeUrl: map['youtube_url'],
//         pricePerPost:
//             map['price_per_post'] == null ? 0 : (map['price_per_post'] as num).toDouble(),
//         followers: map['followers'] ?? 0,
//         engagementRate: map['engagement_rate'] ?? 0,
//         profileImage: map['profile_image'],
//       );

//   Map<String, dynamic> toMap() => {
//         'id': id,
//         'email': email,
//         'name': name,
//         'bio': bio,
//         'niche': niche,
//         'instagram_url': instagramUrl,
//         'tiktok_url': tiktokUrl,
//         'youtube_url': youtubeUrl,
//         'price_per_post': pricePerPost,
//         'followers': followers,
//         'engagement_rate': engagementRate,
//         'profile_image': profileImage,
//       };
// }
// class InfluencerModel {
//   final String id;
//   final String? email;
//   final String? name;
//   final String? bio;
//   final String? niche;
//   final int? followerCount;
//   final double? engagementRate;
//   final String? instagramUrl;
//   final String? tiktokUrl;
//   final String? youtubeUrl;
//   final double? pricePerPost;
//   final int? followers;
//   final int? engagementRateInt; // legacy if used
//   final String? profileImage;
//   final bool onboardingCompleted;

//   InfluencerModel({
//     required this.id,
//     this.email,
//     this.name,
//     this.bio,
//     this.niche,
//     this.followerCount,
//     this.engagementRate,
//     this.instagramUrl,
//     this.tiktokUrl,
//     this.youtubeUrl,
//     this.pricePerPost,
//     this.followers,
//     this.engagementRateInt,
//     this.profileImage,
//     this.onboardingCompleted = false,
//   });

//   // ✅ Factory to create model from Supabase map
//   factory InfluencerModel.fromMap(Map<String, dynamic> map) {
//     return InfluencerModel(
//       id: map['id'],
//       email: map['email'],
//       name: map['name'],
//       bio: map['bio'],
//       niche: map['niche'],
//       followerCount: map['follower_count'] is int ? map['follower_count'] : 0,
//       engagementRate: map['engagement_rate'] != null
//           ? (map['engagement_rate'] as num).toDouble()
//           : 0.0,
//       instagramUrl: map['instagram_url'],
//       tiktokUrl: map['tiktok_url'],
//       youtubeUrl: map['youtube_url'],
//       pricePerPost: map['price_per_post'] != null
//           ? (map['price_per_post'] as num).toDouble()
//           : 0.0,
//       followers: map['followers'] ?? 0,
//       engagementRateInt: map['engagement_rate'] ?? 0,
//       profileImage: map['profile_image'],
//       onboardingCompleted: map['onboarding_completed'] ?? false,
//     );
//   }

//   // ✅ Convert model to Map for Supabase
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'email': email,
//       'name': name,
//       'bio': bio,
//       'niche': niche,
//       'follower_count': followerCount,
//       'engagement_rate': engagementRate,
//       'instagram_url': instagramUrl,
//       'tiktok_url': tiktokUrl,
//       'youtube_url': youtubeUrl,
//       'price_per_post': pricePerPost,
//       'followers': followers,
//       'profile_image': profileImage,
//       'onboarding_completed': onboardingCompleted,
//     };
//   }

//   // ✅ Add copyWith to update model safely
//   InfluencerModel copyWith({
//     String? id,
//     String? email,
//     String? name,
//     String? bio,
//     String? niche,
//     int? followerCount,
//     double? engagementRate,
//     String? instagramUrl,
//     String? tiktokUrl,
//     String? youtubeUrl,
//     double? pricePerPost,
//     int? followers,
//     int? engagementRateInt,
//     String? profileImage,
//     bool? onboardingCompleted,
//   }) {
//     return InfluencerModel(
//       id: id ?? this.id,
//       email: email ?? this.email,
//       name: name ?? this.name,
//       bio: bio ?? this.bio,
//       niche: niche ?? this.niche,
//       followerCount: followerCount ?? this.followerCount,
//       engagementRate: engagementRate ?? this.engagementRate,
//       instagramUrl: instagramUrl ?? this.instagramUrl,
//       tiktokUrl: tiktokUrl ?? this.tiktokUrl,
//       youtubeUrl: youtubeUrl ?? this.youtubeUrl,
//       pricePerPost: pricePerPost ?? this.pricePerPost,
//       followers: followers ?? this.followers,
//       engagementRateInt: engagementRateInt ?? this.engagementRateInt,
//       profileImage: profileImage ?? this.profileImage,
//       onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
//     );
//   }
// }

class InfluencerModel {
  final String id;
  final String? email;
  final String? name;
  final String? bio;
  final String? niche;
  final int? followerCount;
  final double? engagementRate;
  final String? instagramUrl;
  final String? tiktokUrl;
  final String? youtubeUrl;
  final double? pricePerPost;
  final String? profileImage;
  final bool onboardingCompleted;

  InfluencerModel({
    required this.id,
    this.email,
    this.name,
    this.bio,
    this.niche,
    this.followerCount,
    this.engagementRate,
    this.instagramUrl,
    this.tiktokUrl,
    this.youtubeUrl,
    this.pricePerPost,
    this.profileImage,
    this.onboardingCompleted = false,
  });

  // ✅ Factory to create model from Supabase map safely
  factory InfluencerModel.fromMap(Map<String, dynamic> map) {
    return InfluencerModel(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      bio: map['bio'],
      niche: map['niche'],
      followerCount: map['follower_count'] != null
          ? (map['follower_count'] as num).toInt()
          : 0,
      engagementRate: map['engagement_rate'] != null
          ? (map['engagement_rate'] as num).toDouble()
          : 0.0,
      instagramUrl: map['instagram_url'],
      tiktokUrl: map['tiktok_url'],
      youtubeUrl: map['youtube_url'],
      pricePerPost: map['price_per_post'] != null
          ? (map['price_per_post'] as num).toDouble()
          : 0.0,
      profileImage: map['profile_image'],
      onboardingCompleted: map['onboarding_completed'] ?? false,
    );
  }

  // ✅ Convert model to Map for Supabase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'bio': bio,
      'niche': niche,
      'follower_count': followerCount,
      'engagement_rate': engagementRate,
      'instagram_url': instagramUrl,
      'tiktok_url': tiktokUrl,
      'youtube_url': youtubeUrl,
      'price_per_post': pricePerPost,
      'profile_image': profileImage,
      'onboarding_completed': onboardingCompleted,
    };
  }

  // ✅ CopyWith to safely update model
  InfluencerModel copyWith({
    String? id,
    String? email,
    String? name,
    String? bio,
    String? niche,
    int? followerCount,
    double? engagementRate,
    String? instagramUrl,
    String? tiktokUrl,
    String? youtubeUrl,
    double? pricePerPost,
    String? profileImage,
    bool? onboardingCompleted,
  }) {
    return InfluencerModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      niche: niche ?? this.niche,
      followerCount: followerCount ?? this.followerCount,
      engagementRate: engagementRate ?? this.engagementRate,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      tiktokUrl: tiktokUrl ?? this.tiktokUrl,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      pricePerPost: pricePerPost ?? this.pricePerPost,
      profileImage: profileImage ?? this.profileImage,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}
