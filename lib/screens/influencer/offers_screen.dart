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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/influencer_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<InfluencerProvider>();
      provider.fetchAvailableCampaigns(); // Load all brand-posted campaigns
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
    final campaigns = provider.availableCampaigns;
    final loading = provider.loading;

    return Scaffold(
      appBar: AppBar(title: const Text("Available Brand Campaigns")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : campaigns.isEmpty
              ? const Center(
                  child: Text(
                    "No campaigns available yet.",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: campaigns.length,
                  itemBuilder: (_, i) {
                    final c = campaigns[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(Icons.campaign, color: Color(0xFFB25640)),
                        title: Text(
                          c['title'] ?? 'Untitled Campaign',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            c['description'] ?? 'No description provided.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _acceptCampaign(c),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text("Accept"),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';
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
//       provider.fetchAvailableCampaigns();
//     });
//   }

//   Future<void> _acceptCampaign(Map<String, dynamic> campaign) async {
//     final influencerId = context.read<AuthProvider>().currentUser?.id;
//     if (influencerId == null) return;

//     final provider = context.read<InfluencerProvider>();

//     try {
//       await provider.acceptCampaignOffer(campaign['id'], influencerId);

//       // Update local list UI
//       setState(() {
//         campaign['accepted'] = true;
//       });

//       // Send notification to brand
//       final brandToken = await provider.getBrandFcmToken(campaign['brand_id']);
//       if (brandToken != null) {
//         await NotificationService.sendPushMessage(
//           targetToken: brandToken,
//           title: 'Campaign Accepted!',
//           body:
//               '${context.read<AuthProvider>().currentUser?.name ?? "An influencer"} accepted your campaign "${campaign['title']}"',
//         );
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Campaign accepted!")),
//       );
//     } catch (e) {
//       debugPrint('❌ Error accepting campaign: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

//   Future<void> _markAsCompleted(Map<String, dynamic> campaign) async {
//     final influencerId = context.read<AuthProvider>().currentUser?.id;
//     if (influencerId == null) return;

//     final provider = context.read<InfluencerProvider>();

//     try {
//       await provider.completeCampaign(campaign['id']);

//       // Update UI locally
//       setState(() {
//         campaign['status'] = 'completed';
//       });

//       // Send notifications
//       final brandToken = await provider.getBrandFcmToken(campaign['brand_id']);
//       if (brandToken != null) {
//         await NotificationService.sendPushMessage(
//           targetToken: brandToken,
//           title: 'Campaign Completed!',
//           body:
//               'The influencer completed your campaign "${campaign['title']}"',
//         );
//       }

//       final influencerToken =
//           await provider.getInfluencerFcmToken(influencerId);
//       if (influencerToken != null) {
//         await NotificationService.sendPushMessage(
//           targetToken: influencerToken,
//           title: 'Earnings Added!',
//           body:
//               'You received payment for completing "${campaign['title']}".',
//         );
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Campaign marked as completed!")),
//       );
//     } catch (e) {
//       debugPrint('❌ Error completing campaign: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error completing campaign: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<InfluencerProvider>();
//     final campaigns = provider.availableCampaigns;
//     final loading = provider.loading;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Available Brand Campaigns")),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : campaigns.isEmpty
//               ? const Center(
//                   child: Text("No campaigns available yet.",
//                       style: TextStyle(fontSize: 16)),
//                 )
//               : ListView.builder(
//                   itemCount: campaigns.length,
//                   itemBuilder: (_, i) {
//                     final c = campaigns[i];
//                     final bool accepted = c['accepted'] == true;
//                     final String status = c['status'] ?? '';

//                     return Card(
//                       margin:
//                           const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       elevation: 3,
//                       child: ListTile(
//                         leading: const Icon(Icons.campaign,
//                             color: Colors.green),
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
//                         trailing: accepted
//                             ? ElevatedButton(
//                                 onPressed: status == 'completed'
//                                     ? null
//                                     : () => _markAsCompleted(c),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: status == 'completed'
//                                       ? Colors.grey
//                                       : Colors.blue,
//                                 ),
//                                 child: Text(status == 'completed'
//                                     ? "Completed"
//                                     : "Mark Completed"),
//                               )
//                             : ElevatedButton(
//                                 onPressed: () => _acceptCampaign(c),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                 ),
//                                 child: const Text("Accept"),
//                               ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }
