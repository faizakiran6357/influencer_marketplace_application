// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';

// class MyCampaignsScreen extends StatefulWidget {
//   const MyCampaignsScreen({super.key});

//   @override
//   State<MyCampaignsScreen> createState() => _MyCampaignsScreenState();
// }

// class _MyCampaignsScreenState extends State<MyCampaignsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     final influencerId = context.read<AuthProvider>().currentUser?.id;
//     if (influencerId != null) {
//       context.read<InfluencerProvider>().fetchAcceptedCampaigns(influencerId);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final campaigns = context.watch<InfluencerProvider>().acceptedCampaigns;

//     return Scaffold(
//       appBar: AppBar(title: const Text("My Campaigns")),
//       body: campaigns.isEmpty
//           ? const Center(child: Text("No accepted campaigns yet"))
//           : ListView.builder(
//               itemCount: campaigns.length,
//               itemBuilder: (_, i) {
//                 final c = campaigns[i];
//                 return Card(
//                   margin: const EdgeInsets.all(10),
//                   child: ListTile(
//                     leading: const Icon(Icons.check_circle, color: Colors.green),
//                     title: Text(c['title'] ?? 'Untitled'),
//                     subtitle: Text(
//                         "Brand: ${c['brands']?['name'] ?? 'Unknown'} • Budget: \$${c['budget']}"),
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         builder: (_) => AlertDialog(
//                           title: Text(c['title'] ?? 'Campaign'),
//                           content: Text(c['description'] ?? 'No description'),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context),
//                               child: const Text("Close"),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
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
// import '../../services/chat_service.dart';
// import '../../models/chat_model.dart';
// import 'influencer_chat_screen.dart';
// import '../../utils/app_theme.dart';

// class MyCampaignsScreen extends StatefulWidget {
//   const MyCampaignsScreen({super.key});

//   @override
//   State<MyCampaignsScreen> createState() => _MyCampaignsScreenState();
// }

// class _MyCampaignsScreenState extends State<MyCampaignsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final influencerId = context.read<AuthProvider>().currentUser?.id;
//       if (influencerId != null) {
//         context.read<InfluencerProvider>().fetchAcceptedCampaigns(influencerId);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final campaigns = context.watch<InfluencerProvider>().acceptedCampaigns;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Campaigns"),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: campaigns.isEmpty
//           ? const Center(child: Text("No accepted campaigns yet"))
//           : ListView.builder(
//               itemCount: campaigns.length,
//               itemBuilder: (_, i) {
//                 final c = campaigns[i];
//                 final brandName = c['brands']?['name'] ?? 'Unknown';

//                 return Card(
//                   margin: const EdgeInsets.all(10),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(Icons.check_circle,
//                                 color: Colors.green),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 c['title'] ?? 'Untitled Campaign',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           "Brand: $brandName • Budget: \$${c['budget']}",
//                           style:
//                               const TextStyle(fontSize: 14, color: Colors.grey),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           c['description'] ?? 'No description available',
//                           style: const TextStyle(fontSize: 13),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             TextButton(
//                               onPressed: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (_) => AlertDialog(
//                                     title: Text(c['title'] ?? 'Campaign'),
//                                     content: Text(
//                                         c['description'] ?? 'No description'),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () =>
//                                             Navigator.pop(context),
//                                         child: const Text("Close"),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                               child: const Text("View Details"),
//                             ),
//                             const SizedBox(width: 8),
//                             ElevatedButton.icon(
//                               icon: const Icon(Icons.chat_bubble_outline,
//                                   size: 18),
//                               label: const Text("Chat with Brand"),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppTheme.primaryColor,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               onPressed: () async {
//                                 final chat =
//                                     await ChatService().getOrCreateChatForCampaign(
//                                   campaignId: c['id'],
//                                 );

//                                 if (chat != null && mounted) {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => InfluencerChatScreen(
//                                         chatId: chat.id,
//                                       ),
//                                     ),
//                                   );
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                         content: Text(
//                                             "Failed to open chat. Try again.")),
//                                   );
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
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
// import '../../services/chat_service.dart';
// import '../../models/chat_model.dart';
// import 'influencer_chat_screen.dart';
// import '../../utils/app_theme.dart';

// class MyCampaignsScreen extends StatefulWidget {
//   const MyCampaignsScreen({super.key});

//   @override
//   State<MyCampaignsScreen> createState() => _MyCampaignsScreenState();
// }

// class _MyCampaignsScreenState extends State<MyCampaignsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final influencerId = context.read<AuthProvider>().currentUser?.id;
//       if (influencerId != null) {
//         context.read<InfluencerProvider>().fetchAcceptedCampaigns(influencerId);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final campaigns = context.watch<InfluencerProvider>().acceptedCampaigns;
//     final influencerId = context.read<AuthProvider>().currentUser?.id;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Campaigns"),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: campaigns.isEmpty
//           ? const Center(child: Text("No accepted campaigns yet"))
//           : ListView.builder(
//               itemCount: campaigns.length,
//               itemBuilder: (_, i) {
//                 final c = campaigns[i];
//                 final brand = c['brands'];
//                 final brandId = brand?['id'];
//                 final brandName = brand?['name'] ?? 'Unknown';

//                 return Card(
//                   margin: const EdgeInsets.all(10),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(Icons.check_circle,
//                                 color: Colors.green),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 c['title'] ?? 'Untitled Campaign',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           "Brand: $brandName • Budget: \$${c['budget']}",
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           c['description'] ?? 'No description available',
//                           style: const TextStyle(fontSize: 13),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             TextButton(
//                               onPressed: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (_) => AlertDialog(
//                                     title: Text(c['title'] ?? 'Campaign'),
//                                     content: Text(
//                                         c['description'] ?? 'No description'),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () =>
//                                             Navigator.pop(context),
//                                         child: const Text("Close"),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                               child: const Text("View Details"),
//                             ),
//                             const SizedBox(width: 8),
//                             ElevatedButton.icon(
//                               icon: const Icon(Icons.chat_bubble_outline,
//                                   size: 18),
//                               label: const Text("Chat with Brand"),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppTheme.primaryColor,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               onPressed: () async {
//                                 if (brandId == null || influencerId == null) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           "Invalid campaign data. Missing brand or influencer ID."),
//                                     ),
//                                   );
//                                   return;
//                                 }

//                                 final chat =
//                                     await ChatService().getOrCreateChatForCampaign(
//                                   campaignId: c['id'],
//                                   brandId: brandId,
//                                   influencerId: influencerId,
//                                 );

//                                 if (chat != null && mounted) {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => InfluencerChatScreen(
//                                         chatId: chat.id,
//                                       ),
//                                     ),
//                                   );
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           "Failed to open chat. Try again."),
//                                     ),
//                                   );
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
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
// import '../../services/chat_service.dart';
// import '../../models/chat_model.dart';
// import 'influencer_chat_screen.dart';
// import '../../utils/app_theme.dart';

// class MyCampaignsScreen extends StatefulWidget {
//   const MyCampaignsScreen({super.key});

//   @override
//   State<MyCampaignsScreen> createState() => _MyCampaignsScreenState();
// }

// class _MyCampaignsScreenState extends State<MyCampaignsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final influencerId = context.read<AuthProvider>().currentUser?.id;
//       if (influencerId != null) {
//         context.read<InfluencerProvider>().fetchAcceptedCampaigns(influencerId);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final campaigns = context.watch<InfluencerProvider>().acceptedCampaigns;
//     final influencerId = context.read<AuthProvider>().currentUser?.id;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Campaigns"),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: campaigns.isEmpty
//           ? const Center(child: Text("No accepted campaigns yet"))
//           : ListView.builder(
//               itemCount: campaigns.length,
//               itemBuilder: (_, i) {
//                 final c = campaigns[i];
//                 final campaignData = c['campaigns'] ?? {};
//                 final brandId = campaignData['brand_id'];
//                 final title = campaignData['title'] ?? 'Untitled Campaign';
//                 final budget = campaignData['budget'] ?? 'N/A';
//                 final description =
//                     campaignData['description'] ?? 'No description available';

//                 return Card(
//                   margin: const EdgeInsets.all(10),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(Icons.check_circle,
//                                 color: Colors.green),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 title,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           "Brand: ${brandId ?? 'Unknown'} • Budget: \$$budget",
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           description,
//                           style: const TextStyle(fontSize: 13),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             TextButton(
//                               onPressed: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (_) => AlertDialog(
//                                     title: Text(title),
//                                     content: Text(description),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () =>
//                                             Navigator.pop(context),
//                                         child: const Text("Close"),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                               child: const Text("View Details"),
//                             ),
//                             const SizedBox(width: 8),
//                             ElevatedButton.icon(
//                               icon: const Icon(Icons.chat_bubble_outline,
//                                   size: 18),
//                               label: const Text("Chat with Brand"),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppTheme.primaryColor,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               onPressed: () async {
//                                 final campaignId = campaignData['id'];

//                                 debugPrint(
//                                     "💬 Chat pressed -> brandId: $brandId | influencerId: $influencerId | campaignId: $campaignId");

//                                 if (brandId == null || influencerId == null) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           "Invalid campaign data. Missing brand or influencer ID."),
//                                     ),
//                                   );
//                                   return;
//                                 }

//                                 final chat =
//                                     await ChatService().getOrCreateChatForCampaign(
//                                   campaignId: campaignId,
//                                   brandId: brandId,
//                                   influencerId: influencerId,
//                                 );

//                                 if (chat != null && mounted) {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => InfluencerChatScreen(
//                                         chatId: chat.id,
//                                       ),
//                                     ),
//                                   );
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           "Failed to open chat. Try again."),
//                                     ),
//                                   );
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
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
import '../../services/chat_service.dart';
import '../../models/chat_model.dart';
import 'influencer_chat_screen.dart';
import '../../utils/app_theme.dart';

