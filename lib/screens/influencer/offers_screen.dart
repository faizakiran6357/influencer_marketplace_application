// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';

// class OffersScreen extends StatefulWidget {
//   const OffersScreen({super.key});

//   @override
//   State<OffersScreen> createState() => _OffersScreenState();
// }

// class _OffersScreenState extends State<OffersScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _brandController = TextEditingController();
//   final _campaignController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _budgetController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     final userId = context.read<AuthProvider>().currentUser?.id;
//     if (userId != null) {
//       context.read<InfluencerProvider>().fetchOffers(userId);
//     }
//   }

//   Future<void> _addOffer() async {
//     if (!_formKey.currentState!.validate()) return;
//     final provider = context.read<InfluencerProvider>();
//     final userId = context.read<AuthProvider>().currentUser?.id;
//     if (userId == null) return;

//     await provider.addOffer(
//       influencerId: userId,
//       brandName: _brandController.text.trim(),
//       campaignName: _campaignController.text.trim(),
//       description: _descriptionController.text.trim(),
//       budget: double.parse(_budgetController.text.trim()),
//     );

//     if (!mounted) return;
//     Navigator.pop(context);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Offer added successfully!")),
//     );
//   }

//   void _showAddOfferDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Add New Offer"),
//         content: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _brandController,
//                   decoration: const InputDecoration(labelText: "Brand Name"),
//                   validator: (v) => v!.isEmpty ? "Required" : null,
//                 ),
//                 TextFormField(
//                   controller: _campaignController,
//                   decoration: const InputDecoration(labelText: "Campaign Name"),
//                   validator: (v) => v!.isEmpty ? "Required" : null,
//                 ),
//                 TextFormField(
//                   controller: _descriptionController,
//                   decoration: const InputDecoration(labelText: "Description"),
//                   validator: (v) => v!.isEmpty ? "Required" : null,
//                 ),
//                 TextFormField(
//                   controller: _budgetController,
//                   decoration: const InputDecoration(labelText: "Budget (\$)"),
//                   keyboardType: TextInputType.number,
//                   validator: (v) => v!.isEmpty ? "Required" : null,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
//           ElevatedButton(onPressed: _addOffer, child: const Text("Save")),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final offers = context.watch<InfluencerProvider>().offers;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Collaboration Offers")),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddOfferDialog,
//         child: const Icon(Icons.add),
//       ),
//       body: offers.isEmpty
//           ? const Center(child: Text("No offers yet"))
//           : ListView.builder(
//               itemCount: offers.length,
//               itemBuilder: (_, i) {
//                 final o = offers[i];
//                 return ListTile(
//                   leading: const Icon(Icons.local_offer, color: Colors.green),
//                   title: Text(o['campaign_name'] ?? 'Untitled'),
//                   subtitle: Text("Brand: ${o['brand_name']} • \$${o['budget']}"),
//                 );
//               },
//             ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';

// class OffersScreen extends StatefulWidget {
//   const OffersScreen({super.key});

//   @override
//   State<OffersScreen> createState() => _OffersScreenState();
// }

// class _OffersScreenState extends State<OffersScreen> {
//   @override
//   void initState() {
//     super.initState();
//     final provider = context.read<InfluencerProvider>();
//     provider.fetchAvailableCampaigns();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final influencerId = context.read<AuthProvider>().currentUser?.id;
//     final provider = context.watch<InfluencerProvider>();
//     final campaigns = provider.availableCampaigns;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Available Brand Campaigns")),
//       body: campaigns.isEmpty
//           ? const Center(child: Text("No campaigns available yet"))
//           : ListView.builder(
//               itemCount: campaigns.length,
//               itemBuilder: (_, i) {
//                 final c = campaigns[i];
//                 return Card(
//                   margin: const EdgeInsets.all(10),
//                   child: ListTile(
//                     leading: const Icon(Icons.campaign, color: Colors.blue),
//                     title: Text(c['title'] ?? 'Untitled'),
//                     subtitle: Text(c['description'] ?? ''),
//                     trailing: ElevatedButton(
//                       onPressed: influencerId == null
//                           ? null
//                           : () async {
//                               await provider.acceptCampaignOffer(
//                                 c['id'],
//                                 influencerId,
//                               );
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text("Campaign accepted!"),
//                                 ),
//                               );
//                             },
//                       child: const Text("Accept"),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';

// class OffersScreen extends StatefulWidget {
//   const OffersScreen({super.key});

//   @override
//   State<OffersScreen> createState() => _OffersScreenState();
// }

