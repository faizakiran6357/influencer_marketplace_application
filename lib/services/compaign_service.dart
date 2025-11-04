// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/campaign_model.dart';

// class CampaignService {
//   final _client = Supabase.instance.client;

//   /// ✅ Fetch all campaigns created by a brand (brand_id = profiles.id)
//   Future<List<CampaignModel>> fetchCampaignsByBrand(String brandId) async {
//     try {
//       final response =
//           await _client.from('campaigns').select().eq('brand_id', brandId);

//       return List<Map<String, dynamic>>.from(response)
//           .map((e) => CampaignModel.fromMap(e))
//           .toList();
//     } catch (e) {
//       print("❌ fetchCampaignsByBrand error: $e");
//       return [];
//     }
//   }

//   /// ✅ Create a new campaign
//   Future<void> createCampaign(CampaignModel campaign) async {
//     try {
//       await _client.from('campaigns').insert(campaign.toMap());
//       print("✅ Campaign created successfully for brand: ${campaign.brandId}");
//     } catch (e) {
//       print("❌ createCampaign error: $e");
//     }
//   }

//   // /// ✅ Update existing campaign (optional)
//   // Future<void> updateCampaign(CampaignModel campaign) async {
//   //   try {
//   //     await _client
//   //         .from('campaigns')
//   //         .update(campaign.toMap())
//   //         .eq('id', campaign.id);
//   //     print("✅ Campaign updated: ${campaign.id}");
//   //   } catch (e) {
//   //     print("❌ updateCampaign error: $e");
//   //   }
//   // }

//   /// ✅ Delete campaign (optional)
//   Future<void> deleteCampaign(String campaignId) async {
//     try {
//       await _client.from('campaigns').delete().eq('id', campaignId);
//       print("✅ Campaign deleted: $campaignId");
//     } catch (e) {
//       print("❌ deleteCampaign error: $e");
//     }
//   }

//   /// ✅ Analytics: calculate total budget, spent, and remaining for a brand
//   Future<Map<String, double>> getBrandCampaignAnalytics(String brandId) async {
//     try {
//       final response =
//           await _client.from('campaigns').select().eq('brand_id', brandId);

//       final campaigns = List<Map<String, dynamic>>.from(response);
//       double totalBudget = 0;
//       double totalSpent = 0;

//       for (var c in campaigns) {
//         totalBudget += (c['budget'] ?? 0).toDouble();
//         totalSpent += (c['spent'] ?? 0).toDouble();
//       }

//       return {
//         'totalBudget': totalBudget,
//         'totalSpent': totalSpent,
//         'remaining': totalBudget - totalSpent,
//       };
//     } catch (e) {
//       print("❌ getBrandCampaignAnalytics error: $e");
//       return {'totalBudget': 0, 'totalSpent': 0, 'remaining': 0};
//     }
//   }
//   Future<void> updateCampaign(CampaignModel campaign) async {
//   try {
//     await _client
//         .from('campaigns')
//         .update(campaign.toMap())
//         .eq('id', campaign.id);
//   } catch (e) {
//     print("❌ updateCampaign error: $e");
//   }
// }
// // Fetch all active campaigns posted by brands (for influencer to see)
// Future<List<Map<String, dynamic>>> fetchAvailableCampaigns() async {
//   final response = await _client
//       .from('campaigns')
//       .select('*, brands(name)')
//       .eq('status', 'active')
//       .order('created_at', ascending: false);
//   return (response as List).cast<Map<String, dynamic>>();
// }

// // When influencer accepts campaign offer
// Future<void> acceptCampaignOffer({
//   required String campaignId,
//   required String influencerId,
// }) async {
//   await _client.from('campaign_influencers').insert({
//     'campaign_id': campaignId,
//     'influencer_id': influencerId,
//     'status': 'accepted',
//     'created_at': DateTime.now().toIso8601String(),
//   });
// }
// // Fetch campaigns accepted by a specific influencer
// Future<List<Map<String, dynamic>>> fetchAcceptedCampaignsByInfluencer(
//     String influencerId) async {
//   final response = await _client
//       .from('campaign_influencers')
//       .select('campaigns(*, brands(name))')
//       .eq('influencer_id', influencerId)
//       .eq('status', 'accepted')
//       .order('created_at', ascending: false);

//   // Extract campaigns from nested response
//   final data = (response as List)
//       .map((item) => item['campaigns'] as Map<String, dynamic>)
//       .toList();

//   return data;
// }
// }
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/campaign_model.dart';

