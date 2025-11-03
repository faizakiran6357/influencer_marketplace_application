// import 'package:flutter/material.dart';
// import '../models/brand_model.dart';
// import '../models/campaign_model.dart';
// import '../services/brand_service.dart';

// class BrandProvider with ChangeNotifier {
//   final _service = BrandService();

//   BrandModel? brand;
//   List<CampaignModel> campaigns = [];
//   bool loading = false;

//   Future<void> fetchBrand(String userId) async {
//     loading = true;
//     notifyListeners();
//     brand = await _service.fetchBrandByUserId(userId);
//     loading = false;
//     notifyListeners();
//   }

//   Future<void> updateBrand(BrandModel updatedBrand) async {
//     await _service.updateBrand(updatedBrand);
//     brand = updatedBrand;
//     notifyListeners();
//   }

//   Future<void> fetchCampaigns(String brandId) async {
//     campaigns = await _service.fetchCampaigns(brandId);
//     notifyListeners();
//   }

//   Future<void> createCampaign(CampaignModel campaign) async {
//     await _service.createCampaign(campaign);
//     await fetchCampaigns(campaign.brandId);
//   }
// }
// import 'package:flutter/material.dart';
// import '../models/brand_model.dart';
// import '../models/campaign_model.dart';
// import '../services/brand_service.dart';

// class BrandProvider with ChangeNotifier {
//   final _service = BrandService();

//   BrandModel? brand;
//   List<CampaignModel> campaigns = [];
//   bool loading = false;

//   /// ✅ Fetch brand profile safely
//   Future<void> fetchBrand(String userId) async {
//     loading = true;
//     notifyListeners();

//     try {
//       brand = await _service.fetchBrandByUserId(userId);
//       if (brand == null) {
//         print("⚠️ No brand found for userId: $userId");
//       }
//     } catch (e) {
//       print("❌ fetchBrand error: $e");
//     }

//     loading = false;
//     notifyListeners();
//   }

//   /// ✅ Update brand info
//   Future<void> updateBrand(BrandModel updatedBrand) async {
//     try {
//       await _service.updateBrand(updatedBrand);
//       brand = updatedBrand;
//       notifyListeners();
//     } catch (e) {
//       print("❌ updateBrand error: $e");
//     }
//   }

//   /// ✅ Fetch campaigns
//   Future<void> fetchCampaigns(String brandId) async {
//     try {
//       campaigns = await _service.fetchCampaigns(brandId);
//       notifyListeners();
//     } catch (e) {
//       print("❌ fetchCampaigns error: $e");
//     }
//   }

//   /// ✅ Create a new campaign
//   Future<void> createCampaign(CampaignModel campaign) async {
//     try {
//       await _service.createCampaign(campaign);
//       await fetchCampaigns(campaign.brandId);
//     } catch (e) {
//       print("❌ createCampaign error: $e");
//     }
//   }
// }
// lib/providers/brand_provider.dart

// import 'dart:io';
// import 'package:flutter/material.dart';
// import '../models/brand_model.dart';
// import '../models/campaign_model.dart';
// import '../services/brand_service.dart';

// class BrandProvider with ChangeNotifier {
//   final _service = BrandService();

//   BrandModel? brand;
//   List<CampaignModel> campaigns = [];
//   bool loading = false;

//   // Fetch brand by profile id (profiles.id)
//   Future<void> fetchBrand(String userId) async {
//     loading = true;
//     notifyListeners();

//     try {
//       brand = await _service.fetchBrandByUserId(userId);
//     } catch (e) {
//       debugPrint("❌ fetchBrand error: $e");
//       brand = null;
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   // Update brand record in Supabase and local cache
//   Future<void> updateBrand(BrandModel updatedBrand) async {
//     try {
//       await _service.updateBrand(updatedBrand);
//       brand = updatedBrand;
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ updateBrand error: $e");
//     }
//   }

