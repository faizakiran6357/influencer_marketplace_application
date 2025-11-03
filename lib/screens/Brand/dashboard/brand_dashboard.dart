// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/auth_provider.dart';
// import '../../../providers/brand_provider.dart';
// import '../profile/brand_profile_screen.dart';
// import 'campaign_list_screen.dart';
// import '../analytics/campaign_analytics_screen.dart';
// import '../team/team_list_screen.dart';

// class BrandDashboard extends StatefulWidget {
//   const BrandDashboard({super.key});

//   @override
//   State<BrandDashboard> createState() => _BrandDashboardState();
// }

// class _BrandDashboardState extends State<BrandDashboard> {
//   @override
//   void initState() {
//     super.initState();
//     final userId = context.read<AuthProvider>().currentUser?.id;
//     if (userId != null) {
//       context.read<BrandProvider>().fetchBrand(userId);
//       context.read<BrandProvider>().fetchCampaigns(userId);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<BrandProvider>();
//     final brand = provider.brand;

//     if (provider.loading || brand == null) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Welcome, ${brand.name}"),
//       ),
//       body: GridView.count(
//         crossAxisCount: 2,
//         padding: const EdgeInsets.all(16),
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         children: [
//           _buildCard(context, "Profile", Icons.person, const BrandProfileScreen()),
//           _buildCard(context, "Campaigns", Icons.campaign, const CampaignListScreen()),
//           _buildCard(context, "Analytics", Icons.bar_chart, const CampaignAnalyticsScreen()),
//           _buildCard(context, "Team", Icons.group, const TeamListScreen()),
//         ],
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
//               Icon(icon, size: 40, color: Colors.green),
//               const SizedBox(height: 8),
//               Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/Brand/dashboard/Brand%20Settings%20Screen';
// import 'package:provider/provider.dart';
// import '../../../providers/auth_provider.dart';
// import '../../../providers/brand_provider.dart';
// import '../profile/brand_profile_screen.dart';
// import 'campaign_list_screen.dart';
// import '../analytics/campaign_analytics_screen.dart';
// import '../team/team_list_screen.dart';


// class BrandDashboard extends StatefulWidget {
//   const BrandDashboard({super.key});

//   @override
//   State<BrandDashboard> createState() => _BrandDashboardState();
// }

// class _BrandDashboardState extends State<BrandDashboard> {
//   @override
//   void initState() {
//     super.initState();

//     // ✅ Prevent calling Provider during build
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final userId = context.read<AuthProvider>().currentUser?.id;
//       if (userId != null) {
//         final provider = context.read<BrandProvider>();
//         provider.fetchBrand(userId);
//         provider.fetchCampaigns(userId);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<BrandProvider>();
//     final brand = provider.brand;
//     if (provider.loading) {
//   return const Scaffold(body: Center(child: CircularProgressIndicator()));
// }

// if (brand == null) {
//   return Scaffold(
//     appBar: AppBar(title: const Text("Brand Dashboard")),
//     body: const Center(
//       child: Text(
//         "No brand profile found. Please complete your profile setup.",
//         style: TextStyle(fontSize: 16),
//       ),
//     ),
//   );
// }
  

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Welcome, ${brand.name ?? 'Brand'}"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // ✅ Brand info card
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
//                           : const AssetImage('assets/images/default_avatar.png')
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
//                                   builder: (_) => const BrandProfileScreen(),
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
//                 _buildCard(context, "Campaigns", Icons.campaign,
//                     const CampaignListScreen()),
//                 _buildCard(context, "Analytics", Icons.bar_chart,
//                     const CampaignAnalyticsScreen()),
//                 _buildCard(context, "Team", Icons.group,
//                     const TeamListScreen()),
//                 _buildCard(context, "Settings", Icons.settings,
//                     const BrandSettingsScreen()), // ✅ Added settings card
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCard(
//       BuildContext context, String title, IconData icon, Widget page) {
//     return GestureDetector(
//       onTap: () =>
//           Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 40, color: Colors.green),
//               const SizedBox(height: 8),
//               Text(title,
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.w600)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/Brand/dashboard/Brand%20Settings%20Screen';
// import 'package:provider/provider.dart';
// import '../../../providers/auth_provider.dart';
// import '../../../providers/brand_provider.dart';
// import '../profile/edit_brand_profile.dart';
// import 'campaign_list_screen.dart';
// import '../analytics/campaign_analytics_screen.dart';
// import '../team/team_list_screen.dart';

// class BrandDashboard extends StatefulWidget {
//   const BrandDashboard({super.key});

//   @override
//   State<BrandDashboard> createState() => _BrandDashboardState();
// }

// class _BrandDashboardState extends State<BrandDashboard> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final userId = context.read<AuthProvider>().currentUser?.id;
//       if (userId != null) {
//         final provider = context.read<BrandProvider>();
//         provider.fetchBrand(userId);
//         provider.fetchCampaigns(userId);
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
//                           : const AssetImage('assets/images/default_avatar.png')
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
//                 _buildCard(context, "Campaigns", Icons.campaign,
//                     const CampaignListScreen()),
//                 _buildCard(context, "Analytics", Icons.bar_chart,
//                     const CampaignAnalyticsScreen()),
//                 _buildCard(context, "Team", Icons.group,
//                     const TeamListScreen()),
//                 _buildCard(context, "Settings", Icons.settings,
//                     const BrandSettingsScreen()),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCard(
//       BuildContext context, String title, IconData icon, Widget page) {
//     return GestureDetector(
//       onTap: () =>
//           Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 40, color: Colors.green),
//               const SizedBox(height: 8),
//               Text(title,
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.w600)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/screens/Brand/brand_chat_list_screen.dart';
import 'package:influencer_marketplace_application/screens/Brand/dashboard/Brand%20Settings%20Screen';

import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/brand_provider.dart';
import '../profile/edit_brand_profile.dart';
import 'campaign_list_screen.dart';
import '../analytics/campaign_analytics_screen.dart';
import '../team/team_list_screen.dart';


class BrandDashboard extends StatefulWidget {
  const BrandDashboard({super.key});

  @override
  State<BrandDashboard> createState() => _BrandDashboardState();
}

class _BrandDashboardState extends State<BrandDashboard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().currentUser?.id;
      if (userId != null) {
        final provider = context.read<BrandProvider>();
        provider.fetchBrand(userId);
        provider.fetchCampaigns(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BrandProvider>();
    final brand = provider.brand;

    if (provider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (brand == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Brand Dashboard")),
        body: const Center(
          child: Text(
            "No brand profile found. Please complete your profile setup.",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${brand.name ?? 'Brand'}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ Brand Info Card
            Card(
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: brand.profileImage != null &&
                              brand.profileImage!.isNotEmpty
                          ? NetworkImage(brand.profileImage!)
                          : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(brand.name ?? '',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(brand.website ?? 'No website added',
                              style: const TextStyle(color: Colors.blue)),
                          const SizedBox(height: 8),
                          Text(
                            brand.bio ?? 'No bio provided yet.',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditBrandProfile(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text("Edit Profile"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Dashboard Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildCard(context, "Campaigns", Icons.campaign,
                    const CampaignListScreen()),
                _buildCard(context, "Analytics", Icons.bar_chart,
                    const CampaignAnalyticsScreen()),
                _buildCard(
                    context, "Messages", Icons.chat, const BrandChatListScreen()), // ✅ New Chat Card
                _buildCard(context, "Team", Icons.group,
                    const TeamListScreen()),
                _buildCard(context, "Settings", Icons.settings,
                    const BrandSettingsScreen()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.green),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
