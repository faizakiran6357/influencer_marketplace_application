
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/models/audience_model.dart';
// import '../services/influencer_service.dart';
// import '../models/influencer_model.dart';

// class InfluencerProvider with ChangeNotifier {
//   final _service = InfluencerService();

//   InfluencerModel? influencer;
//   List<Map<String, dynamic>> portfolio = [];
//   List<Map<String, dynamic>> offers = [];
//   List<Map<String, dynamic>> earnings = [];

//   bool loading = false;

//   AudienceModel? _audience;
//   AudienceModel? get audience => _audience;

//   // ✅ Fetch influencer profile safely
//   Future<void> fetchInfluencer(String id) async {
//     try {
//       loading = true;
//       notifyListeners();

//       final data = await _service.fetchInfluencer(id);
//       influencer = data;

//       // Automatically initialize audience from onboarding data
//       await initAudienceFromOnboarding(id);
//     } catch (e) {
//       debugPrint("❌ Error fetching influencer: $e");
//       influencer = null;
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   // ✅ Save or update influencer profile
//   Future<void> saveInfluencerProfile(InfluencerModel model) async {
//     try {
//       loading = true;
//       notifyListeners();

//       await _service.upsertInfluencer(model);
//       influencer = model;

//       debugPrint("✅ Influencer profile updated successfully");

//       // Update audience if followers count changes
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id!);
//       }
//     } catch (e) {
//       debugPrint("❌ Error saving influencer profile: $e");
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   // ✅ Mark onboarding as complete
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

//   // ✅ Generate mock audience (can still use manually)
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

//     // Save to Supabase
//     await _service.upsertAudience(influencerId, data);

//     _audience = data; // Store in provider
//     notifyListeners();
//   }

//   // ✅ Initialize audience automatically from influencer onboarding data
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

//     // Save to Supabase
//     await _service.upsertAudience(influencerId, data);
//   }

//   // ✅ Fetch portfolio items
//   Future<void> fetchPortfolio(String id) async {
//     try {
//       portfolio = await _service.fetchPortfolio(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching portfolio: $e");
//     }
//   }

//   // ✅ Fetch offers
//   Future<void> fetchOffers(String id) async {
//     try {
//       offers = await _service.fetchOffers(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching offers: $e");
//     }
//   }

//   // ✅ Fetch earnings
//   Future<void> fetchEarnings(String id) async {
//     try {
//       earnings = await _service.fetchEarnings(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching earnings: $e");
//     }
//   }

//   // ✅ Add new offer
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

//   // ✅ Add new earning
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

//   // ✅ Reset provider state
//   void clear() {
//     influencer = null;
//     portfolio.clear();
//     offers.clear();
//     earnings.clear();
//     _audience = null;
//     notifyListeners();
//   }

//   // ✅ Update influencer profile
//   Future<void> updateInfluencer(InfluencerModel model) async {
//     try {
//       await _service.upsertInfluencer(model);
//       influencer = model;
//       notifyListeners();

//       // Update audience if followers count changes
//       if (influencer != null) {
//         await initAudienceFromOnboarding(influencer!.id!);
//       }
//     } catch (e) {
//       debugPrint("❌ Error updating influencer: $e");
//     }
//   }

//   // ✅ Upload profile image and return its URL
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
// }
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import '../models/audience_model.dart';
// import '../models/influencer_model.dart';
// import '../services/influencer_service.dart';

// class InfluencerProvider with ChangeNotifier {
//   final _service = InfluencerService();

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

//       // Automatically initialize audience from onboarding data if needed
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

//       // Update audience if followers count changes
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

//       // Update audience if followers count changes
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

//   Future<void> connectYouTube(String influencerId, String token) async {
//     try {
//       await _service.updateSocialTokens(influencerId: influencerId, youtubeToken: token);
//       if (influencer != null) influencer = influencer!.copyWith(youtubeToken: token);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error connecting YouTube: $e");
//     }
//   }
// }
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
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

