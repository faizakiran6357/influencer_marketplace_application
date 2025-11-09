
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/influencer_model.dart';
// import '../models/audience_model.dart';

// class InfluencerService {
//   final _supabase = Supabase.instance.client;

//   // ✅ Fetch influencer profile safely
//   Future<InfluencerModel?> fetchInfluencer(String userId) async {
//     try {
//       final res = await _supabase
//           .from('influencers')
//           .select()
//           .eq('id', userId)
//           .maybeSingle();

//       if (res == null) return null;

//       final safeMap = Map<String, dynamic>.from(res);
//       if (safeMap['follower_count'] != null) {
//         safeMap['follower_count'] = (safeMap['follower_count'] as num).toInt();
//       }
//       if (safeMap['engagement_rate'] != null) {
//         safeMap['engagement_rate'] = (safeMap['engagement_rate'] as num).toDouble();
//       }
//       if (safeMap['price_per_post'] != null) {
//         safeMap['price_per_post'] = (safeMap['price_per_post'] as num).toDouble();
//       }

//       return InfluencerModel.fromMap(safeMap);
//     } catch (e) {
//       debugPrint("❌ Error fetching influencer: $e");
//       return null;
//     }
//   }

//   // ✅ Upsert influencer profile
//   Future<void> upsertInfluencer(InfluencerModel model) async {
//     try {
//       await _supabase.from('influencers').upsert(model.toMap());
//       debugPrint("✅ Influencer upsert successful for ${model.id}");
//     } catch (e) {
//       debugPrint("❌ Error upserting influencer: $e");
//       rethrow;
//     }
//   }

//   // ✅ Update social media tokens
//   Future<void> updateSocialTokens({
//     required String influencerId,
//     String? instagramToken,
//     String? tiktokToken,
//     String? youtubeToken,
//   }) async {
//     try {
//       final data = <String, dynamic>{};
//       if (instagramToken != null) data['instagram_token'] = instagramToken;
//       if (tiktokToken != null) data['tiktok_token'] = tiktokToken;
//       if (youtubeToken != null) data['youtube_token'] = youtubeToken;

//       if (data.isNotEmpty) {
//         await _supabase.from('influencers').update(data).eq('id', influencerId);
//         debugPrint("✅ Social media tokens updated for $influencerId");
//       }
//     } catch (e) {
//       debugPrint("❌ Error updating social tokens: $e");
//     }
//   }

//   // ✅ Upload profile image
//   Future<String?> uploadProfileImage(String influencerId, Uint8List bytes) async {
//     try {
//       final path = '$influencerId/profile_image_${DateTime.now().millisecondsSinceEpoch}.png';

//       await _supabase.storage.from('profile_images').uploadBinary(
//         path,
//         bytes,
//         fileOptions: const FileOptions(upsert: true),
//       );

//       final publicUrl = _supabase.storage.from('profile_images').getPublicUrl(path);
//       debugPrint("✅ Profile image uploaded: $publicUrl");

//       await _supabase.from('influencers').update({
//         'profile_image': publicUrl,
//         'updated_at': DateTime.now().toIso8601String(),
//       }).eq('id', influencerId);

//       return publicUrl;
//     } catch (e) {
//       debugPrint("❌ Error uploading profile image: $e");
//       return null;
//     }
//   }

//   // ✅ Mark onboarding complete
//   Future<void> markOnboardingComplete(String influencerId) async {
//     try {
//       await _supabase.from('influencers').update({
//         'onboarding_completed': true,
//         'updated_at': DateTime.now().toIso8601String(),
//       }).eq('id', influencerId);

//       debugPrint("✅ Onboarding marked complete for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Error marking onboarding complete: $e");
//     }
//   }

//   // ✅ Portfolio upload and fetch
//   Future<void> uploadPortfolioItem({
//     required String influencerId,
//     required Uint8List bytes,
//     required String filename,
//     required String title,
//     required String description,
//   }) async {
//     try {
//       final path = '$influencerId/$filename';

//       await _supabase.storage.from('portfolio').uploadBinary(
//         path,
//         bytes,
//         fileOptions: const FileOptions(upsert: true),
//       );

//       final publicUrl = _supabase.storage.from('portfolio').getPublicUrl(path);

//       await _supabase.from('portfolio_items').insert({
//         'influencer_id': influencerId,
//         'title': title,
//         'description': description,
//         'storage_path': path,
//         'public_url': publicUrl,
//       });

//       debugPrint("✅ Portfolio item uploaded for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Upload portfolio item failed: $e");
//       rethrow;
//     }
//   }

//   Future<List<Map<String, dynamic>>> fetchPortfolio(String influencerId) async {
//     try {
//       final res = await _supabase
//           .from('portfolio_items')
//           .select()
//           .eq('influencer_id', influencerId)
//           .order('created_at', ascending: false);

//       return List<Map<String, dynamic>>.from(res);
//     } catch (e) {
//       debugPrint("❌ Error fetching portfolio: $e");
//       return [];
//     }
//   }

//   // ✅ Offers and earnings
//   Future<List<Map<String, dynamic>>> fetchOffers(String influencerId) async {
//     try {
//       final res = await _supabase
//           .from('offers')
//           .select()
//           .eq('influencer_id', influencerId)
//           .order('created_at', ascending: false);

//       return List<Map<String, dynamic>>.from(res);
//     } catch (e) {
//       debugPrint("❌ Error fetching offers: $e");
//       return [];
//     }
//   }

//   Future<void> addOffer({
//     required String influencerId,
//     required String brandName,
//     required String campaignName,
//     required String description,
//     required double budget,
//   }) async {
//     try {
//       await _supabase.from('offers').insert({
//         'influencer_id': influencerId,
//         'brand_name': brandName,
//         'campaign_name': campaignName,
//         'description': description,
//         'budget': budget,
//       });
//       debugPrint("✅ Offer added successfully for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Error adding offer: $e");
//     }
//   }

//   Future<List<Map<String, dynamic>>> fetchEarnings(String influencerId) async {
//     try {
//       final res = await _supabase
//           .from('earnings')
//           .select()
//           .eq('influencer_id', influencerId)
//           .order('date', ascending: false);

//       return List<Map<String, dynamic>>.from(res);
//     } catch (e) {
//       debugPrint("❌ Error fetching earnings: $e");
//       return [];
//     }
//   }

//   Future<void> addEarning({
//     required String influencerId,
//     required double amount,
//     required String description,
//   }) async {
//     try {
//       await _supabase.from('earnings').insert({
//         'influencer_id': influencerId,
//         'amount': amount,
//         'description': description,
//       });
//       debugPrint("✅ Earning added successfully for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Error adding earning: $e");
//     }
//   }

//   // ✅ Audience analytics
//   Future<void> upsertAudience(String influencerId, AudienceModel data) async {
//     try {
//       await _supabase.from('influencer_audience').upsert({
//         'influencer_id': influencerId,
//         ...data.toMap(),
//       });
//       debugPrint("✅ Audience analytics upserted for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Error upserting audience analytics: $e");
//       rethrow;
//     }
//   }

//   Future<AudienceModel?> fetchAudience(String influencerId) async {
//     try {
//       final res = await _supabase
//           .from('influencer_audience')
//           .select('*')
//           .eq('influencer_id', influencerId)
//           .maybeSingle();

//       if (res == null) return null;
//       return AudienceModel.fromMap(Map<String, dynamic>.from(res));
//     } catch (e) {
//       debugPrint("❌ Error fetching audience analytics: $e");
//       return null;
//     }
//   }

//   // ✅ Update YouTube data in Supabase
//   Future<void> updateYouTubeData({
//     required String influencerId,
//     required String accessToken,
//     required String channelId,
//     required String channelName,
//     required String channelThumbnail,
//     required int subscribers,
//     String? description,
//   }) async {
//     try {
//       await _supabase.from('influencers').update({
//         'youtube_token': accessToken,
//         'youtube_channel_id': channelId,
//         'youtube_channel_name': channelName,
//         'youtube_channel_thumbnail': channelThumbnail,
//         'youtube_subscribers': subscribers,
//         'youtube_description': description ?? '',
//         'updated_at': DateTime.now().toIso8601String(),
//       }).eq('id', influencerId);

//       debugPrint("✅ YouTube data updated in Supabase for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Error updating YouTube data: $e");
//     }
//   }
// }
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/influencer_model.dart';
// import '../models/audience_model.dart';

// class InfluencerService {
//   final _supabase = Supabase.instance.client;

//   // ✅ Fetch influencer profile safely
//   Future<InfluencerModel?> fetchInfluencer(String userId) async {
//     try {
//       final res = await _supabase
//           .from('influencers')
//           .select()
//           .eq('id', userId)
//           .maybeSingle();