// class CampaignService {
//   final _client = Supabase.instance.client;

//   /// ✅ Fetch all campaigns created by a brand (brand_id = profiles.id)
//   Future<List<CampaignModel>> fetchCampaignsByBrand(String brandId) async {
//     try {
//       final response =
//           await _client.from('campaigns').select().eq('brand_id', brandId);

//       return List<Map<String, dynamic>>.from(response)
//           .map((e) => CampaignModel.fromMap(e))
//           .toList();
//     } catch (e) {
//       print("❌ fetchCampaignsByBrand error: $e");
//       return [];
//     }
//   }

//   /// ✅ Create a new campaign
//   Future<void> createCampaign(CampaignModel campaign) async {
//     try {
//       await _client.from('campaigns').insert(campaign.toMap());
//       print("✅ Campaign created successfully for brand: ${campaign.brandId}");
//     } catch (e) {
//       print("❌ createCampaign error: $e");
//     }
//   }

//   /// ✅ Update existing campaign
//   Future<void> updateCampaign(CampaignModel campaign) async {
//     try {
//       await _client
//           .from('campaigns')
//           .update(campaign.toMap())
//           .eq('id', campaign.id);
//       print("✅ Campaign updated: ${campaign.id}");
//     } catch (e) {
//       print("❌ updateCampaign error: $e");
//     }
//   }

//   /// ✅ Delete campaign
//   Future<void> deleteCampaign(String campaignId) async {
//     try {
//       await _client.from('campaigns').delete().eq('id', campaignId);
//       print("✅ Campaign deleted: $campaignId");
//     } catch (e) {
//       print("❌ deleteCampaign error: $e");
//     }
//   }

//   /// ✅ Analytics for brand dashboard
//   Future<Map<String, double>> getBrandCampaignAnalytics(String brandId) async {
//     try {
//       final response =
//           await _client.from('campaigns').select().eq('brand_id', brandId);

//       final campaigns = List<Map<String, dynamic>>.from(response);
//       double totalBudget = 0;
//       double totalSpent = 0;

//       for (var c in campaigns) {
//         totalBudget += (c['budget'] ?? 0).toDouble();
//         totalSpent += (c['spent'] ?? 0).toDouble();
//       }

//       return {
//         'totalBudget': totalBudget,
//         'totalSpent': totalSpent,
//         'remaining': totalBudget - totalSpent,
//       };
//     } catch (e) {
//       print("❌ getBrandCampaignAnalytics error: $e");
//       return {'totalBudget': 0, 'totalSpent': 0, 'remaining': 0};
//     }
//   }

//   Future<List<Map<String, dynamic>>> fetchAvailableCampaigns() async {
//   try {
//     final response = await _client
//         .from('campaigns')
//         // ✅ specify which FK relationship to use
//         .select('*, profiles!fk_campaigns_brand(name)')
//         .eq('status', 'active')
//         .order('created_at', ascending: false);

//     return (response as List).cast<Map<String, dynamic>>();
//   } catch (e) {
//     print("❌ fetchAvailableCampaigns error: $e");
//     return [];
//   }
// }


//   // ✅ When influencer accepts a campaign offer
//   Future<void> acceptCampaignOffer({
//     required String campaignId,
//     required String influencerId,
//   }) async {
//     try {
//       await _client.from('campaign_influencers').insert({
//         'campaign_id': campaignId,
//         'influencer_id': influencerId,
//         'status': 'accepted',
//         'created_at': DateTime.now().toIso8601String(),
//       });
//       print("✅ Influencer accepted campaign: $campaignId");
//     } catch (e) {
//       print("❌ acceptCampaignOffer error: $e");
//     }
//   }


//   // ✅ Fetch campaigns accepted by a specific influencer
// Future<List<Map<String, dynamic>>> fetchAcceptedCampaignsByInfluencer(
//     String influencerId) async {
//   try {
//     final response = await _client
//         .from('campaign_influencers')
//         .select('*, campaigns!fk_campaign_influencer_campaign(*, profiles(name, email))')
//         .eq('influencer_id', influencerId)
//         .eq('status', 'accepted')
//         .order('created_at', ascending: false);

//     final data = (response as List)
//         .map((item) => item['campaigns'] as Map<String, dynamic>)
//         .toList();

//     return data;
//   } catch (e) {
//     print("❌ fetchAcceptedCampaigns error: $e");
//     return [];
//   }
// }

// }
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/campaign_model.dart';

// class CampaignService {
//   final _client = Supabase.instance.client;

