
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/Brand/brand_chat_list_screen.dart';
// import 'package:influencer_marketplace_application/screens/Brand/dashboard/Brand%20Settings%20Screen';
// import 'package:provider/provider.dart';
// import '../../../providers/auth_provider.dart';
// import '../../../providers/brand_provider.dart';
// import '../profile/edit_brand_profile.dart';
// import 'campaign_list_screen.dart';
// import '../analytics/campaign_analytics_screen.dart';
// import '../team/team_list_screen.dart';
// import '../../../services/notification_service.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class BrandDashboard extends StatefulWidget {
//   const BrandDashboard({super.key});

//   @override
//   State<BrandDashboard> createState() => _BrandDashboardState();
// }

// class _BrandDashboardState extends State<BrandDashboard> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final userId = context.read<AuthProvider>().currentUser?.id;
//       if (userId != null) {
//         final provider = context.read<BrandProvider>();
//         await provider.fetchBrand(userId);
//         await provider.fetchCampaigns(userId);

//         // ✅ Send "Welcome Back" notification
//         final userData = await Supabase.instance.client
//             .from('profiles')
//             .select('fcm_token')
//             .eq('id', userId)
//             .maybeSingle();

//         final token = userData?['fcm_token'];
//         if (token != null) {
//           await NotificationService.sendPushMessage(
//             targetToken: token,
//             title: 'Welcome Back!',
//             body: 'Hello ${provider.brand?.name ?? 'Brand'}',
//           );
//         }

//         // ✅ Setup future notification listener (for campaigns, earnings etc.)
//         _listenForNotifications(userId);
//       }
//     });
//   }

//   void _listenForNotifications(String userId) {
//     // Example: listen to notifications table or brand-specific triggers
//     Supabase.instance.client
//         .from('notifications:recipient_id=eq.$userId')
//         .stream(primaryKey: ['id'])
//         .listen((event) async {
//       for (final notification in event) {
//         final token = notification['fcm_token'];
//         if (token != null) {
//           await NotificationService.sendPushMessage(
//             targetToken: token,
//             title: notification['title'] ?? 'New Notification',
//             body: notification['body'] ?? '',
//           );
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<BrandProvider>();
//     final brand = provider.brand;

