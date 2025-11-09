
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/influencer/earnings_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/my_campaigns_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/offers_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/settings_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/influencer_chat_list_screen.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';
// import 'edit_influencer_profile.dart';
// import 'portfolio_screen.dart';
// import 'audience_analytics_screen.dart';

// // 🔔 Import NotificationService
// import '../../services/notification_service.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class InfluencerDashboard extends StatefulWidget {
//   const InfluencerDashboard({super.key});

//   @override
//   State<InfluencerDashboard> createState() => _InfluencerDashboardState();
// }

// class _InfluencerDashboardState extends State<InfluencerDashboard> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final userId = context.read<AuthProvider>().currentUser?.id;
//       if (userId != null) {
//         // Fetch influencer data
//         await context.read<InfluencerProvider>().fetchInfluencer(userId);

//         // ✅ Send Welcome Back notification
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
//             body:
//                 'Hello ${context.read<InfluencerProvider>().influencer?.name ?? 'Influencer'}',
//           );
//         }

//         // ✅ Listen for new notifications from Supabase
//         _listenForNotifications(userId);
//       }
//     });
//   }

//   // Realtime listener for notifications table
//   void _listenForNotifications(String userId) {
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
//     final influencerProvider = context.watch<InfluencerProvider>();
//     final influencer = influencerProvider.influencer;

//     if (influencer == null) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final iconColor = isDark ? Colors.greenAccent :Color(0xFFB25640);

//     final hasYouTube = influencer.youtubeChannelName?.isNotEmpty == true &&
//         influencer.youtubeSubscribers != null;

//     return Scaffold(
//       appBar: AppBar(title: Text("Welcome, ${influencer.name ?? 'Influencer'}")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // =========================
//             // Influencer Info Card
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
//                         IconButton(
//                           icon: const Icon(Icons.edit, color: Color(0xFFB25640)),
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
//                             backgroundImage:
//                                 influencer.youtubeChannelThumbnail != null
//                                     ? NetworkImage(
//                                         influencer.youtubeChannelThumbnail!)
//                                     : null,
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
//                                   influencer.youtubeChannelName ??
//                                       "No Channel Name",
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
//                                 if (influencer.youtubeDescription
//                                         ?.isNotEmpty ==
//                                     true)
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
//                 _buildCard(context, "My Campaigns", Icons.campaign,
//                     const MyCampaignsScreen(), iconColor, textColor),
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
//         Icon(icon, color: Color(0xFFB25640), size: 24),
//         const SizedBox(height: 4),
//         Text(label,
//             style: TextStyle(color: color.withOpacity(0.7), fontSize: 12)),
//         Text(value,
//             style: TextStyle(
//                 color: color, fontSize: 14, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }

//   Widget _buildCard(BuildContext context, String title, IconData icon,
//       Widget page, Color iconColor, Color textColor) {
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
// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import '../../providers/influencer_provider.dart';
// import 'earnings_screen.dart';
// import 'portfolio_screen.dart';
// import 'offers_screen.dart';
// import 'settings_screen.dart';
// import 'my_campaigns_screen.dart';

// class InfluencerDashboard extends StatefulWidget {
//   const InfluencerDashboard({super.key});

//   @override
//   State<InfluencerDashboard> createState() => _InfluencerDashboardState();
// }

// class _InfluencerDashboardState extends State<InfluencerDashboard> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = const [
//     _DashboardHome(),
//     MyCampaignsScreen(),
//     OffersScreen(),
//     PortfolioScreen(),
//     SettingsScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blueAccent,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.megaphone),
//             label: 'My Campaigns',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.gift),
//             label: 'Offers',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.folder),
//             label: 'Portfolio',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DashboardHome extends StatelessWidget {
//   const _DashboardHome();

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<InfluencerProvider>();
//     final influencer = provider.influencer;
//     final audience = provider.audience;

//     if (influencer == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text("Dashboard")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // 🧍 Profile Card
//             Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               elevation: 2,
//               child: ListTile(
//                 leading: CircleAvatar(
//                   radius: 28,
//                   backgroundImage: influencer.profileImage != null
//                       ? NetworkImage(influencer.profileImage!)
//                       : null,
//                   child: influencer.profileImage == null
//                       ? const Icon(Icons.person, size: 30)
//                       : null,
//                 ),
//                 title: Text(
//                   influencer.name ?? "Unnamed Influencer",
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Text(influencer.niche ?? "No niche selected"),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // 💰 Total Earnings Card
//             GestureDetector(
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const EarningsScreen()),
//               ),
//               child: Card(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                 elevation: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Total Earnings",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         "\$${provider.totalEarnings.toStringAsFixed(2)}",
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // 📊 Audience Analytics Summary
//             if (audience != null) ...[
//               const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Audience Overview",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Gender Pie
//               SizedBox(
//                 height: 200,
//                 child: SfCircularChart(
//                   series: <PieSeries<_GenderData, String>>[
//                     PieSeries<_GenderData, String>(
//                       dataSource: [
//                         _GenderData('Male', audience.genderMale),
//                         _GenderData('Female', audience.genderFemale),
//                         _GenderData('Other', audience.genderOther),
//                       ],
//                       xValueMapper: (_GenderData data, _) => data.label,
//                       yValueMapper: (_GenderData data, _) => data.value,
//                       dataLabelSettings: const DataLabelSettings(isVisible: true),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Age Bar Chart
//               SizedBox(
//                 height: 200,
//                 child: SfCartesianChart(
//                   primaryXAxis: CategoryAxis(),
//                   primaryYAxis: NumericAxis(),
//                   series: <CartesianSeries<_AgeData, String>>[
//                     ColumnSeries<_AgeData, String>(
//                       dataSource: [
//                         _AgeData('18-24', audience.age18_24),
//                         _AgeData('25-34', audience.age25_34),
//                         _AgeData('35+', audience.age35Plus),
//                       ],
//                       xValueMapper: (_AgeData data, _) => data.label,
//                       yValueMapper: (_AgeData data, _) => data.value.toDouble(),
//                       dataLabelSettings: const DataLabelSettings(isVisible: true),
//                       color: Colors.blueAccent,
//                     ),
//                   ],
//                 ),
//               ),
//             ] else
//               const Text("No audience analytics available yet."),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _GenderData {
//   final String label;
//   final int value;
//   _GenderData(this.label, this.value);
// }