//   /// ✅ Fetch all campaigns created by a brand (brand_id = profiles.id)
//   Future<List<CampaignModel>> fetchCampaignsByBrand(String brandId) async {
//     try {
//       final response =
//           await _client.from('campaigns').select().eq('brand_id', brandId);

//       return List<Map<String, dynamic>>.from(response)
//           .map((e) => CampaignModel.fromMap(e))
//           .toList();
//     } catch (e) {
//       print("❌ fetchCampaignsByBrand error: $e");
//       return [];
//     }
//   }

//   /// ✅ Create a new campaign
//   Future<void> createCampaign(CampaignModel campaign) async {
//     try {
//       await _client.from('campaigns').insert(campaign.toMap());
//       print("✅ Campaign created successfully for brand: ${campaign.brandId}");
//     } catch (e) {
//       print("❌ createCampaign error: $e");
//     }
//   }

//   /// ✅ Update existing campaign
//   Future<void> updateCampaign(CampaignModel campaign) async {
//     try {
//       await _client
//           .from('campaigns')
//           .update(campaign.toMap())
//           .eq('id', campaign.id);
//       print("✅ Campaign updated: ${campaign.id}");
//     } catch (e) {
//       print("❌ updateCampaign error: $e");
//     }
//   }

//   /// ✅ Delete campaign
//   Future<void> deleteCampaign(String campaignId) async {
//     try {
//       await _client.from('campaigns').delete().eq('id', campaignId);
//       print("✅ Campaign deleted: $campaignId");
//     } catch (e) {
//       print("❌ deleteCampaign error: $e");
//     }
//   }

//   /// ✅ Analytics for brand dashboard
//   Future<Map<String, double>> getBrandCampaignAnalytics(String brandId) async {
//     try {
//       final response =
//           await _client.from('campaigns').select().eq('brand_id', brandId);

//       final campaigns = List<Map<String, dynamic>>.from(response);
//       double totalBudget = 0;
//       double totalSpent = 0;

//       for (var c in campaigns) {
//         totalBudget += (c['budget'] ?? 0).toDouble();
//         totalSpent += (c['spent'] ?? 0).toDouble();
//       }

//       return {
//         'totalBudget': totalBudget,
//         'totalSpent': totalSpent,
//         'remaining': totalBudget - totalSpent,
//       };
//     } catch (e) {
//       print("❌ getBrandCampaignAnalytics error: $e");
//       return {'totalBudget': 0, 'totalSpent': 0, 'remaining': 0};
//     }
//   }

//   /// ✅ Fetch active campaigns (for influencer offers screen)
//   Future<List<Map<String, dynamic>>> fetchAvailableCampaigns() async {
//     try {
//       final response = await _client
//           .from('campaigns')
//           // specify the correct foreign key to profiles
//           .select('*, profiles!fk_campaigns_brand(name)')
//           .eq('status', 'active')
//           .order('created_at', ascending: false);

//       return (response as List).cast<Map<String, dynamic>>();
//     } catch (e) {
//       print("❌ fetchAvailableCampaigns error: $e");
//       return [];
//     }
//   }

//   /// ✅ When influencer accepts a campaign offer
//   Future<void> acceptCampaignOffer({
//     required String campaignId,
//     required String influencerId,
//   }) async {
//     try {
//       await _client.from('campaign_influencers').insert({
//         'campaign_id': campaignId,
//         'influencer_id': influencerId,
//         'status': 'accepted',
//         'created_at': DateTime.now().toIso8601String(),
//       });
//       print("✅ Influencer accepted campaign: $campaignId");
//     } catch (e) {
//       print("❌ acceptCampaignOffer error: $e");
//     }
//   }

//   /// ✅ Fetch campaigns accepted by a specific influencer
//   Future<List<Map<String, dynamic>>> fetchAcceptedCampaignsByInfluencer(
//       String influencerId) async {
//     try {
//       final response = await _client
//           .from('campaign_influencers')
//           // specify relationship key to campaigns and profiles
//           .select(
//               '*, campaigns!fk_campaign_influencer_campaign(*, profiles!fk_campaigns_brand(name, email))')
//           .eq('influencer_id', influencerId)
//           .eq('status', 'accepted')
//           .order('created_at', ascending: false);

//       final data = (response as List)
//           .map((item) => item['campaigns'] as Map<String, dynamic>)
//           .toList();

//       return data;
//     } catch (e) {
//       print("❌ fetchAcceptedCampaigns error: $e");
//       return [];
//     }
//   }
// }
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/campaign_model.dart';