//     if (provider.loading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     if (brand == null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("Brand Dashboard")),
//         body: const Center(
//           child: Text(
//             "No brand profile found. Please complete your profile setup.",
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Welcome, ${brand.name ?? 'Brand'}"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // ✅ Brand Info Card
//             Card(
//               margin: const EdgeInsets.all(16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 3,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       radius: 35,
//                       backgroundImage: brand.profileImage != null &&
//                               brand.profileImage!.isNotEmpty
//                           ? NetworkImage(brand.profileImage!)
//                           : const AssetImage(
//                                   'assets/images/default_avatar.png')
//                               as ImageProvider,
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(brand.name ?? '',
//                               style: const TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 4),
//                           Text(brand.website ?? 'No website added',
//                               style: const TextStyle(color: Colors.blue)),
//                           const SizedBox(height: 8),
//                           Text(
//                             brand.bio ?? 'No bio provided yet.',
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           const SizedBox(height: 10),
//                           ElevatedButton.icon(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => const EditBrandProfile(),
//                                 ),
//                               );
//                             },
//                             icon: const Icon(Icons.edit, size: 18),
//                             label: const Text("Edit Profile"),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // ✅ Dashboard Cards
//             GridView.count(
//               crossAxisCount: 2,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               padding: const EdgeInsets.all(16),
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               children: [
//                 _buildCard(
//                     context, "Campaigns", Icons.campaign, const CampaignListScreen()),
//                 _buildCard(context, "Analytics", Icons.bar_chart,
//                     const CampaignAnalyticsScreen()),
//                 _buildCard(
//                     context, "Team", Icons.group, const TeamListScreen()),
//                 _buildCard(
//                     context, "Settings", Icons.settings, const BrandSettingsScreen()),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCard(BuildContext context, String title, IconData icon, Widget page) {
//     return GestureDetector(
//       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 40, color: Color(0xFFB25640)),
//               const SizedBox(height: 8),
//               Text(title,
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../providers/auth_provider.dart';
// import '../../../providers/brand_provider.dart';
// import '../../../services/notification_service.dart';
// import '../analytics/campaign_analytics_screen.dart';
// import 'campaign_list_screen.dart';
// import '../profile/brand_profile_screen.dart';
// import '../../../utils/app_theme.dart';

// class BrandDashboard extends StatefulWidget {
//   const BrandDashboard({super.key});

//   @override
//   State<BrandDashboard> createState() => _BrandDashboardState();
// }

// class _BrandDashboardState extends State<BrandDashboard> {
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final userId = context.read<AuthProvider>().currentUser?.id;
//       if (userId != null) {
//         final provider = context.read<BrandProvider>();
//         await provider.fetchBrand(userId);
//         await provider.fetchCampaigns(userId);
//         final userData = await Supabase.instance.client
//             .from('profiles')
//             .select('fcm_token')
//             .eq('id', userId)
//             .maybeSingle();

//         final token = userData?['fcm_token'];
//         if (token != null) {
//           await NotificationService.sendPushMessage(
//             targetToken: token,
//             title: 'Welcome Back!',
//             body: 'Hello ${provider.brand?.name ?? 'Brand'}',
//           );
//         }
//       }
//     });
//   }

//   final List<Widget> _screens = [
//     const _BrandHomeScreen(),
//     const CampaignListScreen(),
//     const CampaignAnalyticsScreen(),
//     const BrandProfileScreen(),
//   ];

//   void _onItemTapped(int index) => setState(() => _selectedIndex = index);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: AppTheme.primaryColor,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         items: [
//           BottomNavigationBarItem(
//               icon: Icon(LucideIcons.home), label: 'Home'),
//           BottomNavigationBarItem(
//               icon: Icon(LucideIcons.megaphone), label: 'Campaigns'),
//           BottomNavigationBarItem(
//               icon: Icon(LucideIcons.barChart2), label: 'Analytics'),
//           BottomNavigationBarItem(
//               icon: Icon(LucideIcons.user), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }

// class _BrandHomeScreen extends StatelessWidget {
//   const _BrandHomeScreen();

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<BrandProvider>();
//     final brand = provider.brand;

//     if (provider.loading || brand == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔹 Header with gradient and curve
//               Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       AppTheme.primaryColor,
//                       AppTheme.primaryColor.withOpacity(0.8),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   ),
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 32,
//                       backgroundImage: brand.profileImage != null &&
//                               brand.profileImage!.isNotEmpty
//                           ? NetworkImage(brand.profileImage!)
//                           : const AssetImage(
//                                   'assets/images/default_avatar.png')
//                               as ImageProvider,
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             brand.name ?? "Brand",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             brand.website ?? "",
//                             style: const TextStyle(color: Colors.white70),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // 🔹 Banners Section
//               SizedBox(
//                 height: 160,
//                 child: PageView(
//                   children: [
//                     _bannerItem(
//                         "https://i.imgur.com/aPzpFzE.png",
//                         "Grow your brand with top influencers!"),
//                     _bannerItem(
//                         "https://i.imgur.com/T7jN8cP.png",
//                         "Launch your next campaign today!"),
//                     _bannerItem(
//                         "https://i.imgur.com/0qTz3eZ.png",
//                         "Measure performance instantly."),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // 🔹 Categories
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: const [
//                     Text(
//                       "Categories",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     Text("View All",
//                         style: TextStyle(
//                             color: Colors.blueAccent,
//                             fontWeight: FontWeight.w600)),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 12),
//               _horizontalCategoryList(),

//               const SizedBox(height: 24),

//               // 🔹 Popular Influencers
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 child: Text(
//                   "Popular Influencers",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               _horizontalInfluencerList(),

//               const SizedBox(height: 24),

//               // 🔹 Trending Influencers
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 child: Text(
//                   "Trending Influencers",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               _horizontalInfluencerList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _bannerItem(String imageUrl, String caption) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         image:
//             DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
//       ),
//       alignment: Alignment.bottomLeft,
//       padding: const EdgeInsets.all(16),
//       child: Text(
//         caption,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 15,
//           fontWeight: FontWeight.w600,
//           shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
//         ),
//       ),
//     );
//   }

//   Widget _horizontalCategoryList() {
//     final categories = [
//       "Fashion",
//       "Tech",
//       "Fitness",
//       "Beauty",
//       "Travel",
//       "Gaming",
//     ];

//     return SizedBox(
//       height: 40,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: categories.length + 1,
//         itemBuilder: (context, index) {
//           if (index == categories.length) {
//             return Padding(
//               padding: const EdgeInsets.only(right: 16),
//               child: Chip(
//                 label: const Text("View All"),
//                 backgroundColor: Colors.blueAccent.withOpacity(0.1),
//               ),
//             );
//           }
//           return Padding(
//             padding: const EdgeInsets.only(left: 16),
//             child: Chip(
//               label: Text(categories[index]),
//               backgroundColor: Colors.grey.shade200,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _horizontalInfluencerList() {
//     final influencers = [
//       {
//         'name': 'Alice',
//         'followers': '120k',
//         'image': 'https://i.imgur.com/w1GlgkO.jpg'
//       },
//       {
//         'name': 'Mark',
//         'followers': '98k',
//         'image': 'https://i.imgur.com/5q8zYfL.jpg'
//       },
//       {
//         'name': 'Sofia',
//         'followers': '150k',
//         'image': 'https://i.imgur.com/yqL3QyL.jpg'
//       },
//     ];

//     return SizedBox(
//       height: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: influencers.length,
//         itemBuilder: (context, index) {
//           final inf = influencers[index];
//           return Container(
//             width: 150,
//             margin: EdgeInsets.only(
//               left: index == 0 ? 16 : 8,
//               right: index == influencers.length - 1 ? 16 : 8,
//             ),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 6,
//                     offset: const Offset(0, 4))
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 ClipRRect(
//                   borderRadius:
//                       const BorderRadius.vertical(top: Radius.circular(16)),
//                   child: Image.network(
//                     inf['image']!,
//                     height: 120,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(inf['name']!,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 16)),
//                 Text("${inf['followers']} followers",
//                     style: const TextStyle(color: Colors.grey)),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../utils/app_theme.dart';
// import '../analytics/campaign_analytics_screen.dart';
// import '../profile/brand_profile_screen.dart';
// import 'campaign_list_screen.dart';

// class BrandDashboard extends StatefulWidget {
//   const BrandDashboard({super.key});

//   @override
//   State<BrandDashboard> createState() => _BrandDashboardState();
// }

// class _BrandDashboardState extends State<BrandDashboard> {
//   int _selectedIndex = 0;
//   final PageController _pageController = PageController();
//   late Timer _bannerTimer;
//   int _bannerIndex = 0;

//   bool _loading = true;
//   bool _error = false;
//   List<Map<String, dynamic>> popularInfluencers = [];
//   List<Map<String, dynamic>> trendingInfluencers = [];

//   String? _selectedCategory;

//   final List<String> _nicheOptions = [
//     'Fashion & Beauty',
//     'Fitness & Wellness',
//     'Travel & Adventure',
//     'Technology & Gadgets',
//     'Food & Cooking',
//     'Gaming & Esports',
//     'Parenting & Family',
//     'Education & Motivation',
//     'Finance & Business',
//     'Lifestyle & Vlogs',
//     'Art & Photography',
//     'Music & Entertainment',
//     'Automotive & Motorsports',
//     'Home Decor & DIY',
//     'Sports & Outdoors',
//     'Sustainability & Eco-Living',
//     'Pets & Animals',
//     'Health & Skincare',
//     'Comedy & Memes',
//     'Other',
//   ];

//   final List<String> _bannerImages = [
//     'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=1200&auto=format&fit=crop&q=80',
//     'https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=1200&auto=format&fit=crop&q=80',
//     'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=1200&auto=format&fit=crop&q=80',
//   ];

//   @override
//   void initState() {
//     super.initState();

//     _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
//       if (_pageController.hasClients && _bannerImages.isNotEmpty) {
//         _bannerIndex = (_bannerIndex + 1) % _bannerImages.length;
//         _pageController.animateToPage(
//           _bannerIndex,
//           duration: const Duration(milliseconds: 400),
//           curve: Curves.easeInOut,
//         );
//       }
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _fetchInfluencers();
//     });
//   }

//   @override
//   void dispose() {
//     _bannerTimer.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchInfluencers({String? nicheFilter}) async {
//     setState(() {
//       _loading = true;
//       _error = false;
//     });

//     try {
//       final sb = Supabase.instance.client;
//       List<Map<String, dynamic>> rows = [];

//       if (nicheFilter != null && nicheFilter.isNotEmpty) {
//         final response = await sb
//             .from('influencers')
//             .select()
//             .filter('niche', 'eq', nicheFilter)
//             .order('followers', ascending: false)
//             .limit(20);

//         rows = List<Map<String, dynamic>>.from(response as List<dynamic>);
//       } else {
//         final response = await sb
//             .from('influencers')
//             .select()
//             .order('followers', ascending: false)
//             .limit(20);

//         rows = List<Map<String, dynamic>>.from(response as List<dynamic>);
//       }

//       // Normalize followers and engagement
//       for (var r in rows) {
//         r['followers'] = (r['followers'] is num)
//             ? (r['followers'] as num).toInt()
//             : int.tryParse(r['followers']?.toString() ?? '0') ?? 0;
//         r['engagement'] = (r['engagement'] is num)
//             ? (r['engagement'] as num).toDouble()
//             : double.tryParse(r['engagement']?.toString() ?? '0.0') ?? 0.0;
//       }

//       final popular = List<Map<String, dynamic>>.from(rows)
//         ..sort((a, b) => (b['followers']).compareTo(a['followers']));
//       final trending = List<Map<String, dynamic>>.from(rows)
//         ..sort((a, b) => (b['engagement']).compareTo(a['engagement']));

//       setState(() {
//         popularInfluencers = popular.take(10).toList();
//         trendingInfluencers = trending.take(10).toList();
//       });
//     } catch (e) {
//       debugPrint('❌ Error loading influencers: $e');
//       setState(() {
//         _error = true;
//       });
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   void _onCategoryTap(String category) {
//     setState(() {
//       if (_selectedCategory == category) {
//         _selectedCategory = null;
//         _fetchInfluencers();
//       } else {
//         _selectedCategory = category;
//         _fetchInfluencers(nicheFilter: category);
//       }
//     });
//   }

//   void _onNavTap(int index) => setState(() => _selectedIndex = index);

//   @override
//   Widget build(BuildContext context) {
//     final screens = [
//       _buildHome(),
//       const CampaignListScreen(),
//       const CampaignAnalyticsScreen(),
//       const BrandProfileScreen(),
//     ];

//     return Scaffold(
//       body: screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         selectedItemColor: AppTheme.primaryColor,
//         unselectedItemColor: Colors.grey,
//         onTap: _onNavTap,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.megaphone), label: "Campaigns"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.barChart2), label: "Analytics"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: "Profile"),
//         ],
//       ),
//     );
//   }

//   Widget _buildHome() {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Brand Dashboard"),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _error
//               ? Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text("Failed to load influencers"),
//                       const SizedBox(height: 10),
//                       ElevatedButton(onPressed: _fetchInfluencers, child: const Text("Retry"))
//                     ],
//                   ),
//                 )
//               : SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildBanners(),
//                       const SizedBox(height: 10),
//                       _buildCategories(),
//                       const SizedBox(height: 20),
//                       _buildSection("Popular Influencers", popularInfluencers),
//                       const SizedBox(height: 20),
//                       _buildSection("Trending Influencers", trendingInfluencers),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//     );
//   }

//   Widget _buildBanners() {
//     return SizedBox(
//       height: 170,
//       child: PageView.builder(
//         controller: _pageController,
//         itemCount: _bannerImages.length,
//         itemBuilder: (context, i) {
//           return Container(
//             margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(14),
//               image: DecorationImage(
//                 image: NetworkImage(_bannerImages[i]),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCategories() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           child: Text("Categories",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         const SizedBox(height: 8),
//         SizedBox(
//           height: 44,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: _nicheOptions.length > 5 ? 6 : _nicheOptions.length,
//             itemBuilder: (context, idx) {
//               if (idx == 5 && _nicheOptions.length > 5) {
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 12),
//                   child: ActionChip(
//                     label: const Text("View All"),
//                     onPressed: () => showModalBottomSheet(
//                       context: context,
//                       builder: (_) => _fullCategorySheet(),
//                     ),
//                   ),
//                 );
//               }
//               final cat = _nicheOptions[idx];
//               final selected = _selectedCategory == cat;
//               return Padding(
//                 padding: const EdgeInsets.only(left: 12),
//                 child: ChoiceChip(
//                   label: Text(cat, style: const TextStyle(fontSize: 13)),
//                   selected: selected,
//                   selectedColor: AppTheme.primaryColor.withOpacity(0.15),
//                   onSelected: (_) => _onCategoryTap(cat),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _fullCategorySheet() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Wrap(
//         spacing: 8,
//         runSpacing: 8,
//         children: _nicheOptions.map((c) {
//           return ActionChip(
//             label: Text(c),
//             onPressed: () {
//               Navigator.pop(context);
//               _onCategoryTap(c);
//             },
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildSection(String title, List<Map<String, dynamic>> influencers) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child:
//               Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         const SizedBox(height: 12),
//         _influencerList(influencers),
//       ],
//     );
//   }

//   Widget _influencerList(List<Map<String, dynamic>> influencers) {
//     if (influencers.isEmpty) {
//       return const SizedBox(
//         height: 100,
//         child: Center(child: Text("No influencers found")),
//       );
//     }

//     return SizedBox(
//       height: 190,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: influencers.length,
//         itemBuilder: (context, i) {
//           final inf = influencers[i];
//           final image = (inf['profile_image'] ?? '').toString().isNotEmpty
//               ? inf['profile_image']
//               : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800&auto=format&fit=crop&q=80';

//           return Container(
//             width: 150,
//             margin: EdgeInsets.only(left: i == 0 ? 16 : 8, right: i == influencers.length - 1 ? 16 : 0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 4))
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                   child: Image.network(
//                     image,
//                     height: 100,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       height: 100,
//                       color: Colors.grey.shade300,
//                       child: const Icon(Icons.person, size: 40, color: Colors.grey),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(inf['name'] ?? 'Unknown',
//                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                     overflow: TextOverflow.ellipsis),
//                 Text('${inf['followers']} followers',
//                     style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                 Text('Eng: ${inf['engagement']}%',
//                     style: const TextStyle(color: Colors.grey, fontSize: 12)),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../utils/app_theme.dart';
// import '../analytics/campaign_analytics_screen.dart';
// import '../profile/brand_profile_screen.dart';
// import 'campaign_list_screen.dart';

// class BrandDashboard extends StatefulWidget {
//   const BrandDashboard({super.key});

//   @override
//   State<BrandDashboard> createState() => _BrandDashboardState();
// }

// class _BrandDashboardState extends State<BrandDashboard> {
//   int _selectedIndex = 0;
//   final PageController _pageController = PageController();
//   late Timer _bannerTimer;
//   int _bannerIndex = 0;

//   bool _loading = true;
//   bool _error = false;
//   List<Map<String, dynamic>> popularInfluencers = [];
//   List<Map<String, dynamic>> trendingInfluencers = [];

//   String? _selectedCategory;

//   final List<String> _nicheOptions = [
//     'Fashion & Beauty',
//     'Fitness & Wellness',
//     'Travel & Adventure',
//     'Technology & Gadgets',
//     'Food & Cooking',
//     'Gaming & Esports',
//     'Parenting & Family',
//     'Education & Motivation',
//     'Finance & Business',
//     'Lifestyle & Vlogs',
//     'Art & Photography',
//     'Music & Entertainment',
//     'Automotive & Motorsports',
//     'Home Decor & DIY',
//     'Sports & Outdoors',
//     'Sustainability & Eco-Living',
//     'Pets & Animals',
//     'Health & Skincare',
//     'Comedy & Memes',
//     'Other',
//   ];

//   final List<String> _bannerImages = [
//     'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=1200&auto=format&fit=crop&q=80',
//     'https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=1200&auto=format&fit=crop&q=80',
//     'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=1200&auto=format&fit=crop&q=80',
//   ];

//   @override
//   void initState() {
//     super.initState();

//     // Banner auto-scroll
//     _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
//       if (_pageController.hasClients && _bannerImages.isNotEmpty) {
//         _bannerIndex = (_bannerIndex + 1) % _bannerImages.length;
//         _pageController.animateToPage(
//           _bannerIndex,
//           duration: const Duration(milliseconds: 400),
//           curve: Curves.easeInOut,
//         );
//       }
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _fetchInfluencers();
//     });
//   }

//   @override
//   void dispose() {
//     _bannerTimer.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchInfluencers({String? nicheFilter}) async {
//     setState(() {
//       _loading = true;
//       _error = false;
//     });

//     try {
//       final sb = Supabase.instance.client;
//       List<Map<String, dynamic>> rows = [];

//       if (nicheFilter != null && nicheFilter.isNotEmpty) {
//         final response = await sb
//             .from('influencers')
//             .select()
//             .filter('niche', 'eq', nicheFilter)
//             .order('follower_count', ascending: false)
//             .limit(20);
//         rows = List<Map<String, dynamic>>.from(response as List<dynamic>);
//       } else {
//         final response = await sb
//             .from('influencers')
//             .select()
//             .order('follower_count', ascending: false)
//             .limit(20);
//         rows = List<Map<String, dynamic>>.from(response as List<dynamic>);
//       }

//       // Normalize follower_count and engagement_rate
//       for (var r in rows) {
//         r['follower_count'] = (r['follower_count'] is num)
//             ? (r['follower_count'] as num).toInt()
//             : int.tryParse(r['follower_count']?.toString() ?? '0') ?? 0;
//         r['engagement_rate'] = (r['engagement_rate'] is num)
//             ? (r['engagement_rate'] as num).toDouble()
//             : double.tryParse(r['engagement_rate']?.toString() ?? '0.0') ?? 0.0;
//       }

//       final popular = List<Map<String, dynamic>>.from(rows)
//         ..sort((a, b) => (b['follower_count']).compareTo(a['follower_count']));
//       final trending = List<Map<String, dynamic>>.from(rows)
//         ..sort((a, b) => (b['engagement_rate']).compareTo(a['engagement_rate']));

//       setState(() {
//         popularInfluencers = popular.take(10).toList();
//         trendingInfluencers = trending.take(10).toList();
//       });
//     } catch (e) {
//       debugPrint('❌ Error loading influencers: $e');
//       setState(() {
//         _error = true;
//       });
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   void _onCategoryTap(String category) {
//     setState(() {
//       if (_selectedCategory == category) {
//         _selectedCategory = null;
//         _fetchInfluencers();
//       } else {
//         _selectedCategory = category;
//         _fetchInfluencers(nicheFilter: category);
//       }
//     });
//   }

//   void _onNavTap(int index) => setState(() => _selectedIndex = index);

//   @override
//   Widget build(BuildContext context) {
//     final screens = [
//       _buildHome(),
//       const CampaignListScreen(),
//       const CampaignAnalyticsScreen(),
//       const BrandProfileScreen(),
//     ];

//     return Scaffold(
//       body: screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         selectedItemColor: AppTheme.primaryColor,
//         unselectedItemColor: Colors.grey,
//         onTap: _onNavTap,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.megaphone), label: "Campaigns"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.barChart2), label: "Analytics"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: "Profile"),
//         ],
//       ),
//     );
//   }

//   Widget _buildHome() {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Brand Dashboard"),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _error
//               ? Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text("Failed to load influencers"),
//                       const SizedBox(height: 10),
//                       ElevatedButton(onPressed: _fetchInfluencers, child: const Text("Retry"))
//                     ],
//                   ),
//                 )
//               : SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildBanners(),
//                       const SizedBox(height: 10),
//                       _buildCategories(),
//                       const SizedBox(height: 20),
//                       _buildSection("Popular Influencers", popularInfluencers),
//                       const SizedBox(height: 20),
//                       _buildSection("Trending Influencers", trendingInfluencers),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//     );
//   }

//   Widget _buildBanners() {
//     return SizedBox(
//       height: 170,
//       child: PageView.builder(
//         controller: _pageController,
//         itemCount: _bannerImages.length,
//         itemBuilder: (context, i) {
//           return Container(
//             margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(14),
//               image: DecorationImage(
//                 image: NetworkImage(_bannerImages[i]),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCategories() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           child: Text("Categories",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         const SizedBox(height: 8),
//         SizedBox(
//           height: 44,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: _nicheOptions.length > 5 ? 6 : _nicheOptions.length,
//             itemBuilder: (context, idx) {
//               if (idx == 5 && _nicheOptions.length > 5) {
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 12),
//                   child: ActionChip(
//                     label: const Text("View All"),
//                     onPressed: () => showModalBottomSheet(
//                       context: context,
//                       builder: (_) => _fullCategorySheet(),
//                     ),
//                   ),
//                 );
//               }
//               final cat = _nicheOptions[idx];
//               final selected = _selectedCategory == cat;
//               return Padding(
//                 padding: const EdgeInsets.only(left: 12),
//                 child: ChoiceChip(
//                   label: Text(cat, style: const TextStyle(fontSize: 13)),
//                   selected: selected,
//                   selectedColor: AppTheme.primaryColor.withOpacity(0.15),
//                   onSelected: (_) => _onCategoryTap(cat),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _fullCategorySheet() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Wrap(
//         spacing: 8,
//         runSpacing: 8,
//         children: _nicheOptions.map((c) {
//           return ActionChip(
//             label: Text(c),
//             onPressed: () {
//               Navigator.pop(context);
//               _onCategoryTap(c);
//             },
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildSection(String title, List<Map<String, dynamic>> influencers) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child:
//               Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         const SizedBox(height: 12),
//         _influencerList(influencers),
//       ],
//     );
//   }

//   Widget _influencerList(List<Map<String, dynamic>> influencers) {
//     if (influencers.isEmpty) {
//       return const SizedBox(
//         height: 100,
//         child: Center(child: Text("No influencers found")),
//       );
//     }

//     return SizedBox(
//       height: 190,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: influencers.length,
//         itemBuilder: (context, i) {
//           final inf = influencers[i];
//           final image = (inf['profile_image'] ?? '').toString().isNotEmpty
//               ? inf['profile_image']
//               : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800&auto=format&fit=crop&q=80';

//           return Container(
//             width: 150,
//             margin: EdgeInsets.only(left: i == 0 ? 16 : 8, right: i == influencers.length - 1 ? 16 : 0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 4))
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                   child: Image.network(
//                     image,
//                     height: 100,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       height: 100,
//                       color: Colors.grey.shade300,
//                       child: const Icon(Icons.person, size: 40, color: Colors.grey),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(inf['name'] ?? 'Unknown',
//                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                     overflow: TextOverflow.ellipsis),
//                 Text('${inf['follower_count']} followers',
//                     style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                 Text('Eng: ${inf['engagement_rate']}%',
//                     style: const TextStyle(color: Colors.grey, fontSize: 12)),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../utils/app_theme.dart';
// import '../analytics/campaign_analytics_screen.dart';
// import '../profile/brand_profile_screen.dart';
// import 'campaign_list_screen.dart';

// class BrandDashboard extends StatefulWidget {
//   const BrandDashboard({super.key});

//   @override
//   State<BrandDashboard> createState() => _BrandDashboardState();
// }

// class _BrandDashboardState extends State<BrandDashboard> {
//   int _selectedIndex = 0;
//   final PageController _pageController = PageController();
//   late Timer _bannerTimer;
//   int _bannerIndex = 0;

//   bool _loading = true;
//   bool _error = false;
//   List<Map<String, dynamic>> popularInfluencers = [];
//   List<Map<String, dynamic>> trendingInfluencers = [];

//   String? _selectedCategory;

//   final List<String> _nicheOptions = [
//     'Fashion & Beauty',
//     'Fitness & Wellness',
//     'Travel & Adventure',
//     'Technology & Gadgets',
//     'Food & Cooking',
//     'Gaming & Esports',
//     'Parenting & Family',
//     'Education & Motivation',
//     'Finance & Business',
//     'Lifestyle & Vlogs',
//     'Art & Photography',
//     'Music & Entertainment',
//     'Automotive & Motorsports',
//     'Home Decor & DIY',
//     'Sports & Outdoors',
//     'Sustainability & Eco-Living',
//     'Pets & Animals',
//     'Health & Skincare',
//     'Comedy & Memes',
//     'Other',
//   ];

//   final List<String> _bannerImages = [
//     'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=1200&auto=format&fit=crop&q=80',
//     'https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=1200&auto=format&fit=crop&q=80',
//     'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=1200&auto=format&fit=crop&q=80',
//   ];

//   @override
//   void initState() {
//     super.initState();

//     // Banner auto-scroll
//     _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
//       if (_pageController.hasClients && _bannerImages.isNotEmpty) {
//         _bannerIndex = (_bannerIndex + 1) % _bannerImages.length;
//         _pageController.animateToPage(
//           _bannerIndex,
//           duration: const Duration(milliseconds: 400),
//           curve: Curves.easeInOut,
//         );
//       }
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _fetchInfluencers();
//     });
//   }

//   @override
//   void dispose() {
//     _bannerTimer.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchInfluencers({String? nicheFilter}) async {
//     setState(() {
//       _loading = true;
//       _error = false;
//     });

//     try {
//       final sb = Supabase.instance.client;
//       List<Map<String, dynamic>> rows = [];

//       if (nicheFilter != null && nicheFilter.isNotEmpty) {
//         final response = await sb
//             .from('influencers')
//             .select('id, name, profile_image, niche, follower_count, engagement_rate')
//             .match({'niche': nicheFilter})
//             .order('follower_count', ascending: false)
//             .limit(20);
//         rows = List<Map<String, dynamic>>.from(response as List<dynamic>);
//       } else {
//         final response = await sb
//             .from('influencers')
//             .select('id, name, profile_image, niche, follower_count, engagement_rate')
//             .order('follower_count', ascending: false)
//             .limit(20);
//         rows = List<Map<String, dynamic>>.from(response as List<dynamic>);
//       }

//       // Normalize follower_count and engagement_rate
//       for (var r in rows) {
//         r['follower_count'] = (r['follower_count'] is num)
//             ? (r['follower_count'] as num).toInt()
//             : int.tryParse(r['follower_count']?.toString() ?? '0') ?? 0;
//         r['engagement_rate'] = (r['engagement_rate'] is num)
//             ? (r['engagement_rate'] as num).toDouble()
//             : double.tryParse(r['engagement_rate']?.toString() ?? '0.0') ?? 0.0;
//       }

//       final popular = List<Map<String, dynamic>>.from(rows)
//         ..sort((a, b) => (b['follower_count']).compareTo(a['follower_count']));
//       final trending = List<Map<String, dynamic>>.from(rows)
//         ..sort((a, b) => (b['engagement_rate']).compareTo(a['engagement_rate']));

//       setState(() {
//         popularInfluencers = popular.take(10).toList();
//         trendingInfluencers = trending.take(10).toList();
//       });
//     } catch (e) {
//       debugPrint('❌ Error loading influencers: $e');
//       setState(() {
//         _error = true;
//       });
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   void _onCategoryTap(String category) {
//     setState(() {
//       if (_selectedCategory == category) {
//         _selectedCategory = null;
//         _fetchInfluencers();
//       } else {
//         _selectedCategory = category;
//         _fetchInfluencers(nicheFilter: category);
//       }
//     });
//   }

//   void _onNavTap(int index) => setState(() => _selectedIndex = index);

//   @override
//   Widget build(BuildContext context) {
//     final screens = [
//       _buildHome(),
//       const CampaignListScreen(),
//       const CampaignAnalyticsScreen(),
//       const BrandProfileScreen(),
//     ];

//     return Scaffold(
//       body: screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         selectedItemColor: AppTheme.primaryColor,
//         unselectedItemColor: Colors.grey,
//         onTap: _onNavTap,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.megaphone), label: "Campaigns"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.barChart2), label: "Analytics"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: "Profile"),
//         ],
//       ),
//     );
//   }

//   Widget _buildHome() {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Brand Dashboard"),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _error
//               ? Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text("Failed to load influencers"),
//                       const SizedBox(height: 10),
//                       ElevatedButton(onPressed: _fetchInfluencers, child: const Text("Retry"))
//                     ],
//                   ),
//                 )
//               : SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildBanners(),
//                       const SizedBox(height: 10),
//                       _buildCategories(),
//                       const SizedBox(height: 20),
//                       _buildSection("Popular Influencers", popularInfluencers),
//                       const SizedBox(height: 20),
//                       _buildSection("Trending Influencers", trendingInfluencers),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//     );
//   }

//   Widget _buildBanners() {
//     return SizedBox(
//       height: 170,
//       child: PageView.builder(
//         controller: _pageController,
//         itemCount: _bannerImages.length,
//         itemBuilder: (context, i) {
//           return Container(
//             margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(14),
//               image: DecorationImage(
//                 image: NetworkImage(_bannerImages[i]),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCategories() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           child: Text("Categories",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         const SizedBox(height: 8),
//         SizedBox(
//           height: 44,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: _nicheOptions.length > 5 ? 6 : _nicheOptions.length,
//             itemBuilder: (context, idx) {
//               if (idx == 5 && _nicheOptions.length > 5) {
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 12),
//                   child: ActionChip(
//                     label: const Text("View All"),
//                     onPressed: () => showModalBottomSheet(
//                       context: context,
//                       builder: (_) => _fullCategorySheet(),
//                     ),
//                   ),
//                 );
//               }
//               final cat = _nicheOptions[idx];
//               final selected = _selectedCategory == cat;
//               return Padding(
//                 padding: const EdgeInsets.only(left: 12),
//                 child: ChoiceChip(
//                   label: Text(cat, style: const TextStyle(fontSize: 13)),
//                   selected: selected,
//                   selectedColor: AppTheme.primaryColor.withOpacity(0.15),
//                   onSelected: (_) => _onCategoryTap(cat),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _fullCategorySheet() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Wrap(
//         spacing: 8,
//         runSpacing: 8,
//         children: _nicheOptions.map((c) {
//           return ActionChip(
//             label: Text(c),
//             onPressed: () {
//               Navigator.pop(context);
//               _onCategoryTap(c);
//             },
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildSection(String title, List<Map<String, dynamic>> influencers) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child:
//               Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         const SizedBox(height: 12),
//         _influencerList(influencers),
//       ],
//     );
//   }

//   Widget _influencerList(List<Map<String, dynamic>> influencers) {
//     if (influencers.isEmpty) {
//       return const SizedBox(
//         height: 100,
//         child: Center(child: Text("No influencers found")),
//       );
//     }

//     return SizedBox(
//       height: 190,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: influencers.length,
//         itemBuilder: (context, i) {
//           final inf = influencers[i];
//           final image = (inf['profile_image'] ?? '').toString().isNotEmpty
//               ? inf['profile_image']
//               : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800&auto=format&fit=crop&q=80';

//           return Container(
//             width: 150,
//             margin: EdgeInsets.only(left: i == 0 ? 16 : 8, right: i == influencers.length - 1 ? 16 : 0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 4))
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                   child: Image.network(
//                     image,
//                     height: 100,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       height: 100,
//                       color: Colors.grey.shade300,
//                       child: const Icon(Icons.person, size: 40, color: Colors.grey),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(inf['name'] ?? 'Unknown',
//                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                     overflow: TextOverflow.ellipsis),
//                 Text('${inf['follower_count']} followers',
//                     style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                 Text('Eng: ${inf['engagement_rate']}%',
//                     style: const TextStyle(color: Colors.grey, fontSize: 12)),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/influencer/influencer_dashboard.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../utils/app_theme.dart';
// import '../analytics/campaign_analytics_screen.dart';
// import '../profile/brand_profile_screen.dart';
// import 'campaign_list_screen.dart';


// class BrandDashboard extends StatefulWidget {
//   const BrandDashboard({super.key});

//   @override
//   State<BrandDashboard> createState() => _BrandDashboardState();
// }

// class _BrandDashboardState extends State<BrandDashboard> {
//   int _selectedIndex = 0;
//   final PageController _pageController = PageController();
//   late Timer _bannerTimer;
//   int _bannerIndex = 0;

//   bool _loading = true;
//   bool _error = false;
//   List<Map<String, dynamic>> popularInfluencers = [];
//   List<Map<String, dynamic>> trendingInfluencers = [];

//   String? _selectedCategory;

//   final List<String> _nicheOptions = [
//     'Fashion & Beauty',
//     'Fitness & Wellness',
//     'Travel & Adventure',
//     'Technology & Gadgets',
//     'Food & Cooking',
//     'Gaming & Esports',
//     'Parenting & Family',
//     'Education & Motivation',
//     'Finance & Business',
//     'Lifestyle & Vlogs',
//     'Art & Photography',
//     'Music & Entertainment',
//     'Automotive & Motorsports',
//     'Home Decor & DIY',
//     'Sports & Outdoors',
//     'Sustainability & Eco-Living',
//     'Pets & Animals',
//     'Health & Skincare',
//     'Comedy & Memes',
//     'Other',
//   ];

//   final List<String> _bannerImages = [
//     'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=1200&auto=format&fit=crop&q=80',
//     'https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=1200&auto=format&fit=crop&q=80',
//     'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=1200&auto=format&fit=crop&q=80',
//   ];

//   @override
//   void initState() {
//     super.initState();

//     _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
//       if (_pageController.hasClients && _bannerImages.isNotEmpty) {
//         _bannerIndex = (_bannerIndex + 1) % _bannerImages.length;
//         _pageController.animateToPage(
//           _bannerIndex,
//           duration: const Duration(milliseconds: 400),
//           curve: Curves.easeInOut,
//         );
//       }
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _fetchInfluencers();
//     });
//   }

//   @override
//   void dispose() {
//     _bannerTimer.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchInfluencers({String? nicheFilter}) async {
//     setState(() {
//       _loading = true;
//       _error = false;
//     });

//     try {
//       final sb = Supabase.instance.client;
//       List<Map<String, dynamic>> rows = [];

//       final response = await sb
//           .from('influencers')
//           .select('id, name, profile_image, niche, follower_count, engagement_rate')
//           .order('follower_count', ascending: false)
//           .limit(20);

//       rows = List<Map<String, dynamic>>.from(response as List<dynamic>);

//       // Normalize
//       for (var r in rows) {
//         r['follower_count'] = (r['follower_count'] is num)
//             ? (r['follower_count'] as num).toInt()
//             : int.tryParse(r['follower_count']?.toString() ?? '0') ?? 0;
//         r['engagement_rate'] = (r['engagement_rate'] is num)
//             ? (r['engagement_rate'] as num).toDouble()
//             : double.tryParse(r['engagement_rate']?.toString() ?? '0.0') ?? 0.0;
//       }

//       final popular = List<Map<String, dynamic>>.from(rows)
//         ..sort((a, b) => (b['follower_count']).compareTo(a['follower_count']));
//       final trending = List<Map<String, dynamic>>.from(rows)
//         ..sort((a, b) => (b['engagement_rate']).compareTo(a['engagement_rate']));

//       setState(() {
//         popularInfluencers = popular.take(10).toList();
//         trendingInfluencers = trending.take(10).toList();
//       });
//     } catch (e) {
//       debugPrint('❌ Error loading influencers: $e');
//       setState(() {
//         _error = true;
//       });
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   void _onCategoryTap(String category) {
//     setState(() {
//       if (_selectedCategory == category) {
//         _selectedCategory = null;
//         _fetchInfluencers();
//       } else {
//         _selectedCategory = category;
//         _fetchInfluencers(nicheFilter: category);
//       }
//     });
//   }

//   void _onNavTap(int index) => setState(() => _selectedIndex = index);

//   @override
//   Widget build(BuildContext context) {
//     final screens = [
//       _buildHome(),
//       const CampaignListScreen(),
//       const CampaignAnalyticsScreen(),
//       const BrandProfileScreen(),
//     ];

//     return Scaffold(
//       body: screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         selectedItemColor: AppTheme.primaryColor,
//         unselectedItemColor: Colors.grey,
//         onTap: _onNavTap,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.megaphone), label: "Campaigns"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.barChart2), label: "Analytics"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: "Profile"),
//         ],
//       ),
//     );
//   }

//   Widget _buildHome() {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Brand Dashboard"),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: SafeArea(
//         child: _loading
//             ? const Center(child: CircularProgressIndicator())
//             : _error
//                 ? Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text("Failed to load influencers"),
//                         const SizedBox(height: 10),
//                         ElevatedButton(onPressed: _fetchInfluencers, child: const Text("Retry"))
//                       ],
//                     ),
//                   )
//                 : SingleChildScrollView(
//                     padding: const EdgeInsets.only(bottom: 24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildBanners(),
//                         const SizedBox(height: 10),
//                         _buildCategories(),
//                         const SizedBox(height: 20),
//                         _buildSection("Popular Influencers", popularInfluencers),
//                         const SizedBox(height: 20),
//                         _buildSection("Trending Influencers", trendingInfluencers),
//                       ],
//                     ),
//                   ),
//       ),
//     );
//   }

//   Widget _buildBanners() {
//     return SizedBox(
//       height: 180,
//       child: PageView.builder(
//         controller: _pageController,
//         itemCount: _bannerImages.length,
//         itemBuilder: (context, i) {
//           return Container(
//             margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(14),
//               image: DecorationImage(
//                 image: NetworkImage(_bannerImages[i]),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCategories() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           child: Text("Categories",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         const SizedBox(height: 8),
//         SizedBox(
//           height: 44,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: _nicheOptions.length > 5 ? 6 : _nicheOptions.length,
//             itemBuilder: (context, idx) {
//               if (idx == 5 && _nicheOptions.length > 5) {
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 12),
//                   child: ActionChip(
//                     label: const Text("View All"),
//                     onPressed: () => showModalBottomSheet(
//                       context: context,
//                       builder: (_) => _fullCategorySheet(),
//                     ),
//                   ),
//                 );
//               }
//               final cat = _nicheOptions[idx];
//               final selected = _selectedCategory == cat;
//               return Padding(
//                 padding: const EdgeInsets.only(left: 12),
//                 child: ChoiceChip(
//                   label: Text(cat, style: const TextStyle(fontSize: 13)),
//                   selected: selected,
//                   selectedColor: AppTheme.primaryColor.withOpacity(0.15),
//                   onSelected: (_) => _onCategoryTap(cat),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _fullCategorySheet() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Wrap(
//         spacing: 8,
//         runSpacing: 8,
//         children: _nicheOptions.map((c) {
//           return ActionChip(
//             label: Text(c),
//             onPressed: () {
//               Navigator.pop(context);
//               _onCategoryTap(c);
//             },
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildSection(String title, List<Map<String, dynamic>> influencers) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child:
//               Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         const SizedBox(height: 12),
//         _influencerList(influencers),
//       ],
//     );
//   }

//   Widget _influencerList(List<Map<String, dynamic>> influencers) {
//     if (influencers.isEmpty) {
//       return const SizedBox(
//         height: 100,
//         child: Center(child: Text("No influencers found")),
//       );
//     }

//     return SizedBox(
//       height: 190,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: influencers.length,
//         itemBuilder: (context, i) {
//           final inf = influencers[i];
//           final image = (inf['profile_image'] ?? '').toString().isNotEmpty
//               ? inf['profile_image']
//               : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800&auto=format&fit=crop&q=80';

//           return GestureDetector(
//             onTap: () {
//               // ✅ Open influencer dashboard as bottom sheet
//               showModalBottomSheet(
//                 context: context,
//                 isScrollControlled: true,
//                 backgroundColor: Colors.transparent,
//                 builder: (_) => FractionallySizedBox(
//                   heightFactor: 0.92,
//                   child: InfluencerDashboard(
//                     influencerId: inf['id'],
//                   ),
//                 ),
//               );
//             },
//             child: Container(
//               width: 150,
//               margin: EdgeInsets.only(
//                 left: i == 0 ? 16 : 8,
//                 right: i == influencers.length - 1 ? 16 : 0,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.06),
//                     blurRadius: 6,
//                     offset: const Offset(0, 4),
//                   )
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   ClipRRect(
//                     borderRadius:
//                         const BorderRadius.vertical(top: Radius.circular(12)),
//                     child: Image.network(
//                       image,
//                       height: 100,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => Container(
//                         height: 100,
//                         color: Colors.grey.shade300,
//                         child: const Icon(Icons.person, size: 40, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(inf['name'] ?? 'Unknown',
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                       overflow: TextOverflow.ellipsis),
//                   Text('${inf['follower_count']} followers',
//                       style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                   Text('Eng: ${inf['engagement_rate']}%',
//                       style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/influencer/influencer_dashboard.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../utils/app_theme.dart';
// import '../analytics/campaign_analytics_screen.dart';
// import '../profile/brand_profile_screen.dart';
// import 'campaign_list_screen.dart';

// class BrandDashboard extends StatefulWidget {
//   const BrandDashboard({super.key});

//   @override
//   State<BrandDashboard> createState() => _BrandDashboardState();
// }

// class _BrandDashboardState extends State<BrandDashboard> {
//   int _selectedIndex = 0;
//   final PageController _pageController = PageController();
//   late Timer _bannerTimer;
//   int _bannerIndex = 0;

//   bool _loading = true;
//   bool _error = false;
//   List<Map<String, dynamic>> popularInfluencers = [];
//   List<Map<String, dynamic>> trendingInfluencers = [];

//   String? _selectedCategory;

//   final List<String> _nicheOptions = [
//     'Fashion & Beauty',
//     'Fitness & Wellness',
//     'Travel & Adventure',
//     'Technology & Gadgets',
//     'Food & Cooking',
//     'Gaming & Esports',
//     'Education & Motivation',
//     'Music & Entertainment',
//     'Lifestyle & Vlogs',
//     'Finance & Business',
//     'Health & Skincare',
//     'Sports & Outdoors',
//     'Comedy & Memes',
//     'Art & Photography',
//     'Other',
//   ];

//   final List<String> _bannerImages = [
//     'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=1200&auto=format&fit=crop&q=80',
//     'https://plus.unsplash.com/premium_photo-1664475926084-d20248544896?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
//     'https://plus.unsplash.com/premium_photo-1684017834450-21747b64d666?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1171',
//     'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=1200&auto=format&fit=crop&q=80',
    
//   ];

//   @override
//   void initState() {
//     super.initState();

//     _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
//       if (_pageController.hasClients && _bannerImages.isNotEmpty) {
//         _bannerIndex = (_bannerIndex + 1) % _bannerImages.length;
//         _pageController.animateToPage(
//           _bannerIndex,
//           duration: const Duration(milliseconds: 400),
//           curve: Curves.easeInOut,
//         );
//       }
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _fetchInfluencers();
//     });
//   }

//   @override
//   void dispose() {
//     _bannerTimer.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchInfluencers({String? nicheFilter}) async {
//     setState(() {
//       _loading = true;
//       _error = false;
//     });

//     try {
//       final sb = Supabase.instance.client;
//       List<Map<String, dynamic>> rows = [];

//       dynamic response;

//       if (nicheFilter != null && nicheFilter.isNotEmpty) {
//         response = await sb
//             .from('influencers')
//             .select('id, name, profile_image, niche, follower_count, engagement_rate')
//             .eq('niche', nicheFilter)
//             .order('follower_count', ascending: false)
//             .limit(30);
//       } else {
//         response = await sb
//             .from('influencers')
//             .select('id, name, profile_image, niche, follower_count, engagement_rate')
//             .order('follower_count', ascending: false)
//             .limit(30);
//       }

//       rows = List<Map<String, dynamic>>.from(response as List<dynamic>);

//       // Normalize data
//       for (var r in rows) {
//         r['follower_count'] = (r['follower_count'] is num)
//             ? (r['follower_count'] as num).toInt()
//             : int.tryParse(r['follower_count']?.toString() ?? '0') ?? 0;
//         r['engagement_rate'] = (r['engagement_rate'] is num)
//             ? (r['engagement_rate'] as num).toDouble()
//             : double.tryParse(r['engagement_rate']?.toString() ?? '0.0') ?? 0.0;
//       }

//       final popular = List<Map<String, dynamic>>.from(rows)
//         ..sort((a, b) => (b['follower_count']).compareTo(a['follower_count']));
//       final trending = List<Map<String, dynamic>>.from(rows)
//         ..sort((a, b) => (b['engagement_rate']).compareTo(a['engagement_rate']));

//       setState(() {
//         popularInfluencers = popular.take(10).toList();
//         trendingInfluencers = trending.take(10).toList();
//       });
//     } catch (e) {
//       debugPrint('❌ Error loading influencers: $e');
//       setState(() {
//         _error = true;
//       });
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   void _onCategoryTap(String category) {
//     setState(() {
//       if (_selectedCategory == category) {
//         _selectedCategory = null;
//         _fetchInfluencers();
//       } else {
//         _selectedCategory = category;
//         _fetchInfluencers(nicheFilter: category);
//       }
//     });
//   }

//   void _onNavTap(int index) => setState(() => _selectedIndex = index);

//   @override
//   Widget build(BuildContext context) {
//     final screens = [
//       _buildHome(),
//       const CampaignListScreen(),
//       const CampaignAnalyticsScreen(),
//       const BrandProfileScreen(),
//     ];

//     return Scaffold(
//       body: screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         selectedItemColor: AppTheme.primaryColor,
//         unselectedItemColor: Colors.grey,
//         onTap: _onNavTap,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.megaphone), label: "Campaigns"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.barChart2), label: "Analytics"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: "Profile"),
//         ],
//       ),
//     );
//   }

//   Widget _buildHome() {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Brand Dashboard"),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: SafeArea(
//         child: _loading
//             ? const Center(child: CircularProgressIndicator())
//             : _error
//                 ? Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text("Failed to load influencers"),
//                         const SizedBox(height: 10),
//                         ElevatedButton(onPressed: _fetchInfluencers, child: const Text("Retry"))
//                       ],
//                     ),
//                   )
//                 : SingleChildScrollView(
//                     padding: const EdgeInsets.only(bottom: 24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildBanners(),
//                         const SizedBox(height: 14),
//                         _buildModernCategories(),
//                         const SizedBox(height: 20),
//                         _buildSection("Popular Influencers", popularInfluencers),
//                         const SizedBox(height: 20),
//                         _buildSection("Trending Influencers", trendingInfluencers),
//                       ],
//                     ),
//                   ),
//       ),
//     );
//   }

//   Widget _buildBanners() {
//     return SizedBox(
//       height: 180,
//       child: PageView.builder(
//         controller: _pageController,
//         itemCount: _bannerImages.length,
//         itemBuilder: (context, i) {
//           return Container(
//             margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(14),
//               image: DecorationImage(
//                 image: NetworkImage(_bannerImages[i]),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   /// 🌈 Modern category UI with gradient accent
//   Widget _buildModernCategories() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           child: Text(
//             "Categories",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 50,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: _nicheOptions.length,
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             itemBuilder: (context, i) {
//               final cat = _nicheOptions[i];
//               final selected = _selectedCategory == cat;
//               return AnimatedContainer(
//                 duration: const Duration(milliseconds: 250),
//                 margin: const EdgeInsets.symmetric(horizontal: 6),
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(25),
//                   gradient: selected
//                       ? LinearGradient(colors: [
//                           AppTheme.primaryColor.withOpacity(0.9),
//                           AppTheme.primaryColor.withOpacity(0.6)
//                         ])
//                       : null,
//                   border: selected
//                       ? null
//                       : Border.all(color: Colors.grey.shade300),
//                   color: selected ? null : Colors.white,
//                   boxShadow: selected
//                       ? [
//                           BoxShadow(
//                             color: AppTheme.primaryColor.withOpacity(0.3),
//                             blurRadius: 8,
//                             offset: const Offset(0, 4),
//                           )
//                         ]
//                       : [],
//                 ),
//                 child: Center(
//                   child: Text(
//                     cat,
//                     style: TextStyle(
//                       color: selected ? Colors.white : Colors.black87,
//                       fontWeight:
//                           selected ? FontWeight.bold : FontWeight.w500,
//                       fontSize: 13.5,
//                     ),
//                   ),
//                 ),
//               ).buildGestureDetector(() => _onCategoryTap(cat));
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSection(String title, List<Map<String, dynamic>> influencers) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Text(title,
//               style:
//                   const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         const SizedBox(height: 12),
//         _influencerList(influencers),
//       ],
//     );
//   }

//   Widget _influencerList(List<Map<String, dynamic>> influencers) {
//     if (influencers.isEmpty) {
//       return const SizedBox(
//         height: 100,
//         child: Center(child: Text("No influencers found")),
//       );
//     }

//     return SizedBox(
//       height: 190,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: influencers.length,
//         itemBuilder: (context, i) {
//           final inf = influencers[i];
//           final image = (inf['profile_image'] ?? '').toString().isNotEmpty
//               ? inf['profile_image']
//               : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800&auto=format&fit=crop&q=80';

//           return GestureDetector(
//             onTap: () {
//               showModalBottomSheet(
//                 context: context,
//                 isScrollControlled: true,
//                 backgroundColor: Colors.transparent,
//                 builder: (_) => FractionallySizedBox(
//                   heightFactor: 0.92,
//                   child: InfluencerDashboard(influencerId: inf['id']),
//                 ),
//               );
//             },
//             child: Container(
//               width: 150,
//               margin: EdgeInsets.only(
//                 left: i == 0 ? 16 : 8,
//                 right: i == influencers.length - 1 ? 16 : 0,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.06),
//                       blurRadius: 6,
//                       offset: const Offset(0, 4))
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   ClipRRect(
//                     borderRadius:
//                         const BorderRadius.vertical(top: Radius.circular(12)),
//                     child: Image.network(
//                       image,
//                       height: 100,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => Container(
//                         height: 100,
//                         color: Colors.grey.shade300,
//                         child: const Icon(Icons.person,
//                             size: 40, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(inf['name'] ?? 'Unknown',
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 14),
//                       overflow: TextOverflow.ellipsis),
//                   Text('${inf['follower_count']} followers',
//                       style:
//                           const TextStyle(color: Colors.grey, fontSize: 12)),
//                   Text('Eng: ${inf['engagement_rate']}%',
//                       style:
//                           const TextStyle(color: Colors.grey, fontSize: 12)),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// extension _WidgetTapExtension on Widget {
//   Widget buildGestureDetector(VoidCallback onTap) =>
//       GestureDetector(onTap: onTap, child: this);
// }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/influencer/influencer_dashboard.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../utils/app_theme.dart';
// import '../analytics/campaign_analytics_screen.dart';
// import '../profile/brand_profile_screen.dart';
// import 'campaign_list_screen.dart';
// import 'view_all_influencers_screen.dart'; // import the new screen

// class BrandDashboard extends StatefulWidget {
//   const BrandDashboard({super.key});

//   @override
//   State<BrandDashboard> createState() => _BrandDashboardState();
// }

// class _BrandDashboardState extends State<BrandDashboard> {
//   int _selectedIndex = 0;
//   final PageController _pageController = PageController();
//   late Timer _bannerTimer;
//   int _bannerIndex = 0;

//   bool _loading = true;
//   bool _error = false;
//   List<Map<String, dynamic>> popularInfluencers = [];
//   List<Map<String, dynamic>> trendingInfluencers = [];

//   String? _selectedCategory;

//   final List<String> _nicheOptions = [
//     'Fashion & Beauty',
//     'Fitness & Wellness',
//     'Travel & Adventure',
//     'Technology & Gadgets',
//     'Food & Cooking',
//     'Gaming & Esports',
//     'Education & Motivation',
//     'Music & Entertainment',
//     'Lifestyle & Vlogs',
//     'Finance & Business',
//     'Health & Skincare',
//     'Sports & Outdoors',
//     'Comedy & Memes',
//     'Art & Photography',
//     'Other',
//   ];

//   final List<String> _bannerImages = [
//     'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=1200&auto=format&fit=crop&q=80',
//     'https://plus.unsplash.com/premium_photo-1664475926084-d20248544896?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
//     'https://plus.unsplash.com/premium_photo-1684017834450-21747b64d666?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1171',
//     'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=1200&auto=format&fit=crop&q=80',
//   ];

//   @override
//   void initState() {
//     super.initState();

//     _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
//       if (_pageController.hasClients && _bannerImages.isNotEmpty) {
//         _bannerIndex = (_bannerIndex + 1) % _bannerImages.length;
//         _pageController.animateToPage(
//           _bannerIndex,
//           duration: const Duration(milliseconds: 400),
//           curve: Curves.easeInOut,
//         );
//       }
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _fetchInfluencers();
//     });
//   }

//   @override
//   void dispose() {
//     _bannerTimer.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchInfluencers({String? nicheFilter}) async {
//     setState(() {
//       _loading = true;
//       _error = false;
//     });

//     try {
//       final sb = Supabase.instance.client;
//       List<Map<String, dynamic>> rows = [];
//       dynamic response;

//       if (nicheFilter != null && nicheFilter.isNotEmpty) {
//         response = await sb
//             .from('influencers')
//             .select('id, name, profile_image, niche, follower_count, engagement_rate')
//             .eq('niche', nicheFilter)
//             .order('follower_count', ascending: false)
//             .limit(30);
//       } else {
//         response = await sb
//             .from('influencers')
//             .select('id, name, profile_image, niche, follower_count, engagement_rate')
//             .order('follower_count', ascending: false)
//             .limit(30);
//       }

//       rows = List<Map<String, dynamic>>.from(response as List<dynamic>);

//       for (var r in rows) {
//         r['follower_count'] = (r['follower_count'] is num)
//             ? (r['follower_count'] as num).toInt()
//             : int.tryParse(r['follower_count']?.toString() ?? '0') ?? 0;
//         r['engagement_rate'] = (r['engagement_rate'] is num)
//             ? (r['engagement_rate'] as num).toDouble()
//             : double.tryParse(r['engagement_rate']?.toString() ?? '0.0') ?? 0.0;
//       }

//       final popular = List<Map<String, dynamic>>.from(rows)
//         ..sort((a, b) => (b['follower_count']).compareTo(a['follower_count']));
//       final trending = List<Map<String, dynamic>>.from(rows)
//         ..sort((a, b) => (b['engagement_rate']).compareTo(a['engagement_rate']));

//       setState(() {
//         popularInfluencers = popular.take(10).toList();
//         trendingInfluencers = trending.take(10).toList();
//       });
//     } catch (e) {
//       debugPrint('❌ Error loading influencers: $e');
//       setState(() {
//         _error = true;
//       });
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   void _onCategoryTap(String category) {
//     setState(() {
//       if (_selectedCategory == category) {
//         _selectedCategory = null;
//         _fetchInfluencers();
//       } else {
//         _selectedCategory = category;
//         _fetchInfluencers(nicheFilter: category);
//       }
//     });
//   }

//   void _onNavTap(int index) => setState(() => _selectedIndex = index);

//   @override
//   Widget build(BuildContext context) {
//     final screens = [
//       _buildHome(),
//       const CampaignListScreen(),
//       const CampaignAnalyticsScreen(),
//       const BrandProfileScreen(),
//     ];

//     return Scaffold(
//       body: screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         selectedItemColor: AppTheme.primaryColor,
//         unselectedItemColor: Colors.grey,
//         onTap: _onNavTap,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.megaphone), label: "Campaigns"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.barChart2), label: "Analytics"),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: "Profile"),
//         ],
//       ),
//     );
//   }

//   Widget _buildHome() {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Brand Dashboard"),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: SafeArea(
//         child: _loading
//             ? const Center(child: CircularProgressIndicator())
//             : _error
//                 ? Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text("Failed to load influencers"),
//                         const SizedBox(height: 10),
//                         ElevatedButton(onPressed: _fetchInfluencers, child: const Text("Retry"))
//                       ],
//                     ),
//                   )
//                 : SingleChildScrollView(
//                     padding: const EdgeInsets.only(bottom: 24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildBanners(),
//                         const SizedBox(height: 14),
//                         _buildModernCategories(),
//                         const SizedBox(height: 20),
//                         _buildSection("Popular Influencers", popularInfluencers, "popular"),
//                         const SizedBox(height: 20),
//                         _buildSection("Trending Influencers", trendingInfluencers, "trending"),
//                       ],
//                     ),
//                   ),
//       ),
//     );
//   }

//   Widget _buildBanners() {
//     return SizedBox(
//       height: 180,
//       child: PageView.builder(
//         controller: _pageController,
//         itemCount: _bannerImages.length,
//         itemBuilder: (context, i) {
//           return Container(
//             margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(14),
//               image: DecorationImage(
//                 image: NetworkImage(_bannerImages[i]),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildModernCategories() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           child: Text(
//             "Categories",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 50,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: _nicheOptions.length,
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             itemBuilder: (context, i) {
//               final cat = _nicheOptions[i];
//               final selected = _selectedCategory == cat;
//               return AnimatedContainer(
//                 duration: const Duration(milliseconds: 250),
//                 margin: const EdgeInsets.symmetric(horizontal: 6),
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(25),
//                   gradient: selected
//                       ? LinearGradient(colors: [
//                           AppTheme.primaryColor.withOpacity(0.9),
//                           AppTheme.primaryColor.withOpacity(0.6)
//                         ])
//                       : null,
//                   border: selected
//                       ? null
//                       : Border.all(color: Colors.grey.shade300),
//                   color: selected ? null : Colors.white,
//                   boxShadow: selected
//                       ? [
//                           BoxShadow(
//                             color: AppTheme.primaryColor.withOpacity(0.3),
//                             blurRadius: 8,
//                             offset: const Offset(0, 4),
//                           )
//                         ]
//                       : [],
//                 ),
//                 child: Center(
//                   child: Text(
//                     cat,
//                     style: TextStyle(
//                       color: selected ? Colors.white : Colors.black87,
//                       fontWeight: selected ? FontWeight.bold : FontWeight.w500,
//                       fontSize: 13.5,
//                     ),
//                   ),
//                 ),
//               ).buildGestureDetector(() => _onCategoryTap(cat));
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSection(String title, List<Map<String, dynamic>> influencers, String type) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Text(title,
//               style:
//                   const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ),
//         const SizedBox(height: 12),
//         _influencerList(influencers, type),
//       ],
//     );
//   }

//   Widget _influencerList(List<Map<String, dynamic>> influencers, String type) {
//     if (influencers.isEmpty) {
//       return const SizedBox(
//         height: 100,
//         child: Center(child: Text("No influencers found")),
//       );
//     }

//     final displayList = influencers.length > 3 ? influencers.sublist(0, 3) : influencers;

//     return Column(
//       children: [
//         SizedBox(
//           height: 190,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: displayList.length,
//             itemBuilder: (context, i) {
//               final inf = displayList[i];
//               final image = (inf['profile_image'] ?? '').toString().isNotEmpty
//                   ? inf['profile_image']
//                   : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800&auto=format&fit=crop&q=80';

//               return GestureDetector(
//                 onTap: () {
//                   showModalBottomSheet(
//                     context: context,
//                     isScrollControlled: true,
//                     backgroundColor: Colors.transparent,
//                     builder: (_) => FractionallySizedBox(
//                       heightFactor: 0.92,
//                       child: InfluencerDashboard(influencerId: inf['id']),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: 150,
//                   margin: EdgeInsets.only(
//                     left: i == 0 ? 16 : 8,
//                     right: i == displayList.length - 1 ? 16 : 0,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black.withOpacity(0.06),
//                           blurRadius: 6,
//                           offset: const Offset(0, 4))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ClipRRect(
//                         borderRadius:
//                             const BorderRadius.vertical(top: Radius.circular(12)),
//                         child: Image.network(
//                           image,
//                           height: 100,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                           errorBuilder: (_, __, ___) => Container(
//                             height: 100,
//                             color: Colors.grey.shade300,
//                             child: const Icon(Icons.person,
//                                 size: 40, color: Colors.grey),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(inf['name'] ?? 'Unknown',
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 14),
//                           overflow: TextOverflow.ellipsis),
//                       Text('${inf['follower_count']} followers',
//                           style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                       Text('Eng: ${inf['engagement_rate']}%',
//                           style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         if (influencers.length > 3)
//           Padding(
//             padding: const EdgeInsets.only(top: 8, right: 16),
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => ViewAllInfluencersScreen(
//                         popularInfluencers:
//                             type == "popular" ? influencers : popularInfluencers,
//                         trendingInfluencers:
//                             type == "trending" ? influencers : trendingInfluencers,
//                         initialTab: type,
//                       ),
//                     ),
//                   );
//                 },
//                 child: const Text("View All"),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

// extension _WidgetTapExtension on Widget {
//   Widget buildGestureDetector(VoidCallback onTap) =>
//       GestureDetector(onTap: onTap, child: this);
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/screens/influencer/influencer_dashboard.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../../../utils/app_theme.dart';
import '../../../providers/theme_provider.dart';
import '../analytics/campaign_analytics_screen.dart';
import '../profile/brand_profile_screen.dart';
import 'campaign_list_screen.dart';
import 'view_all_influencers_screen.dart';

class BrandDashboard extends StatefulWidget {
  const BrandDashboard({super.key});

  @override
  State<BrandDashboard> createState() => _BrandDashboardState();
}

class _BrandDashboardState extends State<BrandDashboard> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late Timer _bannerTimer;
  int _bannerIndex = 0;

  bool _loading = true;
  bool _error = false;
  List<Map<String, dynamic>> popularInfluencers = [];
  List<Map<String, dynamic>> trendingInfluencers = [];

  String? _selectedCategory;

  final List<String> _nicheOptions = [
    'Fashion & Beauty',
    'Fitness & Wellness',
    'Travel & Adventure',
    'Technology & Gadgets',
    'Food & Cooking',
    'Gaming & Esports',
    'Education & Motivation',
    'Music & Entertainment',
    'Lifestyle & Vlogs',
    'Finance & Business',
    'Health & Skincare',
    'Sports & Outdoors',
    'Comedy & Memes',
    'Art & Photography',
    'Other',
  ];

  final List<String> _bannerImages = [
    'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?w=1200&auto=format&fit=crop&q=80',
    'https://plus.unsplash.com/premium_photo-1664475926084-d20248544896?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
    'https://plus.unsplash.com/premium_photo-1684017834450-21747b64d666?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1171',
    'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=1200&auto=format&fit=crop&q=80',
  ];

  @override
  void initState() {
    super.initState();

    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients && _bannerImages.isNotEmpty) {
        _bannerIndex = (_bannerIndex + 1) % _bannerImages.length;
        _pageController.animateToPage(
          _bannerIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchInfluencers();
    });
  }

  @override
  void dispose() {
    _bannerTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchInfluencers({String? nicheFilter}) async {
    setState(() {
      _loading = true;
      _error = false;
    });

    try {
      final sb = Supabase.instance.client;
      List<Map<String, dynamic>> rows = [];
      dynamic response;

      if (nicheFilter != null && nicheFilter.isNotEmpty) {
        response = await sb
            .from('influencers')
            .select('id, name, profile_image, niche, follower_count, engagement_rate')
            .eq('niche', nicheFilter)
            .order('follower_count', ascending: false)
            .limit(30);
      } else {
        response = await sb
            .from('influencers')
            .select('id, name, profile_image, niche, follower_count, engagement_rate')
            .order('follower_count', ascending: false)
            .limit(30);
      }

      rows = List<Map<String, dynamic>>.from(response as List<dynamic>);

      for (var r in rows) {
        r['follower_count'] = (r['follower_count'] is num)
            ? (r['follower_count'] as num).toInt()
            : int.tryParse(r['follower_count']?.toString() ?? '0') ?? 0;
        r['engagement_rate'] = (r['engagement_rate'] is num)
            ? (r['engagement_rate'] as num).toDouble()
            : double.tryParse(r['engagement_rate']?.toString() ?? '0.0') ?? 0.0;
      }

      final popular = List<Map<String, dynamic>>.from(rows)
        ..sort((a, b) => (b['follower_count']).compareTo(a['follower_count']));
      final trending = List<Map<String, dynamic>>.from(rows)
        ..sort((a, b) => (b['engagement_rate']).compareTo(a['engagement_rate']));

      setState(() {
        popularInfluencers = popular.take(10).toList();
        trendingInfluencers = trending.take(10).toList();
      });
    } catch (e) {
      debugPrint('❌ Error loading influencers: $e');
      setState(() {
        _error = true;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onCategoryTap(String category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = null;
        _fetchInfluencers();
      } else {
        _selectedCategory = category;
        _fetchInfluencers(nicheFilter: category);
      }
    });
  }

  void _onNavTap(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;
    final screens = [
      _buildHome(),
      const CampaignListScreen(),
      const CampaignAnalyticsScreen(),
      const BrandProfileScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: isDark ? Colors.grey.shade500 : Colors.grey,
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          onTap: _onNavTap,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(LucideIcons.megaphone), label: "Campaigns"),
            BottomNavigationBarItem(icon: Icon(LucideIcons.barChart2), label: "Analytics"),
            BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildHome() {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          "Brand Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.3,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryColor,
                ),
              )
            : _error
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.alertCircle,
                          size: 64,
                          color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Failed to load influencers",
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryColor,
                                AppTheme.primaryColor.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _fetchInfluencers,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            icon: const Icon(LucideIcons.refreshCw, color: Colors.white, size: 18),
                            label: const Text(
                              "Retry",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBanners(),
                        const SizedBox(height: 20),
                        _buildModernCategories(),
                        const SizedBox(height: 24),
                        _buildSection(
                            "Popular Influencers", popularInfluencers, "popular"),
                        const SizedBox(height: 24),
                        _buildSection(
                            "Trending Influencers", trendingInfluencers, "trending"),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildBanners() {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;
    
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _bannerImages.length,
            onPageChanged: (index) {
              setState(() {
                _bannerIndex = index;
              });
            },
            itemBuilder: (context, i) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        _bannerImages[i],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                          child: Icon(
                            LucideIcons.image,
                            size: 50,
                            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                          ),
                        ),
                      ),
                      // Gradient overlay for better text readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _bannerImages.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _bannerIndex == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _bannerIndex == index
                    ? AppTheme.primaryColor
                    : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernCategories() {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                LucideIcons.layoutGrid,
                size: 20,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                "Categories",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _nicheOptions.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, i) {
              final cat = _nicheOptions[i];
              final selected = _selectedCategory == cat;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: selected
                      ? LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.primaryColor.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  border: selected
                      ? null
                      : Border.all(
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                          width: 1.5,
                        ),
                  color: selected ? null : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          )
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ],
                ),
                child: Center(
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : (isDark ? Colors.grey.shade300 : Colors.black87),
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ).buildGestureDetector(() => _onCategoryTap(cat));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
      String title, List<Map<String, dynamic>> influencers, String type) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;
    final icon = type == "popular" ? LucideIcons.trendingUp : LucideIcons.flame;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _influencerList(influencers, type),
      ],
    );
  }

  // Updated _influencerList to show "View All" as a card
  Widget _influencerList(List<Map<String, dynamic>> influencers, String type) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;
    
    if (influencers.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.users,
                size: 48,
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
              ),
              const SizedBox(height: 12),
              Text(
                "No influencers found",
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final displayList = influencers.length > 3 ? influencers.sublist(0, 3) : influencers;
    final itemCount = displayList.length >= 3 ? 4 : displayList.length;

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: itemCount,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, i) {
          if (i == 3) {
            // "View All" card
            return Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.1),
                    AppTheme.primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewAllInfluencersScreen(
                          popularInfluencers:
                              type == "popular" ? influencers : popularInfluencers,
                          trendingInfluencers:
                              type == "trending" ? influencers : trendingInfluencers,
                          initialTab: type,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.arrowRight,
                          color: AppTheme.primaryColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "View All",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${influencers.length} influencers",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final inf = displayList[i];
          final image = (inf['profile_image'] ?? '').toString().isNotEmpty
              ? inf['profile_image']
              : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800&auto=format&fit=crop&q=80';

          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => FractionallySizedBox(
                  heightFactor: 0.92,
                  child: InfluencerDashboard(influencerId: inf['id']),
                ),
              );
            },
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Stack(
                      children: [
                        Image.network(
                          image,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 120,
                            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                            child: Icon(
                              LucideIcons.user,
                              size: 40,
                              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                            ),
                          ),
                        ),
                        // Gradient overlay
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          inf['name'] ?? 'Unknown',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              LucideIcons.users,
                              size: 12,
                              color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${inf['follower_count']}',
                                style: TextStyle(
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              LucideIcons.trendingUp,
                              size: 12,
                              color: const Color(0xFF10B981),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${inf['engagement_rate']?.toStringAsFixed(1) ?? '0.0'}%',
                              style: const TextStyle(
                                color: Color(0xFF10B981),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

extension _WidgetTapExtension on Widget {
  Widget buildGestureDetector(VoidCallback onTap) =>
      GestureDetector(onTap: onTap, child: this);
}