// class _AgeData {
//   final String label;
//   final int value;
//   _AgeData(this.label, this.value);
// }
// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import '../../providers/influencer_provider.dart';
// import 'earnings_screen.dart';
// import 'portfolio_screen.dart';
// import 'offers_screen.dart';
// import 'settings_screen.dart';
// import 'my_campaigns_screen.dart';
// import 'edit_influencer_profile.dart';

// class InfluencerDashboard extends StatefulWidget {
//   const InfluencerDashboard({super.key});

//   @override
//   State<InfluencerDashboard> createState() => _InfluencerDashboardState();
// }

// class _InfluencerDashboardState extends State<InfluencerDashboard> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = const [
//     _DashboardHome(),
//     MyCampaignsScreen(),
//     OffersScreen(),
//     PortfolioScreen(),
//     SettingsScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blueAccent,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.megaphone),
//             label: 'My Campaigns',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.gift),
//             label: 'Offers',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.folder),
//             label: 'Portfolio',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DashboardHome extends StatelessWidget {
//   const _DashboardHome();

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<InfluencerProvider>();
//     final influencer = provider.influencer;
//     final audience = provider.audience;

//     if (influencer == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text("Dashboard")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🧍 Enhanced Influencer Info Card
//             Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               elevation: 3,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Profile image
//                         CircleAvatar(
//                           radius: 32,
//                           backgroundImage: influencer.profileImage != null
//                               ? NetworkImage(influencer.profileImage!)
//                               : null,
//                           child: influencer.profileImage == null
//                               ? const Icon(Icons.person, size: 32)
//                               : null,
//                         ),
//                         const SizedBox(width: 16),
//                         // Info (name, niche, bio)
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 influencer.name ?? "Unnamed Influencer",
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 influencer.niche ?? "No niche selected",
//                                 style: const TextStyle(color: Colors.grey),
//                               ),
//                               const SizedBox(height: 6),
//                               Text(
//                                 influencer.bio?.isNotEmpty == true
//                                     ? influencer.bio!
//                                     : "No bio available",
//                                 style: const TextStyle(fontSize: 13, color: Colors.black87),
//                               ),
//                             ],
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.edit, color: Colors.blueAccent),
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
//                     const SizedBox(height: 12),
//                     // Chips Row for engagement and followers
//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 4,
//                       children: [
//                         Chip(
//                           avatar: const Icon(Icons.show_chart,
//                               color: Colors.white, size: 18),
//                           label: Text(
//                             "Engagement: ${influencer.engagementRate?.toStringAsFixed(1) ?? '0'}%",
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                           backgroundColor: Colors.blueAccent,
//                         ),
//                         Chip(
//                           avatar: const Icon(Icons.people,
//                               color: Colors.white, size: 18),
//                           label: Text(
//                             "Followers: ${influencer.followerCount ?? 0}",
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                           backgroundColor: Colors.green,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // 💰 Total Earnings Card
//             GestureDetector(
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const EarningsScreen()),
//               ),
//               child: Card(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                 elevation: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Total Earnings",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         "\$${provider.totalEarnings.toStringAsFixed(2)}",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // 📊 Audience Analytics Summary
//             if (audience != null) ...[
//               const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Audience Overview",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Gender Pie
//               SizedBox(
//                 height: 200,
//                 child: SfCircularChart(
//                   series: <PieSeries<_GenderData, String>>[
//                     PieSeries<_GenderData, String>(
//                       dataSource: [
//                         _GenderData('Male', audience.genderMale),
//                         _GenderData('Female', audience.genderFemale),
//                         _GenderData('Other', audience.genderOther),
//                       ],
//                       xValueMapper: (_GenderData data, _) => data.label,
//                       yValueMapper: (_GenderData data, _) => data.value,
//                       dataLabelSettings: const DataLabelSettings(isVisible: true),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Age Bar Chart
//               SizedBox(
//                 height: 200,
//                 child: SfCartesianChart(
//                   primaryXAxis: CategoryAxis(),
//                   primaryYAxis: NumericAxis(),
//                   series: <CartesianSeries<_AgeData, String>>[
//                     ColumnSeries<_AgeData, String>(
//                       dataSource: [
//                         _AgeData('18-24', audience.age18_24),
//                         _AgeData('25-34', audience.age25_34),
//                         _AgeData('35+', audience.age35Plus),
//                       ],
//                       xValueMapper: (_AgeData data, _) => data.label,
//                       yValueMapper: (_AgeData data, _) => data.value.toDouble(),
//                       dataLabelSettings: const DataLabelSettings(isVisible: true),
//                       color: Colors.blueAccent,
//                     ),
//                   ],
//                 ),
//               ),
//             ] else
//               const Text("No audience analytics available yet."),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _GenderData {
//   final String label;
//   final int value;
//   _GenderData(this.label, this.value);
// }

// class _AgeData {
//   final String label;
//   final int value;
//   _AgeData(this.label, this.value);
// }
// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import '../../providers/influencer_provider.dart';
// import 'earnings_screen.dart';
// import 'portfolio_screen.dart';
// import 'offers_screen.dart';
// import 'settings_screen.dart';
// import 'my_campaigns_screen.dart';
// import 'edit_influencer_profile.dart';