//   // Upload a profile image file to Supabase storage and update the brand.profileImage
//   // Returns the public URL or null on error
//   Future<String?> uploadProfileImage(String brandId, File imageFile) async {
//     try {
//       // Call service to upload file to storage and get public URL
//       final newUrl = await _service.uploadProfileImage(brandId, imageFile);

//       if (newUrl != null) {
//         // Update local model and Supabase record
//         if (brand != null && brand!.id == brandId) {
//           brand = brand!.copyWith(profileImage: newUrl);
//         }
//         // Persist to DB
//         await _service.updateBrand(brand!);
//         notifyListeners();
//       }

//       return newUrl;
//     } catch (e) {
//       debugPrint("❌ uploadProfileImage error: $e");
//       return null;
//     }
//   }

//   // Fetch campaigns for a brand (brandId is profile.id)
//   Future<void> fetchCampaigns(String brandId) async {
//     try {
//       campaigns = await _service.fetchCampaigns(brandId);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ fetchCampaigns error: $e");
//       campaigns = [];
//       notifyListeners();
//     }
//   }

//   // Create campaign and refresh list
//   Future<void> createCampaign(CampaignModel campaign) async {
//     try {
//       await _service.createCampaign(campaign);
//       await fetchCampaigns(campaign.brandId);
//     } catch (e) {
//       debugPrint("❌ createCampaign error: $e");
//     }
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/brand_model.dart';
// import '../models/campaign_model.dart';
// import '../services/brand_service.dart';

// class BrandProvider with ChangeNotifier {
//   final _service = BrandService();
//   final _client = Supabase.instance.client;

//   BrandModel? brand;
//   List<CampaignModel> campaigns = [];
//   bool loading = false;

//   // Fetch brand by profile id (profiles.id)
//   Future<void> fetchBrand(String userId) async {
//     loading = true;
//     notifyListeners();

//     try {
//       brand = await _service.fetchBrandByUserId(userId);
//     } catch (e) {
//       debugPrint("❌ fetchBrand error: $e");
//       brand = null;
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   // Update brand record in Supabase and local cache
//   Future<void> updateBrand(BrandModel updatedBrand) async {
//     try {
//       await _service.updateBrand(updatedBrand);
//       brand = updatedBrand;
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ updateBrand error: $e");
//     }
//   }

//   // ✅ Upload a profile image file to Supabase storage and update profile table
//   Future<String?> uploadProfileImage(String brandId, File imageFile) async {
//     const bucketName = 'profile_images'; // must match your Supabase bucket name exactly
//     try {
//       final fileBytes = await imageFile.readAsBytes();
//       final path = 'brands/$brandId-${DateTime.now().millisecondsSinceEpoch}.jpg';

//       // Upload file to storage
//       await _client.storage.from(bucketName).uploadBinary(
//             path,
//             fileBytes,
//             fileOptions: const FileOptions(upsert: true),
//           );

//       // Get public URL
//       final imageUrl = _client.storage.from(bucketName).getPublicUrl(path);

//       // Update the 'profiles' table
//       await _client.from('profiles').update({
//         'profile_image': imageUrl,
//         'updated_at': DateTime.now().toIso8601String(),
//       }).eq('id', brandId);

//       // Update local model
//       if (brand != null && brand!.id == brandId) {
//         brand = brand!.copyWith(profileImage: imageUrl);
//       }

//       notifyListeners();
//       debugPrint("✅ Brand profile image updated: $imageUrl");
//       return imageUrl;
//     } on StorageException catch (e) {
//       debugPrint("❌ StorageException: ${e.message}");
//       return null;
//     } catch (e) {
//       debugPrint("❌ uploadProfileImage error: $e");
//       return null;
//     }
//   }

//   // Fetch campaigns for a brand (brandId is profile.id)
//   Future<void> fetchCampaigns(String brandId) async {
//     try {
//       campaigns = await _service.fetchCampaigns(brandId);
//       notifyListeners();
//     } catch (e) {
//       debugPrint("❌ fetchCampaigns error: $e");
//       campaigns = [];
//       notifyListeners();
//     }
//   }