// class CampaignService {
//   final _client = Supabase.instance.client;

//   /// ✅ Fetch all campaigns created by a brand (brand_id = profiles.id)
//   Future<List<CampaignModel>> fetchCampaignsByBrand(String brandId) async {
//     try {
//       final response =
//           await _client.from('campaigns').select().eq('brand_id', brandId);

//       return List<Map<String, dynamic>>.from(response)
//           .map((e) => CampaignModel.fromMap(e))
//           .toList();
//     } catch (e) {
//       print("❌ fetchCampaignsByBrand error: $e");
//       return [];
//     }
//   }

//   /// ✅ Create a new campaign
//   Future<void> createCampaign(CampaignModel campaign) async {
//     try {
//       await _client.from('campaigns').insert(campaign.toMap());
//       print("✅ Campaign created successfully for brand: ${campaign.brandId}");
//     } catch (e) {
//       print("❌ createCampaign error: $e");
//     }
//   }

//   /// ✅ Update existing campaign
//   Future<void> updateCampaign(CampaignModel campaign) async {
//     try {
//       await _client
//           .from('campaigns')
//           .update(campaign.toMap())
//           .eq('id', campaign.id);
//       print("✅ Campaign updated: ${campaign.id}");
//     } catch (e) {
//       print("❌ updateCampaign error: $e");
//     }
//   }

//   /// ✅ Delete campaign
//   Future<void> deleteCampaign(String campaignId) async {
//     try {
//       await _client.from('campaigns').delete().eq('id', campaignId);
//       print("✅ Campaign deleted: $campaignId");
//     } catch (e) {
//       print("❌ deleteCampaign error: $e");
//     }
//   }

//   /// ✅ Analytics for brand dashboard
//   Future<Map<String, double>> getBrandCampaignAnalytics(String brandId) async {
//     try {
//       final response =
//           await _client.from('campaigns').select().eq('brand_id', brandId);

//       final campaigns = List<Map<String, dynamic>>.from(response);
//       double totalBudget = 0;
//       double totalSpent = 0;

//       for (var c in campaigns) {
//         totalBudget += (c['budget'] ?? 0).toDouble();
//         totalSpent += (c['spent'] ?? 0).toDouble();
//       }

//       return {
//         'totalBudget': totalBudget,
//         'totalSpent': totalSpent,
//         'remaining': totalBudget - totalSpent,
//       };
//     } catch (e) {
//       print("❌ getBrandCampaignAnalytics error: $e");
//       return {'totalBudget': 0, 'totalSpent': 0, 'remaining': 0};
//     }
//   }

//   /// ✅ Fetch active campaigns (for influencer offers screen)
//   Future<List<Map<String, dynamic>>> fetchAvailableCampaigns() async {
//     try {
//       final response = await _client
//           .from('campaigns')
//           .select('*, profiles!fk_campaigns_brand(name)')
//           .eq('status', 'active')
//           .order('created_at', ascending: false);

//       return (response as List).cast<Map<String, dynamic>>();
//     } catch (e) {
//       print("❌ fetchAvailableCampaigns error: $e");
//       return [];
//     }
//   }

//   /// ✅ When influencer accepts a campaign offer, also create an earning
//   Future<void> acceptCampaignOffer({
//     required String campaignId,
//     required String influencerId,
//   }) async {
//     try {
//       // 1️⃣ Insert into campaign_influencers
//       await _client.from('campaign_influencers').insert({
//         'campaign_id': campaignId,
//         'influencer_id': influencerId,
//         'status': 'accepted',
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       print("✅ Influencer accepted campaign: $campaignId");

//       // 2️⃣ Fetch campaign details to get budget
//       final campaignResp = await _client
//           .from('campaigns')
//           .select()
//           .eq('id', campaignId)
//           .single();

//       if (campaignResp != null) {
//         final double amount = (campaignResp['budget'] ?? 0).toDouble();

//         // 3️⃣ Insert into earnings table
//         await _client.from('earnings').insert({
//           'influencer_id': influencerId,
//           'amount': amount,
//           'description': 'Earning from campaign ${campaignResp['name']}',
//           'created_at': DateTime.now().toIso8601String(),
//         });

//         print("💰 Earning added for influencer $influencerId: $amount");
//       }
//     } catch (e) {
//       print("❌ acceptCampaignOffer error: $e");
//     }
//   }

