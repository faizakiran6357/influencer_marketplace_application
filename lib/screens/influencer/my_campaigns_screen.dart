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
//                             const Icon(Icons.check_circle, color: Colors.green),
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
//                               onPressed: () {
//                                 Future.microtask(() async {
//                                   final campaignId = campaignData['id'];

//                                   debugPrint(
//                                       "💬 Chat pressed -> brandId: $brandId | influencerId: $influencerId | campaignId: $campaignId");

//                                   if (brandId == null || influencerId == null) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             "Invalid campaign data. Missing brand or influencer ID."),
//                                       ),
//                                     );
//                                     return;
//                                   }

//                                   try {
//                                     final chat = await ChatService()
//                                         .getOrCreateChatForCampaign(
//                                       campaignId: campaignId,
//                                       brandId: brandId,
//                                       influencerId: influencerId,
//                                     );

//                                     if (chat != null && context.mounted) {
//                                       WidgetsBinding.instance
//                                           .addPostFrameCallback((_) {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (_) =>
//                                                 InfluencerChatScreen(
//                                               chatId: chat.id,
//                                             ),
//                                           ),
//                                         );
//                                       });
//                                     } else {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         const SnackBar(
//                                           content: Text(
//                                               "Failed to open chat. Try again."),
//                                         ),
//                                       );
//                                     }
//                                   } catch (e) {
//                                     debugPrint("❌ Error opening chat: $e");
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                           content:
//                                               Text("Error opening chat: $e")),
//                                     );
//                                   }
//                                 });
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
// import '../../services/notification_service.dart';
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
//     final provider = context.read<InfluencerProvider>();

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
//                 final status = c['status'] ?? 'in_progress';

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
//                             const Icon(Icons.check_circle, color: Colors.green),
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

//                                 if (brandId == null || influencerId == null) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           "Invalid campaign data. Missing brand or influencer ID."),
//                                     ),
//                                   );
//                                   return;
//                                 }

//                                 try {
//                                   final chat = await ChatService()
//                                       .getOrCreateChatForCampaign(
//                                     campaignId: campaignId,
//                                     brandId: brandId,
//                                     influencerId: influencerId,
//                                   );

//                                   if (chat != null && context.mounted) {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => InfluencerChatScreen(
//                                           chatId: chat.id,
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             "Failed to open chat. Try again."),
//                                       ),
//                                     );
//                                   }
//                                 } catch (e) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                         content:
//                                             Text("Error opening chat: $e")),
//                                   );
//                                 }
//                               },
//                             ),
//                             const SizedBox(width: 8),
//                             // ✅ Completed Button
//                             if (status == 'in_progress')
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.check, size: 18),
//                                 label: const Text("Mark as Completed"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: () async {
//                                   if (influencerId == null || brandId == null) return;

//                                   // ✅ Mark campaign as completed
//                                   await provider.completeCampaign(c['id']);

//                                   // ✅ Get brand FCM token
//                                   final brandFcmToken =
//                                       await provider.getBrandFcmToken(brandId);

//                                   // ✅ Send notification to brand
//                                   if (brandFcmToken != null) {
//                                     await NotificationService.sendPushMessage(
//                                       targetToken: brandFcmToken,
//                                       title: 'Campaign Completed!',
//                                       body:
//                                           'The influencer completed your campaign "$title".',
//                                     );
//                                   }

//                                   if (!mounted) return;
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                         content: Text(
//                                             "Campaign marked as completed!")),
//                                   );
//                                 },
//                               ),
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
// import '../../services/notification_service.dart';
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
//     final provider = context.read<InfluencerProvider>();

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
//                 final status = c['status'] ?? 'in_progress';

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
//                             const Icon(Icons.check_circle, color: Colors.green),
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

//                                 if (brandId == null || influencerId == null) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           "Invalid campaign data. Missing brand or influencer ID."),
//                                     ),
//                                   );
//                                   return;
//                                 }

//                                 try {
//                                   final chat = await ChatService()
//                                       .getOrCreateChatForCampaign(
//                                     campaignId: campaignId,
//                                     brandId: brandId,
//                                     influencerId: influencerId,
//                                   );

//                                   if (chat != null && context.mounted) {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => InfluencerChatScreen(
//                                           chatId: chat.id,
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             "Failed to open chat. Try again."),
//                                       ),
//                                     );
//                                   }
//                                 } catch (e) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                         content:
//                                             Text("Error opening chat: $e")),
//                                   );
//                                 }
//                               },
//                             ),
//                             const SizedBox(width: 8),
//                             // ✅ Completed Button / Label
//                             if (status == 'in_progress')
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.check, size: 18),
//                                 label: const Text("Mark as Completed"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: () async {
//                                   if (influencerId == null || brandId == null)
//                                     return;

