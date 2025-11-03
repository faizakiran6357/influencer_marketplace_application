
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
  final String? instagramToken;
  final String? tiktokToken;
  final String? youtubeToken;
  final double? pricePerPost;
  final String? profileImage;
  final bool onboardingCompleted;

  // ✅ YouTube Channel Metadata (Aligned with provider)
  final String? youtubeChannelId;
  final String? youtubeChannelName;
  final String? youtubeChannelThumbnail;
  final String? youtubeDescription;
  final int? youtubeSubscribers;

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
    this.instagramToken,
    this.tiktokToken,
    this.youtubeToken,
    this.pricePerPost,
    this.profileImage,
    this.onboardingCompleted = false,
    this.youtubeChannelId,
    this.youtubeChannelName,
    this.youtubeChannelThumbnail,
    this.youtubeDescription,
    this.youtubeSubscribers,
  });

  // ✅ Create model from Supabase map
  factory InfluencerModel.fromMap(Map<String, dynamic> map) {
    return InfluencerModel(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      bio: map['bio'],
      niche: map['niche'],
      followerCount:
          map['follower_count'] != null ? (map['follower_count'] as num).toInt() : 0,
      engagementRate:
          map['engagement_rate'] != null ? (map['engagement_rate'] as num).toDouble() : 0.0,
      instagramUrl: map['instagram_url'],
      tiktokUrl: map['tiktok_url'],
      youtubeUrl: map['youtube_url'],
      instagramToken: map['instagram_token'],
      tiktokToken: map['tiktok_token'],
      youtubeToken: map['youtube_token'],
      pricePerPost: map['price_per_post'] != null
          ? (map['price_per_post'] as num).toDouble()
          : 0.0,
      profileImage: map['profile_image'],
      onboardingCompleted: map['onboarding_completed'] ?? false,

      youtubeChannelId: map['youtube_channel_id'],
      youtubeChannelName: map['youtube_channel_name'],
      youtubeChannelThumbnail: map['youtube_channel_thumbnail'],
      youtubeDescription: map['youtube_description'],
      youtubeSubscribers: map['youtube_subscribers'] != null
          ? int.tryParse(map['youtube_subscribers'].toString())
          : null,
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
      'instagram_token': instagramToken,
      'tiktok_token': tiktokToken,
      'youtube_token': youtubeToken,
      'price_per_post': pricePerPost,
      'profile_image': profileImage,
      'onboarding_completed': onboardingCompleted,

      'youtube_channel_id': youtubeChannelId,
      'youtube_channel_name': youtubeChannelName,
      'youtube_channel_thumbnail': youtubeChannelThumbnail,
      'youtube_description': youtubeDescription,
      'youtube_subscribers': youtubeSubscribers,
    };
  }

  // ✅ CopyWith for safe updates
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
    String? instagramToken,
    String? tiktokToken,
    String? youtubeToken,
    double? pricePerPost,
    String? profileImage,
    bool? onboardingCompleted,
    String? youtubeChannelId,
    String? youtubeChannelName,
    String? youtubeChannelThumbnail,
    String? youtubeDescription,
    int? youtubeSubscribers,
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
      instagramToken: instagramToken ?? this.instagramToken,
      tiktokToken: tiktokToken ?? this.tiktokToken,
      youtubeToken: youtubeToken ?? this.youtubeToken,
      pricePerPost: pricePerPost ?? this.pricePerPost,
      profileImage: profileImage ?? this.profileImage,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      youtubeChannelId: youtubeChannelId ?? this.youtubeChannelId,
      youtubeChannelName: youtubeChannelName ?? this.youtubeChannelName,
      youtubeChannelThumbnail: youtubeChannelThumbnail ?? this.youtubeChannelThumbnail,
      youtubeDescription: youtubeDescription ?? this.youtubeDescription,
      youtubeSubscribers: youtubeSubscribers ?? this.youtubeSubscribers,
    );
  }
}