//       if (res == null) return null;

//       final safeMap = Map<String, dynamic>.from(res);
//       if (safeMap['follower_count'] != null) {
//         safeMap['follower_count'] = (safeMap['follower_count'] as num).toInt();
//       }
//       if (safeMap['engagement_rate'] != null) {
//         safeMap['engagement_rate'] =
//             (safeMap['engagement_rate'] as num).toDouble();
//       }
//       if (safeMap['price_per_post'] != null) {
//         safeMap['price_per_post'] = (safeMap['price_per_post'] as num).toDouble();
//       }

//       return InfluencerModel.fromMap(safeMap);
//     } catch (e) {
//       debugPrint("❌ Error fetching influencer: $e");
//       return null;
//     }
//   }

//   // ✅ Upsert influencer profile
//   Future<void> upsertInfluencer(InfluencerModel model) async {
//     try {
//       await _supabase.from('influencers').upsert(model.toMap());
//       debugPrint("✅ Influencer upsert successful for ${model.id}");
//     } catch (e) {
//       debugPrint("❌ Error upserting influencer: $e");
//       rethrow;
//     }
//   }

//   // ✅ Update social media tokens
//   Future<void> updateSocialTokens({
//     required String influencerId,
//     String? instagramToken,
//     String? tiktokToken,
//     String? youtubeToken,
//   }) async {
//     try {
//       final data = <String, dynamic>{};
//       if (instagramToken != null) data['instagram_token'] = instagramToken;
//       if (tiktokToken != null) data['tiktok_token'] = tiktokToken;
//       if (youtubeToken != null) data['youtube_token'] = youtubeToken;

//       if (data.isNotEmpty) {
//         await _supabase.from('influencers').update(data).eq('id', influencerId);
//         debugPrint("✅ Social media tokens updated for $influencerId");
//       }
//     } catch (e) {
//       debugPrint("❌ Error updating social tokens: $e");
//     }
//   }

//   // ✅ Upload profile image
//   Future<String?> uploadProfileImage(String influencerId, Uint8List bytes) async {
//     try {
//       final path =
//           '$influencerId/profile_image_${DateTime.now().millisecondsSinceEpoch}.png';

//       await _supabase.storage.from('profile_images').uploadBinary(
//             path,
//             bytes,
//             fileOptions: const FileOptions(upsert: true),
//           );

//       final publicUrl = _supabase.storage.from('profile_images').getPublicUrl(path);
//       debugPrint("✅ Profile image uploaded: $publicUrl");

//       await _supabase.from('influencers').update({
//         'profile_image': publicUrl,
//         'updated_at': DateTime.now().toIso8601String(),
//       }).eq('id', influencerId);

//       return publicUrl;
//     } catch (e) {
//       debugPrint("❌ Error uploading profile image: $e");
//       return null;
//     }
//   }

//   // ✅ Mark onboarding complete
//   Future<void> markOnboardingComplete(String influencerId) async {
//     try {
//       await _supabase.from('influencers').update({
//         'onboarding_completed': true,
//         'updated_at': DateTime.now().toIso8601String(),
//       }).eq('id', influencerId);

//       debugPrint("✅ Onboarding marked complete for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Error marking onboarding complete: $e");
//     }
//   }

//   // ✅ Portfolio upload and fetch
//   Future<void> uploadPortfolioItem({
//     required String influencerId,
//     required Uint8List bytes,
//     required String filename,
//     required String title,
//     required String description,
//   }) async {
//     try {
//       final path = '$influencerId/$filename';

//       await _supabase.storage.from('portfolio').uploadBinary(
//             path,
//             bytes,
//             fileOptions: const FileOptions(upsert: true),
//           );

//       final publicUrl = _supabase.storage.from('portfolio').getPublicUrl(path);

//       await _supabase.from('portfolio_items').insert({
//         'influencer_id': influencerId,
//         'title': title,
//         'description': description,
//         'storage_path': path,
//         'public_url': publicUrl,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       debugPrint("✅ Portfolio item uploaded for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Upload portfolio item failed: $e");
//       rethrow;
//     }
//   }

//   Future<List<Map<String, dynamic>>> fetchPortfolio(String influencerId) async {
//     try {
//       final res = await _supabase
//           .from('portfolio_items')
//           .select()
//           .eq('influencer_id', influencerId)
//           .order('created_at', ascending: false);