//                                   // Mark campaign as completed
//                                   await provider.completeCampaign(c['id']);

//                                   // Send notification to brand
//                                   final brandFcmToken =
//                                       await provider.getBrandFcmToken(brandId);
//                                   if (brandFcmToken != null) {
//                                     await NotificationService.sendPushMessage(
//                                       targetToken: brandFcmToken,
//                                       title: 'Campaign Completed!',
//                                       body:
//                                           'The influencer completed your campaign "$title".',
//                                     );
//                                   }

//                                   // Update local status immediately
//                                   setState(() {
//                                     c['status'] = 'completed';
//                                   });

//                                   if (!mounted) return;
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                         content: Text(
//                                             "Campaign marked as completed!")),
//                                   );
//                                 },
//                               )
//                             else if (status == 'completed')
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.check, size: 18),
//                                 label: const Text("Completed"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.grey,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: null,
//                               ),
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
// import '../../services/notification_service.dart';
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
//     final provider = context.read<InfluencerProvider>();

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
//                 final status = c['status'] ?? 'in_progress';

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
//                             const Icon(Icons.check_circle, color: Colors.green),
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

//                                 if (brandId == null || influencerId == null) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           "Invalid campaign data. Missing brand or influencer ID."),
//                                     ),
//                                   );
//                                   return;
//                                 }

//                                 try {
//                                   final chat = await ChatService()
//                                       .getOrCreateChatForCampaign(
//                                     campaignId: campaignId,
//                                     brandId: brandId,
//                                     influencerId: influencerId,
//                                   );

//                                   if (chat != null && context.mounted) {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => InfluencerChatScreen(
//                                           chatId: chat.id,
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             "Failed to open chat. Try again."),
//                                       ),
//                                     );
//                                   }
//                                 } catch (e) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                         content:
//                                             Text("Error opening chat: $e")),
//                                   );
//                                 }
//                               },
//                             ),
//                             const SizedBox(width: 8),
//                             // ✅ Completed Button / Label
//                             if (status == 'in_progress')
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.check, size: 18),
//                                 label: const Text("Mark as Completed"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: () async {
//                                   if (influencerId == null || brandId == null)
//                                     return;

//                                   // 1️⃣ Mark campaign as completed
//                                   await provider.completeCampaign(c['id']);

//                                   // 2️⃣ Send notification to brand
//                                   final brandFcmToken =
//                                       await provider.getBrandFcmToken(brandId);
//                                   if (brandFcmToken != null) {
//                                     await NotificationService.sendPushMessage(
//                                       targetToken: brandFcmToken,
//                                       title: 'Campaign Completed!',
//                                       body:
//                                           'The influencer completed your campaign "$title".',
//                                     );
//                                   }

//                                   // 3️⃣ Send notification to influencer about earning
//                                   final influencerFcmToken =
//                                       await provider.getInfluencerFcmToken(influencerId);
//                                   if (influencerFcmToken != null) {
//                                     await NotificationService.sendPushMessage(
//                                       targetToken: influencerFcmToken,
//                                       title: 'Earning Added!',
//                                       body:
//                                           'You received payment for completing the campaign "$title".',
//                                     );
//                                   }

//                                   // 4️⃣ Update local status immediately
//                                   setState(() {
//                                     c['status'] = 'completed';
//                                   });

