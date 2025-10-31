
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '../../providers/influencer_provider.dart';
// import '../../models/influencer_model.dart';

// class EditInfluencerProfile extends StatefulWidget {
//   const EditInfluencerProfile({super.key});

//   @override
//   State<EditInfluencerProfile> createState() => _EditInfluencerProfileState();
// }

// class _EditInfluencerProfileState extends State<EditInfluencerProfile> {
//   final _nameController = TextEditingController();
//   final _bioController = TextEditingController();
//   final _nicheController = TextEditingController();
//   final _followersController = TextEditingController();
//   final _engagementController = TextEditingController();
//   final _instagramController = TextEditingController();
//   final _tiktokController = TextEditingController();
//   final _youtubeController = TextEditingController();

//   Uint8List? _newProfileImage;

//   @override
//   void initState() {
//     super.initState();
//     final influencer = context.read<InfluencerProvider>().influencer;
//     if (influencer != null) {
//       _nameController.text = influencer.name ?? '';
//       _bioController.text = influencer.bio ?? '';
//       _nicheController.text = influencer.niche ?? '';
//       _followersController.text = influencer.followerCount?.toString() ?? '';
//       _engagementController.text = influencer.engagementRate?.toString() ?? '';
//       _instagramController.text = influencer.instagramUrl ?? '';
//       _tiktokController.text = influencer.tiktokUrl ?? '';
//       _youtubeController.text = influencer.youtubeUrl ?? '';
//     }
//   }

//   Future<void> _pickImage() async {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text("Choose from Gallery"),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickFromSource(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text("Take a Photo"),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickFromSource(ImageSource.camera);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickFromSource(ImageSource source) async {
//     try {
//       final picker = ImagePicker();
//       final result = await picker.pickImage(source: source, imageQuality: 80);
//       if (result != null) {
//         final bytes = await result.readAsBytes();
//         setState(() => _newProfileImage = bytes);

//         // Upload immediately
//         final provider = context.read<InfluencerProvider>();
//         final influencer = provider.influencer;
//         if (influencer != null) {
//           final url = await provider.uploadProfileImage(influencer.id, bytes);
//           if (url != null && mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Profile image uploaded successfully!")),
//             );
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint("❌ Image pick/upload error: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to upload image.")),
//         );
//       }
//     }
//   }

//   Future<void> _saveProfile() async {
//     final provider = context.read<InfluencerProvider>();
//     final influencer = provider.influencer;
//     if (influencer == null) return;

//     final updated = influencer.copyWith(
//       name: _nameController.text.trim(),
//       bio: _bioController.text.trim(),
//       niche: _nicheController.text.trim(),
//       followerCount: int.tryParse(_followersController.text.trim()),
//       engagementRate: double.tryParse(_engagementController.text.trim()),
//       instagramUrl: _instagramController.text.trim(),
//       tiktokUrl: _tiktokController.text.trim(),
//       youtubeUrl: _youtubeController.text.trim(),
//     );

//     await provider.updateInfluencer(updated);

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Profile saved successfully!")),
//       );
//       Navigator.pop(context);
//     }
//   }

//   Widget _buildField(TextEditingController controller, String label,
//       {TextInputType keyboard = TextInputType.text}) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboard,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final influencer = context.watch<InfluencerProvider>().influencer;
//     final profileImage = _newProfileImage != null
//         ? MemoryImage(_newProfileImage!)
//         : (influencer?.profileImage != null
//             ? NetworkImage(influencer!.profileImage!)
//             : null);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Profile")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.grey[300],
//                 backgroundImage: profileImage as ImageProvider<Object>?,
//                 child: profileImage == null
//                     ? const Icon(Icons.person, size: 50, color: Colors.white)
//                     : null,
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildField(_nameController, "Full Name"),
//             const SizedBox(height: 10),
//             _buildField(_bioController, "Bio"),
//             const SizedBox(height: 10),
//             _buildField(_nicheController, "Niche"),
//             const SizedBox(height: 10),
//             _buildField(_followersController, "Followers",
//                 keyboard: TextInputType.number),
//             const SizedBox(height: 10),
//             _buildField(_engagementController, "Engagement Rate (%)",
//                 keyboard: TextInputType.number),
//             const SizedBox(height: 10),
//             _buildField(_instagramController, "Instagram URL"),
//             const SizedBox(height: 10),
//             _buildField(_tiktokController, "TikTok URL"),
//             const SizedBox(height: 10),
//             _buildField(_youtubeController, "YouTube URL"),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _saveProfile,
//                 child: const Text("Save Profile"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '../../providers/influencer_provider.dart';
// import '../../models/influencer_model.dart';

// class EditInfluencerProfile extends StatefulWidget {
//   const EditInfluencerProfile({super.key});

//   @override
//   State<EditInfluencerProfile> createState() => _EditInfluencerProfileState();
// }

// class _EditInfluencerProfileState extends State<EditInfluencerProfile> {
//   final _nameController = TextEditingController();
//   final _bioController = TextEditingController();
//   final _nicheController = TextEditingController();
//   final _followersController = TextEditingController();
//   final _engagementController = TextEditingController();
//   final _instagramController = TextEditingController();
//   final _tiktokController = TextEditingController();
//   final _youtubeController = TextEditingController();

//   Uint8List? _newProfileImage;

