
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import '../models/user_model.dart';
// import '../screens/auth/role_selection_screen.dart';

// class SupabaseAuthService {
//   final supabase = Supabase.instance.client;

//   // ---------------- INITIALIZATION ----------------
//   static Future<void> initialize() async {
//     await Supabase.initialize(
//       url: 'https://haepqnfenkduuediwcfb.supabase.co',
//       anonKey:
//           'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhhZXBxbmZlbmtkdXVlZGl3Y2ZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1NjIyNjMsImV4cCI6MjA3NzEzODI2M30.jUvIBlonLDg7gAcJimfaNKYUCrT7fu7_z4dUrB5Fpz4',
//     );
//   }
//   // ---------------- EMAIL SIGNUP ----------------
// Future<UserModel?> signUp(
//     String name, String email, String password, String role) async {
//   final response =
//       await supabase.auth.signUp(email: email, password: password);
//   if (response.user == null) return null;

//   final userId = response.user!.id;

//   // Capitalize role to match Supabase constraint
//   final roleToInsert = role[0].toUpperCase() + role.substring(1).toLowerCase();

//   // Insert profile into Supabase
//   await supabase.from('profiles').insert({
//     'id': userId,
//     'name': name,
//     'email': email,
//     'role': roleToInsert,
//   });

//   return UserModel(
//     id: userId,
//     name: name,
//     email: email,
//     role: roleToInsert,
//   );
// }

//   // ---------------- EMAIL LOGIN ----------------
//   Future<UserModel?> login(String email, String password) async {
//     final response =
//         await supabase.auth.signInWithPassword(email: email, password: password);

//     if (response.user == null) return null;

//     final userId = response.user!.id;
//     final userData = await supabase
//         .from('profiles')
//         .select()
//         .eq('id', userId)
//         .maybeSingle();

//     if (userData == null) return null;
//     return UserModel.fromMap(userData);
//   }

//   // ---------------- LOGOUT ----------------
//   Future<void> logout() async {
//     try {
//       final googleSignIn = GoogleSignIn();
//       await googleSignIn.disconnect();
//     } catch (_) {}
//     await supabase.auth.signOut();
//   }

//   // ---------------- PASSWORD RESET ----------------
//   Future<void> resetPassword(String email) async {
//   try {
//     await Supabase.instance.client.auth.resetPasswordForEmail(
//       email,
//       // 👇 match scheme and host from manifest
//       redirectTo: 'io.supabase.influencerapp://login-callback',
//     );
//   } on AuthException catch (e) {
//     throw Exception(e.message);
//   } catch (e) {
//     throw Exception("Unexpected error: $e");
//   }
// }


//   // ---------------- GET CURRENT USER ----------------
//   Future<UserModel?> getCurrentUser() async {
//     final user = supabase.auth.currentUser;
//     if (user == null) return null;
//     final data =
//         await supabase.from('profiles').select().eq('id', user.id).single();
//     return UserModel.fromMap(data);
//   }

//   // ---------------- UPDATE PROFILE ----------------
//   Future<void> updateProfile({
//     required String userId,
//     String? bio,
//     String? website,
//   }) async {
//     await supabase.from('profiles').update({
//       if (bio != null) 'bio': bio,
//       if (website != null) 'website': website,
//     }).eq('id', userId);
//   }

//   // ---------------- GOOGLE SIGNUP / LOGIN ----------------

// Future<UserModel?> signInWithGoogle(BuildContext context) async {
//   try {
//     const webClientId =
//         '467384361743-ovulm9669fqu3p4sbe7270fnra7itqov.apps.googleusercontent.com';

//     final googleSignIn = GoogleSignIn(
//       scopes: ['email', 'profile'],
//       serverClientId: webClientId,
//     );

//     // Ensure user picks an account fresh each time
//     try {
//       final currentUser = await googleSignIn.signInSilently();
//       if (currentUser != null) await googleSignIn.disconnect();
//     } catch (_) {}

//     final googleUser = await googleSignIn.signIn();
//     if (googleUser == null) return null; // user canceled

//     final googleAuth = await googleUser.authentication;
//     if (googleAuth.idToken == null || googleAuth.accessToken == null) {
//       throw Exception("Missing Google Auth Tokens");
//     }

//     // ✅ Sign in with Supabase using Google tokens
//     final response = await supabase.auth.signInWithIdToken(
//       provider: OAuthProvider.google,
//       idToken: googleAuth.idToken!,
//       accessToken: googleAuth.accessToken!,
//     );

//     final user = response.user;
//     if (user == null) throw Exception("Supabase sign-in failed");

//     // ✅ Check if user already has profile
//     final existing = await supabase
//         .from('profiles')
//         .select()
//         .eq('id', user.id)
//         .maybeSingle();

//     if (existing == null) {
//       // New Google user → go to Role Selection
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => RoleSelectionScreen(
//             userId: user.id,
//             email: user.email ?? '',
//             name: googleUser.displayName ?? 'New User',
//           ),
//         ),
//       );
//       return null;
//     } else {
//       // ✅ Existing user → go to HomeScreen instead of showing SnackBar
//       Navigator.pushReplacementNamed(context, '/home');
//       return UserModel.fromMap(existing);
//     }
//   } catch (e) {
//     debugPrint("Google sign-in error: $e");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Error: $e")),
//     );
//     return null;
//   }
// }


//   // ---------------- HANDLE GOOGLE USER ----------------
//   Future<UserModel?> handleGoogleUser() async {
//     final user = supabase.auth.currentUser;
//     if (user == null) return null;

//     final existing = await supabase
//         .from('profiles')
//         .select()
//         .eq('id', user.id)
//         .maybeSingle();

//     if (existing == null) return null;
//     return UserModel.fromMap(existing);
//   }
// }
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/screens/auth/brand_dashboard.dart';
import 'package:influencer_marketplace_application/screens/auth/influencer_dashboard.dart';
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
    final roleToInsert = role[0].toUpperCase() + role.substring(1).toLowerCase();

    await supabase.from('profiles').insert({
      'id': userId,
      'name': name,
      'email': email,
      'role': roleToInsert,
    });

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

  // ---------------- GET CURRENT USER ----------------
  Future<UserModel?> getCurrentUser() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final data =
        await supabase.from('profiles').select().eq('id', user.id).maybeSingle();
    if (data == null) return null;
    return UserModel.fromMap(data);
  }

  // ---------------- UPDATE PROFILE ----------------
  Future<void> updateProfile({
    required String userId,
    String? bio,
    String? website,
  }) async {
    await supabase.from('profiles').update({
      if (bio != null) 'bio': bio,
      if (website != null) 'website': website,
    }).eq('id', userId);
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

      // Ensure clean account selection
      try {
        final currentUser = await googleSignIn.signInSilently();
        if (currentUser != null) await googleSignIn.disconnect();
      } catch (_) {}

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null || googleAuth.accessToken == null) {
        throw Exception("Missing Google Auth Tokens");
      }

      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      final user = response.user;
      if (user == null) throw Exception("Supabase sign-in failed");

      final existing = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (existing == null) {
        // New Google user → go to role selection
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
        final userModel = UserModel.fromMap(existing);

        // ✅ Navigate to dashboard by role
        if (userModel.role.toLowerCase() == 'brand') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const BrandDashboardScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const InfluencerDashboardScreen()),
          );
        }

        return userModel;
      }
    } catch (e) {
      debugPrint("Google sign-in error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      return null;
    }
  }
}