//                                   if (!mounted) return;
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                         content: Text(
//                                             "Campaign marked as completed!")),
//                                   );
//                                 },
//                               )
//                             else if (status == 'completed')
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.check, size: 18),
//                                 label: const Text("Completed"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.grey,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: null,
//                               ),
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
// import '../../services/notification_service.dart';
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
//     final provider = context.read<InfluencerProvider>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Campaigns"),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: campaigns.isEmpty
//           ? const Center(child: Text("No accepted campaigns yet"))
//           : ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//               itemCount: campaigns.length,
//               itemBuilder: (_, i) {
//                 final c = campaigns[i];
//                 final campaignData = c['campaigns'] ?? {};
//                 final brandId = campaignData['brand_id'];
//                 final title = campaignData['title'] ?? 'Untitled Campaign';
//                 final budget = campaignData['budget'] ?? 'N/A';
//                 final description =
//                     campaignData['description'] ?? 'No description available';
//                 final status = c['status'] ?? 'in_progress';

//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 3,
//                   child: Padding(
//                     padding: const EdgeInsets.all(14.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(Icons.campaign,
//                                 color: AppTheme.primaryColor),
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
//                         const SizedBox(height: 8),
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
//                         const SizedBox(height: 12),

//                         // ✅ Wrap buttons to prevent overflow
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 6,
//                           alignment: WrapAlignment.end,
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

//                                 if (brandId == null || influencerId == null) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           "Invalid campaign data. Missing brand or influencer ID."),
//                                     ),
//                                   );
//                                   return;
//                                 }

//                                 try {
//                                   final chat = await ChatService()
//                                       .getOrCreateChatForCampaign(
//                                     campaignId: campaignId,
//                                     brandId: brandId,
//                                     influencerId: influencerId,
//                                   );

//                                   if (chat != null && context.mounted) {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => InfluencerChatScreen(
//                                           chatId: chat.id,
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             "Failed to open chat. Try again."),
//                                       ),
//                                     );
//                                   }
//                                 } catch (e) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                         content:
//                                             Text("Error opening chat: $e")),
//                                   );
//                                 }
//                               },
//                             ),

//                             if (status == 'in_progress')
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.check, size: 18),
//                                 label: const Text("Mark as Completed"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: () async {
//                                   if (influencerId == null || brandId == null)
//                                     return;

//                                   await provider.completeCampaign(c['id']);

//                                   final brandFcmToken =
//                                       await provider.getBrandFcmToken(brandId);
//                                   if (brandFcmToken != null) {
//                                     await NotificationService.sendPushMessage(
//                                       targetToken: brandFcmToken,
//                                       title: 'Campaign Completed!',
//                                       body:
//                                           'The influencer completed your campaign "$title".',
//                                     );
//                                   }

//                                   final influencerFcmToken =
//                                       await provider.getInfluencerFcmToken(
//                                           influencerId);
//                                   if (influencerFcmToken != null) {
//                                     await NotificationService.sendPushMessage(
//                                       targetToken: influencerFcmToken,
//                                       title: 'Earning Added!',
//                                       body:
//                                           'You received payment for completing the campaign "$title".',
//                                     );
//                                   }

//                                   setState(() {
//                                     c['status'] = 'completed';
//                                   });

//                                   if (!mounted) return;
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                         content: Text(
//                                             "Campaign marked as completed!")),
//                                   );
//                                 },
//                               )
//                             else if (status == 'completed')
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.check, size: 18),
//                                 label: const Text("Completed"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.grey,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: null,
//                               ),
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
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//               itemCount: campaigns.length,
//               itemBuilder: (_, i) {
//                 final c = campaigns[i];
//                 final campaignData = c['campaigns'] ?? {};
//                 final brandId = campaignData['brand_id'];
//                 final title = campaignData['title'] ?? 'Untitled Campaign';
//                 final budget = campaignData['budget'] ?? 'N/A';
//                 final description =
//                     campaignData['description'] ?? 'No description available';
//                 final status = c['status'] ?? 'in_progress';

//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 3,
//                   child: Padding(
//                     padding: const EdgeInsets.all(14.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(Icons.campaign,
//                                 color: AppTheme.primaryColor),
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
//                         const SizedBox(height: 8),
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
//                         const SizedBox(height: 12),

//                         // ✅ Wrap buttons (View Details + Chat)
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 6,
//                           alignment: WrapAlignment.end,
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

//                                 if (brandId == null || influencerId == null) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           "Invalid campaign data. Missing brand or influencer ID."),
//                                     ),
//                                   );
//                                   return;
//                                 }

