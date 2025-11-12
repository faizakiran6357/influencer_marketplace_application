
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/brand_provider.dart';
// import '../../../models/brand_model.dart';

// class EditBrandProfile extends StatefulWidget {
//   const EditBrandProfile({super.key});

//   @override
//   State<EditBrandProfile> createState() => _EditBrandProfileState();
// }

// class _EditBrandProfileState extends State<EditBrandProfile> {
//   final _nameController = TextEditingController();
//   final _bioController = TextEditingController();
//   final _websiteController = TextEditingController();
//   File? _imageFile;
//   bool _isSaving = false;

//   @override
//   void initState() {
//     super.initState();
//     final brand = context.read<BrandProvider>().brand;
//     if (brand != null) {
//       _nameController.text = brand.name;
//       _bioController.text = brand.bio ?? '';
//       _websiteController.text = brand.website ?? '';
//     }
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final source = await showModalBottomSheet<ImageSource>(
//       context: context,
//       builder: (context) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text("Take Photo"),
//               onTap: () => Navigator.pop(context, ImageSource.camera),
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text("Choose from Gallery"),
//               onTap: () => Navigator.pop(context, ImageSource.gallery),
//             ),
//           ],
//         ),
//       ),
//     );

//     if (source == null) return;

//     final pickedFile = await picker.pickImage(source: source, imageQuality: 75);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _saveProfile() async {
//     final provider = context.read<BrandProvider>();
//     final brand = provider.brand;
//     if (brand == null) return;

//     setState(() => _isSaving = true);

//     try {
//       String? imageUrl = brand.profileImage;

//       // ✅ Upload new image if selected
//       if (_imageFile != null) {
//         imageUrl = await provider.uploadProfileImage(brand.id, _imageFile!);
//       }

//       // ✅ Update brand details (with new image URL)
//       final updatedBrand = brand.copyWith(
//         name: _nameController.text,
//         bio: _bioController.text,
//         website: _websiteController.text,
//         profileImage: imageUrl,
//       );

//       await provider.updateBrand(updatedBrand);

//       // ✅ Refresh brand data from backend
//       await provider.fetchBrand(brand.id);

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Profile updated successfully")),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error saving profile: $e")),
//       );
//     } finally {
//       setState(() => _isSaving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final brand = context.watch<BrandProvider>().brand;
//     if (brand == null) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     final image = _imageFile != null
//         ? FileImage(_imageFile!)
//         : (brand.profileImage != null && brand.profileImage!.isNotEmpty
//             ? NetworkImage(brand.profileImage!)
//             : const AssetImage('assets/images/default_avatar.png'))
//                 as ImageProvider;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Profile")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Center(
//               child: Stack(
//                 alignment: Alignment.bottomRight,
//                 children: [
//                   CircleAvatar(radius: 50, backgroundImage: image),
//                   Positioned(
//                     right: 4,
//                     bottom: 4,
//                     child: InkWell(
//                       onTap: _pickImage,
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: const BoxDecoration(
//                           color: Colors.blue,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(labelText: "Name"),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _bioController,
//               decoration: const InputDecoration(labelText: "Bio"),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _websiteController,
//               decoration: const InputDecoration(labelText: "Website"),
//             ),
//             const SizedBox(height: 20),
//             _isSaving
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton.icon(
//                     icon: const Icon(Icons.save),
//                     label: const Text("Save Changes"),
//                     onPressed: _saveProfile,
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../providers/brand_provider.dart';
import '../../../models/brand_model.dart';
import '../../../utils/app_theme.dart';

class EditBrandProfile extends StatefulWidget {
  const EditBrandProfile({super.key});

  @override
  State<EditBrandProfile> createState() => _EditBrandProfileState();
}

class _EditBrandProfileState extends State<EditBrandProfile> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _websiteController = TextEditingController();
  File? _imageFile;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final brand = context.read<BrandProvider>().brand;
    if (brand != null) {
      _nameController.text = brand.name;
      _bioController.text = brand.bio ?? '';
      _websiteController.text = brand.website ?? '';
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final pickedFile = await picker.pickImage(source: source, imageQuality: 75);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    final provider = context.read<BrandProvider>();
    final brand = provider.brand;
    if (brand == null) return;

    setState(() => _isSaving = true);

    try {
      String? imageUrl = brand.profileImage;

      if (_imageFile != null) {
        imageUrl = await provider.uploadProfileImage(brand.id, _imageFile!);
      }

      final updatedBrand = brand.copyWith(
        name: _nameController.text,
        bio: _bioController.text,
        website: _websiteController.text,
        profileImage: imageUrl,
      );

      await provider.updateBrand(updatedBrand);
      await provider.fetchBrand(brand.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: $e")),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.watch<BrandProvider>().brand;
    if (brand == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final image = _imageFile != null
        ? FileImage(_imageFile!)
        : (brand.profileImage != null && brand.profileImage!.isNotEmpty
            ? NetworkImage(brand.profileImage!)
            : const AssetImage('assets/images/default_avatar.png'))
                as ImageProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: AppTheme.primaryColor,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // 🌟 Profile Image
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: image,
                    backgroundColor: Colors.grey[200],
                  ),
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: InkWell(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 🌟 Input Fields
            _buildTextField(
              controller: _nameController,
              label: "Name",
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _bioController,
              label: "Bio",
              icon: Icons.info_outline,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _websiteController,
              label: "Website",
              icon: Icons.language,
            ),
            const SizedBox(height: 30),

            // 🌟 Save Button
            _isSaving
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          "Save Changes",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
