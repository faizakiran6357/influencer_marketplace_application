// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';
// import 'edit_influencer_profile.dart';
// import 'portfolio_screen.dart';


// class InfluencerDashboard extends StatefulWidget {
//   const InfluencerDashboard({super.key});

//   @override
//   State<InfluencerDashboard> createState() => _InfluencerDashboardState();
// }

// class _InfluencerDashboardState extends State<InfluencerDashboard> {
//   @override
//   void initState() {
//     super.initState();
//     final userId = context.read<AuthProvider>().currentUser?.id;
//     if (userId != null) {
//       context.read<InfluencerProvider>().fetchInfluencer(userId);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final influencer = context.watch<InfluencerProvider>().influencer;
//     final name = influencer?.name ?? "Influencer";

//     return Scaffold(
//       appBar: AppBar(title: Text("Welcome, $name")),
//       body: GridView.count(
//         crossAxisCount: 2,
//         padding: const EdgeInsets.all(20),
//         children: [
//           _buildCard(context, "Edit Profile", Icons.person, const EditInfluencerProfile()),
//           _buildCard(context, "Portfolio", Icons.photo_library, const PortfolioScreen()),
//           // _buildCard(context, "Offers", Icons.local_offer, const OffersScreen()),
//           // _buildCard(context, "Earnings", Icons.attach_money, const EarningsScreen()),
//           // _buildCard(context, "Settings", Icons.settings, const SettingsScreen()),
//         ],
//       ),
//     );
//   }

//   Widget _buildCard(BuildContext context, String title, IconData icon, Widget page) {
//     return GestureDetector(
//       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
//       child: Card(
//         elevation: 3,
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Icon(icon, size: 40, color: Colors.green),
//           const SizedBox(height: 10),
//           Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
//         ]),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/influencer/earnings_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/offers_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/settings_screen.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';
// import 'edit_influencer_profile.dart';
// import 'portfolio_screen.dart';

// class InfluencerDashboard extends StatefulWidget {
//   const InfluencerDashboard({super.key});

//   @override
//   State<InfluencerDashboard> createState() => _InfluencerDashboardState();
// }

// class _InfluencerDashboardState extends State<InfluencerDashboard> {
//   @override
//   void initState() {
//     super.initState();
//     // ✅ Delay fetch until after first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final userId = context.read<AuthProvider>().currentUser?.id;
//       if (userId != null) {
//         context.read<InfluencerProvider>().fetchInfluencer(userId);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final influencer = context.watch<InfluencerProvider>().influencer;
//     final name = influencer?.name ?? "Influencer";

//     return Scaffold(
//       appBar: AppBar(title: Text("Welcome, $name")),
//       body: GridView.count(
//         crossAxisCount: 2,
//         padding: const EdgeInsets.all(20),
//         children: [
//           _buildCard(context, "Edit Profile", Icons.person, const EditInfluencerProfile()),
//           _buildCard(context, "Portfolio", Icons.photo_library, const PortfolioScreen()),
//           _buildCard(context, "Offers", Icons.local_offer, const OffersScreen()),
//           _buildCard(context, "Earnings", Icons.attach_money, const EarningsScreen()),
//           _buildCard(context, "Settings", Icons.settings, const SettingsScreen()),
//         ],
//       ),
//     );
//   }

//   Widget _buildCard(BuildContext context, String title, IconData icon, Widget page) {
//     return GestureDetector(
//       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
//       child: Card(
//         elevation: 3,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: Colors.green),
//             const SizedBox(height: 10),
//             Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/influencer/earnings_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/offers_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/settings_screen.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';
// import 'edit_influencer_profile.dart';
// import 'portfolio_screen.dart';

// class InfluencerDashboard extends StatefulWidget {
//   const InfluencerDashboard({super.key});

//   @override
//   State<InfluencerDashboard> createState() => _InfluencerDashboardState();
// }

// class _InfluencerDashboardState extends State<InfluencerDashboard> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final userId = context.read<AuthProvider>().currentUser?.id;
//       if (userId != null) {
//         context.read<InfluencerProvider>().fetchInfluencer(userId);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final influencer = context.watch<InfluencerProvider>().influencer;
//     final name = influencer?.name ?? "Influencer";

