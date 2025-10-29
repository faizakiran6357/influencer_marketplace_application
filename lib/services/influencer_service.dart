// import 'dart:typed_data';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/influencer_model.dart';

// class InfluencerService {
//   final _supabase = Supabase.instance.client;

//   // Get influencer profile
//   Future<InfluencerModel?> fetchInfluencer(String userId) async {
//     final res = await _supabase.from('influencers').select().eq('id', userId).maybeSingle();
//     if (res == null) return null;
//     return InfluencerModel.fromMap(res);
//   }

//   // Upsert influencer
//   Future<void> upsertInfluencer(InfluencerModel model) async {
//     await _supabase.from('influencers').upsert(model.toMap());
//   }

//   // Upload to storage + insert portfolio record
//   Future<void> uploadPortfolioItem({
//     required String influencerId,
//     required Uint8List bytes,
//     required String filename,
//     required String title,
//     required String description,
//   }) async {
//     final path = '$influencerId/$filename';
//     await _supabase.storage.from('portfolio').uploadBinary(path, bytes, fileOptions: FileOptions(upsert: true));
//     final publicUrl = _supabase.storage.from('portfolio').getPublicUrl(path);
//     await _supabase.from('portfolio_items').insert({
//       'influencer_id': influencerId,
//       'title': title,
//       'description': description,
//       'storage_path': path,
//       'public_url': publicUrl,
//     });
//   }

//   Future<List<Map<String, dynamic>>> fetchPortfolio(String influencerId) async {
//     final res = await _supabase.from('portfolio_items').select().eq('influencer_id', influencerId);
//     return List<Map<String, dynamic>>.from(res);
//   }

//   Future<List<Map<String, dynamic>>> fetchOffers(String influencerId) async {
//     final res = await _supabase.from('offers').select().eq('influencer_id', influencerId);
//     return List<Map<String, dynamic>>.from(res);
//   }

//   Future<List<Map<String, dynamic>>> fetchTransactions(String influencerId) async {
//     final res = await _supabase.from('transactions').select().eq('influencer_id', influencerId);
//     return List<Map<String, dynamic>>.from(res);
//   }
  
// }
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
//           .eq('influencer_id', influencerId);
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
//     } catch (e) {
//       debugPrint("❌ Error adding earning: $e");
//     }
//   }
// }
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/influencer_model.dart';

class InfluencerService {
  final _supabase = Supabase.instance.client;

  // ✅ Fetch influencer profile
  Future<InfluencerModel?> fetchInfluencer(String userId) async {
    try {
      final res = await _supabase
          .from('influencers')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (res == null) return null;
      return InfluencerModel.fromMap(res);
    } catch (e) {
      debugPrint("❌ Error fetching influencer: $e");
      return null;
    }
  }

  // ✅ Upsert influencer profile
  Future<void> upsertInfluencer(InfluencerModel model) async {
    try {
      await _supabase.from('influencers').upsert(model.toMap());
    } catch (e) {
      debugPrint("❌ Error upserting influencer: $e");
    }
  }

  // ✅ Upload media to storage & insert record into portfolio_items
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

  // ✅ Fetch offers (collaborations)
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

  // ✅ Fetch earnings (transactions / payments)
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
}
