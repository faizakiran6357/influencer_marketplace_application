// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../services/influencer_service.dart';

// class PortfolioAddEditScreen extends StatefulWidget {
//   final Map<String, dynamic>? item;
//   const PortfolioAddEditScreen({super.key, this.item});

//   @override
//   State<PortfolioAddEditScreen> createState() => _PortfolioAddEditScreenState();
// }

// class _PortfolioAddEditScreenState extends State<PortfolioAddEditScreen> {
//   final _titleController = TextEditingController();
//   final _descController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   File? _pickedImage;
//   bool _loading = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.item != null) {
//       _titleController.text = widget.item!['title'] ?? '';
//       _descController.text = widget.item!['description'] ?? '';
//     }
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final XFile? file = await _picker.pickImage(source: source);
//     if (file != null) setState(() => _pickedImage = File(file.path));
//   }

//   Future<void> _savePortfolio() async {
//     final userId = context.read<AuthProvider>().currentUser?.id;
//     if (userId == null) return;

//     final title = _titleController.text.trim();
//     final desc = _descController.text.trim();

//     if (title.isEmpty || (_pickedImage == null && widget.item == null)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all required fields and select an image.")),
//       );
//       return;
//     }

//     setState(() => _loading = true);
//     try {
//       final fileBytes = _pickedImage != null ? await _pickedImage!.readAsBytes() : null;
//       if (widget.item == null) {
//         await InfluencerService().uploadPortfolioItem(
//           influencerId: userId,
//           bytes: fileBytes!,
//           filename: _pickedImage!.path.split('/').last,
//           title: title,
//           description: desc,
//         );
//       } else {
//         await InfluencerService().updatePortfolioItem(
//           itemId: widget.item!['id'],
//           influencerId: userId,
//           newBytes: fileBytes,
//           filename: _pickedImage != null ? _pickedImage!.path.split('/').last : null,
//           title: title,
//           description: desc,
//         );
//       }

//       if (!mounted) return;
//       Navigator.pop(context, true);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEditing = widget.item != null;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(isEditing ? "Edit Portfolio" : "Add Portfolio"),
//         backgroundColor: const Color(0xFFB25640),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(
//                 labelText: "Title",
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _descController,
//               decoration: InputDecoration(
//                 labelText: "Description",
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 16),
//             GestureDetector(
//               onTap: () {
//                 showModalBottomSheet(
//                   context: context,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                   ),
//                   builder: (_) => SafeArea(
//                     child: Wrap(
//                       children: [
//                         ListTile(
//                           leading: const Icon(Icons.camera_alt),
//                           title: const Text("Take Photo"),
//                           onTap: () {
//                             Navigator.pop(context);
//                             _pickImage(ImageSource.camera);
//                           },
//                         ),
//                         ListTile(
//                           leading: const Icon(Icons.photo_library),
//                           title: const Text("Choose from Gallery"),
//                           onTap: () {
//                             Navigator.pop(context);
//                             _pickImage(ImageSource.gallery);
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//               child: Container(
//                 height: 160,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   color: Colors.grey[300],
//                   border: Border.all(color: Colors.grey.shade400),
//                 ),
//                 child: _pickedImage != null
//                     ? Image.file(_pickedImage!, fit: BoxFit.cover)
//                     : widget.item != null && widget.item!['public_url'] != null
//                         ? Image.network(widget.item!['public_url'], fit: BoxFit.cover)
//                         : const Center(child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey)),
//               ),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: _loading ? null : _savePortfolio,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFB25640),
//                 padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               child: _loading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : Text(isEditing ? "Update Portfolio" : "Add Portfolio"),
//             ),
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
import '../../providers/auth_provider.dart';
import '../../services/influencer_service.dart';

class PortfolioAddEditScreen extends StatefulWidget {
  final Map<String, dynamic>? item;
  const PortfolioAddEditScreen({super.key, this.item});

  @override
  State<PortfolioAddEditScreen> createState() => _PortfolioAddEditScreenState();
}

class _PortfolioAddEditScreenState extends State<PortfolioAddEditScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _titleController.text = widget.item!['title'] ?? '';
      _descController.text = widget.item!['description'] ?? '';
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? file = await _picker.pickImage(source: source);
    if (file != null) setState(() => _pickedImage = File(file.path));
  }

  Future<void> _savePortfolio() async {
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId == null) return;

    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty || (_pickedImage == null && widget.item == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields and select an image.")),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final fileBytes = _pickedImage != null ? await _pickedImage!.readAsBytes() : null;
      if (widget.item == null) {
        await InfluencerService().uploadPortfolioItem(
          influencerId: userId,
          bytes: fileBytes!,
          filename: _pickedImage!.path.split('/').last,
          title: title,
          description: desc,
        );
      } else {
        await InfluencerService().updatePortfolioItem(
          itemId: widget.item!['id'],
          influencerId: userId,
          newBytes: fileBytes,
          filename: _pickedImage != null ? _pickedImage!.path.split('/').last : null,
          title: title,
          description: desc,
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.item != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Portfolio" : "Add Portfolio"),
        backgroundColor: const Color(0xFFB25640),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top image container
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => SafeArea(
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text("Take Photo"),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.camera);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text("Choose from Gallery"),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.gallery);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Container(
                height: 250, // taller container for a pleasant image view
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: _pickedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(_pickedImage!, fit: BoxFit.cover),
                      )
                    : widget.item != null && widget.item!['public_url'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(widget.item!['public_url'], fit: BoxFit.cover),
                          )
                        : const Center(child: Icon(Icons.add_a_photo, size: 60, color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 16),

            // Title field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            // Description field
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _savePortfolio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB25640),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEditing ? "Update Portfolio" : "Add Portfolio", style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
