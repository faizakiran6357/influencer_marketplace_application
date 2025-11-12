
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
     Future<void> fetchAcceptedCampaigns(String influencerId) async {
    try {
      acceptedCampaigns = await _campaignService.fetchAcceptedCampaignsByInfluencer(influencerId);
      notifyListeners();
      debugPrint("✅ ${acceptedCampaigns.length} accepted campaigns loaded");
    } catch (e) {
      debugPrint("❌ fetchAcceptedCampaigns error: $e");
    }
  }
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
Map<String, String> _brandNames = {}; // brandId -> brandName

/// ✅ Fetch brand names from profiles table (role = 'Brand')
Future<void> fetchBrandNames(List<String> brandIds) async {
  try {
    if (brandIds.isEmpty) return;

    debugPrint("🔍 Fetching brand names for IDs: $brandIds");

    // Fetch brand profiles whose IDs match and role == 'Brand'
    final response = await _supabase
        .from('profiles')
        .select('id, name, role')
        .inFilter('id', brandIds) // ✅ Correct method name
        .eq('role', 'Brand'); // ✅ Capital B (matches your DB)

    final data = List<Map<String, dynamic>>.from(response);

    debugPrint("📦 Brand data received: $data");

    for (var brand in data) {
      final id = brand['id'] as String?;
      final name = brand['name'] as String?;
      if (id != null && name != null) {
        _brandNames[id] = name;
      }
    }

    notifyListeners();
    debugPrint("✅ Brand names fetched: ${_brandNames.length}");
  } catch (e, st) {
    debugPrint("❌ Error fetching brand names: $e\n$st");
  }
}

/// ✅ Get brand name by brand ID
String? getBrandNameById(String? brandId) {
  if (brandId == null) return null;
  return _brandNames[brandId];
}
   // ===============================
  // ✅ Computed Getter: Total Earnings
  // ===============================
  double get totalEarnings {
    try {
      if (earnings.isEmpty) return 0.0;
      double total = 0.0;
      for (final e in earnings) {
        final amount = e['amount'];
        if (amount is num) total += amount.toDouble();
      }
      return total;
    } catch (e) {
      debugPrint("❌ Error calculating total earnings: $e");
      return 0.0;
    }
  }

}