//   // Create campaign and refresh list
//   Future<void> createCampaign(CampaignModel campaign) async {
//     try {
//       await _service.createCampaign(campaign);
//       await fetchCampaigns(campaign.brandId);
//     } catch (e) {
//       debugPrint("❌ createCampaign error: $e");
//     }
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/brand_model.dart';
// import '../models/campaign_model.dart';
// import '../services/brand_service.dart';

// class BrandProvider with ChangeNotifier {
//   final _service = BrandService();
//   final _client = Supabase.instance.client;

//   BrandModel? brand;
//   List<CampaignModel> campaigns = [];
//   bool loading = false;

//   /// ✅ Fetch brand data from `profiles` table using user id
//   Future<void> fetchBrand(String userId) async {
//     loading = true;
//     notifyListeners();

//     try {
//       brand = await _service.fetchBrandByUserId(userId);
//       debugPrint("✅ Brand data loaded for $userId");
//     } catch (e) {
//       debugPrint("❌ fetchBrand error: $e");
//       brand = null;
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   /// ✅ Update brand info in Supabase and local cache
//   Future<void> updateBrand(BrandModel updatedBrand) async {
//     try {
//       await _service.updateBrand(updatedBrand);
//       brand = updatedBrand;
//       notifyListeners();
//       debugPrint("✅ Brand profile updated successfully");
//     } catch (e) {
//       debugPrint("❌ updateBrand error: $e");
//     }
//   }

//   /// ✅ Upload brand profile image to Supabase Storage
//   Future<String?> uploadProfileImage(String brandId, File imageFile) async {
//     const bucketName = 'profile_images'; // ensure exact match with Supabase bucket name
//     try {
//       final fileBytes = await imageFile.readAsBytes();
//       final filePath =
//           'brands/$brandId-${DateTime.now().millisecondsSinceEpoch}.jpg';

//       // Upload to Supabase Storage
//       await _client.storage.from(bucketName).uploadBinary(
//             filePath,
//             fileBytes,
//             fileOptions: const FileOptions(upsert: true),
//           );

//       // Get public URL
//       final publicUrl = _client.storage.from(bucketName).getPublicUrl(filePath);

//       // Update brand record in `profiles`
//       await _client.from('profiles').update({
//         'profile_image': publicUrl,
//         'updated_at': DateTime.now().toIso8601String(),
//       }).eq('id', brandId);

//       // Update local model
//       if (brand != null && brand!.id == brandId) {
//         brand = brand!.copyWith(profileImage: publicUrl);
//         notifyListeners();
//       }

//       debugPrint("✅ Brand profile image updated: $publicUrl");
//       return publicUrl;
//     } on StorageException catch (e) {
//       debugPrint("❌ StorageException during image upload: ${e.message}");
//       return null;
//     } catch (e) {
//       debugPrint("❌ uploadProfileImage error: $e");
//       return null;
//     }
//   }

//   /// ✅ Fetch all campaigns created by this brand
//   Future<void> fetchCampaigns(String brandId) async {
//     try {
//       campaigns = await _service.fetchCampaigns(brandId);
//       debugPrint("✅ ${campaigns.length} campaigns fetched for brand $brandId");
//     } catch (e) {
//       debugPrint("❌ fetchCampaigns error: $e");
//       campaigns = [];
//     } finally {
//       notifyListeners();
//     }
//   }

//   /// ✅ Create a new campaign for this brand
//   Future<void> createCampaign(CampaignModel campaign) async {
//     try {
//       await _service.createCampaign(campaign);
//       debugPrint("✅ Campaign created successfully");
//       await fetchCampaigns(campaign.brandId); // refresh list after creation
//     } catch (e) {
//       debugPrint("❌ createCampaign error: $e");
//     }
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/services/compaign_service.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/brand_model.dart';
// import '../models/campaign_model.dart';
// import '../services/brand_service.dart';