//       return List<Map<String, dynamic>>.from(res);
//     } catch (e) {
//       debugPrint("❌ Error fetching portfolio: $e");
//       return [];
//     }
//   }

//   // ✅ Offers and earnings
//   Future<List<Map<String, dynamic>>> fetchOffers(String influencerId) async {
//     try {
//       final res = await _supabase
//           .from('offers')
//           .select()
//           .eq('influencer_id', influencerId)
//           .order('created_at', ascending: false);

//       return List<Map<String, dynamic>>.from(res);
//     } catch (e) {
//       debugPrint("❌ Error fetching offers: $e");
//       return [];
//     }
//   }

//   Future<void> addOffer({
//     required String influencerId,
//     required String brandName,
//     required String campaignName,
//     required String description,
//     required double budget,
//   }) async {
//     try {
//       await _supabase.from('offers').insert({
//         'influencer_id': influencerId,
//         'brand_name': brandName,
//         'campaign_name': campaignName,
//         'description': description,
//         'budget': budget,
//         'created_at': DateTime.now().toIso8601String(),
//       });
//       debugPrint("✅ Offer added successfully for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Error adding offer: $e");
//     }
//   }
//   Future<List<Map<String, dynamic>>> fetchEarnings(String influencerId) async {
//   try {
//     final res = await _supabase
//     .from('earnings')
//     .select('id, amount, description, created_at, campaigns(name)')
//     .eq('influencer_id', influencerId)
//     .order('created_at', ascending: false);

//     return List<Map<String, dynamic>>.from(res);
//   } catch (e) {
//     debugPrint("❌ Error fetching earnings: $e");
//     return [];
//   }
// }


//   /// ✅ Add earning with `created_at` field (prevents PGRST204 error)
//   Future<void> addEarning({
//     required String influencerId,
//     required double amount,
//     required String description,
//   }) async {
//     try {
//       await _supabase.from('earnings').insert({
//         'influencer_id': influencerId,
//         'amount': amount,
//         'description': description,
//         'created_at': DateTime.now().toIso8601String(),
//       });
//       debugPrint("✅ Earning added successfully for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Error adding earning: $e");
//     }
//   }

//   // ✅ Audience analytics
//   Future<void> upsertAudience(String influencerId, AudienceModel data) async {
//     try {
//       await _supabase.from('influencer_audience').upsert({
//         'influencer_id': influencerId,
//         ...data.toMap(),
//       });
//       debugPrint("✅ Audience analytics upserted for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Error upserting audience analytics: $e");
//       rethrow;
//     }
//   }

//   Future<AudienceModel?> fetchAudience(String influencerId) async {
//     try {
//       final res = await _supabase
//           .from('influencer_audience')
//           .select('*')
//           .eq('influencer_id', influencerId)
//           .maybeSingle();

//       if (res == null) return null;
//       return AudienceModel.fromMap(Map<String, dynamic>.from(res));
//     } catch (e) {
//       debugPrint("❌ Error fetching audience analytics: $e");
//       return null;
//     }
//   }

//   // ✅ Update YouTube data in Supabase
//   Future<void> updateYouTubeData({
//     required String influencerId,
//     required String accessToken,
//     required String channelId,
//     required String channelName,
//     required String channelThumbnail,
//     required int subscribers,
//     String? description,
//   }) async {
//     try {
//       await _supabase.from('influencers').update({
//         'youtube_token': accessToken,
//         'youtube_channel_id': channelId,
//         'youtube_channel_name': channelName,
//         'youtube_channel_thumbnail': channelThumbnail,
//         'youtube_subscribers': subscribers,
//         'youtube_description': description ?? '',
//         'updated_at': DateTime.now().toIso8601String(),
//       }).eq('id', influencerId);

//       debugPrint("✅ YouTube data updated in Supabase for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Error updating YouTube data: $e");
//     }
//   }

// }
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/influencer_model.dart';
import '../models/audience_model.dart';

class InfluencerService {
  final _supabase = Supabase.instance.client;

