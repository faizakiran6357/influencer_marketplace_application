import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/providers/auth_provider.dart';
import 'package:influencer_marketplace_application/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String role; // Influencer or Brand
  const ProfileSetupScreen({super.key, required this.role});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _websiteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isInfluencer = widget.role == 'Influencer';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          "Setup ${widget.role} Profile",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isInfluencer
                    ? "Complete your influencer profile"
                    : "Complete your business profile",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textColor),
              ),
              const SizedBox(height: 30),

              // Common fields
              CustomTextField(
                controller: _usernameController,
                hintText: isInfluencer ? "Username" : "Contact Person Name",
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              if (isInfluencer)
                CustomTextField(
                  controller: _bioController,
                  hintText: "Short Bio",
                  prefixIcon: Icons.info_outline,
                )
              else
                CustomTextField(
                  controller: _businessNameController,
                  hintText: "Business / Brand Name",
                  prefixIcon: Icons.business_center_outlined,
                ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _websiteController,
                hintText: isInfluencer ? "Instagram / TikTok URL" : "Website URL",
                prefixIcon: Icons.link_outlined,
              ),
              const SizedBox(height: 30),
//               CustomButton(
//   text: "Save Profile",
//   onPressed: () async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final userId = authProvider.currentUser?.id;
//     if (userId != null) {
//       await SupabaseAuthService().updateProfile(
//         userId: userId,
//         bio: isInfluencer ? _bioController.text.trim() : null,
//         website: _websiteController.text.trim(),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Profile updated successfully!")),
//       );
//     }
//   },
// ),
CustomButton(
  text: "Save Profile",
  onPressed: () async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?.id;

    if (userId != null) {
      await SupabaseAuthService().updateProfile(
        userId: userId,
        bio: isInfluencer ? _bioController.text.trim() : null,
        website: _websiteController.text.trim(),
      );

      // ✅ Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );

      // ✅ Wait briefly so user can see the snackbar
      await Future.delayed(const Duration(seconds: 1));

      // ✅ Log out the user and go back to login screen
      await authProvider.logout();

      // ✅ Navigate back to login screen
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not found.")),
      );
    }
  },
),


            ],
          ),
        ),
      ),
    );
  }
}

