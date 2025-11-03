// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/providers/auth_provider.dart';
// import 'package:influencer_marketplace_application/services/auth_service.dart';
// import 'package:provider/provider.dart';
// import '../../utils/app_theme.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_textfield.dart';

// class ProfileSetupScreen extends StatefulWidget {
//   final String role; // Influencer or Brand
//   const ProfileSetupScreen({super.key, required this.role});

//   @override
//   State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
// }

// class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
//   final _usernameController = TextEditingController();
//   final _bioController = TextEditingController();
//   final _businessNameController = TextEditingController();
//   final _websiteController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final isInfluencer = widget.role == 'Influencer';

//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         title: Text(
//           "Setup ${widget.role} Profile",
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 isInfluencer
//                     ? "Complete your influencer profile"
//                     : "Complete your business profile",
//                 style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: AppTheme.textColor),
//               ),
//               const SizedBox(height: 30),

//               // Common fields
//               CustomTextField(
//                 controller: _usernameController,
//                 hintText: isInfluencer ? "Username" : "Contact Person Name",
//                 prefixIcon: Icons.person_outline,
//               ),
//               const SizedBox(height: 16),

//               if (isInfluencer)
//                 CustomTextField(
//                   controller: _bioController,
//                   hintText: "Short Bio",
//                   prefixIcon: Icons.info_outline,
//                 )
//               else
//                 CustomTextField(
//                   controller: _businessNameController,
//                   hintText: "Business / Brand Name",
//                   prefixIcon: Icons.business_center_outlined,
//                 ),
//               const SizedBox(height: 16),

//               CustomTextField(
//                 controller: _websiteController,
//                 hintText: isInfluencer ? "Instagram / TikTok URL" : "Website URL",
//                 prefixIcon: Icons.link_outlined,
//               ),
//               const SizedBox(height: 30),

//   CustomButton(
//   text: "Save Profile",
//   onPressed: () async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final userId = authProvider.currentUser?.id;
//     final role = widget.role;

//     if (userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("User not found.")),
//       );
//       return;
//     }

//     final isInfluencer = role == "Influencer";

//     final bio = isInfluencer
//         ? _bioController.text.trim()
//         : _businessNameController.text.trim(); // ✅ For brand, use business name as bio or company name
//     final website = _websiteController.text.trim();
//     final name = _usernameController.text.trim();

//     await SupabaseAuthService().updateProfile(
//       userId: userId,
//       name: name,
//       bio: bio,
//       website: website,
//       role: role,
//     );

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Profile saved successfully!")),
//     );

//     // ✅ Wait briefly before redirect
//     await Future.delayed(const Duration(seconds: 1));

//     // ✅ Log out the user and return to login
//     await authProvider.logout();
//     if (mounted) {
//       Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//     }
//   },
// ),

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:influencer_marketplace_application/providers/auth_provider.dart';
import 'package:influencer_marketplace_application/services/auth_service.dart';
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
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _selectedImage = File(pickedFile.path);
                  });
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () async {
                final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() {
                    _selectedImage = File(pickedFile.path);
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

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
              // Profile Image Section
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    child: _selectedImage == null
                        ? const Icon(Icons.camera_alt,
                            size: 32, color: Colors.black54)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),

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
                hintText: isInfluencer
                    ? "Instagram / TikTok URL"
                    : "Website URL",
                prefixIcon: Icons.link_outlined,
              ),
              const SizedBox(height: 30),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      text: "Save Profile",
                      onPressed: () async {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        final userId = authProvider.currentUser?.id;
                        final role = widget.role;

                        if (userId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("User not found.")),
                          );
                          return;
                        }

                        final isInfluencer = role == "Influencer";
                        final bio = isInfluencer
                            ? _bioController.text.trim()
                            : _businessNameController.text.trim();
                        final website = _websiteController.text.trim();
                        final name = _usernameController.text.trim();

                        setState(() => _isLoading = true);

                        try {
                          final authService = SupabaseAuthService();

                          // Update text info
                          await authService.updateProfile(
                            userId: userId,
                            name: name,
                            bio: bio,
                            website: website,
                            role: role,
                          );

                          // Upload image if selected
                          if (_selectedImage != null) {
                            await authService.uploadProfileImage(
                              userId: userId,
                              imageFile: _selectedImage!,
                            );
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Profile saved successfully!")),
                          );

                          await Future.delayed(const Duration(seconds: 1));

                          await authProvider.logout();
                          if (mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $e")),
                          );
                        } finally {
                          setState(() => _isLoading = false);
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
