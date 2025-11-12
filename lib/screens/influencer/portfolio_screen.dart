
// import 'dart:typed_data';
// import 'dart:io';
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

//   // ✅ Safely pick image from camera or gallery
//   Future<void> _pickImage(ImageSource source) async {
//     final authProvider = context.read<AuthProvider>();
//     final userId = authProvider.currentUser?.id;
//     if (userId == null) return;

//     try {
//       final XFile? pickedFile = await _picker.pickImage(source: source);
//       if (pickedFile == null) return;

//       final Uint8List bytes = await pickedFile.readAsBytes();

//       // Upload to Supabase storage
//       await InfluencerService().uploadPortfolioItem(
//         influencerId: userId,
//         bytes: bytes,
//         filename: pickedFile.name,
//         title: "New Portfolio Item",
//         description:
//             "Uploaded via ${source == ImageSource.camera ? 'Camera' : 'Gallery'}",
//       );

//       // Refresh portfolio list
//       if (!mounted) return;
//       await context.read<InfluencerProvider>().fetchPortfolio(userId);

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Image uploaded successfully!")),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error uploading image: $e")),
//       );
//     }
//   }

//   // ✅ Image source selection dialog
//   void _showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt, color: Color(0xFFB25640)),
//                 title: const Text('Take a Photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.camera);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library, color: Colors.blue),
//                 title: const Text('Choose from Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.gallery);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ✅ Load portfolio after first frame
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final id = context.read<AuthProvider>().currentUser?.id;
//       if (id != null) {
//         context.read<InfluencerProvider>().fetchPortfolio(id);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final portfolio = context.watch<InfluencerProvider>().portfolio;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Portfolio"),
//         backgroundColor: Color(0xFFB25640),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Color(0xFFB25640),
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
//                   child: Image.network(
//                     item['public_url'],
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) =>
//                         const Icon(Icons.broken_image, size: 50),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
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

//   // ✅ Ask for title & description before upload
//   Future<Map<String, String>?> _getPortfolioDetails() async {
//     final titleController = TextEditingController();
//     final descController = TextEditingController();

//     return await showDialog<Map<String, String>>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("New Portfolio Item"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: const InputDecoration(labelText: "Title"),
//               ),
//               TextField(
//                 controller: descController,
//                 decoration: const InputDecoration(labelText: "Description"),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFB25640)),
//               onPressed: () {
//                 if (titleController.text.isNotEmpty &&
//                     descController.text.isNotEmpty) {
//                   Navigator.pop(context, {
//                     'title': titleController.text,
//                     'description': descController.text,
//                   });
//                 }
//               },
//               child: const Text("Upload"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // ✅ Pick image and upload
//   Future<void> _pickImage(ImageSource source) async {
//     final authProvider = context.read<AuthProvider>();
//     final userId = authProvider.currentUser?.id;
//     if (userId == null) return;

//     try {
//       final XFile? pickedFile = await _picker.pickImage(source: source);
//       if (pickedFile == null) return;

//       // Ask for title & description
//       final details = await _getPortfolioDetails();
//       if (details == null) return;

//       final Uint8List bytes = await pickedFile.readAsBytes();

//       await InfluencerService().uploadPortfolioItem(
//         influencerId: userId,
//         bytes: bytes,
//         filename: pickedFile.name,
//         title: details['title']!,
//         description: details['description']!,
//       );

//       await context.read<InfluencerProvider>().fetchPortfolio(userId);
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Image uploaded successfully!")),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error uploading image: $e")),
//       );
//     }
//   }

//   // ✅ Edit item details
//   Future<void> _editItem(Map<String, dynamic> item) async {
//     final titleController = TextEditingController(text: item['title']);
//     final descController = TextEditingController(text: item['description']);

//     final result = await showDialog<Map<String, String>>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Edit Portfolio Item"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(labelText: "Title"),
//             ),
//             TextField(
//               controller: descController,
//               decoration: const InputDecoration(labelText: "Description"),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFB25640)),
//             onPressed: () {
//               Navigator.pop(context, {
//                 'title': titleController.text,
//                 'description': descController.text,
//               });
//             },
//             child: const Text("Save"),
//           ),
//         ],
//       ),
//     );

