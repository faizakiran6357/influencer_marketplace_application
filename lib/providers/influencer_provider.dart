
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/services/compaign_service.dart';
// import '../models/audience_model.dart';
// import '../models/influencer_model.dart';
// import '../services/influencer_service.dart';
// import '../services/youtube_service.dart';

// class InfluencerProvider with ChangeNotifier {
//   final _service = InfluencerService();
//   final _youtubeService = YouTubeService();

//   InfluencerModel? influencer;
//   List<Map<String, dynamic>> portfolio = [];
//   List<Map<String, dynamic>> offers = [];
//   List<Map<String, dynamic>> earnings = [];

//   bool loading = false;
//   AudienceModel? _audience;
//   AudienceModel? get audience => _audience;

//   // ===============================
//   // ✅ Influencer Profile Methods
//   // ===============================
//   Future<void> fetchInfluencer(String id) async {
//     try {
//       loading = true;
//       notifyListeners();

//       influencer = await _service.fetchInfluencer(id);

//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching influencer: $e");
//       influencer = null;
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> saveInfluencerProfile(InfluencerModel model) async {
//     try {
//       loading = true;
//       notifyListeners();

//       await _service.upsertInfluencer(model);
//       influencer = model;

//       debugPrint("✅ Influencer profile updated successfully");

//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error saving influencer profile: $e");
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> completeOnboarding(String influencerId) async {
//     try {
//       await _service.markOnboardingComplete(influencerId);
//       if (influencer != null) {
//         influencer = influencer!.copyWith(onboardingCompleted: true);
//       }
//       debugPrint("✅ Onboarding marked as complete for $influencerId");
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error completing onboarding: $e");
//     }
//   }

//   Future<void> updateInfluencer(InfluencerModel model) async {
//     try {
//       await _service.upsertInfluencer(model);
//       influencer = model;
//       notifyListeners();

//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error updating influencer: $e");
//     }
//   }

//   Future<String?> uploadProfileImage(String influencerId, Uint8List bytes) async {
//     try {
//       final imageUrl = await _service.uploadProfileImage(influencerId, bytes);
//       if (imageUrl != null && influencer != null) {
//         influencer = influencer!.copyWith(profileImage: imageUrl);
//         notifyListeners();
//       }
//       return imageUrl;
//     } catch (e) {
//       debugPrint("❌ Error in uploadProfileImage: $e");
//       return null;
//     }
//   }

//   void clear() {
//     influencer = null;
//     portfolio.clear();
//     offers.clear();
//     earnings.clear();
//     _audience = null;
//     notifyListeners();
//   }

//   // ===============================
//   // ✅ Portfolio / Offers / Earnings
//   // ===============================
//   Future<void> fetchPortfolio(String id) async {
//     try {
//       portfolio = await _service.fetchPortfolio(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching portfolio: $e");
//     }
//   }

//   Future<void> fetchOffers(String id) async {
//     try {
//       offers = await _service.fetchOffers(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching offers: $e");
//     }
//   }

//   Future<void> fetchEarnings(String id) async {
//     try {
//       earnings = await _service.fetchEarnings(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching earnings: $e");
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
//       await _service.addOffer(
//         influencerId: influencerId,
//         brandName: brandName,
//         campaignName: campaignName,
//         description: description,
//         budget: budget,
//       );
//       await fetchOffers(influencerId);
//       debugPrint("✅ Offer added and refreshed");
//     } catch (e) {
//       debugPrint("❌ Error adding offer: $e");
//     }
//   }

//   Future<void> addEarning({
//     required String influencerId,
//     required double amount,
//     required String description,
//   }) async {
//     try {
//       await _service.addEarning(
//         influencerId: influencerId,
//         amount: amount,
//         description: description,
//       );
//       await fetchEarnings(influencerId);
//       debugPrint("✅ Earning added and refreshed");
//     } catch (e) {
//       debugPrint("❌ Error adding earning: $e");
//     }
//   }

//   // ===============================
//   // ✅ Audience Analytics
//   // ===============================
//   Future<void> generateMockAudience(String influencerId, int totalFollowers) async {
//     final data = AudienceModel(
//       genderMale: (totalFollowers * 0.5).toInt(),
//       genderFemale: (totalFollowers * 0.4).toInt(),
//       genderOther: (totalFollowers * 0.1).toInt(),
//       age18_24: (totalFollowers * 0.4).toInt(),
//       age25_34: (totalFollowers * 0.35).toInt(),
//       age35Plus: (totalFollowers * 0.25).toInt(),
//       countryTop: ['USA', 'UK', 'Canada'],
//     );

//     await _service.upsertAudience(influencerId, data);
//     _audience = data;
//     notifyListeners();
//   }

//   Future<void> fetchAudience(String influencerId) async {
//     try {
//       _audience = await _service.fetchAudience(influencerId);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching audience: $e");
//     }
//   }

//   Future<void> initAudienceFromOnboarding(String influencerId) async {
//     if (influencer == null) return;

//     final totalFollowers = influencer!.followerCount ?? 1000;

//     final data = AudienceModel(
//       genderMale: (totalFollowers * 0.5).toInt(),
//       genderFemale: (totalFollowers * 0.4).toInt(),
//       genderOther: (totalFollowers * 0.1).toInt(),
//       age18_24: (totalFollowers * 0.4).toInt(),
//       age25_34: (totalFollowers * 0.35).toInt(),
//       age35Plus: (totalFollowers * 0.25).toInt(),
//       countryTop: ['USA', 'UK', 'Canada'],
//     );

//     _audience = data;
//     notifyListeners();

//     await _service.upsertAudience(influencerId, data);
//   }

//   // ===============================
//   // ✅ Social Media Integration
//   // ===============================
//   Future<void> connectInstagram(String influencerId, String token) async {
//     try {
//       await _service.updateSocialTokens(influencerId: influencerId, instagramToken: token);
//       if (influencer != null) influencer = influencer!.copyWith(instagramToken: token);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting Instagram: $e");
//     }
//   }

//   Future<void> connectTikTok(String influencerId, String token) async {
//     try {
//       await _service.updateSocialTokens(influencerId: influencerId, tiktokToken: token);
//       if (influencer != null) influencer = influencer!.copyWith(tiktokToken: token);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting TikTok: $e");
//     }
//   }

//   // ===============================
//   // ✅ YouTube Integration
//   // ===============================
//   Future<void> connectYouTubeAccount() async {
//     if (influencer == null) return;

//     try {
//       loading = true;
//       notifyListeners();

//       debugPrint("🎬 Connecting YouTube...");

//       final data = await _youtubeService.connectYouTube();
//       if (data == null) {
//         debugPrint("❌ YouTube connection failed or cancelled.");
//         return;
//       }

//       final updatedInfluencer = influencer!.copyWith(
//         youtubeToken: data['accessToken'],
//         youtubeChannelId: data['channelId'] ?? '',
//         youtubeChannelName: data['title'] ?? '',
//         youtubeChannelThumbnail: data['thumbnail'] ?? '',
//         youtubeSubscribers: int.tryParse(data['subscriberCount']?.toString() ?? '0') ?? 0,
//         youtubeDescription: data['description'] ?? '',
//       );

//       // ✅ Save all YouTube data to Supabase
//       await _service.updateYouTubeData(
//         influencerId: updatedInfluencer.id,
//         accessToken: updatedInfluencer.youtubeToken ?? '',
//         channelId: updatedInfluencer.youtubeChannelId ?? '',
//         channelName: updatedInfluencer.youtubeChannelName ?? '',
//         channelThumbnail: updatedInfluencer.youtubeChannelThumbnail ?? '',
//         subscribers: updatedInfluencer.youtubeSubscribers ?? 0,
//         description: updatedInfluencer.youtubeDescription ?? '',
//       );

//       // ✅ Update local provider state
//       influencer = updatedInfluencer;
//       notifyListeners();

//       debugPrint("✅ YouTube connected & influencer updated successfully.");
//     } catch (e) {
//       debugPrint("❌ Error connecting YouTube: $e");
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> refreshYouTubeToken() async {
//     if (influencer?.youtubeToken == null) return;
//     try {
//       final newToken = await _youtubeService.refreshToken(influencer!.youtubeToken!);
//       if (newToken != null) {
//         influencer = influencer!.copyWith(youtubeToken: newToken);
//         await _service.updateSocialTokens(
//           influencerId: influencer!.id,
//           youtubeToken: newToken,
//         );
//         notifyListeners();
//         debugPrint("🔄 YouTube token refreshed.");
//       }
//     } catch (e) {
//       debugPrint("❌ Error refreshing YouTube token: $e");
//     }
//   }
//   final _campaignService = CampaignService();

// List<Map<String, dynamic>> availableCampaigns = [];

// // Fetch campaigns posted by brands
// Future<void> fetchAvailableCampaigns() async {
//   try {
//     availableCampaigns = await _campaignService.fetchAvailableCampaigns();
//     notifyListeners();
//     debugPrint("✅ Available campaigns loaded: ${availableCampaigns.length}");
//   } catch (e) {
//     debugPrint("❌ fetchAvailableCampaigns error: $e");
//   }
// }

// // Influencer accepts campaign offer
// Future<void> acceptCampaignOffer(String campaignId, String influencerId) async {
//   try {
//     await _campaignService.acceptCampaignOffer(
//       campaignId: campaignId,
//       influencerId: influencerId,
//     );
//     debugPrint("✅ Offer accepted for campaign $campaignId");
//     await fetchAvailableCampaigns(); // refresh list
//   } catch (e) {
//     debugPrint("❌ acceptCampaignOffer error: $e");
//   }
// }
//  List<Map<String, dynamic>> acceptedCampaigns = [];

// // Fetch all campaigns accepted by influencer
// Future<void> fetchAcceptedCampaigns(String influencerId) async {
//   try {
//     acceptedCampaigns =
//         await _campaignService.fetchAcceptedCampaignsByInfluencer(influencerId);
//     notifyListeners();
//     debugPrint("✅ ${acceptedCampaigns.length} accepted campaigns loaded");
//   } catch (e) {
//     debugPrint("❌ fetchAcceptedCampaigns error: $e");
//   }
// }

// }
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/services/compaign_service.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/audience_model.dart';
// import '../models/influencer_model.dart';
// import '../services/influencer_service.dart';
// import '../services/youtube_service.dart';

// class InfluencerProvider with ChangeNotifier {
//   final _service = InfluencerService();
//   final _youtubeService = YouTubeService();
//   final _campaignService = CampaignService();
//   final SupabaseClient _supabase = Supabase.instance.client;

//   InfluencerModel? influencer;
//   List<Map<String, dynamic>> portfolio = [];
//   List<Map<String, dynamic>> offers = [];
//   List<Map<String, dynamic>> earnings = [];
//   List<Map<String, dynamic>> availableCampaigns = [];
//   List<Map<String, dynamic>> acceptedCampaigns = [];

//   bool loading = false;
//   AudienceModel? _audience;
//   AudienceModel? get audience => _audience;

//   RealtimeChannel? _earningsChannel;
//   RealtimeChannel? _campaignChannel;

//   // ===============================
//   // ✅ Influencer Profile Methods
//   // ===============================
//   Future<void> fetchInfluencer(String id) async {
//     try {
//       loading = true;
//       notifyListeners();

//       influencer = await _service.fetchInfluencer(id);

//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//         await fetchEarnings(influencer!.id);
//         await fetchAcceptedCampaigns(influencer!.id);
//         _subscribeToEarnings(influencer!.id);
//         _subscribeToCampaignStatus(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching influencer: $e");
//       influencer = null;
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> saveInfluencerProfile(InfluencerModel model) async {
//     try {
//       loading = true;
//       notifyListeners();

//       await _service.upsertInfluencer(model);
//       influencer = model;

//       debugPrint("✅ Influencer profile updated successfully");

//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error saving influencer profile: $e");
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> completeOnboarding(String influencerId) async {
//     try {
//       await _service.markOnboardingComplete(influencerId);
//       if (influencer != null) {
//         influencer = influencer!.copyWith(onboardingCompleted: true);
//       }
//       debugPrint("✅ Onboarding marked as complete for $influencerId");
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error completing onboarding: $e");
//     }
//   }

//   Future<void> updateInfluencer(InfluencerModel model) async {
//     try {
//       await _service.upsertInfluencer(model);
//       influencer = model;
//       notifyListeners();

//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error updating influencer: $e");
//     }
//   }

//   Future<String?> uploadProfileImage(String influencerId, Uint8List bytes) async {
//     try {
//       final imageUrl = await _service.uploadProfileImage(influencerId, bytes);
//       if (imageUrl != null && influencer != null) {
//         influencer = influencer!.copyWith(profileImage: imageUrl);
//         notifyListeners();
//       }
//       return imageUrl;
//     } catch (e) {
//       debugPrint("❌ Error in uploadProfileImage: $e");
//       return null;
//     }
//   }

//   void clear() {
//     influencer = null;
//     portfolio.clear();
//     offers.clear();
//     earnings.clear();
//     availableCampaigns.clear();
//     acceptedCampaigns.clear();
//     _audience = null;
//     _earningsChannel?.unsubscribe();
//     _campaignChannel?.unsubscribe();
//     notifyListeners();
//   }

//   // ===============================
//   // ✅ Portfolio / Offers / Earnings
//   // ===============================
//   Future<void> fetchPortfolio(String id) async {
//     try {
//       portfolio = await _service.fetchPortfolio(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching portfolio: $e");
//     }
//   }

//   Future<void> fetchOffers(String id) async {
//     try {
//       offers = await _service.fetchOffers(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching offers: $e");
//     }
//   }

//   Future<void> fetchEarnings(String id) async {
//     try {
//       earnings = await _service.fetchEarnings(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching earnings: $e");
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
//       await _service.addOffer(
//         influencerId: influencerId,
//         brandName: brandName,
//         campaignName: campaignName,
//         description: description,
//         budget: budget,
//       );
//       await fetchOffers(influencerId);
//       debugPrint("✅ Offer added and refreshed");
//     } catch (e) {
//       debugPrint("❌ Error adding offer: $e");
//     }
//   }

//   Future<void> addEarning({
//     required String influencerId,
//     required double amount,
//     required String description,
//   }) async {
//     try {
//       await _service.addEarning(
//         influencerId: influencerId,
//         amount: amount,
//         description: description,
//       );
//       await fetchEarnings(influencerId);
//       debugPrint("✅ Earning added and refreshed");
//     } catch (e) {
//       debugPrint("❌ Error adding earning: $e");
//     }
//   }

//   // ===============================
//   // ✅ Campaigns
//   // ===============================
//   Future<void> fetchAvailableCampaigns() async {
//     try {
//       availableCampaigns = await _campaignService.fetchAvailableCampaigns();
//       notifyListeners();
//       debugPrint("✅ Available campaigns loaded: ${availableCampaigns.length}");
//     } catch (e) {
//       debugPrint("❌ fetchAvailableCampaigns error: $e");
//     }
//   }

//   Future<void> acceptCampaignOffer(String campaignId, String influencerId) async {
//     try {
//       await _campaignService.acceptCampaignOffer(
//         campaignId: campaignId,
//         influencerId: influencerId,
//       );
//       debugPrint("✅ Offer accepted for campaign $campaignId");
//       await fetchAvailableCampaigns();
//       await fetchAcceptedCampaigns(influencerId);
//     } catch (e) {
//       debugPrint("❌ acceptCampaignOffer error: $e");
//     }
//   }

//   Future<void> fetchAcceptedCampaigns(String influencerId) async {
//     try {
//       acceptedCampaigns =
//           await _campaignService.fetchAcceptedCampaignsByInfluencer(influencerId);
//       notifyListeners();
//       debugPrint("✅ ${acceptedCampaigns.length} accepted campaigns loaded");
//     } catch (e) {
//       debugPrint("❌ fetchAcceptedCampaigns error: $e");
//     }
//   }

//   // ===============================
//   // ✅ Realtime Earnings & Campaign Updates
//   // ===============================
//   void _subscribeToEarnings(String influencerId) {
//     _earningsChannel?.unsubscribe();

//     _earningsChannel = _supabase.channel('earnings_updates').onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'earnings',
//       filter: PostgresChangeFilter(
//         type: PostgresChangeFilterType.eq,
//         column: 'influencer_id',
//         value: influencerId,
//       ),
//       callback: (payload) async {
//         debugPrint("💰 New earning detected: ${payload.newRecord}");
//         await fetchEarnings(influencerId);
//       },
//     ).subscribe();
//   }

//   void _subscribeToCampaignStatus(String influencerId) {
//     _campaignChannel?.unsubscribe();

//     _campaignChannel = _supabase.channel('campaign_status_updates').onPostgresChanges(
//       event: PostgresChangeEvent.update,
//       schema: 'public',
//       table: 'campaigns', // ✅ fixed typo
//       filter: PostgresChangeFilter(
//         type: PostgresChangeFilterType.eq,
//         column: 'influencer_id',
//         value: influencerId,
//       ),
//       callback: (payload) async {
//         final newStatus = payload.newRecord['status'];
//         debugPrint("📢 Campaign status changed: $newStatus");
//         if (newStatus == 'completed') {
//           await fetchEarnings(influencerId);
//         }
//         await fetchAcceptedCampaigns(influencerId);
//       },
//     ).subscribe();
//   }

//   // ===============================
//   // ✅ Audience Analytics
//   // ===============================
//   Future<void> generateMockAudience(String influencerId, int totalFollowers) async {
//     final data = AudienceModel(
//       genderMale: (totalFollowers * 0.5).toInt(),
//       genderFemale: (totalFollowers * 0.4).toInt(),
//       genderOther: (totalFollowers * 0.1).toInt(),
//       age18_24: (totalFollowers * 0.4).toInt(),
//       age25_34: (totalFollowers * 0.35).toInt(),
//       age35Plus: (totalFollowers * 0.25).toInt(),
//       countryTop: ['USA', 'UK', 'Canada'],
//     );

//     await _service.upsertAudience(influencerId, data);
//     _audience = data;
//     notifyListeners();
//   }

//   Future<void> fetchAudience(String influencerId) async {
//     try {
//       _audience = await _service.fetchAudience(influencerId);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching audience: $e");
//     }
//   }

//   Future<void> initAudienceFromOnboarding(String influencerId) async {
//     if (influencer == null) return;

//     final totalFollowers = influencer!.followerCount ?? 1000;

//     final data = AudienceModel(
//       genderMale: (totalFollowers * 0.5).toInt(),
//       genderFemale: (totalFollowers * 0.4).toInt(),
//       genderOther: (totalFollowers * 0.1).toInt(),
//       age18_24: (totalFollowers * 0.4).toInt(),
//       age25_34: (totalFollowers * 0.35).toInt(),
//       age35Plus: (totalFollowers * 0.25).toInt(),
//       countryTop: ['USA', 'UK', 'Canada'],
//     );

//     _audience = data;
//     notifyListeners();

//     await _service.upsertAudience(influencerId, data);
//   }

//   // ===============================
//   // ✅ Social Media Integration
//   // ===============================
//   Future<void> connectInstagram(String influencerId, String token) async {
//     try {
//       await _service.updateSocialTokens(influencerId: influencerId, instagramToken: token);
//       if (influencer != null) influencer = influencer!.copyWith(instagramToken: token);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting Instagram: $e");
//     }
//   }

//   Future<void> connectTikTok(String influencerId, String token) async {
//     try {
//       await _service.updateSocialTokens(influencerId: influencerId, tiktokToken: token);
//       if (influencer != null) influencer = influencer!.copyWith(tiktokToken: token);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting TikTok: $e");
//     }
//   }

//   // ===============================
//   // ✅ YouTube Integration
//   // ===============================
//   Future<void> connectYouTubeAccount() async {
//     if (influencer == null) return;

//     try {
//       loading = true;
//       notifyListeners();

//       debugPrint("🎬 Connecting YouTube...");

//       final data = await _youtubeService.connectYouTube();
//       if (data == null) {
//         debugPrint("❌ YouTube connection failed or cancelled.");
//         return;
//       }

//       final updatedInfluencer = influencer!.copyWith(
//         youtubeToken: data['accessToken'],
//         youtubeChannelId: data['channelId'] ?? '',
//         youtubeChannelName: data['title'] ?? '',
//         youtubeChannelThumbnail: data['thumbnail'] ?? '',
//         youtubeSubscribers: int.tryParse(data['subscriberCount']?.toString() ?? '0') ?? 0,
//         youtubeDescription: data['description'] ?? '',
//       );

//       await _service.updateYouTubeData(
//         influencerId: updatedInfluencer.id,
//         accessToken: updatedInfluencer.youtubeToken ?? '',
//         channelId: updatedInfluencer.youtubeChannelId ?? '',
//         channelName: updatedInfluencer.youtubeChannelName ?? '',
//         channelThumbnail: updatedInfluencer.youtubeChannelThumbnail ?? '',
//         subscribers: updatedInfluencer.youtubeSubscribers ?? 0,
//         description: updatedInfluencer.youtubeDescription ?? '',
//       );

//       influencer = updatedInfluencer;
//       notifyListeners();

//       debugPrint("✅ YouTube connected & influencer updated successfully.");
//     } catch (e) {
//       debugPrint("❌ Error connecting YouTube: $e");
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> refreshYouTubeToken() async {
//     if (influencer?.youtubeToken == null) return;
//     try {
//       final newToken = await _youtubeService.refreshToken(influencer!.youtubeToken!);
//       if (newToken != null) {
//         influencer = influencer!.copyWith(youtubeToken: newToken);
//         await _service.updateSocialTokens(
//           influencerId: influencer!.id,
//           youtubeToken: newToken,
//         );
//         notifyListeners();
//         debugPrint("🔄 YouTube token refreshed.");
//       }
//     } catch (e) {
//       debugPrint("❌ Error refreshing YouTube token: $e");
//     }
//   }
// }

// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/audience_model.dart';
// import '../models/influencer_model.dart';
// import '../services/influencer_service.dart';
// import '../services/youtube_service.dart';
// import '../services/compaign_service.dart';

// class InfluencerProvider with ChangeNotifier {
//   final _service = InfluencerService();
//   final _youtubeService = YouTubeService();
//   final _campaignService = CampaignService();
//   final SupabaseClient _supabase = Supabase.instance.client;

//   InfluencerModel? influencer;
//   List<Map<String, dynamic>> portfolio = [];
//   List<Map<String, dynamic>> offers = [];
//   List<Map<String, dynamic>> earnings = [];
//   List<Map<String, dynamic>> availableCampaigns = [];
//   List<Map<String, dynamic>> acceptedCampaigns = [];

//   bool loading = false;
//   AudienceModel? _audience;
//   AudienceModel? get audience => _audience;

//   RealtimeChannel? _earningsChannel;
//   RealtimeChannel? _campaignChannel;

//   // ===============================
//   // ✅ Influencer Profile Methods
//   // ===============================
//   Future<void> fetchInfluencer(String id) async {
//     loading = true;
//     notifyListeners();
//     try {
//       influencer = await _service.fetchInfluencer(id);
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//         await fetchEarnings(influencer!.id);
//         await fetchAcceptedCampaigns(influencer!.id);
//         _subscribeToEarnings(influencer!.id);
//         _subscribeToCampaignStatus(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching influencer: $e");
//       influencer = null;
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> saveInfluencerProfile(InfluencerModel model) async {
//     loading = true;
//     notifyListeners();
//     try {
//       await _service.upsertInfluencer(model);
//       influencer = model;
//       debugPrint("✅ Influencer profile updated successfully");
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error saving influencer profile: $e");
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> completeOnboarding(String influencerId) async {
//     try {
//       await _service.markOnboardingComplete(influencerId);
//       if (influencer != null) {
//         influencer = influencer!.copyWith(onboardingCompleted: true);
//         notifyListeners();
//       }
//       debugPrint("✅ Onboarding marked complete for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Error completing onboarding: $e");
//     }
//   }

//   Future<void> updateInfluencer(InfluencerModel model) async {
//     try {
//       await _service.upsertInfluencer(model);
//       influencer = model;
//       notifyListeners();
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error updating influencer: $e");
//     }
//   }

//   Future<String?> uploadProfileImage(String influencerId, Uint8List bytes) async {
//     try {
//       final imageUrl = await _service.uploadProfileImage(influencerId, bytes);
//       if (imageUrl != null && influencer != null) {
//         influencer = influencer!.copyWith(profileImage: imageUrl);
//         notifyListeners();
//       }
//       return imageUrl;
//     } catch (e) {
//       debugPrint("❌ Error in uploadProfileImage: $e");
//       return null;
//     }
//   }

//   void clear() {
//     influencer = null;
//     portfolio.clear();
//     offers.clear();
//     earnings.clear();
//     availableCampaigns.clear();
//     acceptedCampaigns.clear();
//     _audience = null;
//     _earningsChannel?.unsubscribe();
//     _campaignChannel?.unsubscribe();
//     notifyListeners();
//   }

//   // ===============================
//   // ✅ Portfolio / Offers / Earnings
//   // ===============================
//   Future<void> fetchPortfolio(String id) async {
//     try {
//       portfolio = await _service.fetchPortfolio(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching portfolio: $e");
//     }
//   }

//   Future<void> fetchOffers(String id) async {
//     try {
//       offers = await _service.fetchOffers(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching offers: $e");
//     }
//   }

//   Future<void> fetchEarnings(String id) async {
//     try {
//       earnings = await _service.fetchEarnings(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching earnings: $e");
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
//       await _service.addOffer(
//         influencerId: influencerId,
//         brandName: brandName,
//         campaignName: campaignName,
//         description: description,
//         budget: budget,
//       );
//       await fetchOffers(influencerId);
//       debugPrint("✅ Offer added and refreshed");
//     } catch (e) {
//       debugPrint("❌ Error adding offer: $e");
//     }
//   }

//   Future<void> addEarning({
//     required String influencerId,
//     required double amount,
//     required String description,
//   }) async {
//     try {
//       await _service.addEarning(
//         influencerId: influencerId,
//         amount: amount,
//         description: description,
//       );
//       await fetchEarnings(influencerId);
//       debugPrint("✅ Earning added and refreshed");
//     } catch (e) {
//       debugPrint("❌ Error adding earning: $e");
//     }
//   }

//   // ===============================
//   // ✅ Campaigns
//   // ===============================
//   Future<void> fetchAvailableCampaigns() async {
//     try {
//       availableCampaigns = await _campaignService.fetchAvailableCampaigns();
//       notifyListeners();
//       debugPrint("✅ Available campaigns loaded: ${availableCampaigns.length}");
//     } catch (e) {
//       debugPrint("❌ fetchAvailableCampaigns error: $e");
//     }
//   }

//   Future<void> acceptCampaignOffer(String campaignId, String influencerId) async {
//   try {
//     // Accept campaign
//     await _campaignService.acceptCampaignOffer(
//       campaignId: campaignId,
//       influencerId: influencerId,
//     );
//     debugPrint("✅ Offer accepted for campaign $campaignId");

//     // Refresh lists
//     await fetchAvailableCampaigns();
//     await fetchAcceptedCampaigns(influencerId);

//     // Earnings are automatically handled by subscription
//   } catch (e) {
//     debugPrint("❌ acceptCampaignOffer error: $e");
//   }
// }


//   Future<void> fetchAcceptedCampaigns(String influencerId) async {
//     try {
//       acceptedCampaigns =
//           await _campaignService.fetchAcceptedCampaignsByInfluencer(influencerId);
//       notifyListeners();
//       debugPrint("✅ ${acceptedCampaigns.length} accepted campaigns loaded");
//     } catch (e) {
//       debugPrint("❌ fetchAcceptedCampaigns error: $e");
//     }
//   }

//   // ===============================
//   // ✅ Realtime Earnings & Campaign Updates
//   // ===============================
//   void _subscribeToEarnings(String influencerId) {
//     _earningsChannel?.unsubscribe();

//     _earningsChannel = _supabase.channel('earnings_updates').onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'earnings',
//       filter: PostgresChangeFilter(
//         type: PostgresChangeFilterType.eq,
//         column: 'influencer_id',
//         value: influencerId,
//       ),
//       callback: (payload) async {
//         debugPrint("💰 New earning detected: ${payload.newRecord}");
//         await fetchEarnings(influencerId);
//       },
//     ).subscribe();
//   }

//   void _subscribeToCampaignStatus(String influencerId) {
//     _campaignChannel?.unsubscribe();

//     _campaignChannel = _supabase.channel('campaign_status_updates').onPostgresChanges(
//       event: PostgresChangeEvent.update,
//       schema: 'public',
//       table: 'campaigns',
//       filter: PostgresChangeFilter(
//         type: PostgresChangeFilterType.eq,
//         column: 'influencer_id',
//         value: influencerId,
//       ),
//       callback: (payload) async {
//         final newStatus = payload.newRecord['status'];
//         debugPrint("📢 Campaign status changed: $newStatus");
//         if (newStatus == 'completed') {
//           await fetchEarnings(influencerId);
//         }
//         await fetchAcceptedCampaigns(influencerId);
//       },
//     ).subscribe();
//   }

//   // ===============================
//   // ✅ Audience Analytics
//   // ===============================
//   Future<void> generateMockAudience(String influencerId, int totalFollowers) async {
//     final data = AudienceModel(
//       genderMale: (totalFollowers * 0.5).toInt(),
//       genderFemale: (totalFollowers * 0.4).toInt(),
//       genderOther: (totalFollowers * 0.1).toInt(),
//       age18_24: (totalFollowers * 0.4).toInt(),
//       age25_34: (totalFollowers * 0.35).toInt(),
//       age35Plus: (totalFollowers * 0.25).toInt(),
//       countryTop: ['USA', 'UK', 'Canada'],
//     );

//     await _service.upsertAudience(influencerId, data);
//     _audience = data;
//     notifyListeners();
//   }

//   Future<void> fetchAudience(String influencerId) async {
//     try {
//       _audience = await _service.fetchAudience(influencerId);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching audience: $e");
//     }
//   }

//   Future<void> initAudienceFromOnboarding(String influencerId) async {
//     if (influencer == null) return;

//     final totalFollowers = influencer!.followerCount ?? 1000;
//     final data = AudienceModel(
//       genderMale: (totalFollowers * 0.5).toInt(),
//       genderFemale: (totalFollowers * 0.4).toInt(),
//       genderOther: (totalFollowers * 0.1).toInt(),
//       age18_24: (totalFollowers * 0.4).toInt(),
//       age25_34: (totalFollowers * 0.35).toInt(),
//       age35Plus: (totalFollowers * 0.25).toInt(),
//       countryTop: ['USA', 'UK', 'Canada'],
//     );

//     _audience = data;
//     notifyListeners();
//     await _service.upsertAudience(influencerId, data);
//   }

//   // ===============================
//   // ✅ Social Media Integration
//   // ===============================
//   Future<void> connectInstagram(String influencerId, String token) async {
//     try {
//       await _service.updateSocialTokens(influencerId: influencerId, instagramToken: token);
//       influencer = influencer?.copyWith(instagramToken: token);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting Instagram: $e");
//     }
//   }

//   Future<void> connectTikTok(String influencerId, String token) async {
//     try {
//       await _service.updateSocialTokens(influencerId: influencerId, tiktokToken: token);
//       influencer = influencer?.copyWith(tiktokToken: token);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting TikTok: $e");
//     }
//   }

//   // ===============================
//   // ✅ YouTube Integration
//   // ===============================
//   Future<void> connectYouTubeAccount() async {
//     if (influencer == null) return;
//     loading = true;
//     notifyListeners();
//     try {
//       final data = await _youtubeService.connectYouTube();
//       if (data == null) return;

//       final updatedInfluencer = influencer!.copyWith(
//         youtubeToken: data['accessToken'],
//         youtubeChannelId: data['channelId'] ?? '',
//         youtubeChannelName: data['title'] ?? '',
//         youtubeChannelThumbnail: data['thumbnail'] ?? '',
//         youtubeSubscribers: int.tryParse(data['subscriberCount']?.toString() ?? '0') ?? 0,
//         youtubeDescription: data['description'] ?? '',
//       );

//       await _service.updateYouTubeData(
//         influencerId: updatedInfluencer.id,
//         accessToken: updatedInfluencer.youtubeToken ?? '',
//         channelId: updatedInfluencer.youtubeChannelId ?? '',
//         channelName: updatedInfluencer.youtubeChannelName ?? '',
//         channelThumbnail: updatedInfluencer.youtubeChannelThumbnail ?? '',
//         subscribers: updatedInfluencer.youtubeSubscribers ?? 0,
//         description: updatedInfluencer.youtubeDescription ?? '',
//       );

//       influencer = updatedInfluencer;
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting YouTube: $e");
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> refreshYouTubeToken() async {
//     if (influencer?.youtubeToken == null) return;
//     try {
//       final newToken = await _youtubeService.refreshToken(influencer!.youtubeToken!);
//       if (newToken != null) {
//         influencer = influencer!.copyWith(youtubeToken: newToken);
//         await _service.updateSocialTokens(
//           influencerId: influencer!.id,
//           youtubeToken: newToken,
//         );
//         notifyListeners();
//         debugPrint("🔄 YouTube token refreshed.");
//       }
//     } catch (e) {
//       debugPrint("❌ Error refreshing YouTube token: $e");
//     }
//   }
// }
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/audience_model.dart';
// import '../models/influencer_model.dart';
// import '../services/influencer_service.dart';
// import '../services/youtube_service.dart';
// import '../services/compaign_service.dart';

// class InfluencerProvider with ChangeNotifier {
//   final _service = InfluencerService();
//   final _youtubeService = YouTubeService();
//   final _campaignService = CampaignService();
//   final SupabaseClient _supabase = Supabase.instance.client;

//   InfluencerModel? influencer;
//   List<Map<String, dynamic>> portfolio = [];
//   List<Map<String, dynamic>> offers = [];
//   List<Map<String, dynamic>> earnings = [];
//   List<Map<String, dynamic>> availableCampaigns = [];
//   List<Map<String, dynamic>> acceptedCampaigns = [];

//   bool loading = false;
//   AudienceModel? _audience;
//   AudienceModel? get audience => _audience;

//   RealtimeChannel? _earningsChannel;
//   RealtimeChannel? _campaignChannel;

//   // ===============================
//   // ✅ Influencer Profile Methods
//   // ===============================
//   Future<void> fetchInfluencer(String id) async {
//     loading = true;
//     notifyListeners();
//     try {
//       influencer = await _service.fetchInfluencer(id);
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//         await fetchEarnings(influencer!.id);
//         await fetchAcceptedCampaigns(influencer!.id);
//         _subscribeToEarnings(influencer!.id);
//         _subscribeToCampaignStatus(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching influencer: $e");
//       influencer = null;
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> saveInfluencerProfile(InfluencerModel model) async {
//     loading = true;
//     notifyListeners();
//     try {
//       await _service.upsertInfluencer(model);
//       influencer = model;
//       debugPrint("✅ Influencer profile updated successfully");
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error saving influencer profile: $e");
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> completeOnboarding(String influencerId) async {
//     try {
//       await _service.markOnboardingComplete(influencerId);
//       if (influencer != null) {
//         influencer = influencer!.copyWith(onboardingCompleted: true);
//         notifyListeners();
//       }
//       debugPrint("✅ Onboarding marked complete for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Error completing onboarding: $e");
//     }
//   }

//   Future<void> updateInfluencer(InfluencerModel model) async {
//     try {
//       await _service.upsertInfluencer(model);
//       influencer = model;
//       notifyListeners();
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error updating influencer: $e");
//     }
//   }

//   Future<String?> uploadProfileImage(String influencerId, Uint8List bytes) async {
//     try {
//       final imageUrl = await _service.uploadProfileImage(influencerId, bytes);
//       if (imageUrl != null && influencer != null) {
//         influencer = influencer!.copyWith(profileImage: imageUrl);
//         notifyListeners();
//       }
//       return imageUrl;
//     } catch (e) {
//       debugPrint("❌ Error in uploadProfileImage: $e");
//       return null;
//     }
//   }

//   void clear() {
//     influencer = null;
//     portfolio.clear();
//     offers.clear();
//     earnings.clear();
//     availableCampaigns.clear();
//     acceptedCampaigns.clear();
//     _audience = null;
//     _earningsChannel?.unsubscribe();
//     _campaignChannel?.unsubscribe();
//     notifyListeners();
//   }

//   // ===============================
//   // ✅ Portfolio / Offers / Earnings
//   // ===============================
//   Future<void> fetchPortfolio(String id) async {
//     try {
//       portfolio = await _service.fetchPortfolio(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching portfolio: $e");
//     }
//   }

//   Future<void> fetchOffers(String id) async {
//     try {
//       offers = await _service.fetchOffers(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching offers: $e");
//     }
//   }

//   /// ✅ Fixed: fetch earnings from Supabase safely
//   Future<void> fetchEarnings(String id) async {
//     try {
//       final response = await _supabase
//           .from('earnings')
//           .select()
//           .eq('influencer_id', id)
//           .order('created_at', ascending: false);

//       earnings = List<Map<String, dynamic>>.from(response);
//       notifyListeners();
//       debugPrint("💰 Earnings loaded: ${earnings.length}");
//     } catch (e) {
//       debugPrint("❌ Error fetching earnings: $e");
//       earnings = [];
//       notifyListeners();
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
//       await _service.addOffer(
//         influencerId: influencerId,
//         brandName: brandName,
//         campaignName: campaignName,
//         description: description,
//         budget: budget,
//       );
//       await fetchOffers(influencerId);
//       debugPrint("✅ Offer added and refreshed");
//     } catch (e) {
//       debugPrint("❌ Error adding offer: $e");
//     }
//   }

//   Future<void> addEarning({
//     required String influencerId,
//     required double amount,
//     required String description,
//   }) async {
//     try {
//       await _service.addEarning(
//         influencerId: influencerId,
//         amount: amount,
//         description: description,
//       );
//       await fetchEarnings(influencerId);
//       debugPrint("✅ Earning added and refreshed");
//     } catch (e) {
//       debugPrint("❌ Error adding earning: $e");
//     }
//   }

//   // ===============================
//   // ✅ Campaigns
//   // ===============================
//   Future<void> fetchAvailableCampaigns() async {
//     try {
//       availableCampaigns = await _campaignService.fetchAvailableCampaigns();
//       notifyListeners();
//       debugPrint("✅ Available campaigns loaded: ${availableCampaigns.length}");
//     } catch (e) {
//       debugPrint("❌ fetchAvailableCampaigns error: $e");
//     }
//   }

//   Future<void> acceptCampaignOffer(String campaignId, String influencerId) async {
//     try {
//       await _campaignService.acceptCampaignOffer(
//         campaignId: campaignId,
//         influencerId: influencerId,
//       );
//       debugPrint("✅ Offer accepted for campaign $campaignId");

//       await fetchAvailableCampaigns();
//       await fetchAcceptedCampaigns(influencerId);
//       await fetchEarnings(influencerId);
//     } catch (e) {
//       debugPrint("❌ acceptCampaignOffer error: $e");
//     }
//   }

//   Future<void> fetchAcceptedCampaigns(String influencerId) async {
//     try {
//       acceptedCampaigns =
//           await _campaignService.fetchAcceptedCampaignsByInfluencer(influencerId);
//       notifyListeners();
//       debugPrint("✅ ${acceptedCampaigns.length} accepted campaigns loaded");
//     } catch (e) {
//       debugPrint("❌ fetchAcceptedCampaigns error: $e");
//     }
//   }

//   // ===============================
//   // ✅ Realtime Earnings & Campaign Updates
//   // ===============================
//   void _subscribeToEarnings(String influencerId) {
//     _earningsChannel?.unsubscribe();

//     _earningsChannel = _supabase.channel('earnings_updates').onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'earnings',
//       filter: PostgresChangeFilter(
//         type: PostgresChangeFilterType.eq,
//         column: 'influencer_id',
//         value: influencerId,
//       ),
//       callback: (payload) async {
//         debugPrint("💰 New earning detected: ${payload.newRecord}");
//         await fetchEarnings(influencerId);
//       },
//     ).subscribe();
//   }

//   void _subscribeToCampaignStatus(String influencerId) {
//     _campaignChannel?.unsubscribe();

//     _campaignChannel = _supabase.channel('campaign_status_updates').onPostgresChanges(
//       event: PostgresChangeEvent.update,
//       schema: 'public',
//       table: 'campaigns',
//       filter: PostgresChangeFilter(
//         type: PostgresChangeFilterType.eq,
//         column: 'influencer_id',
//         value: influencerId,
//       ),
//       callback: (payload) async {
//         final newStatus = payload.newRecord['status'];
//         debugPrint("📢 Campaign status changed: $newStatus");
//         if (newStatus == 'completed') {
//           await fetchEarnings(influencerId);
//         }
//         await fetchAcceptedCampaigns(influencerId);
//       },
//     ).subscribe();
//   }

//   // ===============================
//   // ✅ Audience Analytics
//   // ===============================
//   Future<void> generateMockAudience(String influencerId, int totalFollowers) async {
//     final data = AudienceModel(
//       genderMale: (totalFollowers * 0.5).toInt(),
//       genderFemale: (totalFollowers * 0.4).toInt(),
//       genderOther: (totalFollowers * 0.1).toInt(),
//       age18_24: (totalFollowers * 0.4).toInt(),
//       age25_34: (totalFollowers * 0.35).toInt(),
//       age35Plus: (totalFollowers * 0.25).toInt(),
//       countryTop: ['USA', 'UK', 'Canada'],
//     );

//     await _service.upsertAudience(influencerId, data);
//     _audience = data;
//     notifyListeners();
//   }

//   Future<void> fetchAudience(String influencerId) async {
//     try {
//       _audience = await _service.fetchAudience(influencerId);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching audience: $e");
//     }
//   }

//   Future<void> initAudienceFromOnboarding(String influencerId) async {
//     if (influencer == null) return;

//     final totalFollowers = influencer!.followerCount ?? 1000;
//     final data = AudienceModel(
//       genderMale: (totalFollowers * 0.5).toInt(),
//       genderFemale: (totalFollowers * 0.4).toInt(),
//       genderOther: (totalFollowers * 0.1).toInt(),
//       age18_24: (totalFollowers * 0.4).toInt(),
//       age25_34: (totalFollowers * 0.35).toInt(),
//       age35Plus: (totalFollowers * 0.25).toInt(),
//       countryTop: ['USA', 'UK', 'Canada'],
//     );

//     _audience = data;
//     notifyListeners();
//     await _service.upsertAudience(influencerId, data);
//   }

//   // ===============================
//   // ✅ Social Media Integration
//   // ===============================
//   Future<void> connectInstagram(String influencerId, String token) async {
//     try {
//       await _service.updateSocialTokens(
//           influencerId: influencerId, instagramToken: token);
//       influencer = influencer?.copyWith(instagramToken: token);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting Instagram: $e");
//     }
//   }

//   Future<void> connectTikTok(String influencerId, String token) async {
//     try {
//       await _service.updateSocialTokens(
//           influencerId: influencerId, tiktokToken: token);
//       influencer = influencer?.copyWith(tiktokToken: token);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting TikTok: $e");
//     }
//   }

//   // ===============================
//   // ✅ YouTube Integration
//   // ===============================
//   Future<void> connectYouTubeAccount() async {
//     if (influencer == null) return;
//     loading = true;
//     notifyListeners();
//     try {
//       final data = await _youtubeService.connectYouTube();
//       if (data == null) return;

//       final updatedInfluencer = influencer!.copyWith(
//         youtubeToken: data['accessToken'],
//         youtubeChannelId: data['channelId'] ?? '',
//         youtubeChannelName: data['title'] ?? '',
//         youtubeChannelThumbnail: data['thumbnail'] ?? '',
//         youtubeSubscribers:
//             int.tryParse(data['subscriberCount']?.toString() ?? '0') ?? 0,
//         youtubeDescription: data['description'] ?? '',
//       );

//       await _service.updateYouTubeData(
//         influencerId: updatedInfluencer.id,
//         accessToken: updatedInfluencer.youtubeToken ?? '',
//         channelId: updatedInfluencer.youtubeChannelId ?? '',
//         channelName: updatedInfluencer.youtubeChannelName ?? '',
//         channelThumbnail: updatedInfluencer.youtubeChannelThumbnail ?? '',
//         subscribers: updatedInfluencer.youtubeSubscribers ?? 0,
//         description: updatedInfluencer.youtubeDescription ?? '',
//       );

//       influencer = updatedInfluencer;
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting YouTube: $e");
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> refreshYouTubeToken() async {
//     if (influencer?.youtubeToken == null) return;
//     try {
//       final newToken =
//           await _youtubeService.refreshToken(influencer!.youtubeToken!);
//       if (newToken != null) {
//         influencer = influencer!.copyWith(youtubeToken: newToken);
//         await _service.updateSocialTokens(
//           influencerId: influencer!.id,
//           youtubeToken: newToken,
//         );
//         notifyListeners();
//         debugPrint("🔄 YouTube token refreshed.");
//       }
//     } catch (e) {
//       debugPrint("❌ Error refreshing YouTube token: $e");
//     }
//   }
//   // Inside InfluencerProvider
// Future<void> completeCampaign(String campaignId) async {
//   try {
//     // Update campaign status in your accepted_campaigns table
//     await Supabase.instance.client
//         .from('campaign_influencers') // adjust table name if different
//         .update({'status': 'completed'})
//         .eq('id', campaignId);
    
//     // Update local list
//     final index = acceptedCampaigns.indexWhere((c) => c['id'] == campaignId);
//     if (index != -1) {
//       acceptedCampaigns[index]['status'] = 'completed';
//       notifyListeners();
//     }
//   } catch (e) {
//     debugPrint('❌ completeCampaign error: $e');
//   }
// }
//  // Inside InfluencerProvider
// Future<String?> getBrandFcmToken(String brandId) async {
//   try {
//     final response = await Supabase.instance.client
//         .from('profiles') // your profiles table
//         .select('fcm_token')
//         .eq('id', brandId)
//         .single();

//     return response['fcm_token'] as String?;
//   } catch (e) {
//     debugPrint('❌ getBrandFcmToken error: $e');
//     return null;
//   }
// }

// }
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/audience_model.dart';
// import '../models/influencer_model.dart';
// import '../services/influencer_service.dart';
// import '../services/youtube_service.dart';
// import '../services/compaign_service.dart';

// class InfluencerProvider with ChangeNotifier {
//   final _service = InfluencerService();
//   final _youtubeService = YouTubeService();
//   final _campaignService = CampaignService();
//   final SupabaseClient _supabase = Supabase.instance.client;

//   InfluencerModel? influencer;
//   List<Map<String, dynamic>> portfolio = [];
//   List<Map<String, dynamic>> offers = [];
//   List<Map<String, dynamic>> earnings = [];
//   List<Map<String, dynamic>> availableCampaigns = [];
//   List<Map<String, dynamic>> acceptedCampaigns = [];

//   bool loading = false;
//   AudienceModel? _audience;
//   AudienceModel? get audience => _audience;

//   RealtimeChannel? _earningsChannel;
//   RealtimeChannel? _campaignChannel;

//   // ===============================
//   // ✅ Influencer Profile Methods
//   // ===============================
//   Future<void> fetchInfluencer(String id) async {
//     loading = true;
//     notifyListeners();
//     try {
//       influencer = await _service.fetchInfluencer(id);
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//         await fetchEarnings(influencer!.id);
//         await fetchAcceptedCampaigns(influencer!.id);
//         _subscribeToEarnings(influencer!.id);
//         _subscribeToCampaignStatus(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching influencer: $e");
//       influencer = null;
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> saveInfluencerProfile(InfluencerModel model) async {
//     loading = true;
//     notifyListeners();
//     try {
//       await _service.upsertInfluencer(model);
//       influencer = model;
//       debugPrint("✅ Influencer profile updated successfully");
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error saving influencer profile: $e");
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> completeOnboarding(String influencerId) async {
//     try {
//       await _service.markOnboardingComplete(influencerId);
//       if (influencer != null) {
//         influencer = influencer!.copyWith(onboardingCompleted: true);
//         notifyListeners();
//       }
//       debugPrint("✅ Onboarding marked complete for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Error completing onboarding: $e");
//     }
//   }

//   Future<void> updateInfluencer(InfluencerModel model) async {
//     try {
//       await _service.upsertInfluencer(model);
//       influencer = model;
//       notifyListeners();
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error updating influencer: $e");
//     }
//   }

//   Future<String?> uploadProfileImage(String influencerId, Uint8List bytes) async {
//     try {
//       final imageUrl = await _service.uploadProfileImage(influencerId, bytes);
//       if (imageUrl != null && influencer != null) {
//         influencer = influencer!.copyWith(profileImage: imageUrl);
//         notifyListeners();
//       }
//       return imageUrl;
//     } catch (e) {
//       debugPrint("❌ Error in uploadProfileImage: $e");
//       return null;
//     }
//   }

//   void clear() {
//     influencer = null;
//     portfolio.clear();
//     offers.clear();
//     earnings.clear();
//     availableCampaigns.clear();
//     acceptedCampaigns.clear();
//     _audience = null;
//     _earningsChannel?.unsubscribe();
//     _campaignChannel?.unsubscribe();
//     notifyListeners();
//   }

//   // ===============================
//   // ✅ Portfolio / Offers / Earnings
//   // ===============================
//   Future<void> fetchPortfolio(String id) async {
//     try {
//       portfolio = await _service.fetchPortfolio(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching portfolio: $e");
//     }
//   }

//   Future<void> fetchOffers(String id) async {
//     try {
//       offers = await _service.fetchOffers(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching offers: $e");
//     }
//   }

//   Future<void> fetchEarnings(String id) async {
//     try {
//       final response = await _supabase
//           .from('earnings')
//           .select()
//           .eq('influencer_id', id)
//           .order('created_at', ascending: false);

//       earnings = List<Map<String, dynamic>>.from(response);
//       notifyListeners();
//       debugPrint("💰 Earnings loaded: ${earnings.length}");
//     } catch (e) {
//       debugPrint("❌ Error fetching earnings: $e");
//       earnings = [];
//       notifyListeners();
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
//       await _service.addOffer(
//         influencerId: influencerId,
//         brandName: brandName,
//         campaignName: campaignName,
//         description: description,
//         budget: budget,
//       );
//       await fetchOffers(influencerId);
//       debugPrint("✅ Offer added and refreshed");
//     } catch (e) {
//       debugPrint("❌ Error adding offer: $e");
//     }
//   }

//   Future<void> addEarning({
//     required String influencerId,
//     required double amount,
//     required String description,
//   }) async {
//     try {
//       await _service.addEarning(
//         influencerId: influencerId,
//         amount: amount,
//         description: description,
//       );
//       await fetchEarnings(influencerId);
//       debugPrint("✅ Earning added and refreshed");
//     } catch (e) {
//       debugPrint("❌ Error adding earning: $e");
//     }
//   }

//   // ===============================
//   // ✅ Campaigns
//   // ===============================
//   Future<void> fetchAvailableCampaigns() async {
//     try {
//       availableCampaigns = await _campaignService.fetchAvailableCampaigns();
//       notifyListeners();
//       debugPrint("✅ Available campaigns loaded: ${availableCampaigns.length}");
//     } catch (e) {
//       debugPrint("❌ fetchAvailableCampaigns error: $e");
//     }
//   }

//   Future<void> acceptCampaignOffer(String campaignId, String influencerId) async {
//     try {
//       await _campaignService.acceptCampaignOffer(
//         campaignId: campaignId,
//         influencerId: influencerId,
//       );
//       debugPrint("✅ Offer accepted for campaign $campaignId");

//       await fetchAvailableCampaigns();
//       await fetchAcceptedCampaigns(influencerId);
//       await fetchEarnings(influencerId);
//     } catch (e) {
//       debugPrint("❌ acceptCampaignOffer error: $e");
//     }
//   }

//   Future<void> fetchAcceptedCampaigns(String influencerId) async {
//     try {
//       acceptedCampaigns =
//           await _campaignService.fetchAcceptedCampaignsByInfluencer(influencerId);
//       notifyListeners();
//       debugPrint("✅ ${acceptedCampaigns.length} accepted campaigns loaded");
//     } catch (e) {
//       debugPrint("❌ fetchAcceptedCampaigns error: $e");
//     }
//   }

//   // ===============================
//   // ✅ Realtime Earnings & Campaign Updates
//   // ===============================
//   void _subscribeToEarnings(String influencerId) {
//     _earningsChannel?.unsubscribe();

//     _earningsChannel = _supabase.channel('earnings_updates').onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'earnings',
//       filter: PostgresChangeFilter(
//         type: PostgresChangeFilterType.eq,
//         column: 'influencer_id',
//         value: influencerId,
//       ),
//       callback: (payload) async {
//         debugPrint("💰 New earning detected: ${payload.newRecord}");
//         await fetchEarnings(influencerId);
//       },
//     ).subscribe();
//   }

//   void _subscribeToCampaignStatus(String influencerId) {
//     _campaignChannel?.unsubscribe();

//     _campaignChannel = _supabase.channel('campaign_status_updates').onPostgresChanges(
//       event: PostgresChangeEvent.update,
//       schema: 'public',
//       table: 'campaigns',
//       filter: PostgresChangeFilter(
//         type: PostgresChangeFilterType.eq,
//         column: 'influencer_id',
//         value: influencerId,
//       ),
//       callback: (payload) async {
//         final newStatus = payload.newRecord['status'];
//         debugPrint("📢 Campaign status changed: $newStatus");
//         if (newStatus == 'completed') {
//           await fetchEarnings(influencerId);
//         }
//         await fetchAcceptedCampaigns(influencerId);
//       },
//     ).subscribe();
//   }

//   // ===============================
//   // ✅ Audience Analytics
//   // ===============================
//   Future<void> generateMockAudience(String influencerId, int totalFollowers) async {
//     final data = AudienceModel(
//       genderMale: (totalFollowers * 0.5).toInt(),
//       genderFemale: (totalFollowers * 0.4).toInt(),
//       genderOther: (totalFollowers * 0.1).toInt(),
//       age18_24: (totalFollowers * 0.4).toInt(),
//       age25_34: (totalFollowers * 0.35).toInt(),
//       age35Plus: (totalFollowers * 0.25).toInt(),
//       countryTop: ['USA', 'UK', 'Canada'],
//     );

//     await _service.upsertAudience(influencerId, data);
//     _audience = data;
//     notifyListeners();
//   }

//   Future<void> fetchAudience(String influencerId) async {
//     try {
//       _audience = await _service.fetchAudience(influencerId);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching audience: $e");
//     }
//   }

//   Future<void> initAudienceFromOnboarding(String influencerId) async {
//     if (influencer == null) return;

//     final totalFollowers = influencer!.followerCount ?? 1000;
//     final data = AudienceModel(
//       genderMale: (totalFollowers * 0.5).toInt(),
//       genderFemale: (totalFollowers * 0.4).toInt(),
//       genderOther: (totalFollowers * 0.1).toInt(),
//       age18_24: (totalFollowers * 0.4).toInt(),
//       age25_34: (totalFollowers * 0.35).toInt(),
//       age35Plus: (totalFollowers * 0.25).toInt(),
//       countryTop: ['USA', 'UK', 'Canada'],
//     );

//     _audience = data;
//     notifyListeners();
//     await _service.upsertAudience(influencerId, data);
//   }

//   // ===============================
//   // ✅ Social Media Integration
//   // ===============================
//   Future<void> connectInstagram(String influencerId, String token) async {
//     try {
//       await _service.updateSocialTokens(
//           influencerId: influencerId, instagramToken: token);
//       influencer = influencer?.copyWith(instagramToken: token);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting Instagram: $e");
//     }
//   }

//   Future<void> connectTikTok(String influencerId, String token) async {
//     try {
//       await _service.updateSocialTokens(
//           influencerId: influencerId, tiktokToken: token);
//       influencer = influencer?.copyWith(tiktokToken: token);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting TikTok: $e");
//     }
//   }

//   // ===============================
//   // ✅ YouTube Integration
//   // ===============================
//   Future<void> connectYouTubeAccount() async {
//     if (influencer == null) return;
//     loading = true;
//     notifyListeners();
//     try {
//       final data = await _youtubeService.connectYouTube();
//       if (data == null) return;

//       final updatedInfluencer = influencer!.copyWith(
//         youtubeToken: data['accessToken'],
//         youtubeChannelId: data['channelId'] ?? '',
//         youtubeChannelName: data['title'] ?? '',
//         youtubeChannelThumbnail: data['thumbnail'] ?? '',
//         youtubeSubscribers:
//             int.tryParse(data['subscriberCount']?.toString() ?? '0') ?? 0,
//         youtubeDescription: data['description'] ?? '',
//       );

//       await _service.updateYouTubeData(
//         influencerId: updatedInfluencer.id,
//         accessToken: updatedInfluencer.youtubeToken ?? '',
//         channelId: updatedInfluencer.youtubeChannelId ?? '',
//         channelName: updatedInfluencer.youtubeChannelName ?? '',
//         channelThumbnail: updatedInfluencer.youtubeChannelThumbnail ?? '',
//         subscribers: updatedInfluencer.youtubeSubscribers ?? 0,
//         description: updatedInfluencer.youtubeDescription ?? '',
//       );

//       influencer = updatedInfluencer;
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting YouTube: $e");
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> refreshYouTubeToken() async {
//     if (influencer?.youtubeToken == null) return;
//     try {
//       final newToken =
//           await _youtubeService.refreshToken(influencer!.youtubeToken!);
//       if (newToken != null) {
//         influencer = influencer!.copyWith(youtubeToken: newToken);
//         await _service.updateSocialTokens(
//           influencerId: influencer!.id,
//           youtubeToken: newToken,
//         );
//         notifyListeners();
//         debugPrint("🔄 YouTube token refreshed.");
//       }
//     } catch (e) {
//       debugPrint("❌ Error refreshing YouTube token: $e");
//     }
//   }

//   // ===============================
//   // ✅ Complete Campaign & Brand Token
//   // ===============================
//   Future<void> completeCampaign(String campaignId) async {
//     try {
//       await Supabase.instance.client
//           .from('campaign_influencers')
//           .update({'status': 'completed'})
//           .eq('id', campaignId);

//       final index = acceptedCampaigns.indexWhere((c) => c['id'] == campaignId);
//       if (index != -1) {
//         acceptedCampaigns[index]['status'] = 'completed';
//         notifyListeners();
//       }
//     } catch (e) {
//       debugPrint('❌ completeCampaign error: $e');
//     }
//   }



//   Future<String?> getBrandFcmToken(String brandId) async {
//     try {
//       final response = await Supabase.instance.client
//           .from('profiles')
//           .select('fcm_token')
//           .eq('id', brandId)
//           .single();

//       return response['fcm_token'] as String?;
//     } catch (e) {
//       debugPrint('❌ getBrandFcmToken error: $e');
//       return null;
//     }
//   }

//   // ===============================
//   // ✅ NEW: Influencer FCM Token
//   // ===============================
//   Future<String?> getInfluencerFcmToken(String influencerId) async {
//     try {
//       final response = await _supabase
//           .from('profiles')
//           .select('fcm_token')
//           .eq('id', influencerId)
//           .maybeSingle();

//       if (response != null && response['fcm_token'] != null) {
//         return response['fcm_token'] as String;
//       }
//       return null;
//     } catch (e) {
//       debugPrint('❌ getInfluencerFcmToken error: $e');
//       return null;
//     }
//   }
// }
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/services/notification_service.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/audience_model.dart';
// import '../models/influencer_model.dart';
// import '../services/influencer_service.dart';
// import '../services/youtube_service.dart';
// import '../services/compaign_service.dart';

// class InfluencerProvider with ChangeNotifier {
//   final _service = InfluencerService();
//   final _youtubeService = YouTubeService();
//   final _campaignService = CampaignService();
//   final SupabaseClient _supabase = Supabase.instance.client;

//   InfluencerModel? influencer;
//   List<Map<String, dynamic>> portfolio = [];
//   List<Map<String, dynamic>> offers = [];
//   List<Map<String, dynamic>> earnings = [];
//   List<Map<String, dynamic>> availableCampaigns = [];
//   List<Map<String, dynamic>> acceptedCampaigns = [];

//   bool loading = false;
//   AudienceModel? _audience;
//   AudienceModel? get audience => _audience;

//   RealtimeChannel? _earningsChannel;
//   RealtimeChannel? _campaignChannel;

//   // ===============================
//   // ✅ Influencer Profile Methods
//   // ===============================
//   Future<void> fetchInfluencer(String id) async {
//     loading = true;
//     notifyListeners();
//     try {
//       influencer = await _service.fetchInfluencer(id);
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//         await fetchEarnings(influencer!.id);
//         await fetchAcceptedCampaigns(influencer!.id);
//         _subscribeToEarnings(influencer!.id);
//         _subscribeToCampaignStatus(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching influencer: $e");
//       influencer = null;
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> saveInfluencerProfile(InfluencerModel model) async {
//     loading = true;
//     notifyListeners();
//     try {
//       await _service.upsertInfluencer(model);
//       influencer = model;
//       debugPrint("✅ Influencer profile updated successfully");
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error saving influencer profile: $e");
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> completeOnboarding(String influencerId) async {
//     try {
//       await _service.markOnboardingComplete(influencerId);
//       if (influencer != null) {
//         influencer = influencer!.copyWith(onboardingCompleted: true);
//         notifyListeners();
//       }
//       debugPrint("✅ Onboarding marked complete for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Error completing onboarding: $e");
//     }
//   }

//   Future<void> updateInfluencer(InfluencerModel model) async {
//     try {
//       await _service.upsertInfluencer(model);
//       influencer = model;
//       notifyListeners();
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error updating influencer: $e");
//     }
//   }

//   Future<String?> uploadProfileImage(String influencerId, Uint8List bytes) async {
//     try {
//       final imageUrl = await _service.uploadProfileImage(influencerId, bytes);
//       if (imageUrl != null && influencer != null) {
//         influencer = influencer!.copyWith(profileImage: imageUrl);
//         notifyListeners();
//       }
//       return imageUrl;
//     } catch (e) {
//       debugPrint("❌ Error in uploadProfileImage: $e");
//       return null;
//     }
//   }

//   void clear() {
//     influencer = null;
//     portfolio.clear();
//     offers.clear();
//     earnings.clear();
//     availableCampaigns.clear();
//     acceptedCampaigns.clear();
//     _audience = null;
//     _earningsChannel?.unsubscribe();
//     _campaignChannel?.unsubscribe();
//     notifyListeners();
//   }

//   // ===============================
//   // ✅ Portfolio / Offers / Earnings
//   // ===============================
//   Future<void> fetchPortfolio(String id) async {
//     try {
//       portfolio = await _service.fetchPortfolio(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching portfolio: $e");
//     }
//   }

//   Future<void> fetchOffers(String id) async {
//     try {
//       offers = await _service.fetchOffers(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching offers: $e");
//     }
//   }

//   Future<void> fetchEarnings(String id) async {
//     try {
//       final response = await _supabase
//           .from('earnings')
//           .select()
//           .eq('influencer_id', id)
//           .order('created_at', ascending: false);

//       earnings = List<Map<String, dynamic>>.from(response);
//       notifyListeners();
//       debugPrint("💰 Earnings loaded: ${earnings.length}");
//     } catch (e) {
//       debugPrint("❌ Error fetching earnings: $e");
//       earnings = [];
//       notifyListeners();
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
//       await _service.addOffer(
//         influencerId: influencerId,
//         brandName: brandName,
//         campaignName: campaignName,
//         description: description,
//         budget: budget,
//       );
//       await fetchOffers(influencerId);
//       debugPrint("✅ Offer added and refreshed");
//     } catch (e) {
//       debugPrint("❌ Error adding offer: $e");
//     }
//   }

//   Future<void> addEarning({
//     required String influencerId,
//     required double amount,
//     required String description,
//   }) async {
//     try {
//       await _service.addEarning(
//         influencerId: influencerId,
//         amount: amount,
//         description: description,
//       );
//       await fetchEarnings(influencerId);
//       debugPrint("✅ Earning added and refreshed");
//     } catch (e) {
//       debugPrint("❌ Error adding earning: $e");
//     }
//   }

//   // ===============================
//   // ✅ Campaigns
//   // ===============================
//   Future<void> fetchAvailableCampaigns() async {
//     try {
//       availableCampaigns = await _campaignService.fetchAvailableCampaigns();
//       notifyListeners();
//       debugPrint("✅ Available campaigns loaded: ${availableCampaigns.length}");
//     } catch (e) {
//       debugPrint("❌ fetchAvailableCampaigns error: $e");
//     }
//   }

//   Future<void> acceptCampaignOffer(String campaignId, String influencerId) async {
//     try {
//       await _campaignService.acceptCampaignOffer(
//         campaignId: campaignId,
//         influencerId: influencerId,
//       );
//       debugPrint("✅ Offer accepted for campaign $campaignId");

//       await fetchAvailableCampaigns();
//       await fetchAcceptedCampaigns(influencerId);
//       await fetchEarnings(influencerId);
//     } catch (e) {
//       debugPrint("❌ acceptCampaignOffer error: $e");
//     }
//   }

//   Future<void> fetchAcceptedCampaigns(String influencerId) async {
//     try {
//       acceptedCampaigns =
//           await _campaignService.fetchAcceptedCampaignsByInfluencer(influencerId);
//       notifyListeners();
//       debugPrint("✅ ${acceptedCampaigns.length} accepted campaigns loaded");
//     } catch (e) {
//       debugPrint("❌ fetchAcceptedCampaigns error: $e");
//     }
//   }

//   // ===============================
//   // ✅ Realtime Earnings & Campaign Updates
//   // ===============================
//   void _subscribeToEarnings(String influencerId) {
//     _earningsChannel?.unsubscribe();

//     _earningsChannel = _supabase.channel('earnings_updates').onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'earnings',
//       filter: PostgresChangeFilter(
//         type: PostgresChangeFilterType.eq,
//         column: 'influencer_id',
//         value: influencerId,
//       ),
//       callback: (payload) async {
//         debugPrint("💰 New earning detected: ${payload.newRecord}");
//         await fetchEarnings(influencerId);
//       },
//     ).subscribe();
//   }

//   void _subscribeToCampaignStatus(String influencerId) {
//     _campaignChannel?.unsubscribe();

//     _campaignChannel = _supabase.channel('campaign_status_updates').onPostgresChanges(
//       event: PostgresChangeEvent.update,
//       schema: 'public',
//       table: 'campaigns',
//       filter: PostgresChangeFilter(
//         type: PostgresChangeFilterType.eq,
//         column: 'influencer_id',
//         value: influencerId,
//       ),
//       callback: (payload) async {
//         final newStatus = payload.newRecord['status'];
//         debugPrint("📢 Campaign status changed: $newStatus");
//         if (newStatus == 'completed') {
//           await fetchEarnings(influencerId);
//         }
//         await fetchAcceptedCampaigns(influencerId);
//       },
//     ).subscribe();
//   }

//   // ===============================
//   // ✅ Audience Analytics
//   // ===============================
//   Future<void> generateMockAudience(String influencerId, int totalFollowers) async {
//     final data = AudienceModel(
//       genderMale: (totalFollowers * 0.5).toInt(),
//       genderFemale: (totalFollowers * 0.4).toInt(),
//       genderOther: (totalFollowers * 0.1).toInt(),
//       age18_24: (totalFollowers * 0.4).toInt(),
//       age25_34: (totalFollowers * 0.35).toInt(),
//       age35Plus: (totalFollowers * 0.25).toInt(),
//       countryTop: ['USA', 'UK', 'Canada'],
//     );

//     await _service.upsertAudience(influencerId, data);
//     _audience = data;
//     notifyListeners();
//   }

//   Future<void> fetchAudience(String influencerId) async {
//     try {
//       _audience = await _service.fetchAudience(influencerId);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching audience: $e");
//     }
//   }

//   Future<void> initAudienceFromOnboarding(String influencerId) async {
//     if (influencer == null) return;

//     final totalFollowers = influencer!.followerCount ?? 1000;
//     final data = AudienceModel(
//       genderMale: (totalFollowers * 0.5).toInt(),
//       genderFemale: (totalFollowers * 0.4).toInt(),
//       genderOther: (totalFollowers * 0.1).toInt(),
//       age18_24: (totalFollowers * 0.4).toInt(),
//       age25_34: (totalFollowers * 0.35).toInt(),
//       age35Plus: (totalFollowers * 0.25).toInt(),
//       countryTop: ['USA', 'UK', 'Canada'],
//     );

//     _audience = data;
//     notifyListeners();
//     await _service.upsertAudience(influencerId, data);
//   }

//   // ===============================
//   // ✅ Social Media Integration
//   // ===============================
//   Future<void> connectInstagram(String influencerId, String token) async {
//     try {
//       await _service.updateSocialTokens(
//           influencerId: influencerId, instagramToken: token);
//       influencer = influencer?.copyWith(instagramToken: token);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting Instagram: $e");
//     }
//   }

//   Future<void> connectTikTok(String influencerId, String token) async {
//     try {
//       await _service.updateSocialTokens(
//           influencerId: influencerId, tiktokToken: token);
//       influencer = influencer?.copyWith(tiktokToken: token);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting TikTok: $e");
//     }
//   }

//   // ===============================
//   // ✅ YouTube Integration
//   // ===============================
//   Future<void> connectYouTubeAccount() async {
//     if (influencer == null) return;
//     loading = true;
//     notifyListeners();
//     try {
//       final data = await _youtubeService.connectYouTube();
//       if (data == null) return;

//       final updatedInfluencer = influencer!.copyWith(
//         youtubeToken: data['accessToken'],
//         youtubeChannelId: data['channelId'] ?? '',
//         youtubeChannelName: data['title'] ?? '',
//         youtubeChannelThumbnail: data['thumbnail'] ?? '',
//         youtubeSubscribers:
//             int.tryParse(data['subscriberCount']?.toString() ?? '0') ?? 0,
//         youtubeDescription: data['description'] ?? '',
//       );

//       await _service.updateYouTubeData(
//         influencerId: updatedInfluencer.id,
//         accessToken: updatedInfluencer.youtubeToken ?? '',
//         channelId: updatedInfluencer.youtubeChannelId ?? '',
//         channelName: updatedInfluencer.youtubeChannelName ?? '',
//         channelThumbnail: updatedInfluencer.youtubeChannelThumbnail ?? '',
//         subscribers: updatedInfluencer.youtubeSubscribers ?? 0,
//         description: updatedInfluencer.youtubeDescription ?? '',
//       );

//       influencer = updatedInfluencer;
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting YouTube: $e");
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> refreshYouTubeToken() async {
//     if (influencer?.youtubeToken == null) return;
//     try {
//       final newToken =
//           await _youtubeService.refreshToken(influencer!.youtubeToken!);
//       if (newToken != null) {
//         influencer = influencer!.copyWith(youtubeToken: newToken);
//         await _service.updateSocialTokens(
//           influencerId: influencer!.id,
//           youtubeToken: newToken,
//         );
//         notifyListeners();
//         debugPrint("🔄 YouTube token refreshed.");
//       }
//     } catch (e) {
//       debugPrint("❌ Error refreshing YouTube token: $e");
//     }
//   }
//   Future<void> completeCampaign(String campaignInfluencerId) async {
//   try {
//     final supabase = Supabase.instance.client;

//     // 🔹 Step 1: Get campaign details
//     final campaignDataResponse = await supabase
//         .from('campaign_influencers')
//         // .select('campaign_id, influencer_id, campaigns (brand_id, budget)')
//         .select('campaign_id, influencer_id, campaigns!fk_campaign_influencer_campaign (brand_id, budget)')
//         .eq('id', campaignInfluencerId)
//         .single();

//     final campaignId = campaignDataResponse['campaign_id'];
//     final influencerId = campaignDataResponse['influencer_id'];
//     final campaign = campaignDataResponse['campaigns'];
//     final brandId = campaign['brand_id'];
//     final budget = (campaign['budget'] ?? 0).toDouble();

//     // 🔹 Step 2: Update both tables’ status to "completed"
//     await supabase
//         .from('campaign_influencers')
//         .update({'status': 'completed'})
//         .eq('id', campaignInfluencerId);

//     await supabase
//         .from('campaigns')
//         .update({'status': 'completed'})
//         .eq('id', campaignId);

//     // 🔹 Step 3: Add earning record for influencer
//     await supabase.from('earnings').insert({
//       'influencer_id': influencerId,
//       'campaign_id': campaignId,
//       'amount': budget,
//       'date': DateTime.now().toIso8601String(),
//     });

//     // 🔹 Step 4: Send notifications
//     final brandFcmToken = await getBrandFcmToken(brandId);
//     if (brandFcmToken != null) {
//       await NotificationService.sendPushMessage(
//         targetToken: brandFcmToken,
//         title: 'Campaign Completed!',
//         body: 'Your campaign has been completed by the influencer.',
//       );
//     }

//     final influencerFcmToken = await getInfluencerFcmToken(influencerId);
//     if (influencerFcmToken != null) {
//       await NotificationService.sendPushMessage(
//         targetToken: influencerFcmToken,
//         title: 'Earning Added!',
//         body: 'You received payment for completing the campaign.',
//       );
//     }

//     // 🔹 Step 5: Update local list and UI
//     acceptedCampaigns = acceptedCampaigns.map((c) {
//       if (c['id'] == campaignInfluencerId) {
//         c['status'] = 'completed';
//       }
//       return c;
//     }).toList();

//     notifyListeners();
//     debugPrint("✅ Campaign marked as completed successfully!");
//   } catch (e, stack) {
//     debugPrint("❌ Error completing campaign: $e\n$stack");
//   }
// }


//   Future<String?> getBrandFcmToken(String brandId) async {
//     try {
//       final response = await Supabase.instance.client
//           .from('profiles')
//           .select('fcm_token')
//           .eq('id', brandId)
//           .maybeSingle();

//       if (response != null && response['fcm_token'] != null) {
//         return response['fcm_token'] as String?;
//       }
//       return null;
//     } catch (e) {
//       debugPrint('❌ getBrandFcmToken error: $e');
//       return null;
//     }
//   }

//   // ===============================
//   // ✅ NEW: Influencer FCM Token
//   // ===============================
//   Future<String?> getInfluencerFcmToken(String influencerId) async {
//     try {
//       final response = await _supabase
//           .from('profiles')
//           .select('fcm_token')
//           .eq('id', influencerId)
//           .maybeSingle();

//       if (response != null && response['fcm_token'] != null) {
//         return response['fcm_token'] as String;
//       }
//       return null;
//     } catch (e) {
//       debugPrint('❌ getInfluencerFcmToken error: $e');
//       return null;
//     }
//   }
// }
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/services/notification_service.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/audience_model.dart';
// import '../models/influencer_model.dart';
// import '../services/influencer_service.dart';
// import '../services/youtube_service.dart';
// import '../services/compaign_service.dart';

// class InfluencerProvider with ChangeNotifier {
//   final _service = InfluencerService();
//   final _youtubeService = YouTubeService();
//   final _campaignService = CampaignService();
//   final SupabaseClient _supabase = Supabase.instance.client;

//   InfluencerModel? influencer;
//   List<Map<String, dynamic>> portfolio = [];
//   List<Map<String, dynamic>> offers = [];
//   List<Map<String, dynamic>> earnings = [];
//   List<Map<String, dynamic>> availableCampaigns = [];
//   List<Map<String, dynamic>> acceptedCampaigns = [];

//   bool loading = false;
//   AudienceModel? _audience;
//   AudienceModel? get audience => _audience;

//   RealtimeChannel? _earningsChannel;
//   RealtimeChannel? _campaignChannel;

//   // ===============================
//   // ✅ Influencer Profile Methods
//   // ===============================
//   Future<void> fetchInfluencer(String id) async {
//     loading = true;
//     notifyListeners();
//     try {
//       influencer = await _service.fetchInfluencer(id);
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//         await fetchEarnings(influencer!.id);
//         await fetchAcceptedCampaigns(influencer!.id);
//         _subscribeToEarnings(influencer!.id);
//         _subscribeToCampaignStatus(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching influencer: $e");
//       influencer = null;
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> saveInfluencerProfile(InfluencerModel model) async {
//     loading = true;
//     notifyListeners();
//     try {
//       await _service.upsertInfluencer(model);
//       influencer = model;
//       debugPrint("✅ Influencer profile updated successfully");
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error saving influencer profile: $e");
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> completeOnboarding(String influencerId) async {
//     try {
//       await _service.markOnboardingComplete(influencerId);
//       if (influencer != null) {
//         influencer = influencer!.copyWith(onboardingCompleted: true);
//         notifyListeners();
//       }
//       debugPrint("✅ Onboarding marked complete for $influencerId");
//     } catch (e) {
//       debugPrint("❌ Error completing onboarding: $e");
//     }
//   }

//   Future<void> updateInfluencer(InfluencerModel model) async {
//     try {
//       await _service.upsertInfluencer(model);
//       influencer = model;
//       notifyListeners();
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id);
//       }
//     } catch (e) {
//       debugPrint("❌ Error updating influencer: $e");
//     }
//   }

//   Future<String?> uploadProfileImage(String influencerId, Uint8List bytes) async {
//     try {
//       final imageUrl = await _service.uploadProfileImage(influencerId, bytes);
//       if (imageUrl != null && influencer != null) {
//         influencer = influencer!.copyWith(profileImage: imageUrl);
//         notifyListeners();
//       }
//       return imageUrl;
//     } catch (e) {
//       debugPrint("❌ Error in uploadProfileImage: $e");
//       return null;
//     }
//   }

//   void clear() {
//     influencer = null;
//     portfolio.clear();
//     offers.clear();
//     earnings.clear();
//     availableCampaigns.clear();
//     acceptedCampaigns.clear();
//     _audience = null;
//     _earningsChannel?.unsubscribe();
//     _campaignChannel?.unsubscribe();
//     notifyListeners();
//   }

//   // ===============================
//   // ✅ Portfolio / Offers / Earnings
//   // ===============================
//   Future<void> fetchPortfolio(String id) async {
//     try {
//       portfolio = await _service.fetchPortfolio(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching portfolio: $e");
//     }
//   }

//   Future<void> fetchOffers(String id) async {
//     try {
//       offers = await _service.fetchOffers(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching offers: $e");
//     }
//   }

//   Future<void> fetchEarnings(String id) async {
//     try {
//       final response = await _supabase
//           .from('earnings')
//           .select()
//           .eq('influencer_id', id)
//           .order('created_at', ascending: false);

//       earnings = List<Map<String, dynamic>>.from(response);
//       notifyListeners();
//       debugPrint("💰 Earnings loaded: ${earnings.length}");
//     } catch (e) {
//       debugPrint("❌ Error fetching earnings: $e");
//       earnings = [];
//       notifyListeners();
//     }
//   }

//   Future<void> addEarning({
//     required String influencerId,
//     required double amount,
//     required String description,
//   }) async {
//     try {
//       await _service.addEarning(
//         influencerId: influencerId,
//         amount: amount,
//         description: description,
//       );
//       await fetchEarnings(influencerId);
//       debugPrint("✅ Earning added and refreshed");
//     } catch (e) {
//       debugPrint("❌ Error adding earning: $e");
//     }
//   }

//   // ===============================
//   // ✅ Campaigns
//   // ===============================
//   Future<void> fetchAvailableCampaigns() async {
//     try {
//       availableCampaigns = await _campaignService.fetchAvailableCampaigns();
//       notifyListeners();
//       debugPrint("✅ Available campaigns loaded: ${availableCampaigns.length}");
//     } catch (e) {
//       debugPrint("❌ fetchAvailableCampaigns error: $e");
//     }
//   }

//   Future<void> acceptCampaignOffer(String campaignId, String influencerId) async {
//     try {
//       await _campaignService.acceptCampaignOffer(
//         campaignId: campaignId,
//         influencerId: influencerId,
//       );
//       debugPrint("✅ Offer accepted for campaign $campaignId");

//       await fetchAvailableCampaigns();
//       await fetchAcceptedCampaigns(influencerId);
//       await fetchEarnings(influencerId);
//     } catch (e) {
//       debugPrint("❌ acceptCampaignOffer error: $e");
//     }
//   }

//   Future<void> fetchAcceptedCampaigns(String influencerId) async {
//     try {
//       acceptedCampaigns = await _campaignService.fetchAcceptedCampaignsByInfluencer(influencerId);
//       notifyListeners();
//       debugPrint("✅ ${acceptedCampaigns.length} accepted campaigns loaded");
//     } catch (e) {
//       debugPrint("❌ fetchAcceptedCampaigns error: $e");
//     }
//   }

//   // ===============================
//   // ✅ Complete Campaign
//   // ===============================

// Future<void> completeCampaign(String campaignId, String influencerId) async {
//   try {
//     final supabase = Supabase.instance.client;

//     // 1️⃣ Update campaigns table
//     await supabase
//         .from('campaigns')
//         .update({'status': 'completed'})
//         .eq('id', campaignId);

//     // 2️⃣ Update influencer-specific status in campaign_influencers
//     await supabase
//         .from('campaign_influencers')
//         .update({'status': 'completed'})
//         .eq('campaign_id', campaignId)
//         .eq('influencer_id', influencerId);

//     debugPrint('✅ Campaign and influencer campaign status set to completed');

//     // 3️⃣ Refresh the accepted campaigns list
//     await fetchAcceptedCampaigns(influencerId);

//     notifyListeners();
//   } catch (e) {
//     debugPrint("❌ Error completing campaign: $e");
//   }
// }


//   // ===============================
//   // ✅ Realtime Earnings & Campaign Updates
//   // ===============================
//   void _subscribeToEarnings(String influencerId) {
//     _earningsChannel?.unsubscribe();
//     _earningsChannel = _supabase.channel('earnings_updates').onPostgresChanges(
//       event: PostgresChangeEvent.insert,
//       schema: 'public',
//       table: 'earnings',
//       filter: PostgresChangeFilter(
//         type: PostgresChangeFilterType.eq,
//         column: 'influencer_id',
//         value: influencerId,
//       ),
//       callback: (payload) async {
//         debugPrint("💰 New earning detected: ${payload.newRecord}");
//         await fetchEarnings(influencerId);
//       },
//     ).subscribe();
//   }

//   void _subscribeToCampaignStatus(String influencerId) {
//     _campaignChannel?.unsubscribe();
//     _campaignChannel = _supabase.channel('campaign_status_updates').onPostgresChanges(
//       event: PostgresChangeEvent.update,
//       schema: 'public',
//       table: 'campaigns',
//       callback: (payload) async {
//         final newStatus = payload.newRecord['status'];
//         debugPrint("📢 Campaign status changed: $newStatus");
//         if (newStatus == 'completed') {
//           await fetchEarnings(influencerId);
//         }
//         await fetchAcceptedCampaigns(influencerId);
//       },
//     ).subscribe();
//   }

//   // ===============================
//   // ✅ Audience Analytics
//   // ===============================
//   Future<void> initAudienceFromOnboarding(String influencerId) async {
//     if (influencer == null) return;
//     final totalFollowers = influencer!.followerCount ?? 1000;
//     final data = AudienceModel(
//       genderMale: (totalFollowers * 0.5).toInt(),
//       genderFemale: (totalFollowers * 0.4).toInt(),
//       genderOther: (totalFollowers * 0.1).toInt(),
//       age18_24: (totalFollowers * 0.4).toInt(),
//       age25_34: (totalFollowers * 0.35).toInt(),
//       age35Plus: (totalFollowers * 0.25).toInt(),
//       countryTop: ['USA', 'UK', 'Canada'],
//     );
//     _audience = data;
//     notifyListeners();
//     await _service.upsertAudience(influencerId, data);
//   }

//   // ===============================
//   // ✅ Social Media Integration
//   // ===============================
//   Future<void> connectInstagram(String influencerId, String token) async {
//     try {
//       await _service.updateSocialTokens(influencerId: influencerId, instagramToken: token);
//       influencer = influencer?.copyWith(instagramToken: token);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting Instagram: $e");
//     }
//   }

//   Future<void> connectTikTok(String influencerId, String token) async {
//     try {
//       await _service.updateSocialTokens(influencerId: influencerId, tiktokToken: token);
//       influencer = influencer?.copyWith(tiktokToken: token);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting TikTok: $e");
//     }
//   }

//   // ===============================
//   // ✅ YouTube Integration
//   // ===============================
//   Future<void> connectYouTubeAccount() async {
//     if (influencer == null) return;
//     loading = true;
//     notifyListeners();
//     try {
//       final data = await _youtubeService.connectYouTube();
//       if (data == null) return;
//       final updatedInfluencer = influencer!.copyWith(
//         youtubeToken: data['accessToken'],
//         youtubeChannelId: data['channelId'] ?? '',
//         youtubeChannelName: data['title'] ?? '',
//         youtubeChannelThumbnail: data['thumbnail'] ?? '',
//         youtubeSubscribers: int.tryParse(data['subscriberCount']?.toString() ?? '0') ?? 0,
//         youtubeDescription: data['description'] ?? '',
//       );
//       await _service.updateYouTubeData(
//         influencerId: updatedInfluencer.id,
//         accessToken: updatedInfluencer.youtubeToken ?? '',
//         channelId: updatedInfluencer.youtubeChannelId ?? '',
//         channelName: updatedInfluencer.youtubeChannelName ?? '',
//         channelThumbnail: updatedInfluencer.youtubeChannelThumbnail ?? '',
//         subscribers: updatedInfluencer.youtubeSubscribers ?? 0,
//         description: updatedInfluencer.youtubeDescription ?? '',
//       );
//       influencer = updatedInfluencer;
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting YouTube: $e");
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   // ===============================
//   // ✅ Token Helpers
//   // ===============================
//   Future<String?> getBrandFcmToken(String brandId) async {
//     try {
//       final response = await _supabase.from('profiles').select('fcm_token').eq('id', brandId).maybeSingle();
//       return response?['fcm_token'] as String?;
//     } catch (e) {
//       debugPrint('❌ getBrandFcmToken error: $e');
//       return null;
//     }
//   }

//   Future<String?> getInfluencerFcmToken(String influencerId) async {
//     try {
//       final response = await _supabase.from('profiles').select('fcm_token').eq('id', influencerId).maybeSingle();
//       return response?['fcm_token'] as String?;
//     } catch (e) {
//       debugPrint('❌ getInfluencerFcmToken error: $e');
//       return null;
//     }
//   }
// }
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/services/notification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/audience_model.dart';
import '../models/influencer_model.dart';
import '../services/influencer_service.dart';
import '../services/youtube_service.dart';
import '../services/compaign_service.dart';

class InfluencerProvider with ChangeNotifier {
  final _service = InfluencerService();
  final _youtubeService = YouTubeService();
  final _campaignService = CampaignService();
  final SupabaseClient _supabase = Supabase.instance.client;

  InfluencerModel? influencer;
  List<Map<String, dynamic>> portfolio = [];
  List<Map<String, dynamic>> offers = [];
  List<Map<String, dynamic>> earnings = [];
  List<Map<String, dynamic>> availableCampaigns = [];
  List<Map<String, dynamic>> acceptedCampaigns = [];

  bool loading = false;
  AudienceModel? _audience;
  AudienceModel? get audience => _audience;

  RealtimeChannel? _earningsChannel;
  RealtimeChannel? _campaignChannel;

  // ===============================
  // ✅ Influencer Profile Methods
  // ===============================
  Future<void> fetchInfluencer(String id) async {
    loading = true;
    notifyListeners();
    try {
      influencer = await _service.fetchInfluencer(id);
      if (influencer != null) {
        await initAudienceFromOnboarding(influencer!.id);
        await fetchEarnings(influencer!.id);
        await fetchAcceptedCampaigns(influencer!.id);
        _subscribeToEarnings(influencer!.id);
        _subscribeToCampaignStatus(influencer!.id);
      }
    } catch (e) {
      debugPrint("❌ Error fetching influencer: $e");
      influencer = null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> saveInfluencerProfile(InfluencerModel model) async {
    loading = true;
    notifyListeners();
    try {
      await _service.upsertInfluencer(model);
      influencer = model;
      debugPrint("✅ Influencer profile updated successfully");
      if (influencer != null) {
        await initAudienceFromOnboarding(influencer!.id);
      }
    } catch (e) {
      debugPrint("❌ Error saving influencer profile: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> completeOnboarding(String influencerId) async {
    try {
      await _service.markOnboardingComplete(influencerId);
      if (influencer != null) {
        influencer = influencer!.copyWith(onboardingCompleted: true);
        notifyListeners();
      }
      debugPrint("✅ Onboarding marked complete for $influencerId");
    } catch (e) {
      debugPrint("❌ Error completing onboarding: $e");
    }
  }

  Future<void> updateInfluencer(InfluencerModel model) async {
    try {
      await _service.upsertInfluencer(model);
      influencer = model;
      notifyListeners();
      if (influencer != null) {
        await initAudienceFromOnboarding(influencer!.id);
      }
    } catch (e) {
      debugPrint("❌ Error updating influencer: $e");
    }
  }

  Future<String?> uploadProfileImage(String influencerId, Uint8List bytes) async {
    try {
      final imageUrl = await _service.uploadProfileImage(influencerId, bytes);
      if (imageUrl != null && influencer != null) {
        influencer = influencer!.copyWith(profileImage: imageUrl);
        notifyListeners();
      }
      return imageUrl;
    } catch (e) {
      debugPrint("❌ Error in uploadProfileImage: $e");
      return null;
    }
  }

  void clear() {
    influencer = null;
    portfolio.clear();
    offers.clear();
    earnings.clear();
    availableCampaigns.clear();
    acceptedCampaigns.clear();
    _audience = null;
    _earningsChannel?.unsubscribe();
    _campaignChannel?.unsubscribe();
    notifyListeners();
  }

  // ===============================
  // ✅ Portfolio / Offers / Earnings
  // ===============================
  Future<void> fetchPortfolio(String id) async {
    try {
      portfolio = await _service.fetchPortfolio(id);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error fetching portfolio: $e");
    }
  }

  Future<void> fetchOffers(String id) async {
    try {
      offers = await _service.fetchOffers(id);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error fetching offers: $e");
    }
  }

  Future<void> fetchEarnings(String id) async {
    try {
      final response = await _supabase
          .from('earnings')
          .select()
          .eq('influencer_id', id)
          .order('created_at', ascending: false);

      earnings = List<Map<String, dynamic>>.from(response);
      notifyListeners();
      debugPrint("💰 Earnings loaded: ${earnings.length}");
    } catch (e) {
      debugPrint("❌ Error fetching earnings: $e");
      earnings = [];
      notifyListeners();
    }
  }

  Future<void> addEarning({
    required String influencerId,
    required double amount,
    required String description,
  }) async {
    try {
      await _service.addEarning(
        influencerId: influencerId,
        amount: amount,
        description: description,
      );
      await fetchEarnings(influencerId);
      debugPrint("✅ Earning added and refreshed");
    } catch (e) {
      debugPrint("❌ Error adding earning: $e");
    }
  }

  // ===============================
  // ✅ Campaigns
  // ===============================
  Future<void> fetchAvailableCampaigns() async {
    try {
      availableCampaigns = await _campaignService.fetchAvailableCampaigns();
      notifyListeners();
      debugPrint("✅ Available campaigns loaded: ${availableCampaigns.length}");
    } catch (e) {
      debugPrint("❌ fetchAvailableCampaigns error: $e");
    }
  }

  Future<void> acceptCampaignOffer(String campaignId, String influencerId) async {
    try {
      await _campaignService.acceptCampaignOffer(
        campaignId: campaignId,
        influencerId: influencerId,
      );
      debugPrint("✅ Offer accepted for campaign $campaignId");

      await fetchAvailableCampaigns();
      await fetchAcceptedCampaigns(influencerId);
      await fetchEarnings(influencerId);
    } catch (e) {
      debugPrint("❌ acceptCampaignOffer error: $e");
    }
  }

  // Future<void> fetchAcceptedCampaigns(String influencerId) async {
  //   try {
  //     acceptedCampaigns = await _campaignService.fetchAcceptedCampaignsByInfluencer(influencerId);
  //     notifyListeners();
  //     debugPrint("✅ ${acceptedCampaigns.length} accepted campaigns loaded");
  //   } catch (e) {
  //     debugPrint("❌ fetchAcceptedCampaigns error: $e");
  //   }
  // }

  // // ===============================
  // // ✅ Complete Campaign
  // // ===============================
  // Future<void> completeCampaign(String campaignId, String influencerId) async {
  //   try {
  //     // 1️⃣ Update campaigns table
  //     await _supabase
  //         .from('campaigns')
  //         .update({'status': 'completed'})
  //         .eq('id', campaignId);

  //     // 2️⃣ Update influencer-specific status in campaign_influencers
  //     await _supabase
  //         .from('campaign_influencers')
  //         .update({'status': 'completed'})
  //         .eq('campaign_id', campaignId)
  //         .eq('influencer_id', influencerId);

  //     debugPrint('✅ Campaign and influencer campaign status set to completed');

  //     // 3️⃣ Update local list so UI reflects immediately
  //     final index = acceptedCampaigns.indexWhere(
  //         (c) => c['campaigns']?['id'] == campaignId && c['influencer_id'] == influencerId);

  //     if (index != -1) {
  //       acceptedCampaigns[index]['status'] = 'completed';
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     debugPrint("❌ Error completing campaign: $e");
  //   }
  // }
     Future<void> fetchAcceptedCampaigns(String influencerId) async {
    try {
      acceptedCampaigns = await _campaignService.fetchAcceptedCampaignsByInfluencer(influencerId);
      notifyListeners();
      debugPrint("✅ ${acceptedCampaigns.length} accepted campaigns loaded");
    } catch (e) {
      debugPrint("❌ fetchAcceptedCampaigns error: $e");
    }
  }

  // Future<void> completeCampaign(String campaignId, String influencerId) async {
  //   try {
  //     debugPrint('Completing campaign: $campaignId for influencer: $influencerId');

  //     // 1️⃣ Update campaigns table
  //     await _supabase
  //         .from('campaigns')
  //         .update({'status': 'completed'})
  //         .eq('id', campaignId);

  //     // 2️⃣ Update influencer-specific status in campaign_influencers
  //     final res = await _supabase
  //         .from('campaign_influencers')
  //         .update({'status': 'completed'})
  //         .eq('campaign_id', campaignId)
  //         .eq('influencer_id', influencerId);

  //     debugPrint('campaign_influencers update result: $res');

  //     // 3️⃣ Refresh accepted campaigns from DB
  //     await fetchAcceptedCampaigns(influencerId);

  //   } catch (e) {
  //     debugPrint("❌ Error completing campaign: $e");
  //   }
  // }
//   Future<void> completeCampaign(String campaignId, String influencerId) async {
//   try {
//     debugPrint('Completing campaign: $campaignId for influencer: $influencerId');

//     // 1️⃣ Update campaigns table
//     final resCampaign = await _supabase
//         .from('campaigns')
//         .update({'status': 'completed'})
//         .eq('id', campaignId)
//         .select(); // return updated rows

//     debugPrint('campaigns update result: $resCampaign');

//     // 2️⃣ Update influencer-specific status in campaign_influencers
//     // final resInfluencer = await _supabase
//     //     .from('campaign_influencers')
//     //     .update({'status': 'completed'})
//     //     .eq('campaign_id', campaignId)
//     //     .eq('influencer_id', influencerId)
//     //     .select(); // important: add select() to see updated row

//     // debugPrint('campaign_influencers update result: $resInfluencer');
//     final resInfluencer = await _supabase
//     .from('campaign_influencers')
//     .update({'status': 'completed'})
//     .eq('campaign_id', campaignId.toString().trim())
//     .eq('influencer_id', influencerId.toString().trim())
//     .select();
// debugPrint('campaign_influencers update result: $resInfluencer'); 

//     // 3️⃣ Update local list
//     final index = acceptedCampaigns.indexWhere(
//         (c) => c['campaigns']?['id'] == campaignId && c['influencer_id'] == influencerId);

//     if (index != -1) {
//       acceptedCampaigns[index]['status'] = 'completed';
//       notifyListeners();
//     }
//   } catch (e) {
//     debugPrint("❌ Error completing campaign: $e");
//   }
// }
// Future<void> completeCampaign(String campaignId, String influencerId) async {
//   try {
//     debugPrint('Completing campaign: $campaignId for influencer: $influencerId');

//     // Ensure IDs are trimmed and lowercase
//     final campaignIdStr = campaignId.trim();
//     final influencerIdStr = influencerId.trim();

//     // 1️⃣ Update campaigns table
//     final campaignRes = await _supabase
//         .from('campaigns')
//         .update({'status': 'completed'})
//         .eq('id', campaignIdStr)
//         .select();
//     debugPrint('campaigns update result: $campaignRes');

//     // 2️⃣ Update campaign_influencers table
//     final influencerRes = await _supabase
//         .from('campaign_influencers')
//         .update({'status': 'completed'})
//         .eq('campaign_id', campaignIdStr)
//         .eq('influencer_id', influencerIdStr)
//         .select(); // must add .select() to see updated rows
//     debugPrint('campaign_influencers update result: $influencerRes');

//     // 3️⃣ Update local list so UI updates immediately
//     final index = acceptedCampaigns.indexWhere(
//       (c) => c['campaigns']?['id'] == campaignId && c['influencer_id'] == influencerId,
//     );

//     if (index != -1) {
//       acceptedCampaigns[index]['status'] = 'completed';
//       notifyListeners();
//     }
//   } catch (e) {
//     debugPrint("❌ Error completing campaign: $e");
//   }
// }
Future<void> completeCampaign(String campaignId, String influencerId) async {
  try {
    debugPrint('Completing campaign: $campaignId for influencer: $influencerId');

    // 1️⃣ Update campaigns table
    final campaignRes = await _supabase
        .from('campaigns')
        .update({'status': 'completed'})
        .eq('id', campaignId)
        .select();
    debugPrint('campaigns update result: $campaignRes');

    // 2️⃣ Update campaign_influencers table (UUID-safe)
    // final influencerRes = await _supabase
    //     .from('campaign_influencers')
    //     .update({'status': 'completed'})
    //     .filter('campaign_id', 'eq', campaignId)
    //     .filter('influencer_id', 'eq', influencerId)
    //     .select();
    // debugPrint('campaign_influencers update result: $influencerRes');
    // 2️⃣ Update campaign_influencers table using RPC (guaranteed UUID-safe)
final influencerRes = await _supabase
    .rpc('mark_campaign_influencer_completed', params: {
  'c_id': campaignId,
  'i_id': influencerId,
});
debugPrint('✅ campaign_influencers RPC result: $influencerRes');

    // 3️⃣ Update local UI
    final index = acceptedCampaigns.indexWhere(
      (c) => c['campaigns']?['id'] == campaignId && c['influencer_id'] == influencerId,
    );
    if (index != -1) {
      acceptedCampaigns[index]['status'] = 'completed';
      notifyListeners();
    }
  } catch (e) {
    debugPrint("❌ Error completing campaign: $e");
  }
}


  // ===============================
  // ✅ Realtime Earnings & Campaign Updates
  // ===============================
  void _subscribeToEarnings(String influencerId) {
    _earningsChannel?.unsubscribe();
    _earningsChannel = _supabase.channel('earnings_updates').onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'earnings',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'influencer_id',
        value: influencerId,
      ),
      callback: (payload) async {
        debugPrint("💰 New earning detected: ${payload.newRecord}");
        await fetchEarnings(influencerId);
      },
    ).subscribe();
  }

  void _subscribeToCampaignStatus(String influencerId) {
    _campaignChannel?.unsubscribe();
    _campaignChannel = _supabase.channel('campaign_status_updates').onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'campaigns',
      callback: (payload) async {
        final newStatus = payload.newRecord['status'];
        debugPrint("📢 Campaign status changed: $newStatus");
        if (newStatus == 'completed') {
          await fetchEarnings(influencerId);
        }
        await fetchAcceptedCampaigns(influencerId);
      },
    ).subscribe();
  }

  // ===============================
  // ✅ Audience Analytics
  // ===============================
  Future<void> initAudienceFromOnboarding(String influencerId) async {
    if (influencer == null) return;
    final totalFollowers = influencer!.followerCount ?? 1000;
    final data = AudienceModel(
      genderMale: (totalFollowers * 0.5).toInt(),
      genderFemale: (totalFollowers * 0.4).toInt(),
      genderOther: (totalFollowers * 0.1).toInt(),
      age18_24: (totalFollowers * 0.4).toInt(),
      age25_34: (totalFollowers * 0.35).toInt(),
      age35Plus: (totalFollowers * 0.25).toInt(),
      countryTop: ['USA', 'UK', 'Canada'],
    );
    _audience = data;
    notifyListeners();
    await _service.upsertAudience(influencerId, data);
  }

  // ===============================
  // ✅ Social Media Integration
  // ===============================
  Future<void> connectInstagram(String influencerId, String token) async {
    try {
      await _service.updateSocialTokens(influencerId: influencerId, instagramToken: token);
      influencer = influencer?.copyWith(instagramToken: token);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error connecting Instagram: $e");
    }
  }

  Future<void> connectTikTok(String influencerId, String token) async {
    try {
      await _service.updateSocialTokens(influencerId: influencerId, tiktokToken: token);
      influencer = influencer?.copyWith(tiktokToken: token);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error connecting TikTok: $e");
    }
  }

  // ===============================
  // ✅ YouTube Integration
  // ===============================
  Future<void> connectYouTubeAccount() async {
    if (influencer == null) return;
    loading = true;
    notifyListeners();
    try {
      final data = await _youtubeService.connectYouTube();
      if (data == null) return;
      final updatedInfluencer = influencer!.copyWith(
        youtubeToken: data['accessToken'],
        youtubeChannelId: data['channelId'] ?? '',
        youtubeChannelName: data['title'] ?? '',
        youtubeChannelThumbnail: data['thumbnail'] ?? '',
        youtubeSubscribers: int.tryParse(data['subscriberCount']?.toString() ?? '0') ?? 0,
        youtubeDescription: data['description'] ?? '',
      );
      await _service.updateYouTubeData(
        influencerId: updatedInfluencer.id,
        accessToken: updatedInfluencer.youtubeToken ?? '',
        channelId: updatedInfluencer.youtubeChannelId ?? '',
        channelName: updatedInfluencer.youtubeChannelName ?? '',
        channelThumbnail: updatedInfluencer.youtubeChannelThumbnail ?? '',
        subscribers: updatedInfluencer.youtubeSubscribers ?? 0,
        description: updatedInfluencer.youtubeDescription ?? '',
      );
      influencer = updatedInfluencer;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error connecting YouTube: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ===============================
  // ✅ Token Helpers
  // ===============================
  Future<String?> getBrandFcmToken(String brandId) async {
    try {
      final response = await _supabase.from('profiles').select('fcm_token').eq('id', brandId).maybeSingle();
      return response?['fcm_token'] as String?;
    } catch (e) {
      debugPrint('❌ getBrandFcmToken error: $e');
      return null;
    }
  }

  Future<String?> getInfluencerFcmToken(String influencerId) async {
    try {
      final response = await _supabase.from('profiles').select('fcm_token').eq('id', influencerId).maybeSingle();
      return response?['fcm_token'] as String?;
    } catch (e) {
      debugPrint('❌ getInfluencerFcmToken error: $e');
      return null;
    }
  }
  Future<void> deleteCampaignCard(String campaignId, String influencerId) async {
  try {
    await _supabase
        .from('campaign_influencers')
        .delete()
        .eq('campaign_id', campaignId)
        .eq('influencer_id', influencerId);

    acceptedCampaigns.removeWhere(
      (c) =>
          c['campaigns']?['id'] == campaignId &&
          c['influencer_id'] == influencerId,
    );
    notifyListeners();

    debugPrint('🗑️ Campaign card deleted successfully');
  } catch (e) {
    debugPrint('❌ Error deleting campaign card: $e');
  }
}
/// ✅ Delete a specific earning record from Supabase
Future<void> deleteEarning(String id) async {
  try {
    final supabase = Supabase.instance.client;
    await supabase.from('earnings').delete().eq('id', id);

    // Also remove it locally so UI updates instantly
    earnings.removeWhere((e) => e['id'] == id);
    notifyListeners();
  } catch (e) {
    debugPrint('❌ deleteEarning error: $e');
    rethrow;
  }
}


}