//   @override
//   void initState() {
//     super.initState();
//     final influencer = context.read<InfluencerProvider>().influencer;
//     if (influencer != null) {
//       _nameController.text = influencer.name ?? '';
//       _bioController.text = influencer.bio ?? '';
//       _nicheController.text = influencer.niche ?? '';
//       _followersController.text = influencer.followerCount?.toString() ?? '';
//       _engagementController.text = influencer.engagementRate?.toString() ?? '';
//       _instagramController.text = influencer.instagramUrl ?? '';
//       _tiktokController.text = influencer.tiktokUrl ?? '';
//       _youtubeController.text = influencer.youtubeUrl ?? '';
//     }
//   }

//   Future<void> _pickImage() async {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text("Choose from Gallery"),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickFromSource(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text("Take a Photo"),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickFromSource(ImageSource.camera);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickFromSource(ImageSource source) async {
//     try {
//       final picker = ImagePicker();
//       final result = await picker.pickImage(source: source, imageQuality: 80);
//       if (result != null) {
//         final bytes = await result.readAsBytes();
//         setState(() => _newProfileImage = bytes);

//         final provider = context.read<InfluencerProvider>();
//         final influencer = provider.influencer;
//         if (influencer != null) {
//           final url = await provider.uploadProfileImage(influencer.id, bytes);
//           if (url != null && mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Profile image uploaded successfully!")),
//             );
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint("❌ Image pick/upload error: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to upload image.")),
//         );
//       }
//     }
//   }

//   Future<void> _saveProfile() async {
//     final provider = context.read<InfluencerProvider>();
//     final influencer = provider.influencer;
//     if (influencer == null) return;

//     final updated = influencer.copyWith(
//       name: _nameController.text.trim(),
//       bio: _bioController.text.trim(),
//       niche: _nicheController.text.trim(),
//       followerCount: int.tryParse(_followersController.text.trim()),
//       engagementRate: double.tryParse(_engagementController.text.trim()),
//       instagramUrl: _instagramController.text.trim(),
//       tiktokUrl: _tiktokController.text.trim(),
//       youtubeUrl: _youtubeController.text.trim(),
//     );

//     await provider.updateInfluencer(updated);

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Profile saved successfully!")),
//       );
//       Navigator.pop(context);
//     }
//   }

//   Widget _buildField(TextEditingController controller, String label,
//       {TextInputType keyboard = TextInputType.text}) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboard,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Widget _buildConnectButton(String platform, VoidCallback onTap) {
//     Color color;
//     IconData icon;
//     switch (platform) {
//       case 'Instagram':
//         color = Colors.pink;
//         icon = Icons.camera_alt;
//         break;
//       case 'TikTok':
//         color = Colors.black;
//         icon = Icons.music_note;
//         break;
//       case 'YouTube':
//         color = Colors.red;
//         icon = Icons.play_arrow;
//         break;
//       default:
//         color = Colors.grey;
//         icon = Icons.link;
//     }

//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(backgroundColor: color),
//       onPressed: onTap,
//       icon: Icon(icon),
//       label: Text("Connect $platform"),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final influencer = context.watch<InfluencerProvider>().influencer;
//     final profileImage = _newProfileImage != null
//         ? MemoryImage(_newProfileImage!)
//         : (influencer?.profileImage != null
//             ? NetworkImage(influencer!.profileImage!)
//             : null);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Profile")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.grey[300],
//                 backgroundImage: profileImage as ImageProvider<Object>?,
//                 child: profileImage == null
//                     ? const Icon(Icons.person, size: 50, color: Colors.white)
//                     : null,
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildField(_nameController, "Full Name"),
//             const SizedBox(height: 10),
//             _buildField(_bioController, "Bio"),
//             const SizedBox(height: 10),
//             _buildField(_nicheController, "Niche"),
//             const SizedBox(height: 10),
//             _buildField(_followersController, "Followers",
//                 keyboard: TextInputType.number),
//             const SizedBox(height: 10),
//             _buildField(_engagementController, "Engagement Rate (%)",
//                 keyboard: TextInputType.number),
//             const SizedBox(height: 10),
//             _buildField(_instagramController, "Instagram URL"),
//             _buildField(_tiktokController, "TikTok URL"),
//             _buildField(_youtubeController, "YouTube URL"),
//             const SizedBox(height: 20),

//             // Social Connect Buttons Section
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Connect Social Accounts",
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//             ),
//             const SizedBox(height: 10),
//             _buildConnectButton("Instagram", () async {
//               // TODO: Trigger Instagram OAuth / API fetch
//               ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Connect Instagram clicked")));
//             }),
//             const SizedBox(height: 10),
//             _buildConnectButton("TikTok", () async {
//               // TODO: Trigger TikTok OAuth / API fetch
//               ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Connect TikTok clicked")));
//             }),
//             const SizedBox(height: 10),
//             _buildConnectButton("YouTube", () async {
//               // TODO: Trigger YouTube OAuth / API fetch
//               ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Connect YouTube clicked")));
//             }),
//             const SizedBox(height: 20),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _saveProfile,
//                 child: const Text("Save Profile"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// correct code above//
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '../../providers/influencer_provider.dart';
// import '../../models/influencer_model.dart';

// class EditInfluencerProfile extends StatefulWidget {
//   const EditInfluencerProfile({super.key});

//   @override
//   State<EditInfluencerProfile> createState() => _EditInfluencerProfileState();
// }

