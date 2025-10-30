
// // }
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/influencer_model.dart';

// class InfluencerService {
//   final _supabase = Supabase.instance.client;

//   // ✅ Fetch influencer profile
//   Future<InfluencerModel?> fetchInfluencer(String userId) async {
//     try {
//       final res = await _supabase
//           .from('influencers')
//           .select()
//           .eq('id', userId)
//           .maybeSingle();

//       if (res == null) return null;
//       return InfluencerModel.fromMap(res);
//     } catch (e) {
//       debugPrint("❌ Error fetching influencer: $e");
//       return null;
//     }
//   }

//   // ✅ Upsert influencer profile
//   Future<void> upsertInfluencer(InfluencerModel model) async {
//     try {
//       await _supabase.from('influencers').upsert(model.toMap());
//     } catch (e) {
//       debugPrint("❌ Error upserting influencer: $e");
//     }
//   }

//   // ✅ Upload media to storage & insert record into portfolio_items
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
//       });
//     } catch (e) {
//       debugPrint("❌ Upload portfolio item failed: $e");
//       rethrow;
//     }
//   }

//   // ✅ Fetch all portfolio items
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

//   // ✅ Fetch offers (collaborations)
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

//   // ✅ Fetch earnings (transactions / payments)
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

//   // ✅ Add a new offer
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

//   // ✅ Add a new earning
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
// }
// correct code above//
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/influencer_model.dart';

// class InfluencerService {
//   final _supabase = Supabase.instance.client;

//   // ✅ Fetch influencer profile
//   Future<InfluencerModel?> fetchInfluencer(String userId) async {
//     try {
//       final res = await _supabase
//           .from('influencers')
//           .select()
//           .eq('id', userId)
//           .maybeSingle();

//       if (res == null) return null;
//       return InfluencerModel.fromMap(res);
//     } catch (e) {
//       debugPrint("❌ Error fetching influencer: $e");
//       return null;
//     }
//   }

//   // ✅ Upsert influencer profile (includes new onboarding fields)
//   Future<void> upsertInfluencer(InfluencerModel model) async {
//     try {
//       await _supabase.from('influencers').upsert(model.toMap());
//       debugPrint("✅ Influencer upsert successful for ${model.id}");
//     } catch (e) {
//       debugPrint("❌ Error upserting influencer: $e");
//       rethrow;
//     }
//   }

//   // ✅ Mark onboarding as complete
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

//   // ✅ Upload media to storage & insert record into portfolio_items
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
//       });

//       debugPrint("✅ Portfolio item uploaded for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Upload portfolio item failed: $e");
//       rethrow;
//     }
//   }

//   // ✅ Fetch all portfolio items
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

//   // ✅ Fetch offers (collaborations)
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

//   // ✅ Fetch earnings (transactions / payments)
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

//   // ✅ Add a new offer
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

//   // ✅ Add a new earning
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
// }
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/influencer_model.dart';

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

//       // Ensure numeric fields are properly typed
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

//   // ✅ Upsert influencer profile (includes new onboarding fields)
//   Future<void> upsertInfluencer(InfluencerModel model) async {
//     try {
//       await _supabase.from('influencers').upsert(model.toMap());
//       debugPrint("✅ Influencer upsert successful for ${model.id}");
//     } catch (e) {
//       debugPrint("❌ Error upserting influencer: $e");
//       rethrow;
//     }
//   }

//   // ✅ Mark onboarding as complete
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
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/influencer_model.dart';

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

//   // ✅ Upsert influencer profile (includes new onboarding fields)
//   Future<void> upsertInfluencer(InfluencerModel model) async {
//     try {
//       await _supabase.from('influencers').upsert(model.toMap());
//       debugPrint("✅ Influencer upsert successful for ${model.id}");
//     } catch (e) {
//       debugPrint("❌ Error upserting influencer: $e");
//       rethrow;
//     }
//   }

//   // ✅ Upload profile image to Supabase Storage
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

//       // Update influencer record with profile image URL
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

//   // ✅ Upload media to storage & insert record into portfolio_items
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
//       });

//       debugPrint("✅ Portfolio item uploaded for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Upload portfolio item failed: $e");
//       rethrow;
//     }
//   }

//   // ✅ Fetch all portfolio items
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

//   // ✅ Fetch offers (collaborations)
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

//   // ✅ Fetch earnings (transactions / payments)
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

//   // ✅ Add a new offer
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

//   // ✅ Add a new earning
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
// }
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/influencer_model.dart';

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

//   // ✅ Upload profile image to Supabase Storage
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

//       // Update influencer record with profile image URL
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
   
//   // ✅ Upload portfolio item
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
//       });

//       debugPrint("✅ Portfolio item uploaded for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Upload portfolio item failed: $e");
//       rethrow;
//     }
//   }

//   // ✅ Fetch all portfolio items
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

//   // ✅ Fetch offers
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

//   // ✅ Fetch earnings
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

//   // ✅ Add a new offer
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

//   // ✅ Add a new earning
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
// }
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/influencer_model.dart';
import '../models/audience_model.dart'; // <-- make sure to create this model

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
        safeMap['engagement_rate'] = (safeMap['engagement_rate'] as num).toDouble();
      }
      if (safeMap['price_per_post'] != null) {
        safeMap['price_per_post'] = (safeMap['price_per_post'] as num).toDouble();
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

  // ✅ Upload profile image to Supabase Storage
  Future<String?> uploadProfileImage(String influencerId, Uint8List bytes) async {
    try {
      final path = '$influencerId/profile_image_${DateTime.now().millisecondsSinceEpoch}.png';

      await _supabase.storage.from('profile_images').uploadBinary(
        path,
        bytes,
        fileOptions: const FileOptions(upsert: true),
      );

      final publicUrl = _supabase.storage.from('profile_images').getPublicUrl(path);
      debugPrint("✅ Profile image uploaded: $publicUrl");

      // Update influencer record with profile image URL
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

  // ✅ Upload portfolio item
  Future<void> uploadPortfolioItem({
    required String influencerId,
    required Uint8List bytes,
    required String filename,
    required String title,
    required String description,
  }) async {
    try {
      final path = '$influencerId/$filename';

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
        'storage_path': path,
        'public_url': publicUrl,
      });

      debugPrint("✅ Portfolio item uploaded for $influencerId");
    } catch (e) {
      debugPrint("❌ Upload portfolio item failed: $e");
      rethrow;
    }
  }

  // ✅ Fetch all portfolio items
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

  // ✅ Fetch offers
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

  // ✅ Fetch earnings
  Future<List<Map<String, dynamic>>> fetchEarnings(String influencerId) async {
    try {
      final res = await _supabase
          .from('earnings')
          .select()
          .eq('influencer_id', influencerId)
          .order('date', ascending: false);

      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      debugPrint("❌ Error fetching earnings: $e");
      return [];
    }
  }

  // ✅ Add a new offer
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
      });
      debugPrint("✅ Offer added successfully for $influencerId");
    } catch (e) {
      debugPrint("❌ Error adding offer: $e");
    }
  }

  // ✅ Add a new earning
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
      });
      debugPrint("✅ Earning added successfully for $influencerId");
    } catch (e) {
      debugPrint("❌ Error adding earning: $e");
    }
  }

  // =======================
  // ✅ Audience Analytics Methods
  // =======================

  // Upsert audience analytics for influencer
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

  // Fetch audience analytics for influencer
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
}
