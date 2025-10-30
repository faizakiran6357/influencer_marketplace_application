
// import 'package:flutter/material.dart';
// import '../services/influencer_service.dart';
// import '../models/influencer_model.dart';

// class InfluencerProvider with ChangeNotifier {
//   final _service = InfluencerService();

//   InfluencerModel? influencer;
//   List<Map<String, dynamic>> portfolio = [];
//   List<Map<String, dynamic>> offers = [];
//   List<Map<String, dynamic>> earnings = [];

//   bool loading = false;

//   // ✅ Fetch influencer profile
//   Future<void> fetchInfluencer(String id) async {
//     try {
//       loading = true;
//       notifyListeners();
//       influencer = await _service.fetchInfluencer(id);
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   // ✅ Fetch portfolio items
//   Future<void> fetchPortfolio(String id) async {
//     portfolio = await _service.fetchPortfolio(id);
//     notifyListeners();
//   }

//   // ✅ Fetch offers (collaborations)
//   Future<void> fetchOffers(String id) async {
//     offers = await _service.fetchOffers(id);
//     notifyListeners();
//   }

//   // ✅ Fetch earnings (transactions / payments)
//   Future<void> fetchEarnings(String id) async {
//     earnings = await _service.fetchEarnings(id);
//     notifyListeners();
//   }

//   // ✅ Add new offer
//   Future<void> addOffer({
//     required String influencerId,
//     required String brandName,
//     required String campaignName,
//     required String description,
//     required double budget,
//   }) async {
//     await _service.addOffer(
//       influencerId: influencerId,
//       brandName: brandName,
//       campaignName: campaignName,
//       description: description,
//       budget: budget,
//     );
//     await fetchOffers(influencerId);
//   }

//   // ✅ Add new earning
//   Future<void> addEarning({
//     required String influencerId,
//     required double amount,
//     required String description,
//   }) async {
//     await _service.addEarning(
//       influencerId: influencerId,
//       amount: amount,
//       description: description,
//     );
//     await fetchEarnings(influencerId);
//   }

//   // ✅ Reset provider state (optional, for logout)
//   void clear() {
//     influencer = null;
//     portfolio.clear();
//     offers.clear();
//     earnings.clear();
//     notifyListeners();
//   }
// }
// correct code above//
// import 'package:flutter/material.dart';
// import '../services/influencer_service.dart';
// import '../models/influencer_model.dart';

// class InfluencerProvider with ChangeNotifier {
//   final _service = InfluencerService();

//   InfluencerModel? influencer;
//   List<Map<String, dynamic>> portfolio = [];
//   List<Map<String, dynamic>> offers = [];
//   List<Map<String, dynamic>> earnings = [];

//   bool loading = false;

//   // ✅ Fetch influencer profile
//   Future<void> fetchInfluencer(String id) async {
//     try {
//       loading = true;
//       notifyListeners();
//       influencer = await _service.fetchInfluencer(id);
//     } catch (e) {
//       debugPrint("❌ Error fetching influencer: $e");
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

//   // ✅ Fetch portfolio items
//   Future<void> fetchPortfolio(String id) async {
//     try {
//       portfolio = await _service.fetchPortfolio(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching portfolio: $e");
//     }
//   }

//   // ✅ Fetch offers (collaborations)
//   Future<void> fetchOffers(String id) async {
//     try {
//       offers = await _service.fetchOffers(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching offers: $e");
//     }
//   }

//   // ✅ Fetch earnings (transactions / payments)
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

//   // ✅ Reset provider state (optional, for logout)
//   void clear() {
//     influencer = null;
//     portfolio.clear();
//     offers.clear();
//     earnings.clear();
//     notifyListeners();
//   }
//   // ✅ Update influencer profile (used in onboarding wizard)
// Future<void> updateInfluencer(InfluencerModel model) async {
//   try {
//     await _service.upsertInfluencer(model);
//     influencer = model;
//     notifyListeners();
//   } catch (e) {
//     debugPrint("❌ Error updating influencer: $e");
//   }
// }

// }
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import '../services/influencer_service.dart';
// import '../models/influencer_model.dart';

// class InfluencerProvider with ChangeNotifier {
//   final _service = InfluencerService();

//   InfluencerModel? influencer;
//   List<Map<String, dynamic>> portfolio = [];
//   List<Map<String, dynamic>> offers = [];
//   List<Map<String, dynamic>> earnings = [];

//   bool loading = false;

//   // ✅ Fetch influencer profile safely
//   Future<void> fetchInfluencer(String id) async {
//     try {
//       loading = true;
//       notifyListeners();

//       // fetch raw map from service
//       final data = await _service.fetchInfluencer(id);
//       if (data != null) {
//         // parse to model safely
//         influencer = InfluencerModel.fromMap(data.toMap());
//       } else {
//         influencer = null;
//       }
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

//   // ✅ Fetch portfolio items
//   Future<void> fetchPortfolio(String id) async {
//     try {
//       portfolio = await _service.fetchPortfolio(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching portfolio: $e");
//     }
//   }

//   // ✅ Fetch offers (collaborations)
//   Future<void> fetchOffers(String id) async {
//     try {
//       offers = await _service.fetchOffers(id);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error fetching offers: $e");
//     }
//   }

//   // ✅ Fetch earnings (transactions / payments)
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

//   // ✅ Reset provider state (optional, for logout)
//   void clear() {
//     influencer = null;
//     portfolio.clear();
//     offers.clear();
//     earnings.clear();
//     notifyListeners();
//   }