// class _EditInfluencerProfileState extends State<EditInfluencerProfile> {
//   final _nameController = TextEditingController();
//   final _bioController = TextEditingController();
//   final _nicheController = TextEditingController();
//   final _followersController = TextEditingController();
//   final _engagementController = TextEditingController();
//   final _instagramController = TextEditingController();
//   final _tiktokController = TextEditingController();
//   final _youtubeController = TextEditingController();

//   Uint8List? _newProfileImage;

//   @override
//   void initState() {
//     super.initState();
//     final influencer = context.read<InfluencerProvider>().influencer;
//     if (influencer != null) {
//       _nameController.text = influencer.name ?? '';
//       _bioController.text = influencer.bio ?? '';
//       _nicheController.text = influencer.niche ?? '';
//       _followersController.text = influencer.followerCount?.toString() ?? '';
//       _engagementController.text = influencer.engagementRate?.toString() ?? '';
//       _instagramController.text = influencer.instagramUrl ?? '';
//       _tiktokController.text = influencer.tiktokUrl ?? '';
//       _youtubeController.text = influencer.youtubeUrl ?? '';
//     }
//   }

//   Future<void> _pickImage() async {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text("Choose from Gallery"),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickFromSource(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text("Take a Photo"),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickFromSource(ImageSource.camera);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickFromSource(ImageSource source) async {
//     try {
//       final picker = ImagePicker();
//       final result = await picker.pickImage(source: source, imageQuality: 80);
//       if (result != null) {
//         final bytes = await result.readAsBytes();
//         setState(() => _newProfileImage = bytes);

//         final provider = context.read<InfluencerProvider>();
//         final influencer = provider.influencer;
//         if (influencer != null) {
//           final url = await provider.uploadProfileImage(influencer.id, bytes);
//           if (url != null && mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Profile image uploaded successfully!")),
//             );
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint("❌ Image pick/upload error: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to upload image.")),
//         );
//       }
//     }
//   }

//   Future<void> _saveProfile() async {
//     final provider = context.read<InfluencerProvider>();
//     final influencer = provider.influencer;
//     if (influencer == null) return;

//     final updated = influencer.copyWith(
//       name: _nameController.text.trim(),
//       bio: _bioController.text.trim(),
//       niche: _nicheController.text.trim(),
//       followerCount: int.tryParse(_followersController.text.trim()),
//       engagementRate: double.tryParse(_engagementController.text.trim()),
//       instagramUrl: _instagramController.text.trim(),
//       tiktokUrl: _tiktokController.text.trim(),
//       youtubeUrl: _youtubeController.text.trim(),
//     );

//     await provider.updateInfluencer(updated);

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Profile saved successfully!")),
//       );
//       Navigator.pop(context);
//     }
//   }

//   Widget _buildField(TextEditingController controller, String label,
//       {TextInputType keyboard = TextInputType.text}) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboard,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Widget _buildConnectButton(String platform, VoidCallback onTap) {
//     Color color;
//     IconData icon;
//     switch (platform) {
//       case 'Instagram':
//         color = Colors.pink;
//         icon = Icons.camera_alt;
//         break;
//       case 'TikTok':
//         color = Colors.black;
//         icon = Icons.music_note;
//         break;
//       case 'YouTube':
//         color = Colors.red;
//         icon = Icons.play_arrow;
//         break;
//       default:
//         color = Colors.grey;
//         icon = Icons.link;
//     }

//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(backgroundColor: color),
//       onPressed: onTap,
//       icon: Icon(icon),
//       label: Text("Connect $platform"),
//     );
//   }

//   // =========================
//   // ✅ Social Connect Methods
//   // =========================
//   Future<void> _connectInstagram() async {
//     final provider = context.read<InfluencerProvider>();
//     final influencer = provider.influencer;
//     if (influencer == null) return;

//     // TODO: Replace below with real OAuth / API token
//     const mockToken = "instagram_oauth_token_example";

//     await provider.connectInstagram(influencer.id, mockToken);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Instagram connected successfully!")),
//     );
//   }

//   Future<void> _connectTikTok() async {
//     final provider = context.read<InfluencerProvider>();
//     final influencer = provider.influencer;
//     if (influencer == null) return;

//     const mockToken = "tiktok_oauth_token_example";

//     await provider.connectTikTok(influencer.id, mockToken);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("TikTok connected successfully!")),
//     );
//   }

//   Future<void> _connectYouTube() async {
//     final provider = context.read<InfluencerProvider>();
//     final influencer = provider.influencer;
//     if (influencer == null) return;

//     const mockToken = "youtube_oauth_token_example";

//     await provider.connectYouTube(influencer.id, mockToken);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("YouTube connected successfully!")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final influencer = context.watch<InfluencerProvider>().influencer;
//     final profileImage = _newProfileImage != null
//         ? MemoryImage(_newProfileImage!)
//         : (influencer?.profileImage != null
//             ? NetworkImage(influencer!.profileImage!)
//             : null);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Profile")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.grey[300],
//                 backgroundImage: profileImage as ImageProvider<Object>?,
//                 child: profileImage == null
//                     ? const Icon(Icons.person, size: 50, color: Colors.white)
//                     : null,
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildField(_nameController, "Full Name"),
//             const SizedBox(height: 10),
//             _buildField(_bioController, "Bio"),
//             const SizedBox(height: 10),
//             _buildField(_nicheController, "Niche"),
//             const SizedBox(height: 10),
//             _buildField(_followersController, "Followers",
//                 keyboard: TextInputType.number),
//             const SizedBox(height: 10),
//             _buildField(_engagementController, "Engagement Rate (%)",
//                 keyboard: TextInputType.number),
//             const SizedBox(height: 10),
//             _buildField(_instagramController, "Instagram URL"),
//             _buildField(_tiktokController, "TikTok URL"),
//             _buildField(_youtubeController, "YouTube URL"),
//             const SizedBox(height: 20),

