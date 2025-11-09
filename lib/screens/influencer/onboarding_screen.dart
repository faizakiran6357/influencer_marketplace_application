
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '../../../models/influencer_model.dart';
// import '../../../providers/auth_provider.dart';
// import '../../../providers/influencer_provider.dart';
// import '../../../utils/app_theme.dart';
// import 'influencer_dashboard.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final _pageController = PageController();
//   int _currentStep = 0;

//   final _nameController = TextEditingController();
//   final _bioController = TextEditingController();
//   final _nicheController = TextEditingController();
//   final _followersController = TextEditingController();
//   final _engagementController = TextEditingController();
//   final _instagramController = TextEditingController();
//   final _tiktokController = TextEditingController();
//   final _youtubeController = TextEditingController();

//   Uint8List? _profileImageBytes;
//   final ImagePicker _picker = ImagePicker();

//   void _nextStep() {
//     if (_currentStep < 3) {
//       setState(() => _currentStep++);
//       _pageController.nextPage(
//           duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
//     } else {
//       _submitData();
//     }
//   }

//   Future<void> _pickProfileImage() async {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text("Gallery"),
//               onTap: () async {
//                 Navigator.pop(context);
//                 final XFile? image = await _picker.pickImage(
//                     source: ImageSource.gallery, imageQuality: 80);
//                 if (image != null) {
//                   _profileImageBytes = await image.readAsBytes();
//                   setState(() {});
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Image selected from gallery")));
//                 }
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text("Camera"),
//               onTap: () async {
//                 Navigator.pop(context);
//                 final XFile? image = await _picker.pickImage(
//                     source: ImageSource.camera, imageQuality: 80);
//                 if (image != null) {
//                   _profileImageBytes = await image.readAsBytes();
//                   setState(() {});
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Image captured from camera")));
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _submitData() async {
//     final auth = context.read<AuthProvider>();
//     final influencerProvider = context.read<InfluencerProvider>();
//     final id = auth.currentUser?.id;
//     if (id == null) return;

//     InfluencerModel model = InfluencerModel(
//       id: id,
//       name: _nameController.text.trim(),
//       bio: _bioController.text.trim(),
//       niche: _nicheController.text.trim(),
//       followerCount: int.tryParse(_followersController.text) ?? 0,
//       engagementRate: double.tryParse(_engagementController.text) ?? 0.0,
//       instagramUrl: _instagramController.text.trim(),
//       tiktokUrl: _tiktokController.text.trim(),
//       youtubeUrl: _youtubeController.text.trim(),
//       onboardingCompleted: true,
//     );

//     if (_profileImageBytes != null) {
//       final url =
//           await influencerProvider.uploadProfileImage(id, _profileImageBytes!);
//       if (url != null) {
//         model = model.copyWith(profileImage: url);
//       }
//     }

//     await influencerProvider.updateInfluencer(model);

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Profile setup completed successfully!")));
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => const InfluencerDashboard()));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final steps = [
//       _buildStepWithProfileImage(
//         "Your Name & Bio",
//         [_nameController, _bioController],
//         ["Full Name", "Tell us about yourself"],
//       ),
//       _buildStep("Your Niche", [_nicheController], ["e.g. Fashion, Tech, Fitness"]),
//       _buildStep(
//         "Social Accounts",
//         [_instagramController, _tiktokController, _youtubeController],
//         ["Instagram URL", "TikTok URL", "YouTube URL"],
//       ),
//       _buildStep(
//         "Audience Details",
//         [_followersController, _engagementController],
//         ["Followers count", "Engagement rate (%)"],
//       ),
//     ];

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(title: const Text("Complete Your Profile")),
//       body: SafeArea(
//         child: Column(
//           children: [
//             LinearProgressIndicator(
//               value: (_currentStep + 1) / steps.length,
//               backgroundColor: Colors.grey[300],
//               color: AppTheme.primaryColor,
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: steps,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _nextStep,
//                   child: Text(
//                       _currentStep == steps.length - 1 ? "Finish" : "Next"),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStepWithProfileImage(
//       String title, List<TextEditingController> controllers, List<String> hints) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           GestureDetector(
//             onTap: _pickProfileImage,
//             child: CircleAvatar(
//               radius: 50,
//               backgroundColor: Colors.grey[300],
//               backgroundImage: _profileImageBytes != null
//                   ? MemoryImage(_profileImageBytes!)
//                   : null,
//               child: _profileImageBytes == null
//                   ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
//                   : null,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(title,
//               style:
//                   const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 20),
//           for (int i = 0; i < controllers.length; i++) ...[
//             _buildField(controllers[i], hints[i]),
//             const SizedBox(height: 10),
//           ]
//         ],
//       ),
//     );
//   }

//   Widget _buildStep(
//       String title, List<TextEditingController> controllers, List<String> hints) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style:
//                   const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 20),
//           for (int i = 0; i < controllers.length; i++) ...[
//             _buildField(controllers[i], hints[i]),
//             const SizedBox(height: 10),
//           ]
//         ],
//       ),
//     );
//   }

//   Widget _buildField(TextEditingController controller, String hint,
//       {TextInputType keyboard = TextInputType.text}) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboard,
//       decoration: InputDecoration(
//         hintText: hint,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../models/influencer_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/influencer_provider.dart';
import '../../../utils/app_theme.dart';
import 'influencer_dashboard.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentStep = 0;

  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _nicheController = TextEditingController();
  final _followersController = TextEditingController();
  final _engagementController = TextEditingController();
  final _instagramController = TextEditingController();
  final _tiktokController = TextEditingController();
  final _youtubeController = TextEditingController();

  Uint8List? _profileImageBytes;
  final ImagePicker _picker = ImagePicker();

  String? _selectedNiche; // for dropdown selection
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
    'Other', // triggers text field
  ];

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _submitData();
    }
  }

  Future<void> _pickProfileImage() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 80);
                if (image != null) {
                  _profileImageBytes = await image.readAsBytes();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Image selected from gallery")));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera, imageQuality: 80);
                if (image != null) {
                  _profileImageBytes = await image.readAsBytes();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Image captured from camera")));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitData() async {
    final auth = context.read<AuthProvider>();
    final influencerProvider = context.read<InfluencerProvider>();
    final id = auth.currentUser?.id;
    if (id == null) return;

    // use dropdown or manual input
    final niche = _isOtherSelected
        ? _nicheController.text.trim()
        : (_selectedNiche ?? 'Unknown');

    InfluencerModel model = InfluencerModel(
      id: id,
      name: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      niche: niche,
      followerCount: int.tryParse(_followersController.text) ?? 0,
      engagementRate: double.tryParse(_engagementController.text) ?? 0.0,
      instagramUrl: _instagramController.text.trim(),
      tiktokUrl: _tiktokController.text.trim(),
      youtubeUrl: _youtubeController.text.trim(),
      onboardingCompleted: true,
    );

    if (_profileImageBytes != null) {
      final url =
          await influencerProvider.uploadProfileImage(id, _profileImageBytes!);
      if (url != null) {
        model = model.copyWith(profileImage: url);
      }
    }

    await influencerProvider.updateInfluencer(model);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile setup completed successfully!")));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const InfluencerDashboard()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      _buildStepWithProfileImage(
        "Your Name & Bio",
        [_nameController, _bioController],
        ["Full Name", "Tell us about yourself"],
      ),
      _buildNicheStep(), // ✅ custom dropdown niche step
      _buildStep(
        "Social Accounts",
        [_instagramController, _tiktokController, _youtubeController],
        ["Instagram URL", "TikTok URL", "YouTube URL"],
      ),
      _buildStep(
        "Audience Details",
        [_followersController, _engagementController],
        ["Followers count", "Engagement rate (%)"],
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentStep + 1) / steps.length,
              backgroundColor: Colors.grey[300],
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: steps,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  child: Text(
                      _currentStep == steps.length - 1 ? "Finish" : "Next"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Step with profile image upload
  Widget _buildStepWithProfileImage(
      String title, List<TextEditingController> controllers, List<String> hints) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _pickProfileImage,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage: _profileImageBytes != null
                  ? MemoryImage(_profileImageBytes!)
                  : null,
              child: _profileImageBytes == null
                  ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          for (int i = 0; i < controllers.length; i++) ...[
            _buildField(controllers[i], hints[i]),
            const SizedBox(height: 10),
          ]
        ],
      ),
    );
  }

  /// ✅ Step with dropdown for niche
  Widget _buildNicheStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Your Niche",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _selectedNiche,
            decoration: InputDecoration(
              labelText: "Select your niche",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: _nicheOptions
                .map((niche) => DropdownMenuItem(
                      value: niche,
                      child: Text(niche),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedNiche = value;
                _isOtherSelected = value == 'Other';
              });
            },
          ),
          const SizedBox(height: 12),
          if (_isOtherSelected)
            TextField(
              controller: _nicheController,
              decoration: InputDecoration(
                labelText: "Please specify your niche",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStep(
      String title, List<TextEditingController> controllers, List<String> hints) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          for (int i = 0; i < controllers.length; i++) ...[
            _buildField(controllers[i], hints[i]),
            const SizedBox(height: 10),
          ]
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint,
      {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
