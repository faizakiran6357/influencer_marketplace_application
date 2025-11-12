
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
    // final audience = provider.audience; // (not used here)
    final primary = Theme.of(context).primaryColor;

    if (influencer == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🌈 Curved Gradient Header
            Stack(
              children: [
                ClipPath(
                  clipper: _CurvedHeaderClipper(),
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primary, primary.withOpacity(0.85)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                // Decorative subtle circles
                Positioned(
                  top: 30,
                  right: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: -10,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
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
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.25),
                            ),
                            child: CircleAvatar(
                              radius: 38,
                              backgroundImage: influencer.profileImage != null
                                  ? NetworkImage(influencer.profileImage!)
                                  : null,
                              child: influencer.profileImage == null
                                  ? const Icon(Icons.person, size: 38, color: Colors.white)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  influencer.name ?? "Unnamed Influencer",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  influencer.niche ?? "No niche selected",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  influencer.bio?.isNotEmpty == true
                                      ? influencer.bio!
                                      : "No bio available",
                                  style: TextStyle(
                                    fontSize: 12.5,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      color: Colors.blueAccent,
                      icon: LucideIcons.activity,
                      title: "Engagement",
                      value: "${influencer.engagementRate?.toStringAsFixed(1) ?? '0'}%",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      color: Colors.green,
                      icon: LucideIcons.users,
                      title: "Followers",
                      value: "${influencer.followerCount ?? 0}",
                    ),
                  ),
                ],
              ),
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
                    colors: [primary, Colors.green.shade400, Colors.teal.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.25),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
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
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          "\$${provider.totalEarnings.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(LucideIcons.pieChart, color: primary, size: 18),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Audience Overview",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (provider.audience != null)
                          SizedBox(
                            height: 200,
                            child: SfCircularChart(
                              legend: const Legend(isVisible: true),
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
                          Text(
                            "No audience analytics available yet.",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (provider.audience != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(LucideIcons.barChart3, color: primary, size: 18),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Age Distribution",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
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
 