// class _OffersScreenState extends State<OffersScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = context.read<InfluencerProvider>();
//       provider.fetchAvailableCampaigns(); // Load all brand-posted campaigns
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final influencerId = context.read<AuthProvider>().currentUser?.id;
//     final provider = context.watch<InfluencerProvider>();
//     final campaigns = provider.availableCampaigns;
//     final loading = provider.loading;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Available Brand Campaigns")),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : campaigns.isEmpty
//               ? const Center(
//                   child: Text(
//                     "No campaigns available yet.",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 )
//               : ListView.builder(
//                   itemCount: campaigns.length,
//                   itemBuilder: (_, i) {
//                     final c = campaigns[i];
//                     return Card(
//                       margin:
//                           const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       elevation: 3,
//                       child: ListTile(
//                         leading: const Icon(Icons.campaign, color: Colors.green),
//                         title: Text(
//                           c['title'] ?? 'Untitled Campaign',
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         subtitle: Padding(
//                           padding: const EdgeInsets.only(top: 4.0),
//                           child: Text(
//                             c['description'] ?? 'No description provided.',
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         trailing: ElevatedButton(
//                           onPressed: influencerId == null
//                               ? null
//                               : () async {
//                                   await provider.acceptCampaignOffer(
//                                     c['id'],
//                                     influencerId,
//                                   );
//                                   if (!mounted) return;
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text("Campaign accepted!"),
//                                     ),
//                                   );
//                                 },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                           ),
//                           child: const Text("Accept"),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';
// import '../../providers/theme_provider.dart';
// import '../../services/notification_service.dart';

// class OffersScreen extends StatefulWidget {
//   const OffersScreen({super.key});

//   @override
//   State<OffersScreen> createState() => _OffersScreenState();
// }

// class _OffersScreenState extends State<OffersScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = context.read<InfluencerProvider>();
//       provider.fetchAvailableCampaigns(); // Load all brand-posted campaigns
//     });
//   }

//   Future<void> _acceptCampaign(Map<String, dynamic> campaign) async {
//     final influencerId = context.read<AuthProvider>().currentUser?.id;
//     if (influencerId == null) return;

//     final provider = context.read<InfluencerProvider>();

//     try {
//       // 1️⃣ Accept the campaign
//       await provider.acceptCampaignOffer(campaign['id'], influencerId);

//       // 2️⃣ Get brand FCM token
//       final brandToken = await provider.getBrandFcmToken(campaign['brand_id']);
//       if (brandToken != null) {
//         // 3️⃣ Send notification to the brand
//         await NotificationService.sendPushMessage(
//           targetToken: brandToken,
//           title: 'Campaign Accepted!',
//           body:
//               '${context.read<AuthProvider>().currentUser?.name ?? "An influencer"} accepted your campaign "${campaign['title']}"',
//         );
//       }

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Campaign accepted!")),
//       );
//     } catch (e) {
//       debugPrint('❌ Error accepting campaign or sending notification: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<InfluencerProvider>();
//     final themeProvider = context.watch<ThemeProvider>();
//     final campaigns = provider.availableCampaigns;
//     final loading = provider.loading;
//     final primary = Theme.of(context).primaryColor;
//     final isDark = themeProvider.isDark;

//     return Scaffold(
//       backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: primary,
//         title: const Text(
//           "Available Campaigns",
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 20,
//             letterSpacing: -0.3,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: false,
//       ),
//       body: loading
//           ? Center(
//               child: CircularProgressIndicator(
//                 color: primary,
//               ),
//             )
//           : campaigns.isEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         LucideIcons.gift,
//                         size: 64,
//                         color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         "No campaigns available yet",
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         "New campaign offers will appear here",
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : RefreshIndicator(
//                   onRefresh: () async {
//                     await provider.fetchAvailableCampaigns();
//                   },
//                   color: primary,
//                   child: ListView.builder(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     padding: const EdgeInsets.all(16),
//                     itemCount: campaigns.length,
//                     itemBuilder: (_, i) {
//                       final c = campaigns[i];
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 16),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
//                                 blurRadius: 15,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(20),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(12),
//                                       decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             primary,
//                                             primary.withOpacity(0.7),
//                                           ],
//                                           begin: Alignment.topLeft,
//                                           end: Alignment.bottomRight,
//                                         ),
//                                         borderRadius: BorderRadius.circular(14),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: primary.withOpacity(0.3),
//                                             blurRadius: 8,
//                                             offset: const Offset(0, 4),
//                                           ),
//                                         ],
//                                       ),
//                                       child: const Icon(
//                                         LucideIcons.megaphone,
//                                         color: Colors.white,
//                                         size: 22,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 16),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             c['title'] ?? 'Untitled Campaign',
//                                             style: TextStyle(
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.w700,
//                                               color: isDark ? Colors.white : Colors.black87,
//                                               letterSpacing: -0.3,
//                                             ),
//                                             maxLines: 2,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                           const SizedBox(height: 8),
//                                           Text(
//                                             c['description'] ?? 'No description provided.',
//                                             style: TextStyle(
//                                               fontSize: 13,
//                                               color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
//                                               height: 1.4,
//                                             ),
//                                             maxLines: 3,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 20),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                                         decoration: BoxDecoration(
//                                           color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
//                                           borderRadius: BorderRadius.circular(10),
//                                         ),
//                                         child: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Icon(
//                                               LucideIcons.building2,
//                                               size: 16,
//                                               color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
//                                             ),
//                                             const SizedBox(width: 6),
//                                             Flexible(
//                                               child: Text(
//                                                 c['brand_name'] ?? 'Unknown Brand',
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                   color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
//                                                   fontWeight: FontWeight.w600,
//                                                 ),
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     if (c['budget'] != null) ...[
//                                       const SizedBox(width: 8),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                                         decoration: BoxDecoration(
//                                           color: const Color(0xFF10B981).withOpacity(0.1),
//                                           borderRadius: BorderRadius.circular(10),
//                                         ),
//                                         child: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Icon(
//                                               LucideIcons.dollarSign,
//                                               size: 16,
//                                               color: const Color(0xFF10B981),
//                                             ),
//                                             const SizedBox(width: 4),
//                                             Text(
//                                               "\$${c['budget']}",
//                                               style: const TextStyle(
//                                                 fontSize: 13,
//                                                 color: Color(0xFF10B981),
//                                                 fontWeight: FontWeight.w700,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Container(
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [
//                                         const Color(0xFF10B981),
//                                         const Color(0xFF10B981).withOpacity(0.8),
//                                       ],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                     ),
//                                     borderRadius: BorderRadius.circular(14),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: const Color(0xFF10B981).withOpacity(0.3),
//                                         blurRadius: 12,
//                                         offset: const Offset(0, 6),
//                                       ),
//                                     ],
//                                   ),
//                                   child: ElevatedButton.icon(
//                                     onPressed: () => _acceptCampaign(c),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.transparent,
//                                       shadowColor: Colors.transparent,
//                                       padding: const EdgeInsets.symmetric(vertical: 14),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(14),
//                                       ),
//                                     ),
//                                     icon: const Icon(
//                                       LucideIcons.checkCircle,
//                                       color: Colors.white,
//                                       size: 20,
//                                     ),
//                                     label: const Text(
//                                       "Accept Campaign",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w700,
//                                         letterSpacing: 0.3,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/auth_provider.dart';
import '../../providers/influencer_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/notification_service.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<InfluencerProvider>();

      // 1️⃣ Fetch all available campaigns
      await provider.fetchAvailableCampaigns();

      // 2️⃣ Collect unique brand IDs from campaigns
      final brandIds = provider.availableCampaigns
          .map((c) => c['brand_id'] as String?)
          .whereType<String>()
          .toSet()
          .toList();

      // 3️⃣ Fetch brand names
      if (brandIds.isNotEmpty) {
        await provider.fetchBrandNames(brandIds);
      }
    });
  }

  Future<void> _acceptCampaign(Map<String, dynamic> campaign) async {
    final influencerId = context.read<AuthProvider>().currentUser?.id;
    if (influencerId == null) return;

    final provider = context.read<InfluencerProvider>();

    try {
      // 1️⃣ Accept the campaign
      await provider.acceptCampaignOffer(campaign['id'], influencerId);

      // 2️⃣ Get brand FCM token
      final brandToken = await provider.getBrandFcmToken(campaign['brand_id']);
      if (brandToken != null) {
        // 3️⃣ Send notification to the brand
        await NotificationService.sendPushMessage(
          targetToken: brandToken,
          title: 'Campaign Accepted!',
          body:
              '${context.read<AuthProvider>().currentUser?.name ?? "An influencer"} accepted your campaign "${campaign['title']}"',
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Campaign accepted!")),
      );
    } catch (e) {
      debugPrint('❌ Error accepting campaign or sending notification: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InfluencerProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final campaigns = provider.availableCampaigns;
    final loading = provider.loading;
    final primary = Theme.of(context).primaryColor;
    final isDark = themeProvider.isDark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        title: const Text(
          "Available Campaigns",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.3,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(color: primary),
            )
          : campaigns.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.gift,
                        size: 64,
                        color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No campaigns available yet",
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "New campaign offers will appear here",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await provider.fetchAvailableCampaigns();

                    // Refresh brand names too
                    final brandIds = provider.availableCampaigns
                        .map((c) => c['brand_id'] as String?)
                        .whereType<String>()
                        .toSet()
                        .toList();
                    if (brandIds.isNotEmpty) {
                      await provider.fetchBrandNames(brandIds);
                    }
                  },
                  color: primary,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: campaigns.length,
                    itemBuilder: (_, i) {
                      final c = campaigns[i];
                      final brandId = c['brand_id'] as String?;
                      final brandName =
                          provider.getBrandNameById(brandId) ?? 'Unknown Brand';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            primary,
                                            primary.withOpacity(0.7),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primary.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        LucideIcons.megaphone,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            c['title'] ?? 'Untitled Campaign',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: isDark ? Colors.white : Colors.black87,
                                              letterSpacing: -0.3,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            c['description'] ?? 'No description provided.',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                              height: 1.4,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              LucideIcons.building2,
                                              size: 16,
                                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                            ),
                                            const SizedBox(width: 6),
                                            Flexible(
                                              child: Text(
                                                brandName,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (c['budget'] != null) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              LucideIcons.dollarSign,
                                              size: 16,
                                              color: const Color(0xFF10B981),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "\$${c['budget']}",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF10B981),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF10B981),
                                        const Color(0xFF10B981).withOpacity(0.8),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF10B981).withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () => _acceptCampaign(c),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    icon: const Icon(
                                      LucideIcons.checkCircle,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    label: const Text(
                                      "Accept Campaign",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