//   /// ✅ Fetch campaigns accepted by a specific influencer
//   Future<List<Map<String, dynamic>>> fetchAcceptedCampaignsByInfluencer(
//       String influencerId) async {
//     try {
//       final response = await _client
//           .from('campaign_influencers')
//           .select(
//               '*, campaigns!fk_campaign_influencer_campaign(*, profiles!fk_campaigns_brand(name, email))')
//           .eq('influencer_id', influencerId)
//           .eq('status', 'accepted')
//           .order('created_at', ascending: false);

//       final data = (response as List)
//           .map((item) => item['campaigns'] as Map<String, dynamic>)
//           .toList();

//       return data;
//     } catch (e) {
//       print("❌ fetchAcceptedCampaigns error: $e");
//       return [];
//     }
//   }
// }
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/campaign_model.dart';

// class CampaignService {
//   final _client = Supabase.instance.client;

//   /// ✅ Fetch all campaigns created by a brand (brand_id = profiles.id)
//   Future<List<CampaignModel>> fetchCampaignsByBrand(String brandId) async {
//     try {
//       final response =
//           await _client.from('campaigns').select().eq('brand_id', brandId);

//       return List<Map<String, dynamic>>.from(response)
//           .map((e) => CampaignModel.fromMap(e))
//           .toList();
//     } catch (e) {
//       print("❌ fetchCampaignsByBrand error: $e");
//       return [];
//     }
//   }

//   /// ✅ Create a new campaign
//   Future<void> createCampaign(CampaignModel campaign) async {
//     try {
//       await _client.from('campaigns').insert(campaign.toMap());
//       print("✅ Campaign created successfully for brand: ${campaign.brandId}");
//     } catch (e) {
//       print("❌ createCampaign error: $e");
//     }
//   }

//   /// ✅ Update existing campaign
//   Future<void> updateCampaign(CampaignModel campaign) async {
//     try {
//       await _client
//           .from('campaigns')
//           .update(campaign.toMap())
//           .eq('id', campaign.id);
//       print("✅ Campaign updated: ${campaign.id}");
//     } catch (e) {
//       print("❌ updateCampaign error: $e");
//     }
//   }

//   /// ✅ Activate a campaign (draft → active)
//   Future<void> activateCampaign(String campaignId) async {
//     try {
//       await _client
//           .from('campaigns')
//           .update({
//             'status': 'active',
//             'updated_at': DateTime.now().toIso8601String(),
//           })
//           .eq('id', campaignId);

//       print("✅ Campaign activated: $campaignId");
//     } catch (e) {
//       print("❌ activateCampaign error: $e");
//     }
//   }

//   /// ✅ Delete campaign
//   Future<void> deleteCampaign(String campaignId) async {
//     try {
//       await _client.from('campaigns').delete().eq('id', campaignId);
//       print("✅ Campaign deleted: $campaignId");
//     } catch (e) {
//       print("❌ deleteCampaign error: $e");
//     }
//   }

//   /// ✅ Analytics for brand dashboard
//   Future<Map<String, double>> getBrandCampaignAnalytics(String brandId) async {
//     try {
//       final response =
//           await _client.from('campaigns').select().eq('brand_id', brandId);

//       final campaigns = List<Map<String, dynamic>>.from(response);
//       double totalBudget = 0;
//       double totalSpent = 0;

//       for (var c in campaigns) {
//         totalBudget += (c['budget'] ?? 0).toDouble();
//         totalSpent += (c['spent'] ?? 0).toDouble();
//       }

//       return {
//         'totalBudget': totalBudget,
//         'totalSpent': totalSpent,
//         'remaining': totalBudget - totalSpent,
//       };
//     } catch (e) {
//       print("❌ getBrandCampaignAnalytics error: $e");
//       return {'totalBudget': 0, 'totalSpent': 0, 'remaining': 0};
//     }
//   }

//   /// ✅ Fetch active campaigns (for influencer offers screen)
//   Future<List<Map<String, dynamic>>> fetchAvailableCampaigns() async {
//     try {
//       final response = await _client
//           .from('campaigns')
//           .select('*, profiles!fk_campaigns_brand(name)')
//           .eq('status', 'active')
//           .order('created_at', ascending: false);

//       return (response as List).cast<Map<String, dynamic>>();
//     } catch (e) {
//       print("❌ fetchAvailableCampaigns error: $e");
//       return [];
//     }
//   }

//   /// ✅ When influencer accepts a campaign offer, also create an earning
//   Future<void> acceptCampaignOffer({
//     required String campaignId,
//     required String influencerId,
//   }) async {
//     try {
//       // 1️⃣ Fetch campaign to get required fields
//       final campaignResp = await _client
//           .from('campaigns')
//           .select()
//           .eq('id', campaignId)
//           .single();

