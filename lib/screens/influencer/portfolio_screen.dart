// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';
// import '../../services/influencer_service.dart';

// class PortfolioScreen extends StatefulWidget {
//   const PortfolioScreen({super.key});

//   @override
//   State<PortfolioScreen> createState() => _PortfolioScreenState();
// }

// class _PortfolioScreenState extends State<PortfolioScreen> {
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImage(BuildContext context, ImageSource source) async {
//     final userId = context.read<AuthProvider>().currentUser?.id;
//     if (userId == null) return;

//     final XFile? pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile == null) return;

//     final Uint8List bytes = await pickedFile.readAsBytes();

//     await InfluencerService().uploadPortfolioItem(
//       influencerId: userId,
//       bytes: bytes,
//       filename: pickedFile.name,
//       title: "New Portfolio Item",
//       description: "Uploaded via ${source == ImageSource.camera ? 'Camera' : 'Gallery'}",
//     );

//     await context.read<InfluencerProvider>().fetchPortfolio(userId);
//     if (!mounted) return;
// ScaffoldMessenger.of(context).showSnackBar(
//   const SnackBar(content: Text("Image uploaded successfully!")),
// );

//   }

//   void _showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt, color: Colors.green),
//               title: const Text('Take a Photo'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(context, ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library, color: Colors.blue),
//               title: const Text('Choose from Gallery'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(context, ImageSource.gallery);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
// void initState() {
//   super.initState();
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     final id = context.read<AuthProvider>().currentUser?.id;
//     if (id != null) {
//       context.read<InfluencerProvider>().fetchPortfolio(id);
//     }
//   });
// }


//   @override
//   Widget build(BuildContext context) {
//     final portfolio = context.watch<InfluencerProvider>().portfolio;

//     return Scaffold(
//       appBar: AppBar(title: const Text("My Portfolio")),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showImageSourceDialog,
//         child: const Icon(Icons.add_a_photo),
//       ),
//       body: portfolio.isEmpty
//           ? const Center(
//               child: Text(
//                 "No portfolio items yet.\nTap + to add one!",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16),
//               ),
//             )
//           : GridView.builder(
//               padding: const EdgeInsets.all(10),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 8,
//                 mainAxisSpacing: 8,
//               ),
//               itemCount: portfolio.length,
//               itemBuilder: (_, i) {
//                 final item = portfolio[i];
//                 return ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Image.network(item['public_url'], fit: BoxFit.cover),
//                 );
//               },
//             ),
//     );
//   }
// }
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/influencer_provider.dart';
import '../../services/influencer_service.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final ImagePicker _picker = ImagePicker();

  // ✅ Safely pick image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.currentUser?.id;
    if (userId == null) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return;

      final Uint8List bytes = await pickedFile.readAsBytes();

      // Upload to Supabase storage
      await InfluencerService().uploadPortfolioItem(
        influencerId: userId,
        bytes: bytes,
        filename: pickedFile.name,
        title: "New Portfolio Item",
        description:
            "Uploaded via ${source == ImageSource.camera ? 'Camera' : 'Gallery'}",
      );

      // Refresh portfolio list
      if (!mounted) return;
      await context.read<InfluencerProvider>().fetchPortfolio(userId);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image uploaded successfully!")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading image: $e")),
      );
    }
  }

  // ✅ Image source selection dialog
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFB25640)),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ✅ Load portfolio after first frame
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = context.read<AuthProvider>().currentUser?.id;
      if (id != null) {
        context.read<InfluencerProvider>().fetchPortfolio(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final portfolio = context.watch<InfluencerProvider>().portfolio;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Portfolio"),
        backgroundColor: Color(0xFFB25640),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFB25640),
        onPressed: _showImageSourceDialog,
        child: const Icon(Icons.add_a_photo),
      ),
      body: portfolio.isEmpty
          ? const Center(
              child: Text(
                "No portfolio items yet.\nTap + to add one!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: portfolio.length,
              itemBuilder: (_, i) {
                final item = portfolio[i];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    item['public_url'],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 50),
                  ),
                );
              },
            ),
    );
  }
}
