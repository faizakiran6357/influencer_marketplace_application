
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/influencer/earnings_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/offers_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/settings_screen.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';
// import 'edit_influencer_profile.dart';
// import 'portfolio_screen.dart';
// import 'audience_analytics_screen.dart';

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

//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final iconColor = isDark ? Colors.greenAccent : Colors.green;

//     // Manual data
//     final manualName = influencer?.name ?? "Influencer";
//     final manualBio = influencer?.bio?.isNotEmpty == true ? influencer!.bio! : "No bio available";
//     final manualFollowers = influencer?.followerCount ?? 0;
//     final manualEngagement = influencer?.engagementRate ?? 0.0;
//     final manualNiche = influencer?.niche ?? "N/A";
//     final manualProfileImage = influencer?.profileImage;

//     // YouTube data
//     final hasYouTube = influencer?.youtubeChannelName?.isNotEmpty == true &&
//         influencer?.youtubeSubscribers != null;

//     final ytName = hasYouTube ? influencer!.youtubeChannelName! : null;
//     final ytBio = hasYouTube ? influencer?.youtubeDescription : null;
//     final ytSubscribers = hasYouTube ? influencer?.youtubeSubscribers : null;
//     final ytThumbnail = hasYouTube ? influencer?.youtubeChannelThumbnail : null;

//     return Scaffold(
//       appBar: AppBar(title: Text("Welcome, ${ytName ?? manualName}")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ✅ Combined Influencer Card
//             Card(
//               color: Theme.of(context).cardColor,
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Profile picture and edit button
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CircleAvatar(
//                           radius: 40,
//                           backgroundColor: Colors.grey[300],
//                           backgroundImage: hasYouTube && ytThumbnail != null
//                               ? NetworkImage(ytThumbnail)
//                               : (manualProfileImage != null ? NetworkImage(manualProfileImage) : null),
//                           child: (manualProfileImage == null && ytThumbnail == null)
//                               ? const Icon(Icons.person, size: 40, color: Colors.white)
//                               : null,
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 ytName ?? manualName,
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
//                                 ytBio ?? manualBio,
//                                 style: TextStyle(color: textColor.withOpacity(0.7)),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.edit, color: Colors.green),
//                           tooltip: 'Edit Profile',
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (_) => const EditInfluencerProfile()),
//                             );
//                           },
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 16),
//                     const Divider(),

//                     // Manual Data Section
//                     Text("Manual Info", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
//                     const SizedBox(height: 8),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           _infoItem(icon: Icons.category, label: "Niche", value: manualNiche, color: textColor),
//                           const SizedBox(width: 16),
//                           _infoItem(icon: Icons.people, label: "Followers", value: "$manualFollowers", color: textColor),
//                           const SizedBox(width: 16),
//                           _infoItem(icon: Icons.trending_up, label: "Engagement", value: "${manualEngagement.toStringAsFixed(1)}%", color: textColor),
//                         ],
//                       ),
//                     ),

//                     if (hasYouTube) ...[
//                       const SizedBox(height: 16),
//                       const Divider(),
//                       const SizedBox(height: 8),

//                       // YouTube Data Section
//                       Text("YouTube Info", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
//                       const SizedBox(height: 8),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: [
//                             _infoItem(icon: Icons.play_arrow, label: "Channel", value: ytName!, color: Colors.redAccent),
//                             const SizedBox(width: 16),
//                             _infoItem(icon: Icons.people, label: "Subscribers", value: "$ytSubscribers", color: Colors.redAccent),
//                           ],
//                         ),
//                       ),
//                     ],
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
//                 _buildCard(context, "Portfolio", Icons.photo_library,
//                     const PortfolioScreen(), iconColor, textColor),
//                 _buildCard(context, "Offers", Icons.local_offer,
//                     const OffersScreen(), iconColor, textColor),
//                 _buildCard(context, "Earnings", Icons.attach_money,
//                     const EarningsScreen(), iconColor, textColor),
//                 _buildCard(context, "Settings", Icons.settings,
//                     const SettingsScreen(), iconColor, textColor),
//                 _buildCard(context, "Audience Analytics", Icons.bar_chart,
//                     const AudienceAnalyticsScreen(), iconColor, textColor),
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
//         Icon(icon, color: color, size: 24),
//         const SizedBox(height: 4),
//         Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 12)),
//         Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }

//   Widget _buildCard(
//       BuildContext context,
//       String title,
//       IconData icon,
//       Widget page,
//       Color iconColor,
//       Color textColor,
//       ) {
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
//             Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 14)),
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
// import 'audience_analytics_screen.dart';

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

//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final iconColor = isDark ? Colors.greenAccent : Colors.green;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Welcome, ${influencer?.name ?? "Influencer"}"),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Manual Profile Card
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
//                           backgroundImage: influencer?.profileImage != null
//                               ? NetworkImage(influencer!.profileImage!)
//                               : null,
//                           child: influencer?.profileImage == null
//                               ? const Icon(Icons.person, size: 40, color: Colors.white)
//                               : null,
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 influencer?.name ?? "Influencer",
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
//                                 influencer?.bio?.isNotEmpty == true
//                                     ? influencer!.bio!
//                                     : "No bio available",
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
//                                       value: influencer?.niche ?? "N/A",
//                                       color: textColor,
//                                     ),
//                                     const SizedBox(width: 16),
//                                     _infoItem(
//                                       icon: Icons.people,
//                                       label: "Followers",
//                                       value: "${influencer?.followerCount ?? 0}",
//                                       color: textColor,
//                                     ),
//                                     const SizedBox(width: 16),
//                                     _infoItem(
//                                       icon: Icons.trending_up,
//                                       label: "Engagement",
//                                       value:
//                                           "${(influencer?.engagementRate ?? 0.0).toStringAsFixed(1)}%",
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
//                     Positioned(
//                       top: 0,
//                       right: 0,
//                       child: IconButton(
//                         icon: const Icon(Icons.edit, color: Colors.green),
//                         tooltip: 'Edit Profile',
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const EditInfluencerProfile(),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // ✅ YouTube Profile Card (Expandable)
//             if (influencer?.youtubeChannelName?.isNotEmpty == true)
//               Card(
//                 color: Theme.of(context).cardColor,
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ExpansionTile(
//                   leading: CircleAvatar(
//                     radius: 25,
//                     backgroundColor: Colors.grey[300],
//                     backgroundImage: influencer?.youtubeChannelThumbnail != null
//                         ? NetworkImage(influencer!.youtubeChannelThumbnail!)
//                         : null,
//                     child: influencer?.youtubeChannelThumbnail == null
//                         ? const Icon(Icons.play_circle_fill,
//                             size: 25, color: Colors.white)
//                         : null,
//                   ),
//                   title: Text(
//                     influencer!.youtubeChannelName!,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: textColor,
//                     ),
//                   ),
//                   subtitle: Text(
//                     "${influencer.youtubeSubscribers ?? 0} subscribers",
//                     style: TextStyle(color: textColor.withOpacity(0.7)),
//                   ),
//                   childrenPadding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   children: [
//                     if (influencer.youtubeDescription?.isNotEmpty == true)
//                       Text(
//                         influencer.youtubeDescription!,
//                         style: TextStyle(color: textColor),
//                       ),
//                   ],
//                 ),
//               ),

//             const SizedBox(height: 20),

//             // Dashboard Cards
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
//                 _buildCard(context, "Audience Analytics", Icons.bar_chart,
//                     const AudienceAnalyticsScreen(), iconColor, textColor),
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
//         context,
//         MaterialPageRoute(builder: (_) => page),
//       ),
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

// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/influencer/earnings_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/my_campaigns_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/offers_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/settings_screen.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';
// import 'edit_influencer_profile.dart';
// import 'portfolio_screen.dart';
// import 'audience_analytics_screen.dart';

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

//     if (influencer == null) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final iconColor = isDark ? Colors.greenAccent : Colors.green;

//     final hasYouTube = influencer.youtubeChannelName?.isNotEmpty == true &&
//         influencer.youtubeSubscribers != null;

//     return Scaffold(
//       appBar: AppBar(title: Text("Welcome, ${influencer.name ?? 'Influencer'}")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // =========================
//             // Unified Influencer Card
//             // =========================
//             Card(
//               color: Theme.of(context).cardColor,
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     // Manual Influencer Info
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CircleAvatar(
//                           radius: 40,
//                           backgroundColor: Colors.grey[300],
//                           backgroundImage: influencer.profileImage != null
//                               ? NetworkImage(influencer.profileImage!)
//                               : null,
//                           child: influencer.profileImage == null
//                               ? const Icon(Icons.person,
//                                   size: 40, color: Colors.white)
//                               : null,
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 influencer.name ?? "No Name",
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
//                                 influencer.bio?.isNotEmpty == true
//                                     ? influencer.bio!
//                                     : "No bio available",
//                                 style:
//                                     TextStyle(color: textColor.withOpacity(0.7)),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(height: 12),
//                               SingleChildScrollView(
//                                 scrollDirection: Axis.horizontal,
//                                 child: Row(
//                                   children: [
//                                     _infoItem(
//                                         icon: Icons.category,
//                                         label: "Niche",
//                                         value: influencer.niche ?? "N/A",
//                                         color: textColor),
//                                     const SizedBox(width: 16),
//                                     _infoItem(
//                                         icon: Icons.people,
//                                         label: "Followers",
//                                         value:
//                                             "${influencer.followerCount ?? 0}",
//                                         color: textColor),
//                                     const SizedBox(width: 16),
//                                     _infoItem(
//                                         icon: Icons.trending_up,
//                                         label: "Engagement",
//                                         value:
//                                             "${influencer.engagementRate?.toStringAsFixed(1) ?? 0.0}%",
//                                         color: textColor),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Edit Button
//                         IconButton(
//                           icon: const Icon(Icons.edit, color: Colors.green),
//                           tooltip: 'Edit Profile',
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => const EditInfluencerProfile()),
//                             );
//                           },
//                         ),
//                       ],
//                     ),

//                     // =========================
//                     // YouTube Info Section
//                     // =========================
//                     if (hasYouTube) ...[
//                       const Divider(height: 32),
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           "YouTube Channel",
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: textColor),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundColor: Colors.grey[300],
//                             backgroundImage: influencer.youtubeChannelThumbnail != null
//                                 ? NetworkImage(influencer.youtubeChannelThumbnail!)
//                                 : null,
//                             child: influencer.youtubeChannelThumbnail == null
//                                 ? const Icon(Icons.video_library,
//                                     size: 30, color: Colors.white)
//                                 : null,
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   influencer.youtubeChannelName ?? "No Channel Name",
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: textColor),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   "Subscribers: ${influencer.youtubeSubscribers ?? 0}",
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       color: textColor.withOpacity(0.7)),
//                                 ),
//                                 if (influencer.youtubeDescription?.isNotEmpty == true)
//                                   Text(
//                                     influencer.youtubeDescription!,
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         color: textColor.withOpacity(0.7)),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // =========================
//             // Dashboard Cards
//             // =========================
//             // GridView.count(
//             //   crossAxisCount: 2,
//             //   shrinkWrap: true,
//             //   physics: const NeverScrollableScrollPhysics(),
//             //   crossAxisSpacing: 12,
//             //   mainAxisSpacing: 12,
//             //   childAspectRatio: 1.0,
//             //   children: [
//             //     _buildCard(context, "Portfolio", Icons.photo_library,
//             //         const PortfolioScreen(), iconColor, textColor),
//             //     _buildCard(context, "Offers", Icons.local_offer,
//             //         const OffersScreen(), iconColor, textColor),
//             //     _buildCard(context, "Earnings", Icons.attach_money,
//             //         const EarningsScreen(), iconColor, textColor),
//             //     _buildCard(context, "Settings", Icons.settings,
//             //         const SettingsScreen(), iconColor, textColor),
//             //     _buildCard(context, "Audience Analytics", Icons.bar_chart,
//             //         const AudienceAnalyticsScreen(), iconColor, textColor),
//             //   ],
//             // ),
//             GridView.count(
//   crossAxisCount: 2,
//   shrinkWrap: true,
//   physics: const NeverScrollableScrollPhysics(),
//   crossAxisSpacing: 12,
//   mainAxisSpacing: 12,
//   childAspectRatio: 1.0,
//   children: [
//     _buildCard(context, "Portfolio", Icons.photo_library,
//         const PortfolioScreen(), iconColor, textColor),