//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final iconColor = isDark ? Colors.greenAccent : Colors.green;

//     return Scaffold(
//       appBar: AppBar(title: Text("Welcome, $name")),
//       body: GridView.count(
//         crossAxisCount: 2,
//         padding: const EdgeInsets.all(20),
//         children: [
//           _buildCard(context, "Edit Profile", Icons.person, const EditInfluencerProfile(), iconColor, textColor),
//           _buildCard(context, "Portfolio", Icons.photo_library, const PortfolioScreen(), iconColor, textColor),
//           _buildCard(context, "Offers", Icons.local_offer, const OffersScreen(), iconColor, textColor),
//           _buildCard(context, "Earnings", Icons.attach_money, const EarningsScreen(), iconColor, textColor),
//           _buildCard(context, "Settings", Icons.settings, const SettingsScreen(), iconColor, textColor),
//         ],
//       ),
//     );
//   }

//   Widget _buildCard(
//     BuildContext context,
//     String title,
//     IconData icon,
//     Widget page,
//     Color iconColor,
//     Color textColor,
//   ) {
//     return GestureDetector(
//       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
//       child: Card(
//         elevation: 3,
//         color: Theme.of(context).cardColor, // ✅ theme-aware card background
//         shadowColor: Theme.of(context).shadowColor.withOpacity(0.3),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: iconColor),
//             const SizedBox(height: 10),
//             Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: textColor, // ✅ theme-aware text color
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// correct code above//
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/influencer/earnings_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/offers_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/settings_screen.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';
// import 'edit_influencer_profile.dart';
// import 'portfolio_screen.dart';

// class InfluencerDashboard extends StatefulWidget {
//   const InfluencerDashboard({super.key});

//   @override
//   State<InfluencerDashboard> createState() => _InfluencerDashboardState();
// }

// class _InfluencerDashboardState extends State<InfluencerDashboard> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final userId = context.read<AuthProvider>().currentUser?.id;
//       if (userId != null) {
//         context.read<InfluencerProvider>().fetchInfluencer(userId);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final influencer = context.watch<InfluencerProvider>().influencer;
//     final name = influencer?.name ?? "Influencer";

//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final iconColor = isDark ? Colors.greenAccent : Colors.green;

//     return Scaffold(
//       appBar: AppBar(title: Text("Welcome, $name")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ✅ Influencer Info Section
//             if (influencer != null)
//               Card(
//                 color: Theme.of(context).cardColor,
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         influencer.name ?? "Unnamed Influencer",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: textColor,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       if (influencer.bio != null && influencer.bio!.isNotEmpty)
//                         Text(
//                           influencer.bio!,
//                           style: TextStyle(color: textColor.withOpacity(0.7)),
//                         ),
//                       const SizedBox(height: 12),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _infoItem(
//                             icon: Icons.category,
//                             label: "Niche",
//                             value: influencer.niche ?? "N/A",
//                             color: textColor,
//                           ),
//                           _infoItem(
//                             icon: Icons.people,
//                             label: "Followers",
//                             value: "${influencer.followerCount ?? 0}",
//                             color: textColor,
//                           ),
//                           _infoItem(
//                             icon: Icons.trending_up,
//                             label: "Engagement",
//                             value:
//                                 "${(influencer.engagementRate ?? 0).toStringAsFixed(1)}%",
//                             color: textColor,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//             const SizedBox(height: 20),

//             // ✅ Dashboard Cards
//             GridView.count(
//               crossAxisCount: 2,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               children: [
//                 _buildCard(context, "Edit Profile", Icons.person,
//                     const EditInfluencerProfile(), iconColor, textColor),
//                 _buildCard(context, "Portfolio", Icons.photo_library,
//                     const PortfolioScreen(), iconColor, textColor),
//                 _buildCard(context, "Offers", Icons.local_offer,
//                     const OffersScreen(), iconColor, textColor),
//                 _buildCard(context, "Earnings", Icons.attach_money,
//                     const EarningsScreen(), iconColor, textColor),
//                 _buildCard(context, "Settings", Icons.settings,
//                     const SettingsScreen(), iconColor, textColor),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _infoItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.green, size: 24),
//         const SizedBox(height: 4),
//         Text(label,
//             style: TextStyle(color: color.withOpacity(0.7), fontSize: 12)),
//         Text(value,
//             style: TextStyle(
//                 color: color, fontSize: 14, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }

//   Widget _buildCard(
//     BuildContext context,
//     String title,
//     IconData icon,
//     Widget page,
//     Color iconColor,
//     Color textColor,
//   ) {
//     return GestureDetector(
//       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
//       child: Card(
//         elevation: 3,
//         color: Theme.of(context).cardColor,
//         shadowColor: Theme.of(context).shadowColor.withOpacity(0.3),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: iconColor),
//             const SizedBox(height: 10),
//             Text(title,
//                 style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: textColor,
//                     fontSize: 14)),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/influencer/earnings_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/offers_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/settings_screen.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';
// import 'edit_influencer_profile.dart';
// import 'portfolio_screen.dart';

// class InfluencerDashboard extends StatefulWidget {
//   const InfluencerDashboard({super.key});

//   @override
//   State<InfluencerDashboard> createState() => _InfluencerDashboardState();
// }

// class _InfluencerDashboardState extends State<InfluencerDashboard> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final userId = context.read<AuthProvider>().currentUser?.id;
//       if (userId != null) {
//         context.read<InfluencerProvider>().fetchInfluencer(userId);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final influencerProvider = context.watch<InfluencerProvider>();
//     final influencer = influencerProvider.influencer;

//     final name = influencer?.name ?? "Influencer";
//     final bio = influencer?.bio?.isNotEmpty == true ? influencer!.bio! : "No bio available";
//     final niche = influencer?.niche ?? "N/A";
//     final followers = influencer?.followerCount ?? 0;
//     final engagement = influencer?.engagementRate ?? 0.0;

//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final iconColor = isDark ? Colors.greenAccent : Colors.green;

//     return Scaffold(
//       appBar: AppBar(title: Text("Welcome, $name")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ✅ Influencer Info Section
//             Card(
//               color: Theme.of(context).cardColor,
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: textColor,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       bio,
//                       style: TextStyle(color: textColor.withOpacity(0.7)),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _infoItem(
//                           icon: Icons.category,
//                           label: "Niche",
//                           value: niche,
//                           color: textColor,
//                         ),
//                         _infoItem(
//                           icon: Icons.people,
//                           label: "Followers",
//                           value: "$followers",
//                           color: textColor,
//                         ),
//                         _infoItem(
//                           icon: Icons.trending_up,
//                           label: "Engagement",
//                           value: "${engagement.toStringAsFixed(1)}%",
//                           color: textColor,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // ✅ Dashboard Cards
//             GridView.count(
//               crossAxisCount: 2,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               children: [
//                 _buildCard(context, "Edit Profile", Icons.person,
//                     const EditInfluencerProfile(), iconColor, textColor),
//                 _buildCard(context, "Portfolio", Icons.photo_library,
//                     const PortfolioScreen(), iconColor, textColor),
//                 _buildCard(context, "Offers", Icons.local_offer,
//                     const OffersScreen(), iconColor, textColor),
//                 _buildCard(context, "Earnings", Icons.attach_money,
//                     const EarningsScreen(), iconColor, textColor),
//                 _buildCard(context, "Settings", Icons.settings,
//                     const SettingsScreen(), iconColor, textColor),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _infoItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.green, size: 24),
//         const SizedBox(height: 4),
//         Text(label,
//             style: TextStyle(color: color.withOpacity(0.7), fontSize: 12)),
//         Text(value,
//             style: TextStyle(
//                 color: color, fontSize: 14, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }

//   Widget _buildCard(
//     BuildContext context,
//     String title,
//     IconData icon,
//     Widget page,
//     Color iconColor,
//     Color textColor,
//   ) {
//     return GestureDetector(
//       onTap: () => Navigator.push(
//           context, MaterialPageRoute(builder: (_) => page)),
//       child: Card(
//         elevation: 3,
//         color: Theme.of(context).cardColor,
//         shadowColor: Theme.of(context).shadowColor.withOpacity(0.3),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: iconColor),
//             const SizedBox(height: 10),
//             Text(title,
//                 style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: textColor,
//                     fontSize: 14)),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/influencer/earnings_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/offers_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/settings_screen.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';
// import 'edit_influencer_profile.dart';
// import 'portfolio_screen.dart';

// class InfluencerDashboard extends StatefulWidget {
//   const InfluencerDashboard({super.key});

//   @override
//   State<InfluencerDashboard> createState() => _InfluencerDashboardState();
// }

// class _InfluencerDashboardState extends State<InfluencerDashboard> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final userId = context.read<AuthProvider>().currentUser?.id;
//       if (userId != null) {
//         context.read<InfluencerProvider>().fetchInfluencer(userId);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final influencerProvider = context.watch<InfluencerProvider>();
//     final influencer = influencerProvider.influencer;

//     final name = influencer?.name ?? "Influencer";
//     final bio = influencer?.bio?.isNotEmpty == true ? influencer!.bio! : "No bio available";
//     final niche = influencer?.niche ?? "N/A";
//     final followers = influencer?.followerCount ?? 0;
//     final engagement = influencer?.engagementRate ?? 0.0;
//     final profileImage = influencer?.profileImage;

//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final iconColor = isDark ? Colors.greenAccent : Colors.green;

//     return Scaffold(
//       appBar: AppBar(title: Text("Welcome, $name")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ✅ Influencer Info Section with Profile Image
//             Card(
//               color: Theme.of(context).cardColor,
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 40,
//                       backgroundColor: Colors.grey[300],
//                       backgroundImage: profileImage != null
//                           ? NetworkImage(profileImage)
//                           : null,
//                       child: profileImage == null
//                           ? const Icon(Icons.person, size: 40, color: Colors.white)
//                           : null,
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             name,
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: textColor,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             bio,
//                             style: TextStyle(color: textColor.withOpacity(0.7)),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 12),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               _infoItem(
//                                 icon: Icons.category,
//                                 label: "Niche",
//                                 value: niche,
//                                 color: textColor,
//                               ),
//                               _infoItem(
//                                 icon: Icons.people,
//                                 label: "Followers",
//                                 value: "$followers",
//                                 color: textColor,
//                               ),
//                               _infoItem(
//                                 icon: Icons.trending_up,
//                                 label: "Engagement",
//                                 value: "${engagement.toStringAsFixed(1)}%",
//                                 color: textColor,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // ✅ Dashboard Cards
//             GridView.count(
//               crossAxisCount: 2,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               children: [
//                 _buildCard(context, "Edit Profile", Icons.person,
//                     const EditInfluencerProfile(), iconColor, textColor),
//                 _buildCard(context, "Portfolio", Icons.photo_library,
//                     const PortfolioScreen(), iconColor, textColor),
//                 _buildCard(context, "Offers", Icons.local_offer,
//                     const OffersScreen(), iconColor, textColor),
//                 _buildCard(context, "Earnings", Icons.attach_money,
//                     const EarningsScreen(), iconColor, textColor),
//                 _buildCard(context, "Settings", Icons.settings,
//                     const SettingsScreen(), iconColor, textColor),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _infoItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.green, size: 24),
//         const SizedBox(height: 4),
//         Text(label,
//             style: TextStyle(color: color.withOpacity(0.7), fontSize: 12)),
//         Text(value,
//             style: TextStyle(
//                 color: color, fontSize: 14, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }

//   Widget _buildCard(
//     BuildContext context,
//     String title,
//     IconData icon,
//     Widget page,
//     Color iconColor,
//     Color textColor,
//   ) {
//     return GestureDetector(
//       onTap: () => Navigator.push(
//           context, MaterialPageRoute(builder: (_) => page)),
//       child: Card(
//         elevation: 3,
//         color: Theme.of(context).cardColor,
//         shadowColor: Theme.of(context).shadowColor.withOpacity(0.3),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: iconColor),
//             const SizedBox(height: 10),
//             Text(title,
//                 style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: textColor,
//                     fontSize: 14)),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/influencer/earnings_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/offers_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/settings_screen.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';
// import 'edit_influencer_profile.dart';
// import 'portfolio_screen.dart';

// class InfluencerDashboard extends StatefulWidget {
//   const InfluencerDashboard({super.key});

//   @override
//   State<InfluencerDashboard> createState() => _InfluencerDashboardState();
// }

// class _InfluencerDashboardState extends State<InfluencerDashboard> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final userId = context.read<AuthProvider>().currentUser?.id;
//       if (userId != null) {
//         context.read<InfluencerProvider>().fetchInfluencer(userId);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final influencerProvider = context.watch<InfluencerProvider>();
//     final influencer = influencerProvider.influencer;

//     final name = influencer?.name ?? "Influencer";
//     final bio = influencer?.bio?.isNotEmpty == true ? influencer!.bio! : "No bio available";
//     final niche = influencer?.niche ?? "N/A";
//     final followers = influencer?.followerCount ?? 0;
//     final engagement = influencer?.engagementRate ?? 0.0;
//     final profileImage = influencer?.profileImage;

//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final iconColor = isDark ? Colors.greenAccent : Colors.green;

//     return Scaffold(
//       appBar: AppBar(title: Text("Welcome, $name")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ✅ Influencer Info Section with Profile Image
//             Card(
//               color: Theme.of(context).cardColor,
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       radius: 40,
//                       backgroundColor: Colors.grey[300],
//                       backgroundImage: profileImage != null
//                           ? NetworkImage(profileImage)
//                           : null,
//                       child: profileImage == null
//                           ? const Icon(Icons.person, size: 40, color: Colors.white)
//                           : null,
//                     ),
//                     const SizedBox(width: 16),
//                     Flexible(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             name,
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: textColor,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             bio,
//                             style: TextStyle(color: textColor.withOpacity(0.7)),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 12),
//                           SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               children: [
//                                 _infoItem(
//                                   icon: Icons.category,
//                                   label: "Niche",
//                                   value: niche,
//                                   color: textColor,
//                                 ),
//                                 const SizedBox(width: 16),
//                                 _infoItem(
//                                   icon: Icons.people,
//                                   label: "Followers",
//                                   value: "$followers",
//                                   color: textColor,
//                                 ),
//                                 const SizedBox(width: 16),
//                                 _infoItem(
//                                   icon: Icons.trending_up,
//                                   label: "Engagement",
//                                   value: "${engagement.toStringAsFixed(1)}%",
//                                   color: textColor,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // ✅ Dashboard Cards
//             GridView.count(
//               crossAxisCount: 2,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 1.0,
//               children: [
//                 _buildCard(context, "Edit Profile", Icons.person,
//                     const EditInfluencerProfile(), iconColor, textColor),
//                 _buildCard(context, "Portfolio", Icons.photo_library,
//                     const PortfolioScreen(), iconColor, textColor),
//                 _buildCard(context, "Offers", Icons.local_offer,
//                     const OffersScreen(), iconColor, textColor),
//                 _buildCard(context, "Earnings", Icons.attach_money,
//                     const EarningsScreen(), iconColor, textColor),
//                 _buildCard(context, "Settings", Icons.settings,
//                     const SettingsScreen(), iconColor, textColor),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _infoItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.green, size: 24),
//         const SizedBox(height: 4),
//         Text(label,
//             style: TextStyle(color: color.withOpacity(0.7), fontSize: 12)),
//         Text(value,
//             style: TextStyle(
//                 color: color, fontSize: 14, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }

//   Widget _buildCard(
//     BuildContext context,
//     String title,
//     IconData icon,
//     Widget page,
//     Color iconColor,
//     Color textColor,
//   ) {
//     return GestureDetector(
//       onTap: () => Navigator.push(
//           context, MaterialPageRoute(builder: (_) => page)),
//       child: Card(
//         elevation: 3,
//         color: Theme.of(context).cardColor,
//         shadowColor: Theme.of(context).shadowColor.withOpacity(0.3),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: iconColor),
//             const SizedBox(height: 10),
//             Text(title,
//                 style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: textColor,
//                     fontSize: 14)),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/influencer/earnings_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/offers_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/settings_screen.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';
// import 'edit_influencer_profile.dart';
// import 'portfolio_screen.dart';

// class InfluencerDashboard extends StatefulWidget {
//   const InfluencerDashboard({super.key});

//   @override
//   State<InfluencerDashboard> createState() => _InfluencerDashboardState();
// }

// class _InfluencerDashboardState extends State<InfluencerDashboard> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final userId = context.read<AuthProvider>().currentUser?.id;
//       if (userId != null) {
//         context.read<InfluencerProvider>().fetchInfluencer(userId);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final influencerProvider = context.watch<InfluencerProvider>();
//     final influencer = influencerProvider.influencer;

//     final name = influencer?.name ?? "Influencer";
//     final bio = influencer?.bio?.isNotEmpty == true ? influencer!.bio! : "No bio available";
//     final niche = influencer?.niche ?? "N/A";
//     final followers = influencer?.followerCount ?? 0;
//     final engagement = influencer?.engagementRate ?? 0.0;
//     final profileImage = influencer?.profileImage;

//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final iconColor = isDark ? Colors.greenAccent : Colors.green;

//     return Scaffold(
//       appBar: AppBar(title: Text("Welcome, $name")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ✅ Influencer Info Section with Edit Button
//             Card(
//               color: Theme.of(context).cardColor,
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//                 child: Stack(
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CircleAvatar(
//                           radius: 40,
//                           backgroundColor: Colors.grey[300],
//                           backgroundImage: profileImage != null
//                               ? NetworkImage(profileImage)
//                               : null,
//                           child: profileImage == null
//                               ? const Icon(Icons.person, size: 40, color: Colors.white)
//                               : null,
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 name,
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: textColor,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 bio,
//                                 style: TextStyle(color: textColor.withOpacity(0.7)),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(height: 12),
//                               SingleChildScrollView(
//                                 scrollDirection: Axis.horizontal,
//                                 child: Row(
//                                   children: [
//                                     _infoItem(
//                                       icon: Icons.category,
//                                       label: "Niche",
//                                       value: niche,
//                                       color: textColor,
//                                     ),
//                                     const SizedBox(width: 16),
//                                     _infoItem(
//                                       icon: Icons.people,
//                                       label: "Followers",
//                                       value: "$followers",
//                                       color: textColor,
//                                     ),
//                                     const SizedBox(width: 16),
//                                     _infoItem(
//                                       icon: Icons.trending_up,
//                                       label: "Engagement",
//                                       value: "${engagement.toStringAsFixed(1)}%",
//                                       color: textColor,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     // ✅ Edit Icon Button (top-right corner)
//                     Positioned(
//                       top: 0,
//                       right: 0,
//                       child: IconButton(
//                         icon: const Icon(Icons.edit, color: Colors.green),
//                         tooltip: 'Edit Profile',
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (_) => const EditInfluencerProfile()),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // ✅ Dashboard Cards (without Edit Profile)
//             GridView.count(
//               crossAxisCount: 2,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 1.0,
//               children: [
//                 _buildCard(context, "Portfolio", Icons.photo_library,
//                     const PortfolioScreen(), iconColor, textColor),
//                 _buildCard(context, "Offers", Icons.local_offer,
//                     const OffersScreen(), iconColor, textColor),
//                 _buildCard(context, "Earnings", Icons.attach_money,
//                     const EarningsScreen(), iconColor, textColor),
//                 _buildCard(context, "Settings", Icons.settings,
//                     const SettingsScreen(), iconColor, textColor),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _infoItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.green, size: 24),
//         const SizedBox(height: 4),
//         Text(label,
//             style: TextStyle(color: color.withOpacity(0.7), fontSize: 12)),
//         Text(value,
//             style: TextStyle(
//                 color: color, fontSize: 14, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }

//   Widget _buildCard(
//     BuildContext context,
//     String title,
//     IconData icon,
//     Widget page,
//     Color iconColor,
//     Color textColor,
//   ) {
//     return GestureDetector(
//       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
//       child: Card(
//         elevation: 3,
//         color: Theme.of(context).cardColor,
//         shadowColor: Theme.of(context).shadowColor.withOpacity(0.3),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: iconColor),
//             const SizedBox(height: 10),
//             Text(
//               title,
//               style: TextStyle(
//                   fontWeight: FontWeight.w600, color: textColor, fontSize: 14),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/screens/influencer/earnings_screen.dart';
import 'package:influencer_marketplace_application/screens/influencer/offers_screen.dart';
import 'package:influencer_marketplace_application/screens/influencer/settings_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/influencer_provider.dart';
import 'edit_influencer_profile.dart';
import 'portfolio_screen.dart';
import 'audience_analytics_screen.dart'; // <-- Make sure this screen exists

class InfluencerDashboard extends StatefulWidget {
  const InfluencerDashboard({super.key});

  @override
  State<InfluencerDashboard> createState() => _InfluencerDashboardState();
}

class _InfluencerDashboardState extends State<InfluencerDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().currentUser?.id;
      if (userId != null) {
        context.read<InfluencerProvider>().fetchInfluencer(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final influencerProvider = context.watch<InfluencerProvider>();
    final influencer = influencerProvider.influencer;

    final name = influencer?.name ?? "Influencer";
    final bio = influencer?.bio?.isNotEmpty == true ? influencer!.bio! : "No bio available";
    final niche = influencer?.niche ?? "N/A";
    final followers = influencer?.followerCount ?? 0;
    final engagement = influencer?.engagementRate ?? 0.0;
    final profileImage = influencer?.profileImage;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconColor = isDark ? Colors.greenAccent : Colors.green;

    return Scaffold(
      appBar: AppBar(title: Text("Welcome, $name")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Influencer Info Section with Edit Button
            Card(
              color: Theme.of(context).cardColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: profileImage != null
                              ? NetworkImage(profileImage)
                              : null,
                          child: profileImage == null
                              ? const Icon(Icons.person, size: 40, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                bio,
                                style: TextStyle(color: textColor.withOpacity(0.7)),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _infoItem(
                                      icon: Icons.category,
                                      label: "Niche",
                                      value: niche,
                                      color: textColor,
                                    ),
                                    const SizedBox(width: 16),
                                    _infoItem(
                                      icon: Icons.people,
                                      label: "Followers",
                                      value: "$followers",
                                      color: textColor,
                                    ),
                                    const SizedBox(width: 16),
                                    _infoItem(
                                      icon: Icons.trending_up,
                                      label: "Engagement",
                                      value: "${engagement.toStringAsFixed(1)}%",
                                      color: textColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // ✅ Edit Icon Button (top-right corner)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        tooltip: 'Edit Profile',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EditInfluencerProfile()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Dashboard Cards (without Edit Profile)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
              children: [
                _buildCard(context, "Portfolio", Icons.photo_library,
                    const PortfolioScreen(), iconColor, textColor),
                _buildCard(context, "Offers", Icons.local_offer,
                    const OffersScreen(), iconColor, textColor),
                _buildCard(context, "Earnings", Icons.attach_money,
                    const EarningsScreen(), iconColor, textColor),
                _buildCard(context, "Settings", Icons.settings,
                    const SettingsScreen(), iconColor, textColor),
                _buildCard(context, "Audience Analytics", Icons.bar_chart,
                    const AudienceAnalyticsScreen(), iconColor, textColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 24),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(color: color.withOpacity(0.7), fontSize: 12)),
        Text(value,
            style: TextStyle(
                color: color, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget page,
    Color iconColor,
    Color textColor,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Card(
        elevation: 3,
        color: Theme.of(context).cardColor,
        shadowColor: Theme.of(context).shadowColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: textColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