//                                 try {
//                                   final chat = await ChatService()
//                                       .getOrCreateChatForCampaign(
//                                     campaignId: campaignId,
//                                     brandId: brandId,
//                                     influencerId: influencerId,
//                                   );

//                                   if (chat != null && context.mounted) {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => InfluencerChatScreen(
//                                           chatId: chat.id,
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             "Failed to open chat. Try again."),
//                                       ),
//                                     );
//                                   }
//                                 } catch (e) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                         content:
//                                             Text("Error opening chat: $e")),
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
// import '../../services/notification_service.dart';
// import '../../utils/app_theme.dart';
// import 'influencer_chat_screen.dart';

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
//     final provider = context.read<InfluencerProvider>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Campaigns"),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: campaigns.isEmpty
//           ? const Center(child: Text("No accepted campaigns yet"))
//           : ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//               itemCount: campaigns.length,
//               itemBuilder: (_, i) {
//                 final c = campaigns[i];
//                 final campaignData = c['campaigns'] ?? {};
//                 final brandId = campaignData['brand_id'];
//                 final title = campaignData['title'] ?? 'Untitled Campaign';
//                 final budget = campaignData['budget'] ?? 'N/A';
//                 final description =
//                     campaignData['description'] ?? 'No description available';
//                 final status = c['status'] ?? 'in_progress';

//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 3,
//                   child: Padding(
//                     padding: const EdgeInsets.all(14.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(Icons.campaign,
//                                 color: AppTheme.primaryColor),
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
//                         const SizedBox(height: 8),
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
//                         const SizedBox(height: 12),

//                         // ✅ Wrap buttons
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 6,
//                           alignment: WrapAlignment.end,
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

//                                 if (brandId == null || influencerId == null) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           "Invalid campaign data. Missing brand or influencer ID."),
//                                     ),
//                                   );
//                                   return;
//                                 }

//                                 try {
//                                   final chat = await ChatService()
//                                       .getOrCreateChatForCampaign(
//                                     campaignId: campaignId,
//                                     brandId: brandId,
//                                     influencerId: influencerId,
//                                   );

//                                   if (chat != null && context.mounted) {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => InfluencerChatScreen(
//                                           chatId: chat.id,
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             "Failed to open chat. Try again."),
//                                       ),
//                                     );
//                                   }
//                                 } catch (e) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                         content:
//                                             Text("Error opening chat: $e")),
//                                   );
//                                 }
//                               },
//                             ),
//                             if (status == 'in_progress' || status == 'accepted')
//                      ElevatedButton.icon(
//                 icon: const Icon(Icons.check, size: 18),
//             label: const Text("Mark as Completed"),
//             style: ElevatedButton.styleFrom(
//          backgroundColor: Colors.green,
//        foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//     ),
//     onPressed: () async {
//       if (influencerId == null || brandId == null) return;

//       await provider.completeCampaign(c['id']);

//       final brandFcmToken = await provider.getBrandFcmToken(brandId);
//       if (brandFcmToken != null) {
//         await NotificationService.sendPushMessage(
//           targetToken: brandFcmToken,
//           title: 'Campaign Completed!',
//           body: 'The influencer completed your campaign "$title".',
//         );
//       }

//       final influencerFcmToken =
//           await provider.getInfluencerFcmToken(influencerId);
//       if (influencerFcmToken != null) {
//         await NotificationService.sendPushMessage(
//           targetToken: influencerFcmToken,
//           title: 'Earning Added!',
//           body:
//               'You received payment for completing the campaign "$title".',
//         );
//       }

//       setState(() {
//         c['status'] = 'completed';
//       });

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Campaign marked as completed!"),
//         ),
//       );
//     },
//   )
// else if (status == 'completed')
//   ElevatedButton.icon(
//     icon: const Icon(Icons.check, size: 18),
//     label: const Text("Completed"),
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.grey,
//       foregroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//     ),
//     onPressed: null,
//   )

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
// import '../../services/notification_service.dart';
// import '../../utils/app_theme.dart';
// import 'influencer_chat_screen.dart';

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
//     final provider = context.read<InfluencerProvider>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Campaigns"),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: campaigns.isEmpty
//           ? const Center(child: Text("No accepted campaigns yet"))
//           : ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//               itemCount: campaigns.length,
//               itemBuilder: (_, i) {
//                 final c = campaigns[i];
//                 final campaignData = c['campaigns'] ?? {};
//                 final brandId = campaignData['brand_id'];
//                 final title = campaignData['title'] ?? 'Untitled Campaign';
//                 final budget = campaignData['budget'] ?? 'N/A';
//                 final description =
//                     campaignData['description'] ?? 'No description available';
//                 final status = c['status'] ?? 'in_progress';

