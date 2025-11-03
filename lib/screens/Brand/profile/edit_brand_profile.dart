// import 'package:flutter/material.dart';
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

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<BrandProvider>();
//     final brand = provider.brand;

//     if (brand == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Profile")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
//             const SizedBox(height: 10),
//             TextField(controller: _bioController, decoration: const InputDecoration(labelText: "Bio")),
//             const SizedBox(height: 10),
//             TextField(controller: _websiteController, decoration: const InputDecoration(labelText: "Website")),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               child: const Text("Save"),
//               onPressed: () async {
//                 final updatedBrand = brand.copyWith(
//                   name: _nameController.text,
//                   bio: _bioController.text,
//                   website: _websiteController.text,
//                 );
//                 await provider.updateBrand(updatedBrand);
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
//   final ImagePicker _picker = ImagePicker();

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

//   Future<void> _pickImage(ImageSource source) async {
//     final picked = await _picker.pickImage(source: source);
//     if (picked != null) {
//       setState(() => _imageFile = File(picked.path));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<BrandProvider>();
//     final brand = provider.brand;

//     if (brand == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Profile")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // ✅ Profile Image
//               Stack(
//                 alignment: Alignment.bottomRight,
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundImage: _imageFile != null
//                         ? FileImage(_imageFile!)
//                         : (brand.profileImage != null && brand.profileImage!.isNotEmpty)
//                             ? NetworkImage(brand.profileImage!)
//                             : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
//                   ),
//                   PopupMenuButton<String>(
//                     icon: const CircleAvatar(
//                       radius: 18,
//                       backgroundColor: Colors.blueAccent,
//                       child: Icon(Icons.camera_alt, color: Colors.white),
//                     ),
//                     onSelected: (value) {
//                       if (value == 'camera') {
//                         _pickImage(ImageSource.camera);
//                       } else {
//                         _pickImage(ImageSource.gallery);
//                       }
//                     },
//                     itemBuilder: (context) => [
//                       const PopupMenuItem(value: 'camera', child: Text("Camera")),
//                       const PopupMenuItem(value: 'gallery', child: Text("Gallery")),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
//               const SizedBox(height: 10),
//               TextField(controller: _bioController, decoration: const InputDecoration(labelText: "Bio")),
//               const SizedBox(height: 10),
//               TextField(controller: _websiteController, decoration: const InputDecoration(labelText: "Website")),
//               const SizedBox(height: 20),

//               ElevatedButton(
//                 child: const Text("Save Changes"),
//                 onPressed: () async {
//                   String? newImageUrl = brand.profileImage;

//                   if (_imageFile != null) {
//                     newImageUrl = await provider.uploadProfileImage(brand.id, _imageFile!);
//                   }

//                   final updatedBrand = brand.copyWith(
//                     name: _nameController.text,
//                     bio: _bioController.text,
//                     website: _websiteController.text,
//                     profileImage: newImageUrl,
//                   );

//                   await provider.updateBrand(updatedBrand);
//                   if (context.mounted) Navigator.pop(context);
//                 },
//               ),
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
import '../../../providers/brand_provider.dart';
import '../../../models/brand_model.dart';

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

      // ✅ Upload new image if selected
      if (_imageFile != null) {
        imageUrl = await provider.uploadProfileImage(brand.id, _imageFile!);
      }

      // ✅ Update brand details (with new image URL)
      final updatedBrand = brand.copyWith(
        name: _nameController.text,
        bio: _bioController.text,
        website: _websiteController.text,
        profileImage: imageUrl,
      );

      await provider.updateBrand(updatedBrand);

      // ✅ Refresh brand data from backend
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
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(radius: 50, backgroundImage: image),
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: InkWell(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(labelText: "Bio"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _websiteController,
              decoration: const InputDecoration(labelText: "Website"),
            ),
            const SizedBox(height: 20),
            _isSaving
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text("Save Changes"),
                    onPressed: _saveProfile,
                  ),
          ],
        ),
      ),
    );
  }
}