//   /// ✅ YouTube connection using OAuth via YouTubeService
//   Future<void> connectYouTubeAccount() async {
//     try {
//       final data = await _youtubeService.connectYouTube();
//       if (data == null) {
//         debugPrint("❌ YouTube connection failed or cancelled.");
//         return;
//       }

//       final influencerId = influencer?.id;
//       if (influencerId == null) return;

//       // Update tokens & URL
//       await _service.updateSocialTokens(
//         influencerId: influencerId,
//         youtubeToken: data['accessToken'],
//       );

//       influencer = influencer?.copyWith(
//         youtubeToken: data['accessToken'],
//         youtubeUrl: "https://www.youtube.com/channel/${data['channelId']}",
//       );
//       notifyListeners();

//       debugPrint("✅ YouTube connected successfully: ${data['title']}");
//     } catch (e) {
//       debugPrint("❌ Error connecting YouTube: $e");
//     }
//   }

//   /// ✅ Optional helper to refresh YouTube token (future use)
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

 
//    // ===============================
// // ✅ YouTube Integration (Updated)
// // ===============================
// Future<void> connectYouTubeAccount() async {
//   try {
//     final data = await _youtubeService.connectYouTube();
//     if (data == null) {
//       debugPrint("❌ YouTube connection failed or cancelled.");
//       return;
//     }

//     final influencerId = influencer?.id;
//     if (influencerId == null) return;

//     // ✅ Prepare data
//     final youtubeName = data['title'] ?? 'Unknown Channel';
//     final youtubeThumb = data['thumbnail'] ?? '';
//     final youtubeSubs = int.tryParse(data['subscriberCount']?.toString() ?? '0') ?? 0;

//     // ✅ Update in Supabase (only columns you actually have)
//     await _service.updateYouTubeDataSimple(
//       influencerId: influencerId,
//       youtubeChannelName: youtubeName,
//       youtubeChannelThumbnail: youtubeThumb,
//       youtubeSubscribers: youtubeSubs,
//     );

//     // ✅ Update local influencer model
//     influencer = influencer?.copyWith(
//       youtubeChannelName: youtubeName,
//       youtubeChannelThumbnail: youtubeThumb,
//       youtubeSubscribers: youtubeSubs,
//       youtubeToken: data['accessToken'],
//     );

//     notifyListeners();
//     debugPrint("✅ YouTube connected & data synced successfully.");
//   } catch (e) {
//     debugPrint("❌ Error connecting YouTube: $e");
//   }
// }

//   Future<void> refreshYouTubeToken() async {
//     if (influencer?.youtubeToken == null) return;
//     try {
//       // ✅ Fixed: using refreshToken() instead of refreshAccessToken()
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
//   // ✅ YouTube Integration (Final Fixed)
//   // ===============================
//   Future<void> connectYouTubeAccount() async {
//     try {
//       loading = true;
//       notifyListeners();

//       debugPrint("🔄 Connecting to YouTube...");

//       final data = await _youtubeService.connectYouTube();
//       if (data == null) {
//         debugPrint("❌ YouTube connection failed or cancelled.");
//         return;
//       }

//       final influencerId = influencer?.id;
//       if (influencerId == null) return;

//       final youtubeName = data['title'] ?? 'Unknown Channel';
//       final youtubeThumb = data['thumbnail'] ?? '';
//       final youtubeSubs = int.tryParse(data['subscriberCount']?.toString() ?? '0') ?? 0;

//       await _service.updateYouTubeData(
//   influencerId: influencerId,
//   accessToken: data['accessToken'],
//   channelName: youtubeName,
//   channelThumbnail: youtubeThumb,
//   subscribers: youtubeSubs,
// );
//       influencer = influencer?.copyWith(
//         youtubeChannelName: youtubeName,
//         youtubeChannelThumbnail: youtubeThumb,
//         youtubeSubscribers: youtubeSubs,
//         youtubeToken: data['accessToken'],
//       );

