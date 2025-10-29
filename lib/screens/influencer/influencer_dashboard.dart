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
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/screens/influencer/earnings_screen.dart';
import 'package:influencer_marketplace_application/screens/influencer/offers_screen.dart';
import 'package:influencer_marketplace_application/screens/influencer/settings_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/influencer_provider.dart';
import 'edit_influencer_profile.dart';
import 'portfolio_screen.dart';

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
    final influencer = context.watch<InfluencerProvider>().influencer;
    final name = influencer?.name ?? "Influencer";

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconColor = isDark ? Colors.greenAccent : Colors.green;

    return Scaffold(
      appBar: AppBar(title: Text("Welcome, $name")),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        children: [
          _buildCard(context, "Edit Profile", Icons.person, const EditInfluencerProfile(), iconColor, textColor),
          _buildCard(context, "Portfolio", Icons.photo_library, const PortfolioScreen(), iconColor, textColor),
          _buildCard(context, "Offers", Icons.local_offer, const OffersScreen(), iconColor, textColor),
          _buildCard(context, "Earnings", Icons.attach_money, const EarningsScreen(), iconColor, textColor),
          _buildCard(context, "Settings", Icons.settings, const SettingsScreen(), iconColor, textColor),
        ],
      ),
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
        color: Theme.of(context).cardColor, // ✅ theme-aware card background
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
                fontWeight: FontWeight.w600,
                color: textColor, // ✅ theme-aware text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