//     if (result != null) {
//       await InfluencerService().updatePortfolioItem(
//         itemId: item['id'],
//         title: result['title']!,
//         description: result['description']!,
//       );
//       final id = context.read<AuthProvider>().currentUser?.id;
//       if (id != null) {
//         await context.read<InfluencerProvider>().fetchPortfolio(id);
//       }
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Item updated successfully!")),
//       );
//     }
//   }

//   // ✅ Delete item
//   Future<void> _deleteItem(Map<String, dynamic> item) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Item"),
//         content: const Text("Are you sure you want to delete this item?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       await InfluencerService().deletePortfolioItem(item['id']);
//       final id = context.read<AuthProvider>().currentUser?.id;
//       if (id != null) {
//         await context.read<InfluencerProvider>().fetchPortfolio(id);
//       }
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Item deleted.")),
//       );
//     }
//   }

//   // ✅ Choose source
//   void _showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt, color: Color(0xFFB25640)),
//                 title: const Text('Take a Photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.camera);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library, color: Colors.blue),
//                 title: const Text('Choose from Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.gallery);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final id = context.read<AuthProvider>().currentUser?.id;
//       if (id != null) {
//         context.read<InfluencerProvider>().fetchPortfolio(id);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final portfolio = context.watch<InfluencerProvider>().portfolio;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Portfolio"),
//         backgroundColor: Color(0xFFB25640),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Color(0xFFB25640),
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
//                 childAspectRatio: 0.75,
//               ),
//               itemCount: portfolio.length,
//               itemBuilder: (_, i) {
//                 final item = portfolio[i];
//                 return GestureDetector(
//                   onLongPress: () => _showItemOptions(item),
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 3,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: ClipRRect(
//                             borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
//                             child: Image.network(
//                               item['public_url'],
//                               width: double.infinity,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, __, ___) =>
//                                   const Icon(Icons.broken_image, size: 50),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             item['title'] ?? '',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text(
//                             item['description'] ?? '',
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(fontSize: 12, color: Colors.grey),
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   // ✅ Show item options (edit / delete)
//   void _showItemOptions(Map<String, dynamic> item) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.edit, color: Colors.blue),
//               title: const Text("Edit"),
//               onTap: () {
//                 Navigator.pop(context);
//                 _editItem(item);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.delete, color: Colors.red),
//               title: const Text("Delete"),
//               onTap: () {
//                 Navigator.pop(context);
//                 _deleteItem(item);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:typed_data';
// import 'dart:io';
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

//   // ✅ Ask for title & description before uploading
//   Future<Map<String, String>?> _getTitleDescriptionDialog({
//     String? initialTitle,
//     String? initialDescription,
//   }) async {
//     final titleController = TextEditingController(text: initialTitle ?? '');
//     final descController = TextEditingController(text: initialDescription ?? '');

//     return await showDialog<Map<String, String>>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(initialTitle == null ? 'Add Portfolio Item' : 'Edit Portfolio Item'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(labelText: 'Title'),
//             ),
//             TextField(
//               controller: descController,
//               decoration: const InputDecoration(labelText: 'Description'),
//               maxLines: 3,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context, {
//                 'title': titleController.text.trim(),
//                 'description': descController.text.trim(),
//               });
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB25640)),
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }

//   // ✅ Pick image from camera or gallery and upload
//   Future<void> _pickImage(ImageSource source) async {
//     final authProvider = context.read<AuthProvider>();
//     final userId = authProvider.currentUser?.id;
//     if (userId == null) return;

//     try {
//       final XFile? pickedFile = await _picker.pickImage(source: source);
//       if (pickedFile == null) return;

//       final result = await _getTitleDescriptionDialog();
//       if (result == null) return;

//       final Uint8List bytes = await pickedFile.readAsBytes();

//       await InfluencerService().uploadPortfolioItem(
//         influencerId: userId,
//         bytes: bytes,
//         filename: pickedFile.name,
//         title: result['title'] ?? 'Untitled',
//         description: result['description'] ?? 'No description provided',
//       );

//       if (!mounted) return;
//       await context.read<InfluencerProvider>().fetchPortfolio(userId);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Portfolio item added successfully!")),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error: $e")));
//     }
//   }