//       notifyListeners();
//       debugPrint("✅ YouTube connected & data synced successfully.");
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
//   // ✅ YouTube Integration (Final)
//   // ===============================
//   Future<void> connectYouTubeAccount() async {
//     try {
//       loading = true;
//       notifyListeners();
//       debugPrint("🎬 Starting YouTube connection...");

//       final data = await _youtubeService.connectYouTube();
//       if (data == null) {
//         debugPrint("❌ YouTube connection failed or cancelled.");
//         return;
//       }

//       final influencerId = influencer?.id;
//       if (influencerId == null) return;

//       final channelName = data['title'] ?? 'Unknown Channel';
//       final channelThumbnail = data['thumbnail'] ?? '';
//       final subscribers = int.tryParse(data['subscriberCount']?.toString() ?? '0') ?? 0;

//       await _service.updateYouTubeData(
//         influencerId: influencerId,
//         accessToken: data['accessToken'],
//         channelName: channelName,
//         channelThumbnail: channelThumbnail,
//         subscribers: subscribers,
//       );

//       influencer = influencer?.copyWith(
//         youtubeChannelName: channelName,
//         youtubeChannelThumbnail: channelThumbnail,
//         youtubeSubscribers: subscribers,
//         youtubeToken: data['accessToken'],
//       );

//       notifyListeners();
//       debugPrint("✅ YouTube connected & data synced successfully.");
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
//     try {
//       loading = true;
//       notifyListeners();

//       debugPrint("🎬 Starting YouTube connection...");
//       final data = await _youtubeService.connectYouTube();
//       if (data == null) {
//         debugPrint("❌ YouTube connection failed or cancelled.");
//         return;
//       }

//       final influencerId = influencer?.id;
//       if (influencerId == null) return;

//       final channelId = data['channelId'] ?? '';
//       final channelName = data['title'] ?? '';
//       final channelThumbnail = data['thumbnail'] ?? '';
//       final subscribers = int.tryParse(data['subscriberCount']?.toString() ?? '0') ?? 0;
//       final description = data['description'] ?? '';

//       await _service.updateYouTubeData(
//         influencerId: influencerId,
//         accessToken: data['accessToken'] ?? '',
//         channelId: channelId,
//         channelName: channelName,
//         channelThumbnail: channelThumbnail,
//         subscribers: subscribers,
//         description: description,
//       );

//       influencer = influencer?.copyWith(
//         youtubeToken: data['accessToken'],
//         youtubeChannelId: channelId,
//         youtubeChannelName: channelName,
//         youtubeChannelThumbnail: channelThumbnail,
//         youtubeSubscribers: subscribers,
//         youtubeDescription: description,
//       );

//       notifyListeners();
//       debugPrint("✅ YouTube connected & data synced successfully.");
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
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/audience_model.dart';
import '../models/influencer_model.dart';
import '../services/influencer_service.dart';
import '../services/youtube_service.dart';

class InfluencerProvider with ChangeNotifier {
  final _service = InfluencerService();
  final _youtubeService = YouTubeService();

  InfluencerModel? influencer;
  List<Map<String, dynamic>> portfolio = [];
  List<Map<String, dynamic>> offers = [];
  List<Map<String, dynamic>> earnings = [];

  bool loading = false;
  AudienceModel? _audience;
  AudienceModel? get audience => _audience;

