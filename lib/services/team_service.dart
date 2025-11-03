import 'package:supabase_flutter/supabase_flutter.dart';

class TeamService {
  final _client = Supabase.instance.client;

  /// ✅ Fetch team members for a specific brand
  Future<List<Map<String, dynamic>>> fetchTeamMembers(String brandId) async {
    try {
      final response =
          await _client.from('brand_team').select().eq('brand_id', brandId);
      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      print("❌ fetchTeamMembers error: $e");
      return [];
    }
  }

  /// ✅ Add a new team member
  Future<void> addTeamMember({
    required String brandId,
    required String name,
    required String email,
    required String role,
  }) async {
    try {
      await _client.from('brand_team').insert({
        'brand_id': brandId,
        'name': name,
        'email': email,
        'role': role,
      });
      print("✅ Team member added successfully");
    } catch (e) {
      print("❌ addTeamMember error: $e");
    }
  }

  /// ✅ Delete a team member
  Future<void> deleteTeamMember(String memberId) async {
    try {
      await _client.from('brand_team').delete().eq('id', memberId);
      print("✅ Team member deleted: $memberId");
    } catch (e) {
      print("❌ deleteTeamMember error: $e");
    }
  }
}
