
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

  /// ✅ When influencer accepts a campaign offer → add record + update statuses
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
        'created_at': DateTime.now().toIso8601String(),
      });

      // 3️⃣ Update campaign status → in_progress
      await _client
          .from('campaigns')
          .update({
            'status': 'in_progress',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', campaignId);

      print("✅ Influencer accepted campaign: $campaignId");
    } catch (e) {
      print("❌ acceptCampaignOffer error: $e");
    }
  }

  /// ✅ Mark campaign as completed (updates both tables + earnings + notification)
  Future<void> completeCampaign({
    required String campaignId,
    required String influencerId,
  }) async {
    try {
      // 1️⃣ Update both tables to "completed"
      await _client
          .from('campaigns')
          .update({
            'status': 'completed',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', campaignId);

      await _client
          .from('campaign_influencers')
          .update({
            'status': 'completed',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('campaign_id', campaignId)
          .eq('influencer_id', influencerId);

      // 2️⃣ Fetch campaign for amount
      final campaign = await _client
          .from('campaigns')
          .select('name, budget')
          .eq('id', campaignId)
          .maybeSingle();

      if (campaign != null) {
        final double amount = (campaign['budget'] ?? 0).toDouble();

        // 3️⃣ Add earning record
        await _client.from('earnings').insert({
          'influencer_id': influencerId,
          'amount': amount,
          'description':
              'Earning for completed campaign: ${campaign['name']}',
          'created_at': DateTime.now().toIso8601String(),
        });

        print("💰 Earning added for influencer $influencerId: $amount");
      }

      // 4️⃣ Add notification
      await _client.from('notifications').insert({
        'influencer_id': influencerId,
        'campaign_id': campaignId,
        'message': 'Campaign completed successfully!',
        'created_at': DateTime.now().toIso8601String(),
      });

      print("🎉 Campaign completed successfully: $campaignId");
    } catch (e) {
      print("❌ completeCampaign error: $e");
    }
  }

  /// ✅ Fetch campaigns accepted by influencer
  Future<List<Map<String, dynamic>>> fetchAcceptedCampaignsByInfluencer(
      String influencerId) async {
    try {
      final response = await _client
          .from('campaign_influencers')
          .select('*, campaigns!fk_campaign_influencer_campaign(*)')
          .eq('influencer_id', influencerId)
          .neq('status', 'pending');

      final data = List<Map<String, dynamic>>.from(response);

      for (var campaign in data) {
        final campaignData = campaign['campaigns'];
        if (campaignData != null && campaignData['brand_id'] != null) {
          final brandResponse = await _client
              .from('profiles')
              .select('id, name, profile_image')
              .eq('id', campaignData['brand_id'])
              .maybeSingle();

          campaign['brand_name'] = brandResponse?['name'] ?? 'Unknown';
          campaign['brand_image'] = brandResponse?['profile_image'];
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