// class InfluencerDashboard extends StatefulWidget {
//   const InfluencerDashboard({super.key});

//   @override
//   State<InfluencerDashboard> createState() => _InfluencerDashboardState();
// }

// class _InfluencerDashboardState extends State<InfluencerDashboard> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = const [
//     _DashboardHome(),
//     MyCampaignsScreen(),
//     OffersScreen(),
//     PortfolioScreen(),
//     SettingsScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blueAccent,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.megaphone),
//             label: 'My Campaigns',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.gift),
//             label: 'Offers',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.folder),
//             label: 'Portfolio',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DashboardHome extends StatelessWidget {
//   const _DashboardHome();

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<InfluencerProvider>();
//     final influencer = provider.influencer;
//     final audience = provider.audience;

//     if (influencer == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text("Dashboard")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🧍 Enhanced Influencer Info Card
//             Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               elevation: 3,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Profile image
//                     CircleAvatar(
//                       radius: 32,
//                       backgroundImage: influencer.profileImage != null
//                           ? NetworkImage(influencer.profileImage!)
//                           : null,
//                       child: influencer.profileImage == null
//                           ? const Icon(Icons.person, size: 32)
//                           : null,
//                     ),
//                     const SizedBox(width: 16),
//                     // Info (name, niche, bio)
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             influencer.name ?? "Unnamed Influencer",
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             influencer.niche ?? "No niche selected",
//                             style: const TextStyle(color: Colors.grey),
//                           ),
//                           const SizedBox(height: 6),
//                           Text(
//                             influencer.bio?.isNotEmpty == true
//                                 ? influencer.bio!
//                                 : "No bio available",
//                             style: const TextStyle(fontSize: 13, color: Colors.black87),
//                           ),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.blueAccent),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => const EditInfluencerProfile()),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // ✅ Engagement and Followers Chips outside below card
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Chip(
//                   avatar: const Icon(LucideIcons.activity,
//                       color: Colors.white, size: 18),
//                   label: Text(
//                     "Engagement: ${influencer.engagementRate?.toStringAsFixed(1) ?? '0'}%",
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   backgroundColor: Colors.blueAccent,
//                 ),
//                 const SizedBox(width: 8),
//                 Chip(
//                   avatar:
//                       const Icon(LucideIcons.users, color: Colors.white, size: 18),
//                   label: Text(
//                     "Followers: ${influencer.followerCount ?? 0}",
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   backgroundColor: Colors.green,
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             // 💰 Total Earnings Card
//             GestureDetector(
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const EarningsScreen()),
//               ),
//               child: Card(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                 elevation: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Total Earnings",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         "\$${provider.totalEarnings.toStringAsFixed(2)}",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // 📊 Audience Analytics Summary
//             if (audience != null) ...[
//               const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Audience Overview",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Gender Pie
//               SizedBox(
//                 height: 200,
//                 child: SfCircularChart(
//                   series: <PieSeries<_GenderData, String>>[
//                     PieSeries<_GenderData, String>(
//                       dataSource: [
//                         _GenderData('Male', audience.genderMale),
//                         _GenderData('Female', audience.genderFemale),
//                         _GenderData('Other', audience.genderOther),
//                       ],
//                       xValueMapper: (_GenderData data, _) => data.label,
//                       yValueMapper: (_GenderData data, _) => data.value,
//                       dataLabelSettings: const DataLabelSettings(isVisible: true),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Age Bar Chart
//               SizedBox(
//                 height: 200,
//                 child: SfCartesianChart(
//                   primaryXAxis: CategoryAxis(),
//                   primaryYAxis: NumericAxis(),
//                   series: <CartesianSeries<_AgeData, String>>[
//                     ColumnSeries<_AgeData, String>(
//                       dataSource: [
//                         _AgeData('18-24', audience.age18_24),
//                         _AgeData('25-34', audience.age25_34),
//                         _AgeData('35+', audience.age35Plus),
//                       ],
//                       xValueMapper: (_AgeData data, _) => data.label,
//                       yValueMapper: (_AgeData data, _) => data.value.toDouble(),
//                       dataLabelSettings: const DataLabelSettings(isVisible: true),
//                       color: Colors.blueAccent,
//                     ),
//                   ],
//                 ),
//               ),
//             ] else
//               const Text("No audience analytics available yet."),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _GenderData {
//   final String label;
//   final int value;
//   _GenderData(this.label, this.value);
// }

// class _AgeData {
//   final String label;
//   final int value;
//   _AgeData(this.label, this.value);
// }
// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import '../../providers/influencer_provider.dart';
// import 'earnings_screen.dart';
// import 'portfolio_screen.dart';
// import 'offers_screen.dart';
// import 'settings_screen.dart';
// import 'my_campaigns_screen.dart';
// import 'edit_influencer_profile.dart';

// class InfluencerDashboard extends StatefulWidget {
//   const InfluencerDashboard({super.key});

//   @override
//   State<InfluencerDashboard> createState() => _InfluencerDashboardState();
// }

// class _InfluencerDashboardState extends State<InfluencerDashboard> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = const [
//     _DashboardHome(),
//     MyCampaignsScreen(),
//     OffersScreen(),
//     PortfolioScreen(),
//     SettingsScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blueAccent,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.megaphone),
//             label: 'My Campaigns',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.gift),
//             label: 'Offers',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.folder),
//             label: 'Portfolio',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DashboardHome extends StatelessWidget {
//   const _DashboardHome();

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<InfluencerProvider>();
//     final influencer = provider.influencer;
//     final audience = provider.audience;

