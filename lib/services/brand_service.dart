

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/brand_model.dart';
import '../models/campaign_model.dart';

class BrandService {
  final _client = Supabase.instance.client;

  /// ✅ Fetch brand data from `profiles` table by userId
  Future<BrandModel?> fetchBrandByUserId(String userId) async {
    try {
      final res = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (res == null) {
        print("⚠️ No brand profile found for userId: $userId");
        return null;
      }

      if (res['role']?.toString().toLowerCase() != 'brand') {
        print("⚠️ User is not a brand: ${res['role']}");
        return null;
      }

      return BrandModel.fromMap(res);
    } catch (e) {
      print("❌ fetchBrandByUserId error: $e");
      return null;
    }
  }

  /// ✅ Update brand profile details in `profiles` table
  Future<void> updateBrand(BrandModel brand) async {
    try {
      await _client
          .from('profiles')
          .update(brand.toMap())
          .eq('id', brand.id);
      print("✅ Brand profile updated successfully");
    } catch (e) {
      print("❌ updateBrand error: $e");
    }
  }

  /// ✅ Upload brand profile image to Supabase Storage & update profile
  Future<String?> uploadProfileImage(String brandId, File imageFile) async {
    const bucketName = 'profile_images'; // Ensure this bucket exists
    try {
      final fileBytes = await imageFile.readAsBytes();
      final filePath =
          'brands/$brandId-${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload image
      await _client.storage.from(bucketName).uploadBinary(
            filePath,
            fileBytes,
            fileOptions: const FileOptions(upsert: true),
          );

      // Generate public URL
      final publicUrl =
          _client.storage.from(bucketName).getPublicUrl(filePath);

      // Update `profiles` table with new image URL
      await _client.from('profiles').update({
        'profile_image': publicUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', brandId);

      print("✅ Profile image uploaded: $publicUrl");
      return publicUrl;
    } on StorageException catch (e) {
      print("❌ StorageException during upload: ${e.message}");
      return null;
    } catch (e) {
      print("❌ uploadProfileImage error: $e");
      return null;
    }
  }

  /// ✅ Fetch all campaigns created by a brand (brand_id = profiles.id)
  Future<List<CampaignModel>> fetchCampaigns(String brandId) async {
    try {
      final res = await _client
          .from('campaigns')
          .select()
          .eq('brand_id', brandId);

      return List<Map<String, dynamic>>.from(res)
          .map((e) => CampaignModel.fromMap(e))
          .toList();
    } catch (e) {
      print("❌ fetchCampaigns error: $e");
      return [];
    }
  }

  /// ✅ Create a new campaign record
  Future<bool> createCampaign(CampaignModel campaign) async {
    try {
      await _client.from('campaigns').insert(campaign.toMap());
      print("✅ Campaign created successfully");
      return true;
    } catch (e) {
      print("❌ createCampaign error: $e");
      return false;
    }
  }

  /// ✅ Delete a campaign (optional helper)
  Future<bool> deleteCampaign(String campaignId) async {
    try {
      await _client.from('campaigns').delete().eq('id', campaignId);
      print("🗑️ Campaign deleted: $campaignId");
      return true;
    } catch (e) {
      print("❌ deleteCampaign error: $e");
      return false;
    }
  }
}
