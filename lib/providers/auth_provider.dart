
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final _authService = SupabaseAuthService();

  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get userRole => _currentUser?.role;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ---------------- EMAIL SIGNUP ----------------
  Future<String?> signUp(
      String name, String email, String password, String role) async {
    try {
      setLoading(true);
      final user = await _authService.signUp(name, email, password, role);
      _currentUser = user;
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      setLoading(false);
    }
  }

  // ---------------- EMAIL LOGIN ----------------
  Future<String?> login(String email, String password) async {
    try {
      setLoading(true);
      final user = await _authService.login(email, password);
      _currentUser = user;
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      setLoading(false);
    }
  }

  // ---------------- GOOGLE SIGN-IN ----------------
  Future<UserModel?> signInWithGoogle(BuildContext context) async {
    try {
      setLoading(true);
      final user = await _authService.signInWithGoogle(context);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
        return user;
      }
      return null;
    } catch (e) {
      debugPrint("Google sign-in failed: $e");
      return null;
    } finally {
      setLoading(false);
    }
  }

  // ---------------- LOGOUT ----------------
  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }

  // ---------------- PASSWORD RESET ----------------
  Future<String?> resetPassword(String email) async {
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.influencerapp://login-callback',
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Error: $e";
    }
  }

  // ---------------- CURRENT USER ----------------
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = await _authService.getCurrentUser();
      _currentUser = user;
      notifyListeners();
      return user;
    } catch (e) {
      return null;
    }
  }

  set currentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }
}
