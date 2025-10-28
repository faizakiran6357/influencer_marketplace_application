
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import '../models/user_model.dart';

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

//   // ---------------- EMAIL AUTH ----------------
//   Future<UserModel?> signUp(
//       String name, String email, String password, String role) async {
//     final response =
//         await supabase.auth.signUp(email: email, password: password);
//     if (response.user == null) return null;

//     final userId = response.user!.id;
//     await supabase.from('profiles').insert({
//       'id': userId,
//       'name': name,
//       'email': email,
//       'role': role,
//     });

//     return UserModel(
//       id: userId,
//       name: name,
//       email: email,
//       role: role,
//     );
//   }

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

//   Future<void> logout() async {
//     try {
//       final googleSignIn = GoogleSignIn();
//       await googleSignIn.disconnect();
//     } catch (_) {}
//     await supabase.auth.signOut();
//   }

//   Future<void> resetPassword(String email) async {
//     await supabase.auth.resetPasswordForEmail(email);
//   }

//   Future<UserModel?> getCurrentUser() async {
//     final user = supabase.auth.currentUser;
//     if (user == null) return null;
//     final data =
//         await supabase.from('profiles').select().eq('id', user.id).single();
//     return UserModel.fromMap(data);
//   }

//   Future<void> updateProfile({
//     required String userId,
//     String? bio,
//     String? website,
//   }) async {
//     await supabase.from('profiles').update({
//       'bio': bio,
//       'website': website,
//     }).eq('id', userId);
//   } // ✅ Properly closed method

//   // ---------------- GOOGLE AUTH (Native Account Picker) ----------------
//   Future<UserModel?> signInWithGoogle(BuildContext context) async {
//     try {
//       const webClientId =
//           '467384361743-ovulm9669fqu3p4sbe7270fnra7itqov.apps.googleusercontent.com';

//       final GoogleSignIn googleSignIn = GoogleSignIn(
//         scopes: ['email', 'profile'],
//         serverClientId: webClientId,
//       );

//       // Disconnect any previous session
//       try {
//         final currentUser = await googleSignIn.signInSilently();
//         if (currentUser != null) {
//           await googleSignIn.disconnect();
//         }
//       } catch (_) {}

//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//       if (googleUser == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Google sign-in cancelled')),
//         );
//         return null;
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       final idToken = googleAuth.idToken;
//       final accessToken = googleAuth.accessToken;

//       if (idToken == null || accessToken == null) {
//         throw Exception("Missing Google Auth Tokens");
//       }

//       // Authenticate with Supabase
//       final response = await supabase.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: idToken,
//         accessToken: accessToken,
//       );

//       final user = response.user;
//       if (user == null) throw Exception("Supabase sign-in failed");

//       // Ensure user exists in profiles table
//       await _ensureUserProfileExists(user, googleUser);

//       return UserModel(
//         id: user.id,
//         name: googleUser.displayName ?? 'New User',
//         email: user.email ?? '',
//         role: 'influencer',
//       );
//     } catch (e) {
//       debugPrint("Google sign-in error: $e");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error: $e')));
//       return null;
//     }
//   }

//   // ---------------- ENSURE USER PROFILE ----------------
//   Future<void> _ensureUserProfileExists(
//       User user, GoogleSignInAccount googleUser) async {
//     final existing = await supabase
//         .from('profiles')
//         .select()
//         .eq('id', user.id)
//         .maybeSingle();

//     if (existing == null) {
//       await supabase.from('profiles').insert({
//         'id': user.id,
//         'email': user.email,
//         'name': googleUser.displayName ?? 'New User',
//         'role': 'influencer',
//       });
//     }
//   }

//   // ---------------- HANDLE GOOGLE USER ----------------
//   Future<UserModel?> handleGoogleUser() async {
//     final user = supabase.auth.currentUser;
//     if (user == null) return null;

//     final existing = await supabase
//         .from('profiles')
//         .select()
//         .eq('id', user.id)
//         .maybeSingle();

//     if (existing == null) {
//       await supabase.from('profiles').insert({
//         'id': user.id,
//         'email': user.email,
//         'name': user.userMetadata?['name'] ?? 'New User',
//         'role': 'influencer',
//       });

//       return UserModel(
//         id: user.id,
//         name: user.userMetadata?['name'] ?? 'New User',
//         email: user.email ?? '',
//         role: 'influencer',
//       );
//     } else {
//       return UserModel.fromMap(existing);
//     }
//   }
// }
// correct code//
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

//   // ---------------- EMAIL AUTH ----------------
//   Future<UserModel?> signUp(
//       String name, String email, String password, String role) async {
//     final response =
//         await supabase.auth.signUp(email: email, password: password);
//     if (response.user == null) return null;

//     final userId = response.user!.id;
//     await supabase.from('profiles').insert({
//       'id': userId,
//       'name': name,
//       'email': email,
//       'role': role,
//     });

//     return UserModel(
//       id: userId,
//       name: name,
//       email: email,
//       role: role,
//     );
//   }

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

//   Future<void> logout() async {
//     try {
//       final googleSignIn = GoogleSignIn();
//       await googleSignIn.disconnect();
//     } catch (_) {}
//     await supabase.auth.signOut();
//   }

//   Future<void> resetPassword(String email) async {
//     await supabase.auth.resetPasswordForEmail(email);
//   }

//   Future<UserModel?> getCurrentUser() async {
//     final user = supabase.auth.currentUser;
//     if (user == null) return null;
//     final data =
//         await supabase.from('profiles').select().eq('id', user.id).single();
//     return UserModel.fromMap(data);
//   }

//   Future<void> updateProfile({
//     required String userId,
//     String? bio,
//     String? website,
//   }) async {
//     await supabase.from('profiles').update({
//       'bio': bio,
//       'website': website,
//     }).eq('id', userId);
//   }


//   // ---------------- GOOGLE AUTH ----------------
// Future<UserModel?> signInWithGoogle(BuildContext context) async {
//   try {
//     const webClientId =
//         '467384361743-ovulm9669fqu3p4sbe7270fnra7itqov.apps.googleusercontent.com';

//     final GoogleSignIn googleSignIn = GoogleSignIn(
//       scopes: ['email', 'profile'],
//       serverClientId: webClientId,
//     );

//     // Always show account picker
//     try {
//       final currentUser = await googleSignIn.signInSilently();
//       if (currentUser != null) await googleSignIn.disconnect();
//     } catch (_) {}

//     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//     if (googleUser == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Google sign-in cancelled')),
//       );
//       return null;
//     }

//     final googleAuth = await googleUser.authentication;
//     final idToken = googleAuth.idToken;
//     final accessToken = googleAuth.accessToken;
//     if (idToken == null || accessToken == null) {
//       throw Exception("Missing Google Auth Tokens");
//     }

//     // Sign in to Supabase
//     final response = await supabase.auth.signInWithIdToken(
//       provider: OAuthProvider.google,
//       idToken: idToken,
//       accessToken: accessToken,
//     );

//     final user = response.user;
//     if (user == null) throw Exception("Supabase sign-in failed");

//     // Check if profile already exists
//     final existing = await supabase
//         .from('profiles')
//         .select()
//         .eq('id', user.id)
//         .maybeSingle();

//     if (existing == null) {
//       // New Google user → go to Role Selection Screen
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
//       return null; // stop here, wait for role selection
//     }

//     // Existing user → return UserModel
//     return UserModel.fromMap(existing);
//   } catch (e) {
//     debugPrint("Google sign-in error: $e");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error: $e')),
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

//     if (existing == null) {
//       return null;
//     } else {
//       return UserModel.fromMap(existing);
//     }
//   }
// }
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
//           'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhhZXBxbmZlbmtkdXVlZGl3Y2ZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1NjIyNjMsImV4cCI6MjA3NzEzODI2M30.jUvIBlonLDg7gAcJimfaNKYUCrT7fu7_z4dUrB5Fpz4', // Replace with your key
//     );
//   }

//   // ---------------- EMAIL SIGNUP ----------------
//   Future<UserModel?> signUp(
//       String name, String email, String password, String role) async {
//     final response =
//         await supabase.auth.signUp(email: email, password: password);
//     if (response.user == null) return null;

//     final userId = response.user!.id;

//     // Insert profile into Supabase
//     await supabase.from('profiles').insert({
//       'id': userId,
//       'name': name,
//       'email': email,
//       'role': role.toLowerCase(), // ensure lowercase to match role check
//     });

//     return UserModel(
//       id: userId,
//       name: name,
//       email: email,
//       role: role.toLowerCase(),
//     );
//   }

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
//     await supabase.auth.resetPasswordForEmail(email);
//   }

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
//   Future<UserModel?> signInWithGoogle(BuildContext context) async {
//     try {
//       const webClientId =
//           '467384361743-ovulm9669fqu3p4sbe7270fnra7itqov.apps.googleusercontent.com'; // Replace with your Google Client ID

//       final googleSignIn = GoogleSignIn(
//         scopes: ['email', 'profile'],
//         serverClientId: webClientId,
//       );

//       // Always show account picker
//       try {
//         final currentUser = await googleSignIn.signInSilently();
//         if (currentUser != null) await googleSignIn.disconnect();
//       } catch (_) {}