//     if (influencer == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text("Dashboard")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🧍 Influencer Info Card
//             Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               elevation: 3,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       radius: 32,
//                       backgroundImage: influencer.profileImage != null
//                           ? NetworkImage(influencer.profileImage!)
//                           : null,
//                       child: influencer.profileImage == null
//                           ? const Icon(Icons.person, size: 32)
//                           : null,
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             influencer.name ?? "Unnamed Influencer",
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             influencer.niche ?? "No niche selected",
//                             style: const TextStyle(color: Colors.grey),
//                           ),
//                           const SizedBox(height: 6),
//                           Text(
//                             influencer.bio?.isNotEmpty == true
//                                 ? influencer.bio!
//                                 : "No bio available",
//                             style: const TextStyle(fontSize: 13, color: Colors.black87),
//                           ),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.blueAccent),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => const EditInfluencerProfile()),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // ✅ Compact Engagement + Followers Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _StatCard(
//                   color: Colors.blueAccent,
//                   icon: LucideIcons.activity,
//                   title: "Engagement",
//                   value:
//                       "${influencer.engagementRate?.toStringAsFixed(1) ?? '0'}%",
//                 ),
//                 _StatCard(
//                   color: Colors.green,
//                   icon: LucideIcons.users,
//                   title: "Followers",
//                   value: "${influencer.followerCount ?? 0}",
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             // 💰 Total Earnings Card
//             GestureDetector(
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const EarningsScreen()),
//               ),
//               child: Card(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                 elevation: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Total Earnings",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         "\$${provider.totalEarnings.toStringAsFixed(2)}",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // 📊 Audience Analytics Summary
//             if (audience != null) ...[
//               const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Audience Overview",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Gender Pie Chart
//               SizedBox(
//                 height: 200,
//                 child: SfCircularChart(
//                   series: <PieSeries<_GenderData, String>>[
//                     PieSeries<_GenderData, String>(
//                       dataSource: [
//                         _GenderData('Male', audience.genderMale),
//                         _GenderData('Female', audience.genderFemale),
//                         _GenderData('Other', audience.genderOther),
//                       ],
//                       xValueMapper: (_GenderData data, _) => data.label,
//                       yValueMapper: (_GenderData data, _) => data.value,
//                       dataLabelSettings: const DataLabelSettings(isVisible: true),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Age Bar Chart
//               SizedBox(
//                 height: 200,
//                 child: SfCartesianChart(
//                   primaryXAxis: CategoryAxis(),
//                   primaryYAxis: NumericAxis(),
//                   series: <CartesianSeries<_AgeData, String>>[
//                     ColumnSeries<_AgeData, String>(
//                       dataSource: [
//                         _AgeData('18-24', audience.age18_24),
//                         _AgeData('25-34', audience.age25_34),
//                         _AgeData('35+', audience.age35Plus),
//                       ],
//                       xValueMapper: (_AgeData data, _) => data.label,
//                       yValueMapper: (_AgeData data, _) => data.value.toDouble(),
//                       dataLabelSettings: const DataLabelSettings(isVisible: true),
//                       color: Colors.blueAccent,
//                     ),
//                   ],
//                 ),
//               ),
//             ] else
//               const Text("No audience analytics available yet."),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ✅ Reusable Small Stat Card (icon + title + value vertically aligned)
// class _StatCard extends StatelessWidget {
//   final Color color;
//   final IconData icon;
//   final String title;
//   final String value;

//   const _StatCard({
//     required this.color,
//     required this.icon,
//     required this.title,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 140,
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.4)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: color, size: 22),
//           const SizedBox(height: 6),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 13,
//               color: color,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _GenderData {
//   final String label;
//   final int value;
//   _GenderData(this.label, this.value);
// }

// class _AgeData {
//   final String label;
//   final int value;
//   _AgeData(this.label, this.value);
// }
// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import '../../providers/influencer_provider.dart';
// import '../../utils/app_theme.dart';
// import 'earnings_screen.dart';
// import 'portfolio_screen.dart';
// import 'offers_screen.dart';
// import 'settings_screen.dart';
// import 'my_campaigns_screen.dart';
// import 'edit_influencer_profile.dart';

// class InfluencerDashboard extends StatefulWidget {
//   const InfluencerDashboard({super.key});

//   @override
//   State<InfluencerDashboard> createState() => _InfluencerDashboardState();
// }

// class _InfluencerDashboardState extends State<InfluencerDashboard> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = const [
//     _DashboardHome(),
//     MyCampaignsScreen(),
//     OffersScreen(),
//     PortfolioScreen(),
//     SettingsScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Theme.of(context).primaryColor,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.megaphone), label: 'My Campaigns'),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.gift), label: 'Offers'),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.folder), label: 'Portfolio'),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.settings), label: 'Settings'),
//         ],
//       ),
//     );
//   }
// }

// class _DashboardHome extends StatelessWidget {
//   const _DashboardHome();

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<InfluencerProvider>();
//     final influencer = provider.influencer;
//     final audience = provider.audience;
//     final primary = Theme.of(context).primaryColor;

//     if (influencer == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // 🌈 Curved Gradient Header
//             Stack(
//               children: [
//                 ClipPath(
//                   clipper: _CurvedHeaderClipper(),
//                   child: Container(
//                     height: 210,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [primary, primary.withOpacity(0.8)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned.fill(
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 55),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CircleAvatar(
//                             radius: 36,
//                             backgroundImage: influencer.profileImage != null
//                                 ? NetworkImage(influencer.profileImage!)
//                                 : null,
//                             child: influencer.profileImage == null
//                                 ? const Icon(Icons.person, size: 36, color: Colors.white)
//                                 : null,
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   influencer.name ?? "Unnamed Influencer",
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   influencer.niche ?? "No niche selected",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white.withOpacity(0.9),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Text(
//                                   influencer.bio?.isNotEmpty == true
//                                       ? influencer.bio!
//                                       : "No bio available",
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: Colors.white.withOpacity(0.9),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.edit, color: Colors.white),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (_) => const EditInfluencerProfile()),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 10),