//       if (campaignResp == null) {
//         print("❌ Campaign not found: $campaignId");
//         return;
//       }

//       // 2️⃣ Insert into campaign_influencers
//       await _client.from('campaign_influencers').insert({
//         'campaign_id': campaignId,
//         'influencer_id': influencerId,
//         'status': 'accepted',
//         'created_at': DateTime.now().toIso8601String(),
//         'end_date': campaignResp['end_date'], // provide end_date to avoid 42703 error
//       });

//       print("✅ Influencer accepted campaign: $campaignId");

//       // 3️⃣ Add earning for influencer
//       final double amount = (campaignResp['budget'] ?? 0).toDouble();
//       await _client.from('earnings').insert({
//         'influencer_id': influencerId,
//         'amount': amount,
//         'description': 'Earning from campaign ${campaignResp['name']}',
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       print("💰 Earning added for influencer $influencerId: $amount");
//     } catch (e) {
//       print("❌ acceptCampaignOffer error: $e");
//     }
//   }

//   /// ✅ Fetch campaigns accepted by a specific influencer
//   Future<List<Map<String, dynamic>>> fetchAcceptedCampaignsByInfluencer(
//       String influencerId) async {
//     try {
//       final response = await _client
//           .from('campaign_influencers')
//           .select(
//               '*, campaigns!fk_campaign_influencer_campaign(*, profiles!fk_campaigns_brand(name, email))')
//           .eq('influencer_id', influencerId)
//           .eq('status', 'accepted')
//           .order('created_at', ascending: false);

//       final data = (response as List)
//           .map((item) => item['campaigns'] as Map<String, dynamic>)
//           .toList();

//       return data;
//     } catch (e) {
//       print("❌ fetchAcceptedCampaigns error: $e");
//       return [];
//     }
//   }
// }
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/campaign_model.dart';

// class CampaignService {
//   final _client = Supabase.instance.client;

//   /// ✅ Fetch all campaigns created by a brand
//   Future<List<CampaignModel>> fetchCampaignsByBrand(String brandId) async {
//     try {
//       final response =
//           await _client.from('campaigns').select().eq('brand_id', brandId);

//       return List<Map<String, dynamic>>.from(response)
//           .map((e) => CampaignModel.fromMap(e))
//           .toList();
//     } catch (e) {
//       print("❌ fetchCampaignsByBrand error: $e");
//       return [];
//     }
//   }

//   /// ✅ Create a new campaign
//   Future<void> createCampaign(CampaignModel campaign) async {
//     try {
//       await _client.from('campaigns').insert(campaign.toMap());
//       print("✅ Campaign created successfully for brand: ${campaign.brandId}");
//     } catch (e) {
//       print("❌ createCampaign error: $e");
//     }
//   }

//   /// ✅ Update existing campaign
//   Future<void> updateCampaign(CampaignModel campaign) async {
//     try {
//       await _client
//           .from('campaigns')
//           .update(campaign.toMap())
//           .eq('id', campaign.id);
//       print("✅ Campaign updated: ${campaign.id}");
//     } catch (e) {
//       print("❌ updateCampaign error: $e");
//     }
//   }

//   /// ✅ Activate campaign (draft → active)
//   Future<void> activateCampaign(String campaignId) async {
//     try {
//       await _client
//           .from('campaigns')
//           .update({
//             'status': 'active',
//             'updated_at': DateTime.now().toIso8601String(),
//           })
//           .eq('id', campaignId);

//       print("✅ Campaign activated: $campaignId");
//     } catch (e) {
//       print("❌ activateCampaign error: $e");
//     }
//   }

//   /// ✅ Delete campaign
//   Future<void> deleteCampaign(String campaignId) async {
//     try {
//       await _client.from('campaigns').delete().eq('id', campaignId);
//       print("✅ Campaign deleted: $campaignId");
//     } catch (e) {
//       print("❌ deleteCampaign error: $e");
//     }
//   }

//   /// ✅ Brand analytics
//   Future<Map<String, double>> getBrandCampaignAnalytics(String brandId) async {
//     try {
//       final response =
//           await _client.from('campaigns').select().eq('brand_id', brandId);

//       final campaigns = List<Map<String, dynamic>>.from(response);
//       double totalBudget = 0;
//       double totalSpent = 0;

//       for (var c in campaigns) {
//         totalBudget += (c['budget'] ?? 0).toDouble();
//         totalSpent += (c['spent'] ?? 0).toDouble();
//       }

//       return {
//         'totalBudget': totalBudget,
//         'totalSpent': totalSpent,
//         'remaining': totalBudget - totalSpent,
//       };
//     } catch (e) {
//       print("❌ getBrandCampaignAnalytics error: $e");
//       return {'totalBudget': 0, 'totalSpent': 0, 'remaining': 0};
//     }
//   }

//   /// ✅ Fetch active campaigns (for influencer offers screen)
//   Future<List<Map<String, dynamic>>> fetchAvailableCampaigns() async {
//     try {
//       final response = await _client
//           .from('campaigns')
//           .select('*, profiles!fk_campaigns_brand(name)')
//           .eq('status', 'active')
//           .order('created_at', ascending: false);

//       return (response as List).cast<Map<String, dynamic>>();
//     } catch (e) {
//       print("❌ fetchAvailableCampaigns error: $e");
//       return [];
//     }
//   }

//   /// ✅ When influencer accepts a campaign offer → add record + earning
//   Future<void> acceptCampaignOffer({
//     required String campaignId,
//     required String influencerId,
//   }) async {
//     try {
//       // 1️⃣ Get campaign details
//       final campaignResp = await _client
//           .from('campaigns')
//           .select()
//           .eq('id', campaignId)
//           .single();

//       if (campaignResp == null) {
//         print("❌ Campaign not found: $campaignId");
//         return;
//       }

//       // 2️⃣ Add record to campaign_influencers table
//       await _client.from('campaign_influencers').insert({
//         'campaign_id': campaignId,
//         'influencer_id': influencerId,
//         'status': 'accepted',
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       print("✅ Influencer accepted campaign: $campaignId");

//       // 3️⃣ Create earning for influencer
//       final double amount = (campaignResp['budget'] ?? 0).toDouble();

//       await _client.from('earnings').insert({
//         'influencer_id': influencerId,
//         'amount': amount,
//         'description': 'Earning from campaign ${campaignResp['name']}',
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       print("💰 Earning added for influencer $influencerId: $amount");
//     } catch (e) {
//       print("❌ acceptCampaignOffer error: $e");
//     }
//   }

//   /// ✅ Fetch campaigns accepted by influencer
//   Future<List<Map<String, dynamic>>> fetchAcceptedCampaignsByInfluencer(
//       String influencerId) async {
//     try {
//       final response = await _client
//           .from('campaign_influencers')
//           .select(
//               '*, campaigns!fk_campaign_influencer_campaign(*, profiles!fk_campaigns_brand(name, email))')
//           .eq('influencer_id', influencerId)
//           .eq('status', 'accepted')
//           .order('created_at', ascending: false);

//       final data = (response as List)
//           .map((item) => item['campaigns'] as Map<String, dynamic>)
//           .toList();

//       return data;
//     } catch (e) {
//       print("❌ fetchAcceptedCampaigns error: $e");
//       return [];
//     }
//   }
// }
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/campaign_model.dart';

class CampaignService {
  final _client = Supabase.instance.client;

  /// ✅ Fetch all campaigns created by a brand
  Future<List<CampaignModel>> fetchCampaignsByBrand(String brandId) async {
    try {
      final response =
          await _client.from('campaigns').select().eq('brand_id', brandId);

      return List<Map<String, dynamic>>.from(response)
          .map((e) => CampaignModel.fromMap(e))
          .toList();
    } catch (e) {
      print("❌ fetchCampaignsByBrand error: $e");
      return [];
    }
  }

  /// ✅ Create a new campaign
  Future<void> createCampaign(CampaignModel campaign) async {
    try {
      await _client.from('campaigns').insert(campaign.toMap());
      print("✅ Campaign created successfully for brand: ${campaign.brandId}");
    } catch (e) {
      print("❌ createCampaign error: $e");
    }
  }

  /// ✅ Update existing campaign
  Future<void> updateCampaign(CampaignModel campaign) async {
    try {
      await _client
          .from('campaigns')
          .update(campaign.toMap())
          .eq('id', campaign.id);
      print("✅ Campaign updated: ${campaign.id}");
    } catch (e) {
      print("❌ updateCampaign error: $e");
    }
  }

  /// ✅ Activate campaign (draft → active)
  Future<void> activateCampaign(String campaignId) async {
    try {
      await _client
          .from('campaigns')
          .update({
            'status': 'active',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', campaignId);

      print("✅ Campaign activated: $campaignId");
    } catch (e) {
      print("❌ activateCampaign error: $e");
    }
  }

  /// ✅ Delete campaign
  Future<void> deleteCampaign(String campaignId) async {
    try {
      await _client.from('campaigns').delete().eq('id', campaignId);
      print("✅ Campaign deleted: $campaignId");
    } catch (e) {
      print("❌ deleteCampaign error: $e");
    }
  }

  /// ✅ Brand analytics
  Future<Map<String, double>> getBrandCampaignAnalytics(String brandId) async {
    try {
      final response =
          await _client.from('campaigns').select().eq('brand_id', brandId);

      final campaigns = List<Map<String, dynamic>>.from(response);
      double totalBudget = 0;
      double totalSpent = 0;

      for (var c in campaigns) {
        totalBudget += (c['budget'] ?? 0).toDouble();
        totalSpent += (c['spent'] ?? 0).toDouble();
      }

      return {
        'totalBudget': totalBudget,
        'totalSpent': totalSpent,
        'remaining': totalBudget - totalSpent,
      };
    } catch (e) {
      print("❌ getBrandCampaignAnalytics error: $e");
      return {'totalBudget': 0, 'totalSpent': 0, 'remaining': 0};
    }
  }

  /// ✅ Fetch active campaigns (for influencer offers screen)
  Future<List<Map<String, dynamic>>> fetchAvailableCampaigns() async {
    try {
      final response = await _client
          .from('campaigns')
          .select('*, profiles!fk_campaigns_brand(name)')
          .eq('status', 'active')
          .order('created_at', ascending: false);

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      print("❌ fetchAvailableCampaigns error: $e");
      return [];
    }
  }

  /// ✅ When influencer accepts a campaign offer → add record + earning
  Future<void> acceptCampaignOffer({
    required String campaignId,
    required String influencerId,
  }) async {
    try {
      // 1️⃣ Get campaign details
      final campaignResp = await _client
          .from('campaigns')
          .select()
          .eq('id', campaignId)
          .single();

      if (campaignResp == null) {
        print("❌ Campaign not found: $campaignId");
        return;
      }

      // 2️⃣ Add record to campaign_influencers table
      await _client.from('campaign_influencers').insert({
        'campaign_id': campaignId,
        'influencer_id': influencerId,
        'status': 'accepted',
        // created_at optional (ignore if column missing)
        'created_at': DateTime.now().toIso8601String(),
      });

      print("✅ Influencer accepted campaign: $campaignId");

      // 3️⃣ Create earning for influencer
      final double amount = (campaignResp['budget'] ?? 0).toDouble();

      final earningData = {
        'influencer_id': influencerId,
        'amount': amount,
        'description': 'Earning from campaign ${campaignResp['name']}',
      };

      // only add created_at if your table supports it
      try {
        earningData['created_at'] = DateTime.now().toIso8601String();
      } catch (_) {}

      await _client.from('earnings').insert(earningData);

      print("💰 Earning added for influencer $influencerId: $amount");
    } catch (e) {
      print("❌ acceptCampaignOffer error: $e");
    }
  }

  /// ✅ Fetch campaigns accepted by influencer }
  // }
Future<List<Map<String, dynamic>>> fetchAcceptedCampaignsByInfluencer(
    String influencerId) async {
  try {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('campaign_influencers')
        .select('*, campaigns!fk_campaign_influencer_campaign(*)')
        .eq('influencer_id', influencerId)
        .eq('status', 'accepted');

    final data = List<Map<String, dynamic>>.from(response);

    for (var campaign in data) {
      final campaignData = campaign['campaigns'];
      if (campaignData != null && campaignData['brand_id'] != null) {
        // ✅ Fetch brand details from profiles table using correct column names
        final brandResponse = await supabase
            .from('profiles')
            .select('id, name, profile_image') // 👈 use 'name' instead of 'full_name'
            .eq('id', campaignData['brand_id'])
            .maybeSingle();

        if (brandResponse != null) {
          campaign['brand_name'] = brandResponse['name'] ?? 'Unknown';
          campaign['brand_image'] = brandResponse['profile_image'];
        } else {
          campaign['brand_name'] = 'Unknown';
          campaign['brand_image'] = null;
        }
      }
    }

    debugPrint("✅ ${data.length} accepted campaigns loaded");
    return data;
  } catch (e) {
    debugPrint("❌ fetchAcceptedCampaignsByInfluencer error: $e");
    return [];
  }
}


}