//       final googleUser = await googleSignIn.signIn();
//       if (googleUser == null) return null;

//       final googleAuth = await googleUser.authentication;
//       final idToken = googleAuth.idToken;
//       final accessToken = googleAuth.accessToken;
//       if (idToken == null || accessToken == null) {
//         throw Exception("Missing Google Auth Tokens");
//       }

//       // Sign in to Supabase
//       final response = await supabase.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: idToken,
//         accessToken: accessToken,
//       );

//       final user = response.user;
//       if (user == null) throw Exception("Supabase sign-in failed");

//       // Check if profile already exists
//       final existing = await supabase
//           .from('profiles')
//           .select()
//           .eq('id', user.id)
//           .maybeSingle();

//       if (existing == null) {
//         // New Google user → go to Role Selection Screen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => RoleSelectionScreen(
//               userId: user.id,
//               email: user.email ?? '',
//               name: googleUser.displayName ?? 'New User',
//             ),
//           ),
//         );
//         return null; // wait for role selection
//       }

//       // Existing user → return UserModel
//       return UserModel.fromMap(existing);
//     } catch (e) {
//       debugPrint("Google sign-in error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//       return null;
//     }
//   }

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

  // Capitalize role to match Supabase constraint
  final roleToInsert = role[0].toUpperCase() + role.substring(1).toLowerCase();

  // Insert profile into Supabase
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
      // 👇 match scheme and host from manifest
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
        await supabase.from('profiles').select().eq('id', user.id).single();
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

  // ---------------- GOOGLE SIGNUP / LOGIN ----------------
//   Future<UserModel?> signInWithGoogle(BuildContext context) async {
//     try {
//       const webClientId =
//           '467384361743-ovulm9669fqu3p4sbe7270fnra7itqov.apps.googleusercontent.com';

//       final googleSignIn = GoogleSignIn(
//         scopes: ['email', 'profile'],
//         serverClientId: webClientId,
//       );

//       // Always show account picker
//       try {
//         final currentUser = await googleSignIn.signInSilently();
//         if (currentUser != null) await googleSignIn.disconnect();
//       } catch (_) {}

//       final googleUser = await googleSignIn.signIn();
//       if (googleUser == null) return null;

//       final googleAuth = await googleUser.authentication;
//       final idToken = googleAuth.idToken;
//       final accessToken = googleAuth.accessToken;
//       if (idToken == null || accessToken == null) {
//         throw Exception("Missing Google Auth Tokens");
//       }

//       // Sign in to Supabase
//       final response = await supabase.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: idToken,
//         accessToken: accessToken,
//       );

//       final user = response.user;
//       if (user == null) throw Exception("Supabase sign-in failed");

//       // Check if profile already exists
//       final existing = await supabase
//           .from('profiles')
//           .select()
//           .eq('id', user.id)
//           .maybeSingle();

//       if (existing == null) {
//   // New Google user → go to Role Selection Screen
//   Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(
//       builder: (_) => RoleSelectionScreen(
//         userId: user.id,
//         email: user.email ?? '',
//         name: googleUser.displayName ?? 'New User',
//       ),
//     ),
//   );
//   return null; // wait for role selection
// } else {
//   // Existing user → show message
//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(content: Text("User already exists, please log in.")),
//   );
//   return UserModel.fromMap(existing);
// }

//     } catch (e) {
//       debugPrint("Google sign-in error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//       return null;
//     }
//   }
Future<UserModel?> signInWithGoogle(BuildContext context) async {
  try {
    const webClientId =
        '467384361743-ovulm9669fqu3p4sbe7270fnra7itqov.apps.googleusercontent.com';

    final googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      serverClientId: webClientId,
    );

    // Ensure user picks an account fresh each time
    try {
      final currentUser = await googleSignIn.signInSilently();
      if (currentUser != null) await googleSignIn.disconnect();
    } catch (_) {}

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null; // user canceled

    final googleAuth = await googleUser.authentication;
    if (googleAuth.idToken == null || googleAuth.accessToken == null) {
      throw Exception("Missing Google Auth Tokens");
    }

    // ✅ Sign in with Supabase using Google tokens
    final response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken!,
    );

    final user = response.user;
    if (user == null) throw Exception("Supabase sign-in failed");

    // ✅ Check if user already has profile
    final existing = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (existing == null) {
      // New Google user → go to Role Selection
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
      // ✅ Existing user → go to HomeScreen instead of showing SnackBar
      Navigator.pushReplacementNamed(context, '/home');
      return UserModel.fromMap(existing);
    }
  } catch (e) {
    debugPrint("Google sign-in error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
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
}