//             // 🟢 Engagement + Followers Chips
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _StatCard(
//                   color: Colors.blueAccent,
//                   icon: LucideIcons.activity,
//                   title: "Engagement",
//                   value: "${influencer.engagementRate?.toStringAsFixed(1) ?? '0'}%",
//                 ),
//                 _StatCard(
//                   color: Colors.green,
//                   icon: LucideIcons.users,
//                   title: "Followers",
//                   value: "${influencer.followerCount ?? 0}",
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             // 💰 Gradient Total Earnings Card
//             GestureDetector(
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const EarningsScreen()),
//               ),
//               child: Container(
//                 width: double.infinity,
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [primary, Colors.green.shade400],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.08),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: const [
//                         Icon(LucideIcons.wallet, color: Colors.white, size: 22),
//                         SizedBox(width: 8),
//                         Text(
//                           "Total Earnings",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       "\$${provider.totalEarnings.toStringAsFixed(2)}",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             // 📊 Audience Analytics (No extra cards)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Audience Overview",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 12),

//                   // Gender Pie Chart
//                   if (audience != null)
//                     SizedBox(
//                       height: 200,
//                       child: SfCircularChart(
//                         series: <PieSeries<_GenderData, String>>[
//                           PieSeries<_GenderData, String>(
//                             dataSource: [
//                               _GenderData('Male', audience.genderMale),
//                               _GenderData('Female', audience.genderFemale),
//                               _GenderData('Other', audience.genderOther),
//                             ],
//                             xValueMapper: (_GenderData data, _) => data.label,
//                             yValueMapper: (_GenderData data, _) => data.value,
//                             dataLabelSettings: const DataLabelSettings(isVisible: true),
//                           ),
//                         ],
//                       ),
//                     )
//                   else
//                     const Text("No audience analytics available yet."),

//                   const SizedBox(height: 24),

//                   if (audience != null)
//                     SizedBox(
//                       height: 200,
//                       child: SfCartesianChart(
//                         primaryXAxis: CategoryAxis(),
//                         primaryYAxis: NumericAxis(),
//                         series: <CartesianSeries<_AgeData, String>>[
//                           ColumnSeries<_AgeData, String>(
//                             dataSource: [
//                               _AgeData('18-24', audience.age18_24),
//                               _AgeData('25-34', audience.age25_34),
//                               _AgeData('35+', audience.age35Plus),
//                             ],
//                             xValueMapper: (_AgeData data, _) => data.label,
//                             yValueMapper: (_AgeData data, _) => data.value.toDouble(),
//                             dataLabelSettings: const DataLabelSettings(isVisible: true),
//                             color: primary,
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // 🌊 Custom Curved Header Clipper
// class _CurvedHeaderClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(0, size.height - 40);
//     path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 40);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

// // ✅ Stat Chips
// class _StatCard extends StatelessWidget {
//   final Color color;
//   final IconData icon;
//   final String title;
//   final String value;

//   const _StatCard({
//     required this.color,
//     required this.icon,
//     required this.title,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 140,
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: color, size: 22),
//           const SizedBox(height: 6),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 13,
//               color: color,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _GenderData {
//   final String label;
//   final int value;
//   _GenderData(this.label, this.value);
// }

// class _AgeData {
//   final String label;
//   final int value;
//   _AgeData(this.label, this.value);
// }
// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../providers/influencer_provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../services/notification_service.dart';
// import '../../utils/app_theme.dart';
// import 'earnings_screen.dart';
// import 'portfolio_screen.dart';
// import 'offers_screen.dart';
// import 'settings_screen.dart';
// import 'my_campaigns_screen.dart';
// import 'edit_influencer_profile.dart';

// class InfluencerDashboard extends StatefulWidget {
//   const InfluencerDashboard({super.key});

//   @override
//   State<InfluencerDashboard> createState() => _InfluencerDashboardState();
// }

// class _InfluencerDashboardState extends State<InfluencerDashboard> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = const [
//     _DashboardHome(),
//     MyCampaignsScreen(),
//     OffersScreen(),
//     PortfolioScreen(),
//     SettingsScreen(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final userId = context.read<AuthProvider>().currentUser?.id;
//       if (userId != null) {
//         // ✅ Fetch influencer data
//         await context.read<InfluencerProvider>().fetchInfluencer(userId);

//         // ✅ Send Welcome Back notification
//         final userData = await Supabase.instance.client
//             .from('profiles')
//             .select('fcm_token')
//             .eq('id', userId)
//             .maybeSingle();

//         final token = userData?['fcm_token'];
//         final influencerName = context.read<InfluencerProvider>().influencer?.name ?? 'Influencer';

//         if (token != null) {
//           await NotificationService.sendPushMessage(
//             targetToken: token,
//             title: 'Welcome Back!',
//             body: 'Hello $influencerName 👋',
//           );
//         }

//         // ✅ Listen for new notifications (e.g., campaign accepted)
//         _listenForNotifications(userId);
//       }
//     });
//   }

//   void _listenForNotifications(String userId) {
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

//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Theme.of(context).primaryColor,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.megaphone), label: 'My Campaigns'),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.gift), label: 'Offers'),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.folder), label: 'Portfolio'),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.settings), label: 'Settings'),
//         ],
//       ),
//     );
//   }
// }

// class _DashboardHome extends StatelessWidget {
//   const _DashboardHome();

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<InfluencerProvider>();
//     final influencer = provider.influencer;
//     final audience = provider.audience;
//     final primary = Theme.of(context).primaryColor;