//   // ✅ Show bottom sheet for camera/gallery
//   void _showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt, color: Color(0xFFB25640)),
//                 title: const Text('Take a Photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.camera);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library, color: Colors.blue),
//                 title: const Text('Choose from Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.gallery);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ✅ Edit existing item (title, description, and optionally image)
//   Future<void> _editItem(Map<String, dynamic> item) async {
//     final authProvider = context.read<AuthProvider>();
//     final userId = authProvider.currentUser?.id;
//     if (userId == null) return;

//     final result = await _getTitleDescriptionDialog(
//       initialTitle: item['title'] ?? '',
//       initialDescription: item['description'] ?? '',
//     );

//     if (result == null) return;

//     // Ask if user wants to replace image
//     bool changeImage = false;
//     File? newImage;
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Change Image?'),
//         content: const Text('Would you like to replace the image as well?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
//           TextButton(
//             onPressed: () async {
//               final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//               if (pickedFile != null) {
//                 newImage = File(pickedFile.path);
//                 changeImage = true;
//               }
//               Navigator.pop(context);
//             },
//             child: const Text('Yes'),
//           ),
//         ],
//       ),
//     );

//     await InfluencerService().updatePortfolioItem(
//       itemId: int.parse(item['id'].toString()),
//       influencerId: userId,
//       newBytes: changeImage ? await newImage!.readAsBytes() : null,
//       filename: changeImage ? newImage!.path.split('/').last : null,
//       title: result['title'] ?? 'Untitled',
//       description: result['description'] ?? 'No description provided',
//     );

//     await context.read<InfluencerProvider>().fetchPortfolio(userId);

//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Portfolio item updated successfully!")),
//     );
//   }

//   // ✅ Delete portfolio item
//   Future<void> _deleteItem(Map<String, dynamic> item) async {
//     final userId = context.read<AuthProvider>().currentUser?.id;
//     if (userId == null) return;

//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Item?"),
//         content: const Text("Are you sure you want to delete this item?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );

//     if (confirm != true) return;

//     await InfluencerService().deletePortfolioItem(int.parse(item['id'].toString()));

//     await context.read<InfluencerProvider>().fetchPortfolio(userId);

//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Item deleted successfully.")),
//     );
//   }

//   // ✅ Show options for edit/delete
//   void _showItemOptions(Map<String, dynamic> item) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.edit, color: Colors.blue),
//               title: const Text('Edit'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _editItem(item);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.delete, color: Colors.red),
//               title: const Text('Delete'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _deleteItem(item);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final id = context.read<AuthProvider>().currentUser?.id;
//       if (id != null) {
//         context.read<InfluencerProvider>().fetchPortfolio(id);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final portfolio = context.watch<InfluencerProvider>().portfolio;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Portfolio"),
//         backgroundColor: const Color(0xFFB25640),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFFB25640),
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
//                 childAspectRatio: 0.8,
//               ),
//               itemCount: portfolio.length,
//               itemBuilder: (_, i) {
//                 final item = portfolio[i];

//                 // Safely extract values
//                 final imageUrl = item['public_url'] ?? '';
//                 final title = item['title'] ?? 'Untitled';
//                 final description = item['description'] ?? 'No description available';

//                 return GestureDetector(
//                   onLongPress: () => _showItemOptions(item),
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     clipBehavior: Clip.antiAlias,
//                     elevation: 3,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: imageUrl.isNotEmpty
//                               ? Image.network(
//                                   imageUrl,
//                                   width: double.infinity,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (_, __, ___) =>
//                                       const Icon(Icons.broken_image, size: 60),
//                                 )
//                               : Container(
//                                   color: Colors.grey[300],
//                                   child: const Center(
//                                     child: Icon(Icons.image_not_supported, size: 50),
//                                   ),
//                                 ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             title,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text(
//                             description,
//                             style: const TextStyle(fontSize: 12, color: Colors.grey),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
// import 'dart:typed_data';
// import 'dart:io';
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

//   // ---------- Unified Add/Edit Dialog with Camera/Gallery ----------
//   Future<Map<String, dynamic>?> _getPortfolioDialog({
//     String? initialTitle,
//     String? initialDescription,
//     String? initialImageUrl,
//   }) async {
//     final titleController = TextEditingController(text: initialTitle ?? '');
//     final descController = TextEditingController(text: initialDescription ?? '');
//     File? pickedImage;