//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 3,
//                   child: Padding(
//                     padding: const EdgeInsets.all(14.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(Icons.campaign,
//                                 color: AppTheme.primaryColor),
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
//                         const SizedBox(height: 8),
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
//                         const SizedBox(height: 12),

//                         // ✅ Wrap buttons
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 6,
//                           alignment: WrapAlignment.end,
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

//                                 if (brandId == null || influencerId == null) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           "Invalid campaign data. Missing brand or influencer ID."),
//                                     ),
//                                   );
//                                   return;
//                                 }

//                                 try {
//                                   final chat = await ChatService()
//                                       .getOrCreateChatForCampaign(
//                                     campaignId: campaignId,
//                                     brandId: brandId,
//                                     influencerId: influencerId,
//                                   );

//                                   if (chat != null && context.mounted) {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => InfluencerChatScreen(
//                                           chatId: chat.id,
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             "Failed to open chat. Try again."),
//                                       ),
//                                     );
//                                   }
//                                 } catch (e) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                         content:
//                                             Text("Error opening chat: $e")),
//                                   );
//                                 }
//                               },
//                             ),

//                             // ✅ Mark as completed button (fixed)
//                             if (status == 'in_progress' || status == 'accepted')
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.check, size: 18),
//                                 label: const Text("Mark as Completed"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: () async {
//                                   if (influencerId == null || brandId == null)
//                                     return;

//                                   await provider.completeCampaign(
//                                       campaignData['id'], influencerId);

//                                   final brandFcmToken =
//                                       await provider.getBrandFcmToken(brandId);
//                                   if (brandFcmToken != null) {
//                                     await NotificationService.sendPushMessage(
//                                       targetToken: brandFcmToken,
//                                       title: 'Campaign Completed!',
//                                       body:
//                                           'The influencer completed your campaign "$title".',
//                                     );
//                                   }

//                                   final influencerFcmToken =
//                                       await provider.getInfluencerFcmToken(
//                                           influencerId);
//                                   if (influencerFcmToken != null) {
//                                     await NotificationService.sendPushMessage(
//                                       targetToken: influencerFcmToken,
//                                       title: 'Earning Added!',
//                                       body:
//                                           'You received payment for completing the campaign "$title".',
//                                     );
//                                   }

//                                   setState(() {
//                                     c['status'] = 'completed';
//                                   });

//                                   if (!mounted) return;
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           "Campaign marked as completed!"),
//                                     ),
//                                   );
//                                 },
//                               )
//                             else if (status == 'completed')
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.check, size: 18),
//                                 label: const Text("Completed"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.grey,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: null,
//                               ),
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
// import '../../services/notification_service.dart';
// import '../../utils/app_theme.dart';
// import 'influencer_chat_screen.dart';

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
//     final provider = context.read<InfluencerProvider>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Campaigns"),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: campaigns.isEmpty
//           ? const Center(child: Text("No accepted campaigns yet"))
//           : ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//               itemCount: campaigns.length,
//               itemBuilder: (_, i) {
//                 final c = campaigns[i];
//                 final campaignData = c['campaigns'] ?? {};
//                 final brandId = campaignData['brand_id'];
//                 final title = campaignData['title'] ?? 'Untitled Campaign';
//                 final budget = campaignData['budget'] ?? 'N/A';
//                 final description =
//                     campaignData['description'] ?? 'No description available';
//                 final status = c['status'] ?? 'in_progress';

//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 3,
//                   child: Padding(
//                     padding: const EdgeInsets.all(14.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(Icons.campaign,
//                                 color: AppTheme.primaryColor),
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
//                         const SizedBox(height: 8),
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
//                         const SizedBox(height: 12),

//                         // Buttons
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 6,
//                           alignment: WrapAlignment.end,
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
//                                 if (brandId == null || influencerId == null) return;