//     if (influencer == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // 🌈 Curved Gradient Header
//             Stack(
//               children: [
//                 ClipPath(
//                   clipper: _CurvedHeaderClipper(),
//                   child: Container(
//                     height: 210,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [primary, primary.withOpacity(0.8)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned.fill(
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 55),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CircleAvatar(
//                             radius: 36,
//                             backgroundImage: influencer.profileImage != null
//                                 ? NetworkImage(influencer.profileImage!)
//                                 : null,
//                             child: influencer.profileImage == null
//                                 ? const Icon(Icons.person, size: 36, color: Colors.white)
//                                 : null,
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   influencer.name ?? "Unnamed Influencer",
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   influencer.niche ?? "No niche selected",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white.withOpacity(0.9),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Text(
//                                   influencer.bio?.isNotEmpty == true
//                                       ? influencer.bio!
//                                       : "No bio available",
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: Colors.white.withOpacity(0.9),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.edit, color: Colors.white),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (_) => const EditInfluencerProfile()),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 10),

//             // 🟢 Engagement + Followers Chips
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _StatCard(
//                   color: Colors.blueAccent,
//                   icon: LucideIcons.activity,
//                   title: "Engagement",
//                   value: "${influencer.engagementRate?.toStringAsFixed(1) ?? '0'}%",
//                 ),
//                 _StatCard(
//                   color: Colors.green,
//                   icon: LucideIcons.users,
//                   title: "Followers",
//                   value: "${influencer.followerCount ?? 0}",
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             // 💰 Gradient Total Earnings Card
//             GestureDetector(
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const EarningsScreen()),
//               ),
//               child: Container(
//                 width: double.infinity,
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [primary, Colors.green.shade400],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.08),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: const [
//                         Icon(LucideIcons.wallet, color: Colors.white, size: 22),
//                         SizedBox(width: 8),
//                         Text(
//                           "Total Earnings",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       "\$${provider.totalEarnings.toStringAsFixed(2)}",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             // 📊 Audience Analytics (No extra cards)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Audience Overview",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 12),

//                   // Gender Pie Chart
//                   if (audience != null)
//                     SizedBox(
//                       height: 200,
//                       child: SfCircularChart(
//                         series: <PieSeries<_GenderData, String>>[
//                           PieSeries<_GenderData, String>(
//                             dataSource: [
//                               _GenderData('Male', audience.genderMale),
//                               _GenderData('Female', audience.genderFemale),
//                               _GenderData('Other', audience.genderOther),
//                             ],
//                             xValueMapper: (_GenderData data, _) => data.label,
//                             yValueMapper: (_GenderData data, _) => data.value,
//                             dataLabelSettings: const DataLabelSettings(isVisible: true),
//                           ),
//                         ],
//                       ),
//                     )
//                   else
//                     const Text("No audience analytics available yet."),

//                   const SizedBox(height: 24),

//                   if (audience != null)
//                     SizedBox(
//                       height: 200,
//                       child: SfCartesianChart(
//                         primaryXAxis: CategoryAxis(),
//                         primaryYAxis: NumericAxis(),
//                         series: <CartesianSeries<_AgeData, String>>[
//                           ColumnSeries<_AgeData, String>(
//                             dataSource: [
//                               _AgeData('18-24', audience.age18_24),
//                               _AgeData('25-34', audience.age25_34),
//                               _AgeData('35+', audience.age35Plus),
//                             ],
//                             xValueMapper: (_AgeData data, _) => data.label,
//                             yValueMapper: (_AgeData data, _) => data.value.toDouble(),
//                             dataLabelSettings: const DataLabelSettings(isVisible: true),
//                             color: primary,
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // 🌊 Curved Header Clipper
// class _CurvedHeaderClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(0, size.height - 40);
//     path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 40);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

// // ✅ Stat Chips
// class _StatCard extends StatelessWidget {
//   final Color color;
//   final IconData icon;
//   final String title;
//   final String value;

//   const _StatCard({
//     required this.color,
//     required this.icon,
//     required this.title,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 140,
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: color, size: 22),
//           const SizedBox(height: 6),
//           Text(
//             title,
//             style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 4),
//           Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
//         ],
//       ),
//     );
//   }
// }

// class _GenderData {
//   final String label;
//   final int value;
//   _GenderData(this.label, this.value);
// }

// class _AgeData {
//   final String label;
//   final int value;
//   _AgeData(this.label, this.value);
// }
// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../providers/influencer_provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../services/notification_service.dart';
// import '../../utils/app_theme.dart';
// import 'earnings_screen.dart';
// import 'portfolio_screen.dart';
// import 'offers_screen.dart';
// import 'settings_screen.dart';
// import 'my_campaigns_screen.dart';
// import 'edit_influencer_profile.dart';

// class InfluencerDashboard extends StatefulWidget {
//   final String? influencerId; // ✅ make optional

//   const InfluencerDashboard({super.key, this.influencerId});

//   @override
//   State<InfluencerDashboard> createState() => _InfluencerDashboardState();
// }

// class _InfluencerDashboardState extends State<InfluencerDashboard> {
//   int _selectedIndex = 0;

//   late final List<Widget> _screens;

//   @override
//   void initState() {
//     super.initState();

//     _screens = const [
//       _DashboardHome(),
//       MyCampaignsScreen(),
//       OffersScreen(),
//       PortfolioScreen(),
//       SettingsScreen(),
//     ];

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final userId = widget.influencerId ?? context.read<AuthProvider>().currentUser?.id;

//       if (userId != null) {
//         // ✅ Fetch influencer data
//         await context.read<InfluencerProvider>().fetchInfluencer(userId);

//         // ✅ Send Welcome Back notification (only for self)
//         if (widget.influencerId == null) {
//           final userData = await Supabase.instance.client
//               .from('profiles')
//               .select('fcm_token')
//               .eq('id', userId)
//               .maybeSingle();