//     Future<void> _pickImage(ImageSource source) async {
//       final XFile? file = await _picker.pickImage(source: source);
//       if (file != null) {
//         setState(() {
//           pickedImage = File(file.path);
//         });
//       }
//     }

//     return await showDialog<Map<String, dynamic>>(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: Text(initialTitle == null ? 'Add Portfolio Item' : 'Edit Portfolio Item'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Title field
//                 TextField(
//                   controller: titleController,
//                   decoration: const InputDecoration(labelText: 'Title'),
//                 ),
//                 const SizedBox(height: 8),
//                 // Description field
//                 TextField(
//                   controller: descController,
//                   decoration: const InputDecoration(labelText: 'Description'),
//                   maxLines: 3,
//                 ),
//                 const SizedBox(height: 16),
//                 // Image preview and picker
//                 GestureDetector(
//                   onTap: () {
//                     showModalBottomSheet(
//                       context: context,
//                       builder: (_) => SafeArea(
//                         child: Wrap(
//                           children: [
//                             ListTile(
//                               leading: const Icon(Icons.camera_alt),
//                               title: const Text('Take a Photo'),
//                               onTap: () async {
//                                 Navigator.pop(context);
//                                 await _pickImage(ImageSource.camera);
//                               },
//                             ),
//                             ListTile(
//                               leading: const Icon(Icons.photo_library),
//                               title: const Text('Choose from Gallery'),
//                               onTap: () async {
//                                 Navigator.pop(context);
//                                 await _pickImage(ImageSource.gallery);
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                   child: pickedImage != null
//                       ? Image.file(pickedImage!, height: 150, fit: BoxFit.cover)
//                       : initialImageUrl != null
//                           ? Image.network(initialImageUrl, height: 150, fit: BoxFit.cover)
//                           : Container(
//                               height: 150,
//                               color: Colors.grey[300],
//                               child: const Center(
//                                 child: Icon(Icons.add_a_photo, size: 50),
//                               ),
//                             ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'Tap image to change',
//                   style: TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB25640)),
//               onPressed: () {
//                 Navigator.pop(context, {
//                   'title': titleController.text.trim(),
//                   'description': descController.text.trim(),
//                   'imageFile': pickedImage,
//                 });
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ---------- Add new portfolio item ----------
//   Future<void> _addPortfolio() async {
//     final authProvider = context.read<AuthProvider>();
//     final userId = authProvider.currentUser?.id;
//     if (userId == null) return;

//     final result = await _getPortfolioDialog();
//     if (result == null) return;

//     try {
//       final file = result['imageFile'] as File?;
//       if (file == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please select an image.")),
//         );
//         return;
//       }

//       final bytes = await file.readAsBytes();

//       await InfluencerService().uploadPortfolioItem(
//         influencerId: userId,
//         bytes: bytes,
//         filename: file.path.split('/').last,
//         title: result['title'] ?? 'Untitled',
//         description: result['description'] ?? 'No description provided',
//       );

//       await context.read<InfluencerProvider>().fetchPortfolio(userId);

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Portfolio item added successfully!")),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }

//   // ---------- Edit portfolio item ----------
//   Future<void> _editItem(Map<String, dynamic> item) async {
//     final authProvider = context.read<AuthProvider>();
//     final userId = authProvider.currentUser?.id;
//     if (userId == null) return;

//     final result = await _getPortfolioDialog(
//       initialTitle: item['title'],
//       initialDescription: item['description'],
//       initialImageUrl: item['public_url'],
//     );
//     if (result == null) return;

//     try {
//       final file = result['imageFile'] as File?;

//       await InfluencerService().updatePortfolioItem(
//         itemId: item['id'],
//         influencerId: userId,
//         newBytes: file != null ? await file.readAsBytes() : null,
//         filename: file != null ? file.path.split('/').last : null,
//         title: result['title'] ?? 'Untitled',
//         description: result['description'] ?? 'No description provided',
//       );

//       await context.read<InfluencerProvider>().fetchPortfolio(userId);

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Portfolio item updated successfully!")),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }

//   // ---------- Delete portfolio item ----------
//   Future<void> _deleteItem(Map<String, dynamic> item) async {
//     final userId = context.read<AuthProvider>().currentUser?.id;
//     if (userId == null) return;

//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Item?"),
//         content: const Text("Are you sure you want to delete this item?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );

//     if (confirm != true) return;

//     await InfluencerService().deletePortfolioItem(item['id']);
//     await context.read<InfluencerProvider>().fetchPortfolio(userId);

//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Item deleted successfully.")),
//     );
//   }

//   void _showItemOptions(Map<String, dynamic> item) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.edit, color: Colors.blue),
//               title: const Text('Edit'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _editItem(item);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.delete, color: Colors.red),
//               title: const Text('Delete'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _deleteItem(item);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final id = context.read<AuthProvider>().currentUser?.id;
//       if (id != null) {
//         context.read<InfluencerProvider>().fetchPortfolio(id);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final portfolio = context.watch<InfluencerProvider>().portfolio;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Portfolio"),
//         backgroundColor: const Color(0xFFB25640),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFFB25640),
//         onPressed: _addPortfolio,
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
//                 childAspectRatio: 0.8,
//               ),
//               itemCount: portfolio.length,
//               itemBuilder: (_, i) {
//                 final item = portfolio[i];
//                 final imageUrl = item['public_url'] ?? '';
//                 final title = item['title'] ?? 'Untitled';
//                 final description = item['description'] ?? 'No description available';

//                 return GestureDetector(
//                   onLongPress: () => _showItemOptions(item),
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     clipBehavior: Clip.antiAlias,
//                     elevation: 3,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: imageUrl.isNotEmpty
//                               ? Image.network(
//                                   imageUrl,
//                                   width: double.infinity,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (_, __, ___) =>
//                                       const Icon(Icons.broken_image, size: 60),
//                                 )
//                               : Container(
//                                   color: Colors.grey[300],
//                                   child: const Center(
//                                     child: Icon(Icons.image_not_supported, size: 50),
//                                   ),
//                                 ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             title,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text(
//                             description,
//                             style: const TextStyle(fontSize: 12, color: Colors.grey),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
// import 'dart:typed_data';
// import 'dart:io';
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

//   // ---------- Unified Add/Edit Dialog with Camera/Gallery ----------
//   Future<Map<String, dynamic>?> _getPortfolioDialog({
//     String? initialTitle,
//     String? initialDescription,
//     String? initialImageUrl,
//   }) async {
//     final titleController = TextEditingController(text: initialTitle ?? '');
//     final descController = TextEditingController(text: initialDescription ?? '');
//     File? pickedImage;

//     return await showDialog<Map<String, dynamic>>(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: Text(initialTitle == null ? 'Add Portfolio Item' : 'Edit Portfolio Item'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Title field
//                 TextField(
//                   controller: titleController,
//                   decoration: const InputDecoration(labelText: 'Title'),
//                 ),
//                 const SizedBox(height: 8),
//                 // Description field
//                 TextField(
//                   controller: descController,
//                   decoration: const InputDecoration(labelText: 'Description'),
//                   maxLines: 3,
//                 ),
//                 const SizedBox(height: 16),
//                 // Image picker
//                 GestureDetector(
//                   onTap: () {
//                     showModalBottomSheet(
//                       context: context,
//                       builder: (_) => SafeArea(
//                         child: Wrap(
//                           children: [
//                             ListTile(
//                               leading: const Icon(Icons.camera_alt),
//                               title: const Text('Take a Photo'),
//                               onTap: () async {
//                                 Navigator.pop(context);
//                                 final XFile? file = await _picker.pickImage(source: ImageSource.camera);
//                                 if (file != null) {
//                                   setState(() {
//                                     pickedImage = File(file.path);
//                                   });
//                                 }
//                               },
//                             ),
//                             ListTile(
//                               leading: const Icon(Icons.photo_library),
//                               title: const Text('Choose from Gallery'),
//                               onTap: () async {
//                                 Navigator.pop(context);
//                                 final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
//                                 if (file != null) {
//                                   setState(() {
//                                     pickedImage = File(file.path);
//                                   });
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     height: 150,
//                     width: double.infinity,
//                     color: Colors.grey[300],
//                     child: pickedImage != null
//                         ? Image.file(pickedImage!, fit: BoxFit.cover)
//                         : initialImageUrl != null
//                             ? Image.network(initialImageUrl, fit: BoxFit.cover)
//                             : const Center(
//                                 child: Icon(Icons.add_a_photo, size: 50),
//                               ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   pickedImage != null
//                       ? 'Tap to change image'
//                       : initialImageUrl != null
//                           ? 'Tap to change image'
//                           : 'Tap to add image',
//                   style: const TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB25640)),
//               onPressed: () {
//                 Navigator.pop(context, {
//                   'title': titleController.text.trim(),
//                   'description': descController.text.trim(),
//                   'imageFile': pickedImage,
//                 });
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ---------- Add or Edit portfolio ----------
//   Future<void> _addOrEditPortfolio({Map<String, dynamic>? item}) async {
//     final authProvider = context.read<AuthProvider>();
//     final userId = authProvider.currentUser?.id;
//     if (userId == null) return;

