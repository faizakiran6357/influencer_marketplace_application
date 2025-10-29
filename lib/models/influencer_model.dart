class InfluencerModel {
  final String id;
  final String? email;
  final String? name;
  final String? bio;
  final String? niche;
  final String? instagramUrl;
  final String? tiktokUrl;
  final String? youtubeUrl;
  final double? pricePerPost;
  final int? followers;
  final int? engagementRate;
  final String? profileImage;

  InfluencerModel({
    required this.id,
    this.email,
    this.name,
    this.bio,
    this.niche,
    this.instagramUrl,
    this.tiktokUrl,
    this.youtubeUrl,
    this.pricePerPost,
    this.followers,
    this.engagementRate,
    this.profileImage,
  });

  factory InfluencerModel.fromMap(Map<String, dynamic> map) => InfluencerModel(
        id: map['id'],
        email: map['email'],
        name: map['name'],
        bio: map['bio'],
        niche: map['niche'],
        instagramUrl: map['instagram_url'],
        tiktokUrl: map['tiktok_url'],
        youtubeUrl: map['youtube_url'],
        pricePerPost:
            map['price_per_post'] == null ? 0 : (map['price_per_post'] as num).toDouble(),
        followers: map['followers'] ?? 0,
        engagementRate: map['engagement_rate'] ?? 0,
        profileImage: map['profile_image'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'name': name,
        'bio': bio,
        'niche': niche,
        'instagram_url': instagramUrl,
        'tiktok_url': tiktokUrl,
        'youtube_url': youtubeUrl,
        'price_per_post': pricePerPost,
        'followers': followers,
        'engagement_rate': engagementRate,
        'profile_image': profileImage,
      };
}