//           final token = userData?['fcm_token'];
//           final influencerName = context.read<InfluencerProvider>().influencer?.name ?? 'Influencer';

//           if (token != null) {
//             await NotificationService.sendPushMessage(
//               targetToken: token,
//               title: 'Welcome Back!',
//               body: 'Hello $influencerName 👋',
//             );
//           }

//           // ✅ Listen for new notifications
//           _listenForNotifications(userId);
//         }
//       }
//     });
//   }

//   void _listenForNotifications(String userId) {
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

//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Theme.of(context).primaryColor,
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.megaphone), label: 'My Campaigns'),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.gift), label: 'Offers'),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.folder), label: 'Portfolio'),
//           BottomNavigationBarItem(icon: Icon(LucideIcons.settings), label: 'Settings'),
//         ],
//       ),
//     );
//   }
// }

// class _DashboardHome extends StatelessWidget {
//   const _DashboardHome();

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<InfluencerProvider>();
//     final influencer = provider.influencer;
//     final audience = provider.audience;
//     final primary = Theme.of(context).primaryColor;

//     if (influencer == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // 🌈 Curved Gradient Header
//             Stack(
//               children: [
//                 ClipPath(
//                   clipper: _CurvedHeaderClipper(),
//                   child: Container(
//                     height: 230,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [primary, primary.withOpacity(0.8)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned.fill(
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 55),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CircleAvatar(
//                             radius: 38,
//                             backgroundImage: influencer.profileImage != null
//                                 ? NetworkImage(influencer.profileImage!)
//                                 : null,
//                             child: influencer.profileImage == null
//                                 ? const Icon(Icons.person, size: 38, color: Colors.white)
//                                 : null,
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   influencer.name ?? "Unnamed Influencer",
//                                   style: const TextStyle(
//                                     fontSize: 21,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Text(
//                                   influencer.niche ?? "No niche selected",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white.withOpacity(0.9),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   influencer.bio?.isNotEmpty == true
//                                       ? influencer.bio!
//                                       : "No bio available",
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: Colors.white.withOpacity(0.9),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.edit, color: Colors.white),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (_) => const EditInfluencerProfile()),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             // 🟢 Engagement + Followers
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _StatCard(
//                   color: Colors.blueAccent,
//                   icon: LucideIcons.activity,
//                   title: "Engagement",
//                   value: "${influencer.engagementRate?.toStringAsFixed(1) ?? '0'}%",
//                 ),
//                 _StatCard(
//                   color: Colors.green,
//                   icon: LucideIcons.users,
//                   title: "Followers",
//                   value: "${influencer.followerCount ?? 0}",
//                 ),
//               ],
//             ),

//             const SizedBox(height: 22),

//             // 💰 Total Earnings
//             GestureDetector(
//               onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const EarningsScreen()),
//               ),
//               child: Container(
//                 width: double.infinity,
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [primary, Colors.green.shade400],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.08),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: const [
//                         Icon(LucideIcons.wallet, color: Colors.white, size: 22),
//                         SizedBox(width: 8),
//                         Text(
//                           "Total Earnings",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       "\$${provider.totalEarnings.toStringAsFixed(2)}",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             // 📊 Audience Overview
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Audience Overview",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 12),

//                   if (audience != null)
//                     SizedBox(
//                       height: 200,
//                       child: SfCircularChart(
//                         series: <PieSeries<_GenderData, String>>[
//                           PieSeries<_GenderData, String>(
//                             dataSource: [
//                               _GenderData('Male', audience.genderMale),
//                               _GenderData('Female', audience.genderFemale),
//                               _GenderData('Other', audience.genderOther),
//                             ],
//                             xValueMapper: (_GenderData data, _) => data.label,
//                             yValueMapper: (_GenderData data, _) => data.value,
//                             dataLabelSettings: const DataLabelSettings(isVisible: true),
//                           ),
//                         ],
//                       ),
//                     )
//                   else
//                     const Text("No audience analytics available yet."),

//                   const SizedBox(height: 24),

//                   if (audience != null)
//                     SizedBox(
//                       height: 200,
//                       child: SfCartesianChart(
//                         primaryXAxis: CategoryAxis(),
//                         primaryYAxis: NumericAxis(),
//                         series: <CartesianSeries<_AgeData, String>>[
//                           ColumnSeries<_AgeData, String>(
//                             dataSource: [
//                               _AgeData('18-24', audience.age18_24),
//                               _AgeData('25-34', audience.age25_34),
//                               _AgeData('35+', audience.age35Plus),
//                             ],
//                             xValueMapper: (_AgeData data, _) => data.label,
//                             yValueMapper: (_AgeData data, _) => data.value.toDouble(),
//                             dataLabelSettings: const DataLabelSettings(isVisible: true),
//                             color: primary,
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // 🌊 Curved Header
// class _CurvedHeaderClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(0, size.height - 40);
//     path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 40);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

// // ✅ Stat Chips
// class _StatCard extends StatelessWidget {
//   final Color color;
//   final IconData icon;
//   final String title;
//   final String value;

//   const _StatCard({
//     required this.color,
//     required this.icon,
//     required this.title,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 140,
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: color, size: 22),
//           const SizedBox(height: 6),
//           Text(
//             title,
//             style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 4),
//           Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
//         ],
//       ),
//     );
//   }
// }

// class _GenderData {
//   final String label;
//   final int value;
//   _GenderData(this.label, this.value);
// }

// class _AgeData {
//   final String label;
//   final int value;
//   _AgeData(this.label, this.value);
// }
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/influencer_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/notification_service.dart';
import '../../utils/app_theme.dart';
import 'earnings_screen.dart';
import 'portfolio_screen.dart';
import 'offers_screen.dart';
import 'settings_screen.dart';
import 'my_campaigns_screen.dart';
import 'edit_influencer_profile.dart';

