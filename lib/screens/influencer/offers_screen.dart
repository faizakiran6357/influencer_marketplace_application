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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/influencer_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final influencerId = context.read<AuthProvider>().currentUser?.id;
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
                      margin:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(Icons.campaign, color: Colors.green),
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
                          onPressed: influencerId == null
                              ? null
                              : () async {
                                  await provider.acceptCampaignOffer(
                                    c['id'],
                                    influencerId,
                                  );
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Campaign accepted!"),
                                    ),
                                  );
                                },
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

