
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

//   /// ✅ YouTube Connect using InfluencerProvider method
//   Future<void> _connectYouTube() async {
//     final provider = context.read<InfluencerProvider>();
//     await provider.connectYouTubeAccount();
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
//             // const SizedBox(height: 10),
//             // _buildConnectButton("Instagram", _connectInstagram),
//             // const SizedBox(height: 10),
//             // _buildConnectButton("TikTok", _connectTikTok),
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
import '../../providers/theme_provider.dart';

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

  String? _selectedNiche;
  bool _isOtherSelected = false;

  final List<String> _nicheOptions = [
    'Fashion & Beauty',
    'Fitness & Wellness',
    'Travel & Adventure',
    'Technology & Gadgets',
    'Food & Cooking',
    'Gaming & Esports',
    'Parenting & Family',
    'Education & Motivation',
    'Finance & Business',
    'Lifestyle & Vlogs',
    'Art & Photography',
    'Music & Entertainment',
    'Automotive & Motorsports',
    'Home Decor & DIY',
    'Sports & Outdoors',
    'Sustainability & Eco-Living',
    'Pets & Animals',
    'Health & Skincare',
    'Comedy & Memes',
    'Other',
  ];

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
      _followersController.text = influencer.followerCount?.toString() ?? '';
      _engagementController.text = influencer.engagementRate?.toString() ?? '';
      _instagramController.text = influencer.instagramUrl ?? '';
      _tiktokController.text = influencer.tiktokUrl ?? '';
      _youtubeController.text = influencer.youtubeUrl ?? '';

      // Handle niche dropdown
      if (_nicheOptions.contains(influencer.niche)) {
        _selectedNiche = influencer.niche;
        _isOtherSelected = false;
      } else if (influencer.niche != null && influencer.niche!.isNotEmpty) {
        _selectedNiche = 'Other';
        _isOtherSelected = true;
        _nicheController.text = influencer.niche!;
      }
    }
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.blue),
                ),
                title: const Text(
                  "Choose from Gallery",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickFromSource(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.green),
                ),
                title: const Text(
                  "Take a Photo",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickFromSource(ImageSource.camera);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
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

    final niche = _isOtherSelected
        ? _nicheController.text.trim()
        : (_selectedNiche ?? influencer.niche ?? '');

    final updated = influencer.copyWith(
      name: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      niche: niche,
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
      {TextInputType keyboard = TextInputType.text, IconData? icon, required bool isDark}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        style: TextStyle(fontSize: 15, color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon, size: 20, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600) : null,
          labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontWeight: FontWeight.w500),
          filled: true,
          fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildConnectButton(String platform, VoidCallback onTap) {
    Color color;
    Color gradientColor;
    IconData icon;
    switch (platform) {
      case 'Instagram':
        color = const Color(0xFFE4405F);
        gradientColor = const Color(0xFF833AB4);
        icon = Icons.camera_alt;
        break;
      case 'TikTok':
        color = Colors.black;
        gradientColor = const Color(0xFF25F4EE);
        icon = Icons.music_note;
        break;
      case 'YouTube':
        color = const Color(0xFFFF0000);
        gradientColor = const Color(0xFFFF6B6B);
        icon = Icons.play_arrow;
        break;
      default:
        color = Colors.grey;
        gradientColor = Colors.grey.shade700;
        icon = Icons.link;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, gradientColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 22),
        label: Text(
          "Connect $platform",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.3,
          ),
        ),
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

  Future<void> _connectYouTube() async {
    final provider = context.read<InfluencerProvider>();
    await provider.connectYouTubeAccount();
  }

  @override
  Widget build(BuildContext context) {
    final influencer = context.watch<InfluencerProvider>().influencer;
    final themeProvider = context.watch<ThemeProvider>();
    final primary = Theme.of(context).primaryColor;
    final isDark = themeProvider.isDark;
    final profileImage = _newProfileImage != null
        ? MemoryImage(_newProfileImage!)
        : (influencer?.profileImage != null
            ? NetworkImage(influencer!.profileImage!)
            : null);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.3,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Image Section
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [primary, primary.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      backgroundImage: profileImage as ImageProvider<Object>?,
                      child: profileImage == null
                          ? Icon(Icons.person, size: 60, color: primary)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Basic Information Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.person_outline, color: primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Basic Information",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildField(_nameController, "Full Name", icon: Icons.badge_outlined, isDark: isDark),
                  const SizedBox(height: 16),
                  _buildField(_bioController, "Bio", icon: Icons.description_outlined, isDark: isDark),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedNiche,
                      isExpanded: true,
                      dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 15),
                      decoration: InputDecoration(
                        labelText: "Niche",
                        prefixIcon: Icon(Icons.category_outlined, size: 20, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                        labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontWeight: FontWeight.w500),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.only(left: 20, right: 12, top: 16, bottom: 16),
                      ),
                      items: _nicheOptions
                          .map((niche) => DropdownMenuItem(
                                value: niche,
                                child: Text(
                                  niche,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                                ),
                              ))
                          .toList(),
                      selectedItemBuilder: (BuildContext context) {
                        return _nicheOptions.map((niche) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              niche,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(fontSize: 15, color: isDark ? Colors.white : Colors.black87),
                            ),
                          );
                        }).toList();
                      },
                      onChanged: (value) {
                        setState(() {
                          _selectedNiche = value;
                          _isOtherSelected = value == 'Other';
                          if (!_isOtherSelected) _nicheController.clear();
                        });
                      },
                    ),
                  ),
                  if (_isOtherSelected) ...[
                    const SizedBox(height: 16),
                    _buildField(_nicheController, "Enter your niche", icon: Icons.edit_outlined, isDark: isDark),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Statistics Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.analytics_outlined, color: Colors.green, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Statistics",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildField(_followersController, "Followers",
                      keyboard: TextInputType.number, icon: Icons.people_outline, isDark: isDark),
                  const SizedBox(height: 16),
                  _buildField(_engagementController, "Engagement Rate (%)",
                      keyboard: TextInputType.number, icon: Icons.trending_up_outlined, isDark: isDark),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Social Links Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.link_outlined, color: Colors.purple, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Social Links",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildField(_instagramController, "Instagram URL", icon: Icons.camera_alt, isDark: isDark),
                  const SizedBox(height: 16),
                  _buildField(_tiktokController, "TikTok URL", icon: Icons.music_note, isDark: isDark),
                  const SizedBox(height: 16),
                  _buildField(_youtubeController, "YouTube URL", icon: Icons.play_arrow, isDark: isDark),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Connect Social Accounts Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.connect_without_contact, color: Colors.red, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Connect Social Accounts",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildConnectButton("YouTube", _connectYouTube),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Save Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, primary.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Save Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