class InfluencerDashboard extends StatefulWidget {
  final String? influencerId; // optional for viewing other profiles

  const InfluencerDashboard({super.key, this.influencerId});

  @override
  State<InfluencerDashboard> createState() => _InfluencerDashboardState();
}

class _InfluencerDashboardState extends State<InfluencerDashboard> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = const [
      _DashboardHome(),
      MyCampaignsScreen(),
      OffersScreen(),
      PortfolioScreen(),
      SettingsScreen(),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = widget.influencerId ?? context.read<AuthProvider>().currentUser?.id;

      if (userId != null) {
        // Fetch influencer data
        await context.read<InfluencerProvider>().fetchInfluencer(userId);

        // Send welcome back notification (only for self)
        if (widget.influencerId == null) {
          final userData = await Supabase.instance.client
              .from('profiles')
              .select('fcm_token')
              .eq('id', userId)
              .maybeSingle();

          final token = userData?['fcm_token'];
          final influencerName = context.read<InfluencerProvider>().influencer?.name ?? 'Influencer';

          if (token != null) {
            await NotificationService.sendPushMessage(
              targetToken: token,
              title: 'Welcome Back!',
              body: 'Hello $influencerName 👋',
            );
          }

          // Listen for new notifications
          _listenForNotifications(userId);
        }
      }
    });
  }

  void _listenForNotifications(String userId) {
    Supabase.instance.client
        .from('notifications:recipient_id=eq.$userId')
        .stream(primaryKey: ['id'])
        .listen((event) async {
      for (final notification in event) {
        final token = notification['fcm_token'];
        if (token != null) {
          await NotificationService.sendPushMessage(
            targetToken: token,
            title: notification['title'] ?? 'New Notification',
            body: notification['body'] ?? '',
          );
        }
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.megaphone), label: 'My Campaigns'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.gift), label: 'Offers'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.folder), label: 'Portfolio'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class _DashboardHome extends StatelessWidget {
  const _DashboardHome();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InfluencerProvider>();
    final influencer = provider.influencer;
    final audience = provider.audience;
    final primary = Theme.of(context).primaryColor;

    if (influencer == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🌈 Curved Gradient Header
            Stack(
              children: [
                ClipPath(
                  clipper: _CurvedHeaderClipper(),
                  child: Container(
                    height: 230,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primary, primary.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 55),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 38,
                            backgroundImage: influencer.profileImage != null
                                ? NetworkImage(influencer.profileImage!)
                                : null,
                            child: influencer.profileImage == null
                                ? const Icon(Icons.person, size: 38, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  influencer.name ?? "Unnamed Influencer",
                                  style: const TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  influencer.niche ?? "No niche selected",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  influencer.bio?.isNotEmpty == true
                                      ? influencer.bio!
                                      : "No bio available",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () async {
                              // Navigate to edit profile and wait for result
                              final updated = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const EditInfluencerProfile()),
                              );

                              // Refresh influencer data if updated
                              if (updated == true) {
                                final userId = context.read<AuthProvider>().currentUser?.id;
                                if (userId != null) {
                                  await context.read<InfluencerProvider>().fetchInfluencer(userId);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 🟢 Engagement + Followers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatCard(
                  color: Colors.blueAccent,
                  icon: LucideIcons.activity,
                  title: "Engagement",
                  value: "${influencer.engagementRate?.toStringAsFixed(1) ?? '0'}%",
                ),
                _StatCard(
                  color: Colors.green,
                  icon: LucideIcons.users,
                  title: "Followers",
                  value: "${influencer.followerCount ?? 0}",
                ),
              ],
            ),

            const SizedBox(height: 22),

            // 💰 Total Earnings
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EarningsScreen()),
              ),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primary, Colors.green.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(LucideIcons.wallet, color: Colors.white, size: 22),
                        SizedBox(width: 8),
                        Text(
                          "Total Earnings",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "\$${provider.totalEarnings.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 📊 Audience Overview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Audience Overview",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  if (provider.audience != null)
                    SizedBox(
                      height: 200,
                      child: SfCircularChart(
                        series: <PieSeries<_GenderData, String>>[
                          PieSeries<_GenderData, String>(
                            dataSource: [
                              _GenderData('Male', provider.audience!.genderMale),
                              _GenderData('Female', provider.audience!.genderFemale),
                              _GenderData('Other', provider.audience!.genderOther),
                            ],
                            xValueMapper: (_GenderData data, _) => data.label,
                            yValueMapper: (_GenderData data, _) => data.value,
                            dataLabelSettings: const DataLabelSettings(isVisible: true),
                          ),
                        ],
                      ),
                    )
                  else
                    const Text("No audience analytics available yet."),

                  const SizedBox(height: 24),

                  if (provider.audience != null)
                    SizedBox(
                      height: 200,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(),
                        series: <CartesianSeries<_AgeData, String>>[
                          ColumnSeries<_AgeData, String>(
                            dataSource: [
                              _AgeData('18-24', provider.audience!.age18_24),
                              _AgeData('25-34', provider.audience!.age25_34),
                              _AgeData('35+', provider.audience!.age35Plus),
                            ],
                            xValueMapper: (_AgeData data, _) => data.label,
                            yValueMapper: (_AgeData data, _) => data.value.toDouble(),
                            dataLabelSettings: const DataLabelSettings(isVisible: true),
                            color: primary,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// 🌊 Curved Header
class _CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// ✅ Stat Chips
class _StatCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _GenderData {
  final String label;
  final int value;
  _GenderData(this.label, this.value);
}

class _AgeData {
  final String label;
  final int value;
  _AgeData(this.label, this.value);
}
 