  // ===============================
  // ✅ Influencer Profile Methods
  // ===============================
  Future<void> fetchInfluencer(String id) async {
    try {
      loading = true;
      notifyListeners();

      influencer = await _service.fetchInfluencer(id);

      if (influencer != null) {
        await initAudienceFromOnboarding(influencer!.id);
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
    try {
      loading = true;
      notifyListeners();

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
      }
      debugPrint("✅ Onboarding marked as complete for $influencerId");
      notifyListeners();
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
    _audience = null;
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
      earnings = await _service.fetchEarnings(id);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error fetching earnings: $e");
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
      await _service.addOffer(
        influencerId: influencerId,
        brandName: brandName,
        campaignName: campaignName,
        description: description,
        budget: budget,
      );
      await fetchOffers(influencerId);
      debugPrint("✅ Offer added and refreshed");
    } catch (e) {
      debugPrint("❌ Error adding offer: $e");
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
  // ✅ Audience Analytics
  // ===============================
  Future<void> generateMockAudience(String influencerId, int totalFollowers) async {
    final data = AudienceModel(
      genderMale: (totalFollowers * 0.5).toInt(),
      genderFemale: (totalFollowers * 0.4).toInt(),
      genderOther: (totalFollowers * 0.1).toInt(),
      age18_24: (totalFollowers * 0.4).toInt(),
      age25_34: (totalFollowers * 0.35).toInt(),
      age35Plus: (totalFollowers * 0.25).toInt(),
      countryTop: ['USA', 'UK', 'Canada'],
    );

    await _service.upsertAudience(influencerId, data);
    _audience = data;
    notifyListeners();
  }

  Future<void> fetchAudience(String influencerId) async {
    try {
      _audience = await _service.fetchAudience(influencerId);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error fetching audience: $e");
    }
  }

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
      if (influencer != null) influencer = influencer!.copyWith(instagramToken: token);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error connecting Instagram: $e");
    }
  }

  Future<void> connectTikTok(String influencerId, String token) async {
    try {
      await _service.updateSocialTokens(influencerId: influencerId, tiktokToken: token);
      if (influencer != null) influencer = influencer!.copyWith(tiktokToken: token);
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

    try {
      loading = true;
      notifyListeners();

      debugPrint("🎬 Connecting YouTube...");

      final data = await _youtubeService.connectYouTube();
      if (data == null) {
        debugPrint("❌ YouTube connection failed or cancelled.");
        return;
      }

      final updatedInfluencer = influencer!.copyWith(
        youtubeToken: data['accessToken'],
        youtubeChannelId: data['channelId'] ?? '',
        youtubeChannelName: data['title'] ?? '',
        youtubeChannelThumbnail: data['thumbnail'] ?? '',
        youtubeSubscribers: int.tryParse(data['subscriberCount']?.toString() ?? '0') ?? 0,
        youtubeDescription: data['description'] ?? '',
      );

      // ✅ Save all YouTube data to Supabase
      await _service.updateYouTubeData(
        influencerId: updatedInfluencer.id,
        accessToken: updatedInfluencer.youtubeToken ?? '',
        channelId: updatedInfluencer.youtubeChannelId ?? '',
        channelName: updatedInfluencer.youtubeChannelName ?? '',
        channelThumbnail: updatedInfluencer.youtubeChannelThumbnail ?? '',
        subscribers: updatedInfluencer.youtubeSubscribers ?? 0,
        description: updatedInfluencer.youtubeDescription ?? '',
      );

      // ✅ Update local provider state
      influencer = updatedInfluencer;
      notifyListeners();

      debugPrint("✅ YouTube connected & influencer updated successfully.");
    } catch (e) {
      debugPrint("❌ Error connecting YouTube: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshYouTubeToken() async {
    if (influencer?.youtubeToken == null) return;
    try {
      final newToken = await _youtubeService.refreshToken(influencer!.youtubeToken!);
      if (newToken != null) {
        influencer = influencer!.copyWith(youtubeToken: newToken);
        await _service.updateSocialTokens(
          influencerId: influencer!.id,
          youtubeToken: newToken,
        );
        notifyListeners();
        debugPrint("🔄 YouTube token refreshed.");
      }
    } catch (e) {
      debugPrint("❌ Error refreshing YouTube token: $e");
    }
  }
}