//   // ✅ Update influencer profile (used in onboarding wizard)
//   Future<void> updateInfluencer(InfluencerModel model) async {
//     try {
//       await _service.upsertInfluencer(model);
//       influencer = model;
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error updating influencer: $e");
//     }
//   }
//   // Add this inside InfluencerProvider class

// // ✅ Upload profile image and update influencer model
// Future<void> uploadProfileImage(String influencerId, Uint8List bytes) async {
//   try {
//     final imageUrl = await _service.uploadProfileImage(influencerId, bytes);
//     if (imageUrl != null && influencer != null) {
//       influencer = influencer!.copyWith(profileImage: imageUrl);
//       notifyListeners();
//     }
//   } catch (e) {
//     debugPrint("❌ Error in uploadProfileImage: $e");
//   }
// }

// }
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

//   // ✅ Fetch influencer profile safely
//   Future<void> fetchInfluencer(String id) async {
//     try {
//       loading = true;
//       notifyListeners();

//       final data = await _service.fetchInfluencer(id);
//       influencer = data;
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
//   Future<void> generateMockAudience(String influencerId, int totalFollowers) async {
//   final data = AudienceModel(
//     genderMale: (totalFollowers * 0.5).toInt(),
//     genderFemale: (totalFollowers * 0.4).toInt(),
//     genderOther: (totalFollowers * 0.1).toInt(),
//     age18_24: (totalFollowers * 0.4).toInt(),
//     age25_34: (totalFollowers * 0.35).toInt(),
//     age35Plus: (totalFollowers * 0.25).toInt(),
//     countryTop: ['USA', 'UK', 'Canada'],
//   );

//   // Save to Supabase
//   await _service.upsertAudience(influencerId, data);

//   _audience = data; // Store in provider
//   notifyListeners();
// }

// AudienceModel? _audience;
// AudienceModel? get audience => _audience;


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
//     notifyListeners();
//   }

//   // ✅ Update influencer profile
//   Future<void> updateInfluencer(InfluencerModel model) async {
//     try {
//       await _service.upsertInfluencer(model);
//       influencer = model;
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ Error updating influencer: $e");
//     }
//   }

//  // ✅ Upload profile image and return its URL
// Future<String?> uploadProfileImage(String influencerId, Uint8List bytes) async {
//   try {
//     final imageUrl = await _service.uploadProfileImage(influencerId, bytes);
//     if (imageUrl != null && influencer != null) {
//       influencer = influencer!.copyWith(profileImage: imageUrl);
//       notifyListeners();
//     }
//     return imageUrl; // <-- Return the URL here
//   } catch (e) {
//     debugPrint("❌ Error in uploadProfileImage: $e");
//     return null;
//   }
// }

// }
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/models/audience_model.dart';
import '../services/influencer_service.dart';
import '../models/influencer_model.dart';

class InfluencerProvider with ChangeNotifier {
  final _service = InfluencerService();

  InfluencerModel? influencer;
  List<Map<String, dynamic>> portfolio = [];
  List<Map<String, dynamic>> offers = [];
  List<Map<String, dynamic>> earnings = [];

  bool loading = false;

  AudienceModel? _audience;
  AudienceModel? get audience => _audience;

  // ✅ Fetch influencer profile safely
  Future<void> fetchInfluencer(String id) async {
    try {
      loading = true;
      notifyListeners();

      final data = await _service.fetchInfluencer(id);
      influencer = data;

      // Automatically initialize audience from onboarding data
      await initAudienceFromOnboarding(id);
    } catch (e) {
      debugPrint("❌ Error fetching influencer: $e");
      influencer = null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ✅ Save or update influencer profile
  Future<void> saveInfluencerProfile(InfluencerModel model) async {
    try {
      loading = true;
      notifyListeners();

      await _service.upsertInfluencer(model);
      influencer = model;

      debugPrint("✅ Influencer profile updated successfully");

      // Update audience if followers count changes
      if (influencer != null) {
        await initAudienceFromOnboarding(influencer!.id!);
      }
    } catch (e) {
      debugPrint("❌ Error saving influencer profile: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ✅ Mark onboarding as complete
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

  // ✅ Generate mock audience (can still use manually)
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

    // Save to Supabase
    await _service.upsertAudience(influencerId, data);

    _audience = data; // Store in provider
    notifyListeners();
  }

  // ✅ Initialize audience automatically from influencer onboarding data
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

    // Save to Supabase
    await _service.upsertAudience(influencerId, data);
  }

  // ✅ Fetch portfolio items
  Future<void> fetchPortfolio(String id) async {
    try {
      portfolio = await _service.fetchPortfolio(id);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error fetching portfolio: $e");
    }
  }

  // ✅ Fetch offers
  Future<void> fetchOffers(String id) async {
    try {
      offers = await _service.fetchOffers(id);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error fetching offers: $e");
    }
  }

  // ✅ Fetch earnings
  Future<void> fetchEarnings(String id) async {
    try {
      earnings = await _service.fetchEarnings(id);
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error fetching earnings: $e");
    }
  }

  // ✅ Add new offer
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

  // ✅ Add new earning
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

  // ✅ Reset provider state
  void clear() {
    influencer = null;
    portfolio.clear();
    offers.clear();
    earnings.clear();
    _audience = null;
    notifyListeners();
  }

  // ✅ Update influencer profile
  Future<void> updateInfluencer(InfluencerModel model) async {
    try {
      await _service.upsertInfluencer(model);
      influencer = model;
      notifyListeners();

      // Update audience if followers count changes
      if (influencer != null) {
        await initAudienceFromOnboarding(influencer!.id!);
      }
    } catch (e) {
      debugPrint("❌ Error updating influencer: $e");
    }
  }

  // ✅ Upload profile image and return its URL
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
}