//                                 try {
//                                   final chat = await ChatService()
//                                       .getOrCreateChatForCampaign(
//                                     campaignId: campaignId,
//                                     brandId: brandId,
//                                     influencerId: influencerId,
//                                   );

//                                   if (chat != null && context.mounted) {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => InfluencerChatScreen(
//                                           chatId: chat.id,
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                 } catch (e) {
//                                   if (!mounted) return;
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                         content: Text(
//                                             "Error opening chat: $e")),
//                                   );
//                                 }
//                               },
//                             ),

//                             // Mark as completed button
//                             if (status == 'in_progress' || status == 'accepted')
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.check, size: 18),
//                                 label: const Text("Mark as Completed"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: () async {
//                                   if (influencerId == null || brandId == null) return;

//                                   // Complete campaign in backend
//                                   await provider.completeCampaign(
//                                       campaignData['id'], influencerId);

//                                   // Send notifications
//                                   final brandFcmToken =
//                                       await provider.getBrandFcmToken(brandId);
//                                   if (brandFcmToken != null) {
//                                     await NotificationService.sendPushMessage(
//                                       targetToken: brandFcmToken,
//                                       title: 'Campaign Completed!',
//                                       body:
//                                           'The influencer completed your campaign "$title".',
//                                     );
//                                   }

//                                   final influencerFcmToken =
//                                       await provider.getInfluencerFcmToken(
//                                           influencerId);
//                                   if (influencerFcmToken != null) {
//                                     await NotificationService.sendPushMessage(
//                                       targetToken: influencerFcmToken,
//                                       title: 'Earning Added!',
//                                       body:
//                                           'You received payment for completing the campaign "$title".',
//                                     );
//                                   }

//                                   // ✅ Refresh campaigns list from backend
//                                   await provider.fetchAcceptedCampaigns(influencerId);

//                                   if (!mounted) return;
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           "Campaign marked as completed!"),
//                                     ),
//                                   );
//                                 },
//                               )
//                             else if (status == 'completed')
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.check, size: 18),
//                                 label: const Text("Completed"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.grey,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: null,
//                               ),
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
// import '../../services/notification_service.dart';
// import '../../utils/app_theme.dart';
// import 'influencer_chat_screen.dart';  

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
//     final provider = context.watch<InfluencerProvider>();
//     final influencerId = context.read<AuthProvider>().currentUser?.id;
//     final campaigns = provider.acceptedCampaigns;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Campaigns"),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: campaigns.isEmpty
//           ? const Center(child: Text("No accepted campaigns yet"))
//           : ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//               itemCount: campaigns.length,
//               itemBuilder: (_, i) {
//                 final c = campaigns[i];
//                 final campaignData = c['campaigns'] ?? {};
//                 final brandId = campaignData['brand_id'];
//                 final title = campaignData['title'] ?? 'Untitled Campaign';
//                 final budget = campaignData['budget'] ?? 'N/A';
//                 final description =
//                     campaignData['description'] ?? 'No description available';
//                 final status = c['status'] ?? 'in_progress';

//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 3,
//                   child: Padding(
//                     padding: const EdgeInsets.all(14.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(Icons.campaign, color: AppTheme.primaryColor),
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
//                         const SizedBox(height: 8),
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
//                         const SizedBox(height: 12),
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 6,
//                           alignment: WrapAlignment.end,
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
//                                         onPressed: () => Navigator.pop(context),
//                                         child: const Text("Close"),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                               child: const Text("View Details"),
//                             ),
//                             ElevatedButton.icon(
//                               icon: const Icon(Icons.chat_bubble_outline, size: 18),
//                               label: const Text("Chat with Brand"),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppTheme.primaryColor,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               onPressed: () async {
//                                 if (brandId == null || influencerId == null) return;
//                                 try {
//                                   final chat = await ChatService()
//                                       .getOrCreateChatForCampaign(
//                                           campaignId: campaignData['id'],
//                                           brandId: brandId,
//                                           influencerId: influencerId);

//                                   if (chat != null && context.mounted) {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => InfluencerChatScreen(
//                                           chatId: chat.id,
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                 } catch (e) {
//                                   if (!mounted) return;
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text("Error opening chat: $e")),
//                                   );
//                                 }
//                               },
//                             ),