//     final result = await _getPortfolioDialog(
//       initialTitle: item != null ? item['title'] : null,
//       initialDescription: item != null ? item['description'] : null,
//       initialImageUrl: item != null ? item['public_url'] : null,
//     );

//     if (result == null) return;

//     try {
//       final file = result['imageFile'] as File?;
//       if (item == null && file == null) {
//         // New item requires image
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please select an image.")),
//         );
//         return;
//       }

//       if (item == null) {
//         // Add new
//         final bytes = await file!.readAsBytes();
//         await InfluencerService().uploadPortfolioItem(
//           influencerId: userId,
//           bytes: bytes,
//           filename: file.path.split('/').last,
//           title: result['title'] ?? 'Untitled',
//           description: result['description'] ?? 'No description provided',
//         );
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Portfolio item added successfully!")),
//         );
//       } else {
//         // Edit existing
//         await InfluencerService().updatePortfolioItem(
//           itemId: item['id'],
//           influencerId: userId,
//           newBytes: file != null ? await file.readAsBytes() : null,
//           filename: file != null ? file.path.split('/').last : null,
//           title: result['title'] ?? 'Untitled',
//           description: result['description'] ?? 'No description provided',
//         );
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Portfolio item updated successfully!")),
//         );
//       }

//       await context.read<InfluencerProvider>().fetchPortfolio(userId);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }

//   // ---------- Delete portfolio item ----------
//   Future<void> _deleteItem(Map<String, dynamic> item) async {
//     final userId = context.read<AuthProvider>().currentUser?.id;
//     if (userId == null) return;

//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Item?"),
//         content: const Text("Are you sure you want to delete this item?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );

//     if (confirm != true) return;

//     await InfluencerService().deletePortfolioItem(item['id']);
//     await context.read<InfluencerProvider>().fetchPortfolio(userId);

//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Item deleted successfully.")),
//     );
//   }

//   void _showItemOptions(Map<String, dynamic> item) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.edit, color: Colors.blue),
//               title: const Text('Edit'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _addOrEditPortfolio(item: item);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.delete, color: Colors.red),
//               title: const Text('Delete'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _deleteItem(item);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final id = context.read<AuthProvider>().currentUser?.id;
//       if (id != null) {
//         context.read<InfluencerProvider>().fetchPortfolio(id);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final portfolio = context.watch<InfluencerProvider>().portfolio;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Portfolio"),
//         backgroundColor: const Color(0xFFB25640),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFFB25640),
//         onPressed: () => _addOrEditPortfolio(),
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
//                 childAspectRatio: 0.8,
//               ),
//               itemCount: portfolio.length,
//               itemBuilder: (_, i) {
//                 final item = portfolio[i];
//                 final imageUrl = item['public_url'] ?? '';
//                 final title = item['title'] ?? 'Untitled';
//                 final description = item['description'] ?? 'No description available';

//                 return GestureDetector(
//                   onLongPress: () => _showItemOptions(item),
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     clipBehavior: Clip.antiAlias,
//                     elevation: 3,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: imageUrl.isNotEmpty
//                               ? Image.network(
//                                   imageUrl,
//                                   width: double.infinity,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (_, __, ___) =>
//                                       const Icon(Icons.broken_image, size: 60),
//                                 )
//                               : Container(
//                                   color: Colors.grey[300],
//                                   child: const Center(
//                                     child: Icon(Icons.image_not_supported, size: 50),
//                                   ),
//                                 ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             title,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text(
//                             description,
//                             style: const TextStyle(fontSize: 12, color: Colors.grey),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
// import 'dart:typed_data';
// import 'dart:io';
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

