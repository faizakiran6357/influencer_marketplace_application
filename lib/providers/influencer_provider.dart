// import 'package:flutter/material.dart';
// import '../services/influencer_service.dart';
// import '../models/influencer_model.dart';

// class InfluencerProvider with ChangeNotifier {
//   final _service = InfluencerService();

//   InfluencerModel? influencer;
//   List<Map<String, dynamic>> portfolio = [];
//   List<Map<String, dynamic>> offers = [];
//   List<Map<String, dynamic>> transactions = [];

//   bool loading = false;

//   Future<void> fetchInfluencer(String id) async {
//     loading = true;
//     notifyListeners();
//     influencer = await _service.fetchInfluencer(id);
//     loading = false;
//     notifyListeners();
//   }

//   Future<void> fetchPortfolio(String id) async {
//     portfolio = await _service.fetchPortfolio(id);
//     notifyListeners();
//   }

//   Future<void> fetchOffers(String id) async {
//     offers = await _service.fetchOffers(id);
//     notifyListeners();
//   }

//   Future<void> fetchTransactions(String id) async {
//     transactions = await _service.fetchTransactions(id);
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import '../services/influencer_service.dart';
import '../models/influencer_model.dart';

class InfluencerProvider with ChangeNotifier {
  final _service = InfluencerService();

  InfluencerModel? influencer;
  List<Map<String, dynamic>> portfolio = [];
  List<Map<String, dynamic>> offers = [];
  List<Map<String, dynamic>> earnings = [];

  bool loading = false;

  // ✅ Fetch influencer profile
  Future<void> fetchInfluencer(String id) async {
    try {
      loading = true;
      notifyListeners();
      influencer = await _service.fetchInfluencer(id);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ✅ Fetch portfolio items
  Future<void> fetchPortfolio(String id) async {
    portfolio = await _service.fetchPortfolio(id);
    notifyListeners();
  }

  // ✅ Fetch offers (collaborations)
  Future<void> fetchOffers(String id) async {
    offers = await _service.fetchOffers(id);
    notifyListeners();
  }

  // ✅ Fetch earnings (transactions / payments)
  Future<void> fetchEarnings(String id) async {
    earnings = await _service.fetchEarnings(id);
    notifyListeners();
  }

  // ✅ Add new offer
  Future<void> addOffer({
    required String influencerId,
    required String brandName,
    required String campaignName,
    required String description,
    required double budget,
  }) async {
    await _service.addOffer(
      influencerId: influencerId,
      brandName: brandName,
      campaignName: campaignName,
      description: description,
      budget: budget,
    );
    await fetchOffers(influencerId);
  }

  // ✅ Add new earning
  Future<void> addEarning({
    required String influencerId,
    required double amount,
    required String description,
  }) async {
    await _service.addEarning(
      influencerId: influencerId,
      amount: amount,
      description: description,
    );
    await fetchEarnings(influencerId);
  }

  // ✅ Reset provider state (optional, for logout)
  void clear() {
    influencer = null;
    portfolio.clear();
    offers.clear();
    earnings.clear();
    notifyListeners();
  }
}