// class BrandProvider with ChangeNotifier {
//   final _brandService = BrandService();
//   final _campaignService = CampaignService();
//   final _client = Supabase.instance.client;

//   BrandModel? brand;
//   List<CampaignModel> campaigns = [];
//   bool loading = false;

//   // ✅ Fetch brand data from profiles table
//   Future<void> fetchBrand(String userId) async {
//     loading = true;
//     notifyListeners();

//     try {
//       brand = await _brandService.fetchBrandByUserId(userId);
//       debugPrint("✅ Brand data loaded for $userId");
//     } catch (e) {
//       debugPrint("❌ fetchBrand error: $e");
//       brand = null;
//     } finally {
//       loading = false;
//       notifyListeners();
//     }
//   }

//   // ✅ Update brand profile info
//   Future<void> updateBrand(BrandModel updatedBrand) async {
//     try {
//       await _brandService.updateBrand(updatedBrand);
//       brand = updatedBrand;
//       notifyListeners();
//       debugPrint("✅ Brand profile updated successfully");
//     } catch (e) {
//       debugPrint("❌ updateBrand error: $e");
//     }
//   }

//   // ✅ Upload and update profile image
//   Future<String?> uploadProfileImage(String brandId, File imageFile) async {
//     const bucketName = 'profile_images'; // must match Supabase bucket name
//     try {
//       final fileBytes = await imageFile.readAsBytes();
//       final filePath =
//           'brands/$brandId-${DateTime.now().millisecondsSinceEpoch}.jpg';

//       // Upload to Supabase storage
//       await _client.storage.from(bucketName).uploadBinary(
//             filePath,
//             fileBytes,
//             fileOptions: const FileOptions(upsert: true),
//           );

//       // Generate public URL
//       final publicUrl = _client.storage.from(bucketName).getPublicUrl(filePath);

//       // Update profiles table
//       await _client.from('profiles').update({
//         'profile_image': publicUrl,
//         'updated_at': DateTime.now().toIso8601String(),
//       }).eq('id', brandId);

//       // Update local model
//       if (brand != null && brand!.id == brandId) {
//         brand = brand!.copyWith(profileImage: publicUrl);
//         notifyListeners();
//       }

//       debugPrint("✅ Brand profile image updated: $publicUrl");
//       return publicUrl;
//     } on StorageException catch (e) {
//       debugPrint("❌ StorageException: ${e.message}");
//       return null;
//     } catch (e) {
//       debugPrint("❌ uploadProfileImage error: $e");
//       return null;
//     }
//   }

//   // ✅ Fetch all campaigns for this brand
//   Future<void> fetchCampaigns(String brandId) async {
//     try {
//       campaigns = await _campaignService.fetchCampaignsByBrand(brandId);
//       debugPrint("✅ ${campaigns.length} campaigns fetched for brand $brandId");
//     } catch (e) {
//       debugPrint("❌ fetchCampaigns error: $e");
//       campaigns = [];
//     } finally {
//       notifyListeners();
//     }
//   }

//   // ✅ Create a new campaign
//   Future<void> createCampaign(CampaignModel campaign) async {
//     try {
//       await _campaignService.createCampaign(campaign);
//       debugPrint("✅ Campaign created successfully");
//       await fetchCampaigns(campaign.brandId);
//     } catch (e) {
//       debugPrint("❌ createCampaign error: $e");
//     }
//   }

//   // ✅ Analytics helper (calls campaign service)
//   Future<Map<String, double>> getCampaignAnalytics(String brandId) async {
//     try {
//       final stats =
//           await _campaignService.getBrandCampaignAnalytics(brandId);
//       debugPrint("✅ Analytics loaded for brand $brandId: $stats");
//       return stats;
//     } catch (e) {
//       debugPrint("❌ getCampaignAnalytics error: $e");
//       return {'totalBudget': 0, 'totalSpent': 0, 'remaining': 0};
//     }
//   }
  
// }
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
}