//             // Social Connect Buttons Section
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Connect Social Accounts",
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//             ),
//             const SizedBox(height: 10),
//             _buildConnectButton("Instagram", _connectInstagram),
//             const SizedBox(height: 10),
//             _buildConnectButton("TikTok", _connectTikTok),
//             const SizedBox(height: 10),
//             _buildConnectButton("YouTube", _connectYouTube),
//             const SizedBox(height: 20),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _saveProfile,
//                 child: const Text("Save Profile"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '../../providers/influencer_provider.dart';
// import '../../models/influencer_model.dart';
// import '../../services/youtube_service.dart'; // ✅ Add this import

// class EditInfluencerProfile extends StatefulWidget {
//   const EditInfluencerProfile({super.key});

//   @override
//   State<EditInfluencerProfile> createState() => _EditInfluencerProfileState();
// }

// class _EditInfluencerProfileState extends State<EditInfluencerProfile> {
//   final _nameController = TextEditingController();
//   final _bioController = TextEditingController();
//   final _nicheController = TextEditingController();
//   final _followersController = TextEditingController();
//   final _engagementController = TextEditingController();
//   final _instagramController = TextEditingController();
//   final _tiktokController = TextEditingController();
//   final _youtubeController = TextEditingController();

//   Uint8List? _newProfileImage;

//   @override
//   void initState() {
//     super.initState();
//     final influencer = context.read<InfluencerProvider>().influencer;
//     if (influencer != null) {
//       _nameController.text = influencer.name ?? '';
//       _bioController.text = influencer.bio ?? '';
//       _nicheController.text = influencer.niche ?? '';
//       _followersController.text = influencer.followerCount?.toString() ?? '';
//       _engagementController.text = influencer.engagementRate?.toString() ?? '';
//       _instagramController.text = influencer.instagramUrl ?? '';
//       _tiktokController.text = influencer.tiktokUrl ?? '';
//       _youtubeController.text = influencer.youtubeUrl ?? '';
//     }
//   }

//   Future<void> _pickImage() async {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text("Choose from Gallery"),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickFromSource(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text("Take a Photo"),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickFromSource(ImageSource.camera);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickFromSource(ImageSource source) async {
//     try {
//       final picker = ImagePicker();
//       final result = await picker.pickImage(source: source, imageQuality: 80);
//       if (result != null) {
//         final bytes = await result.readAsBytes();
//         setState(() => _newProfileImage = bytes);

//         final provider = context.read<InfluencerProvider>();
//         final influencer = provider.influencer;
//         if (influencer != null) {
//           final url = await provider.uploadProfileImage(influencer.id, bytes);
//           if (url != null && mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Profile image uploaded successfully!")),
//             );
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint("❌ Image pick/upload error: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to upload image.")),
//         );
//       }
//     }
//   }

//   Future<void> _saveProfile() async {
//     final provider = context.read<InfluencerProvider>();
//     final influencer = provider.influencer;
//     if (influencer == null) return;

//     final updated = influencer.copyWith(
//       name: _nameController.text.trim(),
//       bio: _bioController.text.trim(),
//       niche: _nicheController.text.trim(),
//       followerCount: int.tryParse(_followersController.text.trim()),
//       engagementRate: double.tryParse(_engagementController.text.trim()),
//       instagramUrl: _instagramController.text.trim(),
//       tiktokUrl: _tiktokController.text.trim(),
//       youtubeUrl: _youtubeController.text.trim(),
//     );

//     await provider.updateInfluencer(updated);

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Profile saved successfully!")),
//       );
//       Navigator.pop(context);
//     }
//   }

//   Widget _buildField(TextEditingController controller, String label,
//       {TextInputType keyboard = TextInputType.text}) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboard,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Widget _buildConnectButton(String platform, VoidCallback onTap) {
//     Color color;
//     IconData icon;
//     switch (platform) {
//       case 'Instagram':
//         color = Colors.pink;
//         icon = Icons.camera_alt;
//         break;
//       case 'TikTok':
//         color = Colors.black;
//         icon = Icons.music_note;
//         break;
//       case 'YouTube':
//         color = Colors.red;
//         icon = Icons.play_arrow;
//         break;
//       default:
//         color = Colors.grey;
//         icon = Icons.link;
//     }

//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(backgroundColor: color),
//       onPressed: onTap,
//       icon: Icon(icon),
//       label: Text("Connect $platform"),
//     );
//   }

//   // =========================
//   // ✅ Social Connect Methods
//   // =========================
//   Future<void> _connectInstagram() async {
//     final provider = context.read<InfluencerProvider>();
//     final influencer = provider.influencer;
//     if (influencer == null) return;

//     const mockToken = "instagram_oauth_token_example";
//     await provider.connectInstagram(influencer.id, mockToken);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Instagram connected successfully!")),
//     );
//   }