class MyCampaignsScreen extends StatefulWidget {
  const MyCampaignsScreen({super.key});

  @override
  State<MyCampaignsScreen> createState() => _MyCampaignsScreenState();
}

class _MyCampaignsScreenState extends State<MyCampaignsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final influencerId = context.read<AuthProvider>().currentUser?.id;
      if (influencerId != null) {
        context.read<InfluencerProvider>().fetchAcceptedCampaigns(influencerId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final campaigns = context.watch<InfluencerProvider>().acceptedCampaigns;
    final influencerId = context.read<AuthProvider>().currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Campaigns"),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: campaigns.isEmpty
          ? const Center(child: Text("No accepted campaigns yet"))
          : ListView.builder(
              itemCount: campaigns.length,
              itemBuilder: (_, i) {
                final c = campaigns[i];
                final campaignData = c['campaigns'] ?? {};
                final brandId = campaignData['brand_id'];
                final title = campaignData['title'] ?? 'Untitled Campaign';
                final budget = campaignData['budget'] ?? 'N/A';
                final description =
                    campaignData['description'] ?? 'No description available';

                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Brand: ${brandId ?? 'Unknown'} • Budget: \$$budget",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: const TextStyle(fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text(title),
                                    content: Text(description),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text("Close"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text("View Details"),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.chat_bubble_outline,
                                  size: 18),
                              label: const Text("Chat with Brand"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Future.microtask(() async {
                                  final campaignId = campaignData['id'];

                                  debugPrint(
                                      "💬 Chat pressed -> brandId: $brandId | influencerId: $influencerId | campaignId: $campaignId");

                                  if (brandId == null || influencerId == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Invalid campaign data. Missing brand or influencer ID."),
                                      ),
                                    );
                                    return;
                                  }

                                  try {
                                    final chat = await ChatService()
                                        .getOrCreateChatForCampaign(
                                      campaignId: campaignId,
                                      brandId: brandId,
                                      influencerId: influencerId,
                                    );

                                    if (chat != null && context.mounted) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                InfluencerChatScreen(
                                              chatId: chat.id,
                                            ),
                                          ),
                                        );
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Failed to open chat. Try again."),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    debugPrint("❌ Error opening chat: $e");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Error opening chat: $e")),
                                    );
                                  }
                                });
                              },
                            ),
                          ],
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