  // ✅ Fetch influencer profile safely
  Future<InfluencerModel?> fetchInfluencer(String userId) async {
    try {
      final res = await _supabase
          .from('influencers')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (res == null) return null;

      final safeMap = Map<String, dynamic>.from(res);
      if (safeMap['follower_count'] != null) {
        safeMap['follower_count'] = (safeMap['follower_count'] as num).toInt();
      }
      if (safeMap['engagement_rate'] != null) {
        safeMap['engagement_rate'] =
            (safeMap['engagement_rate'] as num).toDouble();
      }
      if (safeMap['price_per_post'] != null) {
        safeMap['price_per_post'] =
            (safeMap['price_per_post'] as num).toDouble();
      }

      return InfluencerModel.fromMap(safeMap);
    } catch (e) {
      debugPrint("❌ Error fetching influencer: $e");
      return null;
    }
  }

  // ✅ Upsert influencer profile
  Future<void> upsertInfluencer(InfluencerModel model) async {
    try {
      await _supabase.from('influencers').upsert(model.toMap());
      debugPrint("✅ Influencer upsert successful for ${model.id}");
    } catch (e) {
      debugPrint("❌ Error upserting influencer: $e");
      rethrow;
    }
  }

  // ✅ Update social media tokens
  Future<void> updateSocialTokens({
    required String influencerId,
    String? instagramToken,
    String? tiktokToken,
    String? youtubeToken,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (instagramToken != null) data['instagram_token'] = instagramToken;
      if (tiktokToken != null) data['tiktok_token'] = tiktokToken;
      if (youtubeToken != null) data['youtube_token'] = youtubeToken;

      if (data.isNotEmpty) {
        await _supabase.from('influencers').update(data).eq('id', influencerId);
        debugPrint("✅ Social media tokens updated for $influencerId");
      }
    } catch (e) {
      debugPrint("❌ Error updating social tokens: $e");
    }
  }