//   Future<void> _connectTikTok() async {
//     final provider = context.read<InfluencerProvider>();
//     final influencer = provider.influencer;
//     if (influencer == null) return;

//     const mockToken = "tiktok_oauth_token_example";
//     await provider.connectTikTok(influencer.id, mockToken);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("TikTok connected successfully!")),
//     );
//   }

//   // ✅ Updated YouTube Connect Implementation
//   Future<void> _connectYouTube() async {
//     final youTubeService = YouTubeService();
//     final data = await youTubeService.connectYouTube();

//     if (data != null) {
//       final provider = context.read<InfluencerProvider>();
//       final influencer = provider.influencer;

//       if (influencer != null) {
//         final updated = influencer.copyWith(
//           youtubeUrl: "https://www.youtube.com/channel/${data['channelId']}",
//         );
//         await provider.updateInfluencer(updated);
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Connected YouTube: ${data['title']}")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to connect YouTube")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final influencer = context.watch<InfluencerProvider>().influencer;
//     final profileImage = _newProfileImage != null
//         ? MemoryImage(_newProfileImage!)
//         : (influencer?.profileImage != null
//             ? NetworkImage(influencer!.profileImage!)
//             : null);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Profile")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.grey[300],
//                 backgroundImage: profileImage as ImageProvider<Object>?,
//                 child: profileImage == null
//                     ? const Icon(Icons.person, size: 50, color: Colors.white)
//                     : null,
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildField(_nameController, "Full Name"),
//             const SizedBox(height: 10),
//             _buildField(_bioController, "Bio"),
//             const SizedBox(height: 10),
//             _buildField(_nicheController, "Niche"),
//             const SizedBox(height: 10),
//             _buildField(_followersController, "Followers",
//                 keyboard: TextInputType.number),
//             const SizedBox(height: 10),
//             _buildField(_engagementController, "Engagement Rate (%)",
//                 keyboard: TextInputType.number),
//             const SizedBox(height: 10),
//             _buildField(_instagramController, "Instagram URL"),
//             _buildField(_tiktokController, "TikTok URL"),
//             _buildField(_youtubeController, "YouTube URL"),
//             const SizedBox(height: 20),

//             // Social Connect Buttons Section
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Connect Social Accounts",
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//             ),
//             const SizedBox(height: 10),
//             _buildConnectButton("Instagram", _connectInstagram),
//             const SizedBox(height: 10),
//             _buildConnectButton("TikTok", _connectTikTok),
//             const SizedBox(height: 10),
//             _buildConnectButton("YouTube", _connectYouTube),
//             const SizedBox(height: 20),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _saveProfile,
//                 child: const Text("Save Profile"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '../../providers/influencer_provider.dart';
// import '../../models/influencer_model.dart';
// import '../../services/youtube_service.dart';

// class EditInfluencerProfile extends StatefulWidget {
//   const EditInfluencerProfile({super.key});

//   @override
//   State<EditInfluencerProfile> createState() => _EditInfluencerProfileState();
// }

// class _EditInfluencerProfileState extends State<EditInfluencerProfile> {
//   final _nameController = TextEditingController();
//   final _bioController = TextEditingController();
//   final _nicheController = TextEditingController();
//   final _followersController = TextEditingController();
//   final _engagementController = TextEditingController();
//   final _instagramController = TextEditingController();
//   final _tiktokController = TextEditingController();
//   final _youtubeController = TextEditingController();

//   Uint8List? _newProfileImage;

//   @override
//   void initState() {
//     super.initState();
//     final influencer = context.read<InfluencerProvider>().influencer;
//     if (influencer != null) {
//       _nameController.text = influencer.name ?? '';
//       _bioController.text = influencer.bio ?? '';
//       _nicheController.text = influencer.niche ?? '';
//       _followersController.text = influencer.followerCount?.toString() ?? '';
//       _engagementController.text = influencer.engagementRate?.toString() ?? '';
//       _instagramController.text = influencer.instagramUrl ?? '';
//       _tiktokController.text = influencer.tiktokUrl ?? '';
//       _youtubeController.text = influencer.youtubeUrl ?? '';
//     }
//   }

//   Future<void> _pickImage() async {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text("Choose from Gallery"),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickFromSource(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text("Take a Photo"),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickFromSource(ImageSource.camera);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickFromSource(ImageSource source) async {
//     try {
//       final picker = ImagePicker();
//       final result = await picker.pickImage(source: source, imageQuality: 80);
//       if (result != null) {
//         final bytes = await result.readAsBytes();
//         setState(() => _newProfileImage = bytes);

//         final provider = context.read<InfluencerProvider>();
//         final influencer = provider.influencer;
//         if (influencer != null) {
//           final url = await provider.uploadProfileImage(influencer.id, bytes);
//           if (url != null && mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Profile image uploaded successfully!")),
//             );
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint("❌ Image pick/upload error: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to upload image.")),
//         );
//       }
//     }
//   }

//   Future<void> _saveProfile() async {
//     final provider = context.read<InfluencerProvider>();
//     final influencer = provider.influencer;
//     if (influencer == null) return;