//                             // Mark as Completed button
//                             if (status != 'completed')
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.check, size: 18),
//                                 label: const Text("Mark as Completed"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: () async {
//                                   if (influencerId == null || brandId == null) return;

//                                   // Complete campaign in backend
//                                   await provider.completeCampaign(
//                                       campaignData['id'], influencerId);

//                                   // Send notifications
//                                   final brandFcmToken =
//                                       await provider.getBrandFcmToken(brandId);
//                                   if (brandFcmToken != null) {
//                                     await NotificationService.sendPushMessage(
//                                       targetToken: brandFcmToken,
//                                       title: 'Campaign Completed!',
//                                       body: 'The influencer completed your campaign "$title".',
//                                     );
//                                   }

//                                   final influencerFcmToken =
//                                       await provider.getInfluencerFcmToken(influencerId);
//                                   if (influencerFcmToken != null) {
//                                     await NotificationService.sendPushMessage(
//                                       targetToken: influencerFcmToken,
//                                       title: 'Earning Added!',
//                                       body: 'You received payment for completing the campaign "$title".',
//                                     );
//                                   }
//                                 },
//                               )
//                             else
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.check, size: 18),
//                                 label: const Text("Completed"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.grey,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: null,
//                               ),
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
// import '../../services/notification_service.dart';
// import '../../utils/app_theme.dart';
// import 'influencer_chat_screen.dart';

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
//     final provider = context.watch<InfluencerProvider>();
//     final influencerId = context.read<AuthProvider>().currentUser?.id;
//     final campaigns = provider.acceptedCampaigns;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Campaigns"),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: campaigns.isEmpty
//           ? const Center(child: Text("No accepted campaigns yet"))
//           : ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//               itemCount: campaigns.length,
//               itemBuilder: (_, i) {
//                 final c = campaigns[i];
//                 final campaignData = c['campaigns'] ?? {};
//                 final brandId = campaignData['brand_id'];
//                 final title = campaignData['title'] ?? 'Untitled Campaign';
//                 final budget = campaignData['budget'] ?? 'N/A';
//                 final description = campaignData['description'] ?? 'No description';
//                 final status = c['status'] ?? 'in_progress';
//                 final isCompleted = status == 'completed';

//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 3,
//                   child: Padding(
//                     padding: const EdgeInsets.all(14.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(Icons.campaign, color: AppTheme.primaryColor),
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
//                             if (isCompleted)
//                               Chip(
//                                 label: const Text('Completed', style: TextStyle(color: Colors.white)),
//                                 backgroundColor: Colors.green,
//                               ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           "Brand: ${brandId ?? 'Unknown'} • Budget: \$$budget",
//                           style: const TextStyle(fontSize: 14, color: Colors.grey),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           description,
//                           style: const TextStyle(fontSize: 13),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 12),
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 6,
//                           alignment: WrapAlignment.end,
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
//                                         onPressed: () => Navigator.pop(context),
//                                         child: const Text("Close"),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                               child: const Text("View Details"),
//                             ),
//                             ElevatedButton.icon(
//                               icon: const Icon(Icons.chat_bubble_outline, size: 18),
//                               label: const Text("Chat with Brand"),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppTheme.primaryColor,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               onPressed: () async {
//                                 if (brandId == null || influencerId == null) return;
//                                 try {
//                                   final chat = await ChatService().getOrCreateChatForCampaign(
//                                     campaignId: campaignData['id'],
//                                     brandId: brandId,
//                                     influencerId: influencerId,
//                                   );

//                                   if (chat != null && context.mounted) {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => InfluencerChatScreen(chatId: chat.id),
//                                       ),
//                                     );
//                                   }
//                                 } catch (e) {
//                                   if (!mounted) return;
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text("Error opening chat: $e")),
//                                   );
//                                 }
//                               },
//                             ),
//                             // Mark as Completed
//                             ElevatedButton.icon(
//                               icon: const Icon(Icons.check, size: 18),
//                               label: Text(isCompleted ? "Completed" : "Mark as Completed"),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: isCompleted ? Colors.grey : Colors.green,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               onPressed: isCompleted
//                                   ? null
//                                   : () async {
//                                       if (influencerId == null || brandId == null) return;