//     _buildCard(context, "My Campaigns", Icons.campaign,
//         const MyCampaignsScreen(), iconColor, textColor),

//     _buildCard(context, "Offers", Icons.local_offer,
//         const OffersScreen(), iconColor, textColor),

//     _buildCard(context, "Earnings", Icons.attach_money,
//         const EarningsScreen(), iconColor, textColor),

//     _buildCard(context, "Settings", Icons.settings,
//         const SettingsScreen(), iconColor, textColor),

//     _buildCard(context, "Audience Analytics", Icons.bar_chart,
//         const AudienceAnalyticsScreen(), iconColor, textColor),
//   ],
// ),

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
//       BuildContext context,
//       String title,
//       IconData icon,
//       Widget page,
//       Color iconColor,
//       Color textColor) {
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
import 'package:influencer_marketplace_application/screens/influencer/my_campaigns_screen.dart';
import 'package:influencer_marketplace_application/screens/influencer/offers_screen.dart';
import 'package:influencer_marketplace_application/screens/influencer/settings_screen.dart';
import 'package:influencer_marketplace_application/screens/influencer/influencer_chat_list_screen.dart'; // ✅ new import
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/influencer_provider.dart';
import 'edit_influencer_profile.dart';
import 'portfolio_screen.dart';
import 'audience_analytics_screen.dart';

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

    if (influencer == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconColor = isDark ? Colors.greenAccent : Colors.green;

    final hasYouTube = influencer.youtubeChannelName?.isNotEmpty == true &&
        influencer.youtubeSubscribers != null;

    return Scaffold(
      appBar: AppBar(title: Text("Welcome, ${influencer.name ?? 'Influencer'}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // =========================
            // Influencer Info Card
            // =========================
            Card(
              color: Theme.of(context).cardColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: influencer.profileImage != null
                              ? NetworkImage(influencer.profileImage!)
                              : null,
                          child: influencer.profileImage == null
                              ? const Icon(Icons.person,
                                  size: 40, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                influencer.name ?? "No Name",
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
                                influencer.bio?.isNotEmpty == true
                                    ? influencer.bio!
                                    : "No bio available",
                                style:
                                    TextStyle(color: textColor.withOpacity(0.7)),
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
                                        value: influencer.niche ?? "N/A",
                                        color: textColor),
                                    const SizedBox(width: 16),
                                    _infoItem(
                                        icon: Icons.people,
                                        label: "Followers",
                                        value:
                                            "${influencer.followerCount ?? 0}",
                                        color: textColor),
                                    const SizedBox(width: 16),
                                    _infoItem(
                                        icon: Icons.trending_up,
                                        label: "Engagement",
                                        value:
                                            "${influencer.engagementRate?.toStringAsFixed(1) ?? 0.0}%",
                                        color: textColor),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.green),
                          tooltip: 'Edit Profile',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const EditInfluencerProfile()),
                            );
                          },
                        ),
                      ],
                    ),
                    if (hasYouTube) ...[
                      const Divider(height: 32),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "YouTube Channel",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[300],
                            backgroundImage:
                                influencer.youtubeChannelThumbnail != null
                                    ? NetworkImage(
                                        influencer.youtubeChannelThumbnail!)
                                    : null,
                            child: influencer.youtubeChannelThumbnail == null
                                ? const Icon(Icons.video_library,
                                    size: 30, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  influencer.youtubeChannelName ??
                                      "No Channel Name",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: textColor),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Subscribers: ${influencer.youtubeSubscribers ?? 0}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: textColor.withOpacity(0.7)),
                                ),
                                if (influencer.youtubeDescription
                                        ?.isNotEmpty ==
                                    true)
                                  Text(
                                    influencer.youtubeDescription!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: textColor.withOpacity(0.7)),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // Dashboard Cards
            // =========================
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
                _buildCard(context, "My Campaigns", Icons.campaign,
                    const MyCampaignsScreen(), iconColor, textColor),
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

  Widget _buildCard(BuildContext context, String title, IconData icon,
      Widget page, Color iconColor, Color textColor) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => page)),
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