//     final updated = influencer.copyWith(
//       name: _nameController.text.trim(),
//       bio: _bioController.text.trim(),
//       niche: _nicheController.text.trim(),
//       followerCount: int.tryParse(_followersController.text.trim()),
//       engagementRate: double.tryParse(_engagementController.text.trim()),
//       instagramUrl: _instagramController.text.trim(),
//       tiktokUrl: _tiktokController.text.trim(),
//       youtubeUrl: _youtubeController.text.trim(),
//     );

//     await provider.updateInfluencer(updated);

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Profile saved successfully!")),
//       );
//       Navigator.pop(context);
//     }
//   }

//   Widget _buildField(TextEditingController controller, String label,
//       {TextInputType keyboard = TextInputType.text}) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboard,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Widget _buildConnectButton(String platform, VoidCallback onTap) {
//     Color color;
//     IconData icon;
//     switch (platform) {
//       case 'Instagram':
//         color = Colors.pink;
//         icon = Icons.camera_alt;
//         break;
//       case 'TikTok':
//         color = Colors.black;
//         icon = Icons.music_note;
//         break;
//       case 'YouTube':
//         color = Colors.red;
//         icon = Icons.play_arrow;
//         break;
//       default:
//         color = Colors.grey;
//         icon = Icons.link;
//     }

//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         minimumSize: const Size(double.infinity, 48),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       onPressed: onTap,
//       icon: Icon(icon, color: Colors.white),
//       label: Text(
//         "Connect $platform",
//         style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//       ),
//     );
//   }

//   // =========================
//   // ✅ Social Connect Methods
//   // =========================
//   Future<void> _connectInstagram() async {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Instagram integration coming soon.")),
//     );
//   }

//   Future<void> _connectTikTok() async {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("TikTok integration coming soon.")),
//     );
//   }

//   /// ✅ YouTube Connect Implementation (with OAuth)
//   Future<void> _connectYouTube() async {
//     final youTubeService = YouTubeService();
//     final data = await youTubeService.connectYouTube();

//     if (data != null) {
//       final provider = context.read<InfluencerProvider>();
//       final influencer = provider.influencer;

//       if (influencer != null) {
//         final updated = influencer.copyWith(
//           youtubeUrl: "https://www.youtube.com/channel/${data['channelId']}",
//           youtubeToken: data['accessToken'], // ✅ Save token
//         );
//         await provider.updateInfluencer(updated);
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Connected YouTube: ${data['title']}")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to connect YouTube.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final influencer = context.watch<InfluencerProvider>().influencer;
//     final profileImage = _newProfileImage != null
//         ? MemoryImage(_newProfileImage!)
//         : (influencer?.profileImage != null
//             ? NetworkImage(influencer!.profileImage!)
//             : null);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Profile")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.grey[300],
//                 backgroundImage: profileImage as ImageProvider<Object>?,
//                 child: profileImage == null
//                     ? const Icon(Icons.person, size: 50, color: Colors.white)
//                     : null,
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildField(_nameController, "Full Name"),
//             const SizedBox(height: 10),
//             _buildField(_bioController, "Bio"),
//             const SizedBox(height: 10),
//             _buildField(_nicheController, "Niche"),
//             const SizedBox(height: 10),
//             _buildField(_followersController, "Followers",
//                 keyboard: TextInputType.number),
//             const SizedBox(height: 10),
//             _buildField(_engagementController, "Engagement Rate (%)",
//                 keyboard: TextInputType.number),
//             const SizedBox(height: 10),
//             _buildField(_instagramController, "Instagram URL"),
//             const SizedBox(height: 10),
//             _buildField(_tiktokController, "TikTok URL"),
//             const SizedBox(height: 10),
//             _buildField(_youtubeController, "YouTube URL"),
//             const SizedBox(height: 20),

//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Connect Social Accounts",
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//             ),
//             const SizedBox(height: 10),
//             _buildConnectButton("Instagram", _connectInstagram),
//             const SizedBox(height: 10),
//             _buildConnectButton("TikTok", _connectTikTok),
//             const SizedBox(height: 10),
//             _buildConnectButton("YouTube", _connectYouTube),
//             const SizedBox(height: 30),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _saveProfile,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 child: const Text(
//                   "Save Profile",
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '../../providers/influencer_provider.dart';
// import '../../models/influencer_model.dart';
// import '../../services/youtube_service.dart';

// class EditInfluencerProfile extends StatefulWidget {
//   const EditInfluencerProfile({super.key});

//   @override
//   State<EditInfluencerProfile> createState() => _EditInfluencerProfileState();
// }

// class _EditInfluencerProfileState extends State<EditInfluencerProfile> {
//   final _nameController = TextEditingController();
//   final _bioController = TextEditingController();
//   final _nicheController = TextEditingController();
//   final _followersController = TextEditingController();
//   final _engagementController = TextEditingController();
//   final _instagramController = TextEditingController();
//   final _tiktokController = TextEditingController();
//   final _youtubeController = TextEditingController();

//   Uint8List? _newProfileImage;

//   @override
//   void initState() {
//     super.initState();
//     _loadInfluencerData();
//   }

//   void _loadInfluencerData() {
//     final influencer = context.read<InfluencerProvider>().influencer;
//     if (influencer != null) {
//       _nameController.text = influencer.name ?? '';
//       _bioController.text = influencer.bio ?? '';
//       _nicheController.text = influencer.niche ?? '';
//       _followersController.text = influencer.followerCount?.toString() ?? '';
//       _engagementController.text = influencer.engagementRate?.toString() ?? '';
//       _instagramController.text = influencer.instagramUrl ?? '';
//       _tiktokController.text = influencer.tiktokUrl ?? '';
//       _youtubeController.text = influencer.youtubeUrl ?? '';
//     }
//   }

//   Future<void> _pickImage() async {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text("Choose from Gallery"),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickFromSource(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text("Take a Photo"),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickFromSource(ImageSource.camera);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickFromSource(ImageSource source) async {
//     try {
//       final picker = ImagePicker();
//       final result = await picker.pickImage(source: source, imageQuality: 80);
//       if (result != null) {
//         final bytes = await result.readAsBytes();
//         setState(() => _newProfileImage = bytes);

//         final provider = context.read<InfluencerProvider>();
//         final influencer = provider.influencer;
//         if (influencer != null) {
//           final url = await provider.uploadProfileImage(influencer.id, bytes);
//           if (url != null && mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Profile image uploaded successfully!")),
//             );
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint("❌ Image pick/upload error: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to upload image.")),
//         );
//       }
//     }
//   }

//   Future<void> _saveProfile() async {
//     final provider = context.read<InfluencerProvider>();
//     final influencer = provider.influencer;
//     if (influencer == null) return;

//     final updated = influencer.copyWith(
//       name: _nameController.text.trim(),
//       bio: _bioController.text.trim(),
//       niche: _nicheController.text.trim(),
//       followerCount: int.tryParse(_followersController.text.trim()),
//       engagementRate: double.tryParse(_engagementController.text.trim()),
//       instagramUrl: _instagramController.text.trim(),
//       tiktokUrl: _tiktokController.text.trim(),
//       youtubeUrl: _youtubeController.text.trim(),
//     );

//     await provider.updateInfluencer(updated);

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Profile saved successfully!")),
//       );
//       Navigator.pop(context);
//     }
//   }

//   Widget _buildField(TextEditingController controller, String label,
//       {TextInputType keyboard = TextInputType.text}) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboard,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   Widget _buildConnectButton(String platform, VoidCallback onTap) {
//     Color color;
//     IconData icon;
//     switch (platform) {
//       case 'Instagram':
//         color = Colors.pink;
//         icon = Icons.camera_alt;
//         break;
//       case 'TikTok':
//         color = Colors.black;
//         icon = Icons.music_note;
//         break;
//       case 'YouTube':
//         color = Colors.red;
//         icon = Icons.play_arrow;
//         break;
//       default:
//         color = Colors.grey;
//         icon = Icons.link;
//     }

//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         minimumSize: const Size(double.infinity, 48),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       onPressed: onTap,
//       icon: Icon(icon, color: Colors.white),
//       label: Text(
//         "Connect $platform",
//         style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//       ),
//     );
//   }

//   Future<void> _connectInstagram() async {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Instagram integration coming soon.")),
//     );
//   }

//   Future<void> _connectTikTok() async {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("TikTok integration coming soon.")),
//     );
//   }

//   /// ✅ YouTube Connect with auto-update for dashboard
//   Future<void> _connectYouTube() async {
//     final provider = context.read<InfluencerProvider>();
//     final influencer = provider.influencer;
//     if (influencer == null) return;

//     final youTubeService = YouTubeService();
//     final data = await youTubeService.connectYouTube();

//     if (data != null) {
//       final updated = influencer.copyWith(
//         youtubeChannelName: data['title'] ?? influencer.youtubeChannelName,
//         youtubeChannelThumbnail: data['thumbnail'] ?? influencer.youtubeChannelThumbnail,
//         youtubeSubscribers: int.tryParse(data['subscriberCount']?.toString() ?? '0') ?? influencer.youtubeSubscribers,
//         youtubeToken: data['accessToken'],
//         youtubeUrl: "https://www.youtube.com/channel/${data['channelId']}",
//         youtubeDescription: data['description'] ?? influencer.youtubeDescription,
//       );

//       // ✅ Update influencer in Supabase and refresh provider
//       await provider.updateInfluencer(updated);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Connected YouTube: ${data['title']}")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to connect YouTube.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final influencer = context.watch<InfluencerProvider>().influencer;
//     final profileImage = _newProfileImage != null
//         ? MemoryImage(_newProfileImage!)
//         : (influencer?.profileImage != null
//             ? NetworkImage(influencer!.profileImage!)
//             : null);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Profile")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.grey[300],
//                 backgroundImage: profileImage as ImageProvider<Object>?,
//                 child: profileImage == null
//                     ? const Icon(Icons.person, size: 50, color: Colors.white)
//                     : null,
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildField(_nameController, "Full Name"),
//             const SizedBox(height: 10),
//             _buildField(_bioController, "Bio"),
//             const SizedBox(height: 10),
//             _buildField(_nicheController, "Niche"),
//             const SizedBox(height: 10),
//             _buildField(_followersController, "Followers",
//                 keyboard: TextInputType.number),
//             const SizedBox(height: 10),
//             _buildField(_engagementController, "Engagement Rate (%)",
//                 keyboard: TextInputType.number),
//             const SizedBox(height: 10),
//             _buildField(_instagramController, "Instagram URL"),
//             const SizedBox(height: 10),
//             _buildField(_tiktokController, "TikTok URL"),
//             const SizedBox(height: 10),
//             _buildField(_youtubeController, "YouTube URL"),
//             const SizedBox(height: 20),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Connect Social Accounts",
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//             ),
//             const SizedBox(height: 10),
//             _buildConnectButton("Instagram", _connectInstagram),
//             const SizedBox(height: 10),
//             _buildConnectButton("TikTok", _connectTikTok),
//             const SizedBox(height: 10),
//             _buildConnectButton("YouTube", _connectYouTube),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _saveProfile,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 child: const Text(
//                   "Save Profile",
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/influencer_provider.dart';
import '../../models/influencer_model.dart';