  // ✅ Upload profile image
  Future<String?> uploadProfileImage(String influencerId, Uint8List bytes) async {
    try {
      final path =
          '$influencerId/profile_image_${DateTime.now().millisecondsSinceEpoch}.png';

      await _supabase.storage.from('profile_images').uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      final publicUrl =
          _supabase.storage.from('profile_images').getPublicUrl(path);
      debugPrint("✅ Profile image uploaded: $publicUrl");

      await _supabase.from('influencers').update({
        'profile_image': publicUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', influencerId);

      return publicUrl;
    } catch (e) {
      debugPrint("❌ Error uploading profile image: $e");
      return null;
    }
  }

  // ✅ Mark onboarding complete
  Future<void> markOnboardingComplete(String influencerId) async {
    try {
      await _supabase.from('influencers').update({
        'onboarding_completed': true,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', influencerId);

      debugPrint("✅ Onboarding marked complete for $influencerId");
    } catch (e) {
      debugPrint("❌ Error marking onboarding complete: $e");
    }
  }

  // ✅ Upload new portfolio item
  Future<void> uploadPortfolioItem({
    required String influencerId,
    required Uint8List bytes,
    required String filename,
    required String title,
    required String description,
  }) async {
    try {
      final path = '$influencerId/${DateTime.now().millisecondsSinceEpoch}_$filename';

      await _supabase.storage.from('portfolio').uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      final publicUrl = _supabase.storage.from('portfolio').getPublicUrl(path);

      await _supabase.from('portfolio_items').insert({
        'influencer_id': influencerId,
        'title': title,
        'description': description,
        'public_url': publicUrl,
        'storage_path': path,
        'created_at': DateTime.now().toIso8601String(),
      });

      debugPrint("✅ Portfolio item uploaded for $influencerId");
    } catch (e) {
      debugPrint("❌ Upload portfolio item failed: $e");
      rethrow;
    }
  }

  // ✅ Update portfolio item (image optional) – **UUID-safe**
  Future<void> updatePortfolioItem({
    required String itemId, // <- changed to String
    required String influencerId,
    Uint8List? newBytes,
    String? filename,
    required String title,
    required String description,
  }) async {
    try {
      String? newPublicUrl;

      if (newBytes != null && filename != null) {
        final newPath =
            '$influencerId/${DateTime.now().millisecondsSinceEpoch}_$filename';

        await _supabase.storage.from('portfolio').uploadBinary(
              newPath,
              newBytes,
              fileOptions: const FileOptions(upsert: true),
            );

        newPublicUrl = _supabase.storage.from('portfolio').getPublicUrl(newPath);

        await _supabase.from('portfolio_items').update({
          'title': title,
          'description': description,
          'public_url': newPublicUrl,
          'storage_path': newPath,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', itemId);
      } else {
        await _supabase.from('portfolio_items').update({
          'title': title,
          'description': description,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', itemId);
      }

      debugPrint("✅ Portfolio item updated (ID: $itemId)");
    } catch (e) {
      debugPrint("❌ Error updating portfolio item: $e");
      rethrow;
    }
  }

  // ✅ Delete portfolio item (and image) – **UUID-safe**
  Future<void> deletePortfolioItem(String itemId) async {
    try {
      final item = await _supabase
          .from('portfolio_items')
          .select('storage_path')
          .eq('id', itemId)
          .maybeSingle();

      if (item != null && item['storage_path'] != null) {
        await _supabase.storage
            .from('portfolio')
            .remove([item['storage_path'] as String]);
      }

      await _supabase.from('portfolio_items').delete().eq('id', itemId);

      debugPrint("✅ Portfolio item deleted (ID: $itemId)");
    } catch (e) {
      debugPrint("❌ Error deleting portfolio item: $e");
      rethrow;
    }
  }

  // ✅ Fetch portfolio list
  Future<List<Map<String, dynamic>>> fetchPortfolio(String influencerId) async {
    try {
      final res = await _supabase
          .from('portfolio_items')
          .select()
          .eq('influencer_id', influencerId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint("❌ Error fetching portfolio: $e");
      return [];
    }
  }

  // ✅ Other methods remain unchanged...
  Future<List<Map<String, dynamic>>> fetchOffers(String influencerId) async {
    try {
      final res = await _supabase
          .from('offers')
          .select()
          .eq('influencer_id', influencerId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint("❌ Error fetching offers: $e");
      return [];
    }
  }

  Future<void> addOffer({
    required String influencerId,
    required String brandName,
    required String campaignName,
    required String description,
    required double budget,
  }) async {
    try {
      await _supabase.from('offers').insert({
        'influencer_id': influencerId,
        'brand_name': brandName,
        'campaign_name': campaignName,
        'description': description,
        'budget': budget,
        'created_at': DateTime.now().toIso8601String(),
      });
      debugPrint("✅ Offer added successfully for $influencerId");
    } catch (e) {
      debugPrint("❌ Error adding offer: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchEarnings(String influencerId) async {
    try {
      final res = await _supabase
          .from('earnings')
          .select('id, amount, description, created_at, campaigns(name)')
          .eq('influencer_id', influencerId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint("❌ Error fetching earnings: $e");
      return [];
    }
  }

  Future<void> addEarning({
    required String influencerId,
    required double amount,
    required String description,
  }) async {
    try {
      await _supabase.from('earnings').insert({
        'influencer_id': influencerId,
        'amount': amount,
        'description': description,
        'created_at': DateTime.now().toIso8601String(),
      });
      debugPrint("✅ Earning added successfully for $influencerId");
    } catch (e) {
      debugPrint("❌ Error adding earning: $e");
    }
  }

  Future<void> upsertAudience(String influencerId, AudienceModel data) async {
    try {
      await _supabase.from('influencer_audience').upsert({
        'influencer_id': influencerId,
        ...data.toMap(),
      });
      debugPrint("✅ Audience analytics upserted for $influencerId");
    } catch (e) {
      debugPrint("❌ Error upserting audience analytics: $e");
      rethrow;
    }
  }

  Future<AudienceModel?> fetchAudience(String influencerId) async {
    try {
      final res = await _supabase
          .from('influencer_audience')
          .select('*')
          .eq('influencer_id', influencerId)
          .maybeSingle();

      if (res == null) return null;
      return AudienceModel.fromMap(Map<String, dynamic>.from(res));
    } catch (e) {
      debugPrint("❌ Error fetching audience analytics: $e");
      return null;
    }
  }

  Future<void> updateYouTubeData({
    required String influencerId,
    required String accessToken,
    required String channelId,
    required String channelName,
    required String channelThumbnail,
    required int subscribers,
    String? description,
  }) async {
    try {
      await _supabase.from('influencers').update({
        'youtube_token': accessToken,
        'youtube_channel_id': channelId,
        'youtube_channel_name': channelName,
        'youtube_channel_thumbnail': channelThumbnail,
        'youtube_subscribers': subscribers,
        'youtube_description': description ?? '',
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', influencerId);

      debugPrint("✅ YouTube data updated in Supabase for $influencerId");
    } catch (e) {
      debugPrint("❌ Error updating YouTube data: $e");
    }
  }
}