//                                       await provider.completeCampaign(campaignData['id'], influencerId);

//                                       // Send notifications
//                                       final brandFcmToken = await provider.getBrandFcmToken(brandId);
//                                       if (brandFcmToken != null) {
//                                         await NotificationService.sendPushMessage(
//                                           targetToken: brandFcmToken,
//                                           title: 'Campaign Completed!',
//                                           body: 'The influencer completed your campaign "$title".',
//                                         );
//                                       }

//                                       final influencerFcmToken = await provider.getInfluencerFcmToken(influencerId);
//                                       if (influencerFcmToken != null) {
//                                         await NotificationService.sendPushMessage(
//                                           targetToken: influencerFcmToken,
//                                           title: 'Earning Added!',
//                                           body: 'You received payment for completing the campaign "$title".',
//                                         );
//                                       }
//                                     },
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
import '../../services/notification_service.dart';
import '../../utils/app_theme.dart';
import 'influencer_chat_screen.dart';

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
    final provider = context.watch<InfluencerProvider>();
    final influencerId = context.read<AuthProvider>().currentUser?.id;
    final campaigns = provider.acceptedCampaigns;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Campaigns"),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: campaigns.isEmpty
          ? const Center(child: Text("No accepted campaigns yet"))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              itemCount: campaigns.length,
              itemBuilder: (_, i) {
                final c = campaigns[i];
                final campaignData = c['campaigns'] ?? {};
                final brandId = campaignData['brand_id'];
                final campaignId = campaignData['id'];
                final title = campaignData['title'] ?? 'Untitled Campaign';
                final budget = campaignData['budget'] ?? 'N/A';
                final description = campaignData['description'] ?? 'No description';
                final status = c['status'] ?? 'in_progress';
                final isCompleted = status == 'completed';

                return Dismissible(
                  key: Key(campaignId ?? i.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white, size: 28),
                  ),
                  confirmDismiss: (direction) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Delete Campaign"),
                        content: const Text(
                            "Are you sure you want to delete this campaign card? This won’t affect the brand data."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    );
                    return confirm ?? false;
                  },
                  onDismissed: (_) async {
                    await provider.deleteCampaignCard(campaignId, influencerId!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Campaign \"$title\" deleted")),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.campaign,
                                  color: AppTheme.primaryColor),
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
                              if (isCompleted)
                                Chip(
                                  label: const Text('Completed',
                                      style: TextStyle(color: Colors.white)),
                                  backgroundColor: Colors.green,
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Brand: ${brandId ?? 'Unknown'} • Budget: \$$budget",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: const TextStyle(fontSize: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            alignment: WrapAlignment.end,
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
                                onPressed: () async {
                                  if (brandId == null ||
                                      influencerId == null) return;
                                  try {
                                    final chat = await ChatService()
                                        .getOrCreateChatForCampaign(
                                      campaignId: campaignId,
                                      brandId: brandId,
                                      influencerId: influencerId,
                                    );

                                    if (chat != null && context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              InfluencerChatScreen(
                                                  chatId: chat.id),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Error opening chat: $e")),
                                    );
                                  }
                                },
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.check, size: 18),
                                label: Text(isCompleted
                                    ? "Completed"
                                    : "Mark as Completed"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isCompleted
                                      ? Colors.grey
                                      : Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: isCompleted
                                    ? null
                                    : () async {
                                        if (influencerId == null ||
                                            brandId == null) return;

                                        await provider.completeCampaign(
                                            campaignId, influencerId);

                                        final brandFcmToken =
                                            await provider.getBrandFcmToken(
                                                brandId);
                                        if (brandFcmToken != null) {
                                          await NotificationService
                                              .sendPushMessage(
                                            targetToken: brandFcmToken,
                                            title: 'Campaign Completed!',
                                            body:
                                                'The influencer completed your campaign "$title".',
                                          );
                                        }

                                        final influencerFcmToken = await provider
                                            .getInfluencerFcmToken(
                                                influencerId);
                                        if (influencerFcmToken != null) {
                                          await NotificationService
                                              .sendPushMessage(
                                            targetToken: influencerFcmToken,
                                            title: 'Earning Added!',
                                            body:
                                                'You received payment for completing the campaign "$title".',
                                          );
                                        }
                                      },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
