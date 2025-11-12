
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/brand_model.dart';
import '../models/campaign_model.dart';
import '../services/brand_service.dart';
import '../services/compaign_service.dart';

class BrandProvider with ChangeNotifier {
  final _brandService = BrandService();
  final _campaignService = CampaignService();
  final _client = Supabase.instance.client;

  BrandModel? brand;
  List<CampaignModel> campaigns = [];
  bool loading = false;

  /// Fetch brand profile from 'profiles' table
  Future<void> fetchBrand(String userId) async {
    loading = true;
    notifyListeners();

    try {
      brand = await _brandService.fetchBrandByUserId(userId);
      debugPrint("✅ Brand data loaded for $userId");
    } catch (e) {
      debugPrint("❌ fetchBrand error: $e");
      brand = null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Update brand profile
  Future<void> updateBrand(BrandModel updatedBrand) async {
    try {
      await _brandService.updateBrand(updatedBrand);
      brand = updatedBrand;
      notifyListeners();
      debugPrint("✅ Brand profile updated successfully");
    } catch (e) {
      debugPrint("❌ updateBrand error: $e");
    }
  }

  /// Upload profile image to Supabase storage and update profile
  Future<String?> uploadProfileImage(String brandId, File imageFile) async {
    const bucketName = 'profile_images'; // must match bucket name
    try {
      final fileBytes = await imageFile.readAsBytes();
      final filePath =
          'brands/$brandId-${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload binary file
      await _client.storage.from(bucketName).uploadBinary(
            filePath,
            fileBytes,
            fileOptions: const FileOptions(upsert: true),
          );

      final publicUrl = _client.storage.from(bucketName).getPublicUrl(filePath);

      // Update profiles table
      await _client.from('profiles').update({
        'profile_image': publicUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', brandId);

      // Update local model
      if (brand != null && brand!.id == brandId) {
        brand = brand!.copyWith(profileImage: publicUrl);
        notifyListeners();
      }

      debugPrint("✅ Brand profile image updated: $publicUrl");
      return publicUrl;
    } on StorageException catch (e) {
      debugPrint("❌ StorageException: ${e.message}");
      return null;
    } catch (e) {
      debugPrint("❌ uploadProfileImage error: $e");
      return null;
    }
  }

  /// Fetch all campaigns for the brand
  Future<void> fetchCampaigns(String brandId) async {
    try {
      campaigns = await _campaignService.fetchCampaignsByBrand(brandId);
      debugPrint("✅ ${campaigns.length} campaigns fetched for brand $brandId");
    } catch (e) {
      debugPrint("❌ fetchCampaigns error: $e");
      campaigns = [];
    } finally {
      notifyListeners();
    }
  }

  /// Create a new campaign
  Future<void> createCampaign(CampaignModel campaign) async {
    try {
      await _campaignService.createCampaign(campaign);
      debugPrint("✅ Campaign created successfully");
      await fetchCampaigns(campaign.brandId);
    } catch (e) {
      debugPrint("❌ createCampaign error: $e");
    }
  }

  /// Update an existing campaign (so edit works)
  Future<void> updateCampaign(CampaignModel campaign) async {
    try {
      await _campaignService.updateCampaign(campaign);
      debugPrint("✅ Campaign updated successfully");
      await fetchCampaigns(campaign.brandId);
    } catch (e) {
      debugPrint("❌ updateCampaign error: $e");
    }
  }

  /// Analytics helper
  Future<Map<String, double>> getCampaignAnalytics(String brandId) async {
    try {
      final stats = await _campaignService.getBrandCampaignAnalytics(brandId);
      debugPrint("✅ Analytics loaded for brand $brandId: $stats");
      return stats;
    } catch (e) {
      debugPrint("❌ getCampaignAnalytics error: $e");
      return {'totalBudget': 0, 'totalSpent': 0, 'remaining': 0};
    }
  }
  Future<void> deleteCampaign(String campaignId) async {
  try {
    await Supabase.instance.client
        .from('campaigns')
        .delete()
        .eq('id', campaignId);

    campaigns.removeWhere((c) => c.id == campaignId);
    notifyListeners();
  } catch (e) {
    debugPrint('❌ deleteCampaign error: $e');
    rethrow;
  }
}

}