class EditInfluencerProfile extends StatefulWidget {
  const EditInfluencerProfile({super.key});

  @override
  State<EditInfluencerProfile> createState() => _EditInfluencerProfileState();
}

class _EditInfluencerProfileState extends State<EditInfluencerProfile> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _nicheController = TextEditingController();
  final _followersController = TextEditingController();
  final _engagementController = TextEditingController();
  final _instagramController = TextEditingController();
  final _tiktokController = TextEditingController();
  final _youtubeController = TextEditingController();

  Uint8List? _newProfileImage;

  @override
  void initState() {
    super.initState();
    _loadInfluencerData();
  }

  void _loadInfluencerData() {
    final influencer = context.read<InfluencerProvider>().influencer;
    if (influencer != null) {
      _nameController.text = influencer.name ?? '';
      _bioController.text = influencer.bio ?? '';
      _nicheController.text = influencer.niche ?? '';
      _followersController.text = influencer.followerCount?.toString() ?? '';
      _engagementController.text = influencer.engagementRate?.toString() ?? '';
      _instagramController.text = influencer.instagramUrl ?? '';
      _tiktokController.text = influencer.tiktokUrl ?? '';
      _youtubeController.text = influencer.youtubeUrl ?? '';
    }
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () async {
                Navigator.pop(context);
                await _pickFromSource(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a Photo"),
              onTap: () async {
                Navigator.pop(context);
                await _pickFromSource(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromSource(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final result = await picker.pickImage(source: source, imageQuality: 80);
      if (result != null) {
        final bytes = await result.readAsBytes();
        setState(() => _newProfileImage = bytes);

        final provider = context.read<InfluencerProvider>();
        final influencer = provider.influencer;
        if (influencer != null) {
          final url = await provider.uploadProfileImage(influencer.id, bytes);
          if (url != null && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile image uploaded successfully!")),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Image pick/upload error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to upload image.")),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    final provider = context.read<InfluencerProvider>();
    final influencer = provider.influencer;
    if (influencer == null) return;

    final updated = influencer.copyWith(
      name: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      niche: _nicheController.text.trim(),
      followerCount: int.tryParse(_followersController.text.trim()),
      engagementRate: double.tryParse(_engagementController.text.trim()),
      instagramUrl: _instagramController.text.trim(),
      tiktokUrl: _tiktokController.text.trim(),
      youtubeUrl: _youtubeController.text.trim(),
    );

    await provider.updateInfluencer(updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved successfully!")),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildField(TextEditingController controller, String label,
      {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildConnectButton(String platform, VoidCallback onTap) {
    Color color;
    IconData icon;
    switch (platform) {
      case 'Instagram':
        color = Colors.pink;
        icon = Icons.camera_alt;
        break;
      case 'TikTok':
        color = Colors.black;
        icon = Icons.music_note;
        break;
      case 'YouTube':
        color = Colors.red;
        icon = Icons.play_arrow;
        break;
      default:
        color = Colors.grey;
        icon = Icons.link;
    }

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        "Connect $platform",
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Future<void> _connectInstagram() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Instagram integration coming soon.")),
    );
  }

  Future<void> _connectTikTok() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("TikTok integration coming soon.")),
    );
  }

  /// ✅ YouTube Connect using InfluencerProvider method
  Future<void> _connectYouTube() async {
    final provider = context.read<InfluencerProvider>();
    await provider.connectYouTubeAccount();
  }

  @override
  Widget build(BuildContext context) {
    final influencer = context.watch<InfluencerProvider>().influencer;
    final profileImage = _newProfileImage != null
        ? MemoryImage(_newProfileImage!)
        : (influencer?.profileImage != null
            ? NetworkImage(influencer!.profileImage!)
            : null);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: profileImage as ImageProvider<Object>?,
                child: profileImage == null
                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            _buildField(_nameController, "Full Name"),
            const SizedBox(height: 10),
            _buildField(_bioController, "Bio"),
            const SizedBox(height: 10),
            _buildField(_nicheController, "Niche"),
            const SizedBox(height: 10),
            _buildField(_followersController, "Followers",
                keyboard: TextInputType.number),
            const SizedBox(height: 10),
            _buildField(_engagementController, "Engagement Rate (%)",
                keyboard: TextInputType.number),
            const SizedBox(height: 10),
            _buildField(_instagramController, "Instagram URL"),
            const SizedBox(height: 10),
            _buildField(_tiktokController, "TikTok URL"),
            const SizedBox(height: 10),
            _buildField(_youtubeController, "YouTube URL"),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Connect Social Accounts",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            // const SizedBox(height: 10),
            // _buildConnectButton("Instagram", _connectInstagram),
            // const SizedBox(height: 10),
            // _buildConnectButton("TikTok", _connectTikTok),
            const SizedBox(height: 10),
            _buildConnectButton("YouTube", _connectYouTube),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Save Profile",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