//   Future<Map<String, dynamic>?> _getPortfolioDialog({
//     String? initialTitle,
//     String? initialDescription,
//     String? initialImageUrl,
//   }) async {
//     final titleController = TextEditingController(text: initialTitle ?? '');
//     final descController = TextEditingController(text: initialDescription ?? '');
//     File? pickedImage;

//     return await showDialog<Map<String, dynamic>>(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           title: Text(initialTitle == null ? 'Add Portfolio Item' : 'Edit Portfolio Item'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: InputDecoration(
//                     labelText: 'Title',
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: descController,
//                   decoration: InputDecoration(
//                     labelText: 'Description',
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   maxLines: 3,
//                 ),
//                 const SizedBox(height: 16),
//                 GestureDetector(
//                   onTap: () {
//                     showModalBottomSheet(
//                       context: context,
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                       ),
//                       builder: (_) => SafeArea(
//                         child: Wrap(
//                           children: [
//                             ListTile(
//                               leading: const Icon(Icons.camera_alt),
//                               title: const Text('Take a Photo'),
//                               onTap: () async {
//                                 Navigator.pop(context);
//                                 final XFile? file = await _picker.pickImage(source: ImageSource.camera);
//                                 if (file != null) setState(() => pickedImage = File(file.path));
//                               },
//                             ),
//                             ListTile(
//                               leading: const Icon(Icons.photo_library),
//                               title: const Text('Choose from Gallery'),
//                               onTap: () async {
//                                 Navigator.pop(context);
//                                 final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
//                                 if (file != null) setState(() => pickedImage = File(file.path));
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     height: 160,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       color: Colors.grey[300],
//                       border: Border.all(color: Colors.grey.shade400),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       child: pickedImage != null
//                           ? Image.file(pickedImage!, fit: BoxFit.cover)
//                           : initialImageUrl != null
//                               ? Image.network(initialImageUrl, fit: BoxFit.cover)
//                               : const Center(child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey)),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   pickedImage != null || initialImageUrl != null
//                       ? 'Tap to change image'
//                       : 'Tap to add image',
//                   style: const TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFB25640),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               ),
//               onPressed: () {
//                 Navigator.pop(context, {
//                   'title': titleController.text.trim(),
//                   'description': descController.text.trim(),
//                   'imageFile': pickedImage,
//                 });
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _addOrEditPortfolio({Map<String, dynamic>? item}) async {
//     final authProvider = context.read<AuthProvider>();
//     final userId = authProvider.currentUser?.id;
//     if (userId == null) return;

//     final result = await _getPortfolioDialog(
//       initialTitle: item != null ? item['title'] : null,
//       initialDescription: item != null ? item['description'] : null,
//       initialImageUrl: item != null ? item['public_url'] : null,
//     );

//     if (result == null) return;

//     try {
//       final file = result['imageFile'] as File?;
//       if (item == null && file == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please select an image.")),
//         );
//         return;
//       }

//       if (item == null) {
//         final bytes = await file!.readAsBytes();
//         await InfluencerService().uploadPortfolioItem(
//           influencerId: userId,
//           bytes: bytes,
//           filename: file.path.split('/').last,
//           title: result['title'] ?? 'Untitled',
//           description: result['description'] ?? 'No description provided',
//         );
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Portfolio item added successfully!")),
//         );
//       } else {
//         await InfluencerService().updatePortfolioItem(
//           itemId: item['id'],
//           influencerId: userId,
//           newBytes: file != null ? await file.readAsBytes() : null,
//           filename: file != null ? file.path.split('/').last : null,
//           title: result['title'] ?? 'Untitled',
//           description: result['description'] ?? 'No description provided',
//         );
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Portfolio item updated successfully!")),
//         );
//       }

//       await context.read<InfluencerProvider>().fetchPortfolio(userId);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }

//   Future<void> _deleteItem(Map<String, dynamic> item) async {
//     final userId = context.read<AuthProvider>().currentUser?.id;
//     if (userId == null) return;

//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Item?"),
//         content: const Text("Are you sure you want to delete this item?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );

//     if (confirm != true) return;

//     await InfluencerService().deletePortfolioItem(item['id']);
//     await context.read<InfluencerProvider>().fetchPortfolio(userId);

//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Item deleted successfully.")),
//     );
//   }

//   void _showItemOptions(Map<String, dynamic> item) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.edit, color: Colors.blue),
//               title: const Text('Edit'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _addOrEditPortfolio(item: item);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.delete, color: Colors.red),
//               title: const Text('Delete'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _deleteItem(item);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final id = context.read<AuthProvider>().currentUser?.id;
//       if (id != null) context.read<InfluencerProvider>().fetchPortfolio(id);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final portfolio = context.watch<InfluencerProvider>().portfolio;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         title: const Text("My Portfolio",style: TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 20,
//             letterSpacing: -0.3,
//             color: Colors.white,
//           ),),
//         backgroundColor: const Color(0xFFB25640),
//         elevation: 4,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFFB25640),
//         onPressed: () => _addOrEditPortfolio(),
//         child: const Icon(Icons.add_a_photo, size: 28),
//       ),
//       body: portfolio.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   Icon(Icons.photo_library, size: 80, color: Colors.grey),
//                   SizedBox(height: 16),
//                   Text(
//                     "No portfolio items yet.\nTap + to add one!",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             )
//           : GridView.builder(
//               padding: const EdgeInsets.all(12),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 childAspectRatio: 0.75,
//               ),
//               itemCount: portfolio.length,
//               itemBuilder: (_, i) {
//                 final item = portfolio[i];
//                 final imageUrl = item['public_url'] ?? '';
//                 final title = item['title'] ?? 'Untitled';
//                 final description = item['description'] ?? 'No description available';

//                 return GestureDetector(
//                   onLongPress: () => _showItemOptions(item),
//                   child: Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFFB25640), Color(0xFFD98C70)],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               blurRadius: 8,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: imageUrl.isNotEmpty
//                               ? Image.network(
//                                   imageUrl,
//                                   width: double.infinity,
//                                   height: double.infinity,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (_, __, ___) =>
//                                       const Icon(Icons.broken_image, size: 60, color: Colors.white),
//                                 )
//                               : Container(
//                                   color: Colors.grey[300],
//                                   child: const Center(
//                                     child: Icon(Icons.image_not_supported, size: 50, color: Colors.white),
//                                   ),
//                                 ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         left: 0,
//                         right: 0,
//                         child: Container(
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.4),
//                             borderRadius: const BorderRadius.only(
//                               bottomLeft: Radius.circular(20),
//                               bottomRight: Radius.circular(20),
//                             ),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 title,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(height: 2),
//                               Text(
//                                 description,
//                                 style: const TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 11,
//                                 ),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/screens/influencer/PortfolioAddEditScreen.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = context.read<AuthProvider>().currentUser?.id;
      if (id != null) context.read<InfluencerProvider>().fetchPortfolio(id);
    });
  }

  Future<void> _deleteItem(Map<String, dynamic> item) async {
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Item?"),
        content: const Text("Are you sure you want to delete this item?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await InfluencerService().deletePortfolioItem(item['id']);
    await context.read<InfluencerProvider>().fetchPortfolio(userId);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Item deleted successfully.")),
    );
  }

  void _openAddEditScreen({Map<String, dynamic>? item}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PortfolioAddEditScreen(item: item),
      ),
    );

    if (result == true) {
      final userId = context.read<AuthProvider>().currentUser?.id;
      if (userId != null) {
        context.read<InfluencerProvider>().fetchPortfolio(userId);
      }
    }
  }

  void _showItemOptions(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _openAddEditScreen(item: item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _deleteItem(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final portfolio = context.watch<InfluencerProvider>().portfolio;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          "My Portfolio",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.3,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFB25640),
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFB25640),
        onPressed: () => _openAddEditScreen(),
        child: const Icon(Icons.add_a_photo, size: 28),
      ),
      body: portfolio.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.photo_library, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No portfolio items yet.\nTap + to add one!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: portfolio.length,
              itemBuilder: (_, i) {
                final item = portfolio[i];
                final imageUrl = item['public_url'] ?? '';
                final title = item['title'] ?? 'Untitled';
                final description = item['description'] ?? 'No description available';

                return GestureDetector(
                  onLongPress: () => _showItemOptions(item),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB25640), Color(0xFFD98C70)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image, size: 60, color: Colors.white),
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported, size: 50, color: Colors.white),
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                description,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
