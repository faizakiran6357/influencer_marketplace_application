
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../screens/auth/role_selection_screen.dart';

class SupabaseAuthService {
  final supabase = Supabase.instance.client;

  // ---------------- INITIALIZATION ----------------
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://haepqnfenkduuediwcfb.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhhZXBxbmZlbmtkdXVlZGl3Y2ZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1NjIyNjMsImV4cCI6MjA3NzEzODI2M30.jUvIBlonLDg7gAcJimfaNKYUCrT7fu7_z4dUrB5Fpz4',
    );
  }

  // ---------------- EMAIL SIGNUP ----------------
  Future<UserModel?> signUp(
      String name, String email, String password, String role) async {
    final response =
        await supabase.auth.signUp(email: email, password: password);
    if (response.user == null) return null;

    final userId = response.user!.id;

    // Capitalize role
    final roleToInsert = role[0].toUpperCase() + role.substring(1).toLowerCase();

    // Insert into profiles
    await supabase.from('profiles').insert({
      'id': userId,
      'name': name,
      'email': email,
      'role': roleToInsert,
    });

    // ✅ Ensure influencer record exists
    if (roleToInsert == 'Influencer') {
      await ensureInfluencerRecord(userId, email, name);
    }

    return UserModel(
      id: userId,
      name: name,
      email: email,
      role: roleToInsert,
    );
  }

  // ---------------- EMAIL LOGIN ----------------
  Future<UserModel?> login(String email, String password) async {
    final response =
        await supabase.auth.signInWithPassword(email: email, password: password);

    if (response.user == null) return null;

    final userId = response.user!.id;
    final userData = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (userData == null) return null;

    // ✅ Also ensure influencer record exists if user is influencer
    if (userData['role'] == 'Influencer') {
      await ensureInfluencerRecord(userId, email, userData['name']);
    }

    return UserModel.fromMap(userData);
  }

  // ---------------- LOGOUT ----------------
  Future<void> logout() async {
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.disconnect();
    } catch (_) {}
    await supabase.auth.signOut();
  }

  // ---------------- PASSWORD RESET ----------------
  Future<void> resetPassword(String email) async {
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.influencerapp://login-callback',
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  // ---------------- GOOGLE SIGN-IN ----------------
  Future<UserModel?> signInWithGoogle(BuildContext context) async {
    try {
      const webClientId =
          '467384361743-ovulm9669fqu3p4sbe7270fnra7itqov.apps.googleusercontent.com';

      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: webClientId,
      );

      // Disconnect silent sessions
      try {
        final currentUser = await googleSignIn.signInSilently();
        if (currentUser != null) await googleSignIn.disconnect();
      } catch (_) {}

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;
      if (idToken == null || accessToken == null) {
        throw Exception("Missing Google Auth Tokens");
      }

      // Supabase sign-in
      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final user = response.user;
      if (user == null) throw Exception("Supabase sign-in failed");

      // Check profile
      final existing = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (existing == null) {
        // New Google user → choose role
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => RoleSelectionScreen(
              userId: user.id,
              email: user.email ?? '',
              name: googleUser.displayName ?? 'New User',
            ),
          ),
        );
        return null;
      } else {
        // ✅ Ensure influencer record exists if role = Influencer
        if (existing['role'] == 'Influencer') {
          await ensureInfluencerRecord(
            user.id,
            user.email ?? '',
            existing['name'] ?? googleUser.displayName ?? 'Influencer',
          );
        }

        return UserModel.fromMap(existing);
      }
    } catch (e) {
      debugPrint("Google sign-in error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return null;
    }
  }

  // ---------------- HANDLE GOOGLE USER ----------------
  Future<UserModel?> handleGoogleUser() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final existing = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (existing == null) return null;
    return UserModel.fromMap(existing);
  }

  // ---------------- ENSURE INFLUENCER RECORD ----------------
  Future<void> ensureInfluencerRecord(
      String userId, String email, String name) async {
    final existing = await supabase
        .from('influencers')
        .select('id')
        .eq('id', userId)
        .maybeSingle();

    if (existing == null) {
      await supabase.from('influencers').insert({
        'id': userId,
        'name': name,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  // ---------------- GET CURRENT USER ----------------
  Future<UserModel?> getCurrentUser() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;
    final data =
        await supabase.from('profiles').select().eq('id', user.id).single();
    return UserModel.fromMap(data);
  }
// ---------------- UPDATE PROFILE ----------------
Future<void> updateProfile({
  required String userId,
  String? name,
  String? bio,
  String? website,
  String? role,
  String? profileImage, // ✅ optional for image URL
}) async {
  try {
    final updates = <String, dynamic>{
      if (name != null && name.isNotEmpty) 'name': name,
      if (bio != null && bio.isNotEmpty) 'bio': bio,
      if (website != null && website.isNotEmpty) 'website': website,
      if (role != null && role.isNotEmpty) 'role': role,
      if (profileImage != null && profileImage.isNotEmpty)
        'profile_image': profileImage,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await Supabase.instance.client
        .from('profiles')
        .update(updates)
        .eq('id', userId);

    print("✅ Profile updated successfully for $userId");
  } on PostgrestException catch (e) {
    print("❌ Error updating profile: ${e.message}");
    rethrow;
  } catch (e) {
    print("❌ Unknown error updating profile: $e");
    rethrow;
  }
}

// ---------------- UPLOAD PROFILE IMAGE ----------------
Future<String?> uploadProfileImage({
  required String userId,
  required File imageFile,
}) async {
  try {
    const bucketName = 'profile_images';
    final client = Supabase.instance.client;

    // ✅ Upload path (brands or influencers folder)
    final filePath =
        'brands/$userId-${DateTime.now().millisecondsSinceEpoch}.jpg';

    // ✅ Upload to Supabase Storage
    await client.storage.from(bucketName).upload(
          filePath,
          imageFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );

    // ✅ Get the public URL
    final publicUrl = client.storage.from(bucketName).getPublicUrl(filePath);

    // ✅ Save URL to profiles table
    await updateProfile(
      userId: userId,
      profileImage: publicUrl,
    );

    print("✅ Profile image uploaded successfully: $publicUrl");
    return publicUrl;
  } on StorageException catch (e) {
    print("❌ Supabase Storage error: ${e.message}");
    rethrow;
  } catch (e) {
    print("❌ uploadProfileImage error: $e");
    rethrow;
  }
}

 
}