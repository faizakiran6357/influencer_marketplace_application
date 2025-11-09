
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
//                 final campaignId = campaignData['id'];
//                 final title = campaignData['title'] ?? 'Untitled Campaign';
//                 final budget = campaignData['budget'] ?? 'N/A';
//                 final description = campaignData['description'] ?? 'No description';
//                 final status = c['status'] ?? 'in_progress';
//                 final isCompleted = status == 'completed';

//                 return Dismissible(
//                   key: Key(campaignId ?? i.toString()),
//                   direction: DismissDirection.endToStart,
//                   background: Container(
//                     alignment: Alignment.centerRight,
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     color: Colors.redAccent,
//                     child: const Icon(Icons.delete, color: Colors.white, size: 28),
//                   ),
//                   confirmDismiss: (direction) async {
//                     final confirm = await showDialog<bool>(
//                       context: context,
//                       builder: (_) => AlertDialog(
//                         title: const Text("Delete Campaign"),
//                         content: const Text(
//                             "Are you sure you want to delete this campaign card? This won’t affect the brand data."),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context, false),
//                             child: const Text("Cancel"),
//                           ),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                             onPressed: () => Navigator.pop(context, true),
//                             child: const Text("Delete"),
//                           ),
//                         ],
//                       ),
//                     );
//                     return confirm ?? false;
//                   },
//                   onDismissed: (_) async {
//                     await provider.deleteCampaignCard(campaignId, influencerId!);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text("Campaign \"$title\" deleted")),
//                     );
//                   },
//                   child: Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 3,
//                     child: Padding(
//                       padding: const EdgeInsets.all(14.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(Icons.campaign,
//                                   color: AppTheme.primaryColor),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   title,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               if (isCompleted)
//                                 Chip(
//                                   label: const Text('Completed',
//                                       style: TextStyle(color: Colors.white)),
//                                   backgroundColor: Colors.green,
//                                 ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Brand: ${brandId ?? 'Unknown'} • Budget: \$$budget",
//                             style: const TextStyle(
//                                 fontSize: 14, color: Colors.grey),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             description,
//                             style: const TextStyle(fontSize: 13),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 12),
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 6,
//                             alignment: WrapAlignment.end,
//                             children: [
//                               TextButton(
//                                 onPressed: () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (_) => AlertDialog(
//                                       title: Text(title),
//                                       content: Text(description),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () =>
//                                               Navigator.pop(context),
//                                           child: const Text("Close"),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                                 child: const Text("View Details"),
//                               ),
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.chat_bubble_outline,
//                                     size: 18),
//                                 label: const Text("Chat with Brand"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: AppTheme.primaryColor,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: () async {
//                                   if (brandId == null ||
//                                       influencerId == null) return;
//                                   try {
//                                     final chat = await ChatService()
//                                         .getOrCreateChatForCampaign(
//                                       campaignId: campaignId,
//                                       brandId: brandId,
//                                       influencerId: influencerId,
//                                     );

//                                     if (chat != null && context.mounted) {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (_) =>
//                                               InfluencerChatScreen(
//                                                   chatId: chat.id),
//                                         ),
//                                       );
//                                     }
//                                   } catch (e) {
//                                     if (!mounted) return;
//                                     ScaffoldMessenger.of(context)
//                                         .showSnackBar(
//                                       SnackBar(
//                                           content:
//                                               Text("Error opening chat: $e")),
//                                     );
//                                   }
//                                 },
//                               ),
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.check, size: 18),
//                                 label: Text(isCompleted
//                                     ? "Completed"
//                                     : "Mark as Completed"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: isCompleted
//                                       ? Colors.grey
//                                       : Colors.green,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: isCompleted
//                                     ? null
//                                     : () async {
//                                         if (influencerId == null ||
//                                             brandId == null) return;

//                                         await provider.completeCampaign(
//                                             campaignId, influencerId);

//                                         final brandFcmToken =
//                                             await provider.getBrandFcmToken(
//                                                 brandId);
//                                         if (brandFcmToken != null) {
//                                           await NotificationService
//                                               .sendPushMessage(
//                                             targetToken: brandFcmToken,
//                                             title: 'Campaign Completed!',
//                                             body:
//                                                 'The influencer completed your campaign "$title".',
//                                           );
//                                         }

//                                         final influencerFcmToken = await provider
//                                             .getInfluencerFcmToken(
//                                                 influencerId);
//                                         if (influencerFcmToken != null) {
//                                           await NotificationService
//                                               .sendPushMessage(
//                                             targetToken: influencerFcmToken,
//                                             title: 'Earning Added!',
//                                             body:
//                                                 'You received payment for completing the campaign "$title".',
//                                           );
//                                         }
//                                       },
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
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
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final influencerId = context.read<AuthProvider>().currentUser?.id;
//       if (influencerId != null) {
//         final provider = context.read<InfluencerProvider>();

//         // 1️⃣ Fetch accepted campaigns
//         await provider.fetchAcceptedCampaigns(influencerId);

//         // 2️⃣ Extract brand IDs from campaigns
//         final brandIds = provider.acceptedCampaigns
//             .map((c) => c['campaigns']?['brand_id'] as String?)
//             .whereType<String>()
//             .toList();

//         // 3️⃣ Fetch brand names from profiles table
//         await provider.fetchBrandNames(brandIds);
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
//                 final brandId = campaignData['brand_id'] as String?;
//                 final brandName = provider.getBrandNameById(brandId); // ✅ Get brand name
//                 final campaignId = campaignData['id'];
//                 final title = campaignData['title'] ?? 'Untitled Campaign';
//                 final budget = campaignData['budget'] ?? 'N/A';
//                 final description = campaignData['description'] ?? 'No description';
//                 final status = c['status'] ?? 'in_progress';
//                 final isCompleted = status == 'completed';

//                 return Dismissible(
//                   key: Key(campaignId ?? i.toString()),
//                   direction: DismissDirection.endToStart,
//                   background: Container(
//                     alignment: Alignment.centerRight,
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     color: Colors.redAccent,
//                     child: const Icon(Icons.delete, color: Colors.white, size: 28),
//                   ),
//                   confirmDismiss: (direction) async {
//                     final confirm = await showDialog<bool>(
//                       context: context,
//                       builder: (_) => AlertDialog(
//                         title: const Text("Delete Campaign"),
//                         content: const Text(
//                             "Are you sure you want to delete this campaign card? This won’t affect the brand data."),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context, false),
//                             child: const Text("Cancel"),
//                           ),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                             onPressed: () => Navigator.pop(context, true),
//                             child: const Text("Delete"),
//                           ),
//                         ],
//                       ),
//                     );
//                     return confirm ?? false;
//                   },
//                   onDismissed: (_) async {
//                     if (influencerId != null) {
//                       await provider.deleteCampaignCard(campaignId, influencerId);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("Campaign \"$title\" deleted")),
//                       );
//                     }
//                   },
//                   child: Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 3,
//                     child: Padding(
//                       padding: const EdgeInsets.all(14.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(Icons.campaign, color: AppTheme.primaryColor),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   title,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               if (isCompleted)
//                                 Chip(
//                                   label: const Text('Completed',
//                                       style: TextStyle(color: Colors.white)),
//                                   backgroundColor: Colors.green,
//                                 ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Brand: ${brandName ?? 'Unknown'} • Budget: \$$budget",
//                             style: const TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             description,
//                             style: const TextStyle(fontSize: 13),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 12),
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 6,
//                             alignment: WrapAlignment.end,
//                             children: [
//                               TextButton(
//                                 onPressed: () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (_) => AlertDialog(
//                                       title: Text(title),
//                                       content: Text(description),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () => Navigator.pop(context),
//                                           child: const Text("Close"),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                                 child: const Text("View Details"),
//                               ),
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.chat_bubble_outline, size: 18),
//                                 label: const Text("Chat with Brand"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: AppTheme.primaryColor,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: () async {
//                                   if (brandId == null || influencerId == null) return;
//                                   try {
//                                     final chat = await ChatService().getOrCreateChatForCampaign(
//                                       campaignId: campaignId,
//                                       brandId: brandId,
//                                       influencerId: influencerId,
//                                     );
//                                     if (chat != null && context.mounted) {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (_) => InfluencerChatScreen(chatId: chat.id),
//                                         ),
//                                       );
//                                     }
//                                   } catch (e) {
//                                     if (!mounted) return;
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(content: Text("Error opening chat: $e")),
//                                     );
//                                   }
//                                 },
//                               ),
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.check, size: 18),
//                                 label: Text(isCompleted ? "Completed" : "Mark as Completed"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: isCompleted ? Colors.grey : Colors.green,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: isCompleted
//                                     ? null
//                                     : () async {
//                                         if (influencerId == null || brandId == null) return;

//                                         await provider.completeCampaign(campaignId, influencerId);

//                                         final brandFcmToken =
//                                             await provider.getBrandFcmToken(brandId);
//                                         if (brandFcmToken != null) {
//                                           await NotificationService.sendPushMessage(
//                                             targetToken: brandFcmToken,
//                                             title: 'Campaign Completed!',
//                                             body:
//                                                 'The influencer completed your campaign "$title".',
//                                           );
//                                         }

//                                         final influencerFcmToken =
//                                             await provider.getInfluencerFcmToken(influencerId);
//                                         if (influencerFcmToken != null) {
//                                           await NotificationService.sendPushMessage(
//                                             targetToken: influencerFcmToken,
//                                             title: 'Earning Added!',
//                                             body:
//                                                 'You received payment for completing the campaign "$title".',
//                                           );
//                                         }
//                                       },
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
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
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final influencerId = context.read<AuthProvider>().currentUser?.id;
//       final provider = context.read<InfluencerProvider>();

//       if (influencerId != null) {
//         await provider.fetchAcceptedCampaigns(influencerId);

//         // Collect all brand IDs from accepted campaigns
//         final brandIds = provider.acceptedCampaigns
//             .map((c) => c['campaigns']?['brand_id'] as String?)
//             .whereType<String>()
//             .toList();

//         // Fetch brand names
//         await provider.fetchBrandNames(brandIds);
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
//                 final brandId = campaignData['brand_id'] as String?;
//                 final campaignId = campaignData['id'];
//                 final title = campaignData['title'] ?? 'Untitled Campaign';
//                 final budget = campaignData['budget'] ?? 'N/A';
//                 final description = campaignData['description'] ?? 'No description';
//                 final status = c['status'] ?? 'in_progress';
//                 final isCompleted = status == 'completed';

//                 // Get brand name from provider
//                 final brandName = provider.getBrandNameById(brandId) ?? 'Unknown';

//                 return Dismissible(
//                   key: Key(campaignId ?? i.toString()),
//                   direction: DismissDirection.endToStart,
//                   background: Container(
//                     alignment: Alignment.centerRight,
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     color: Colors.redAccent,
//                     child: const Icon(Icons.delete, color: Colors.white, size: 28),
//                   ),
//                   confirmDismiss: (direction) async {
//                     final confirm = await showDialog<bool>(
//                       context: context,
//                       builder: (_) => AlertDialog(
//                         title: const Text("Delete Campaign"),
//                         content: const Text(
//                             "Are you sure you want to delete this campaign card? This won’t affect the brand data."),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context, false),
//                             child: const Text("Cancel"),
//                           ),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                             onPressed: () => Navigator.pop(context, true),
//                             child: const Text("Delete"),
//                           ),
//                         ],
//                       ),
//                     );
//                     return confirm ?? false;
//                   },
//                   onDismissed: (_) async {
//                     if (influencerId != null) {
//                       await provider.deleteCampaignCard(campaignId, influencerId);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("Campaign \"$title\" deleted")),
//                       );
//                     }
//                   },
//                   child: Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 3,
//                     child: Padding(
//                       padding: const EdgeInsets.all(14.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(Icons.campaign, color: AppTheme.primaryColor),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   title,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               if (isCompleted)
//                                 Chip(
//                                   label: const Text('Completed',
//                                       style: TextStyle(color: Colors.white)),
//                                   backgroundColor: Colors.green,
//                                 ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Brand: $brandName • Budget: \$$budget",
//                             style: const TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             description,
//                             style: const TextStyle(fontSize: 13),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 12),
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 6,
//                             alignment: WrapAlignment.end,
//                             children: [
//                               TextButton(
//                                 onPressed: () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (_) => AlertDialog(
//                                       title: Text(title),
//                                       content: Text(description),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () => Navigator.pop(context),
//                                           child: const Text("Close"),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                                 child: const Text("View Details"),
//                               ),
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.chat_bubble_outline, size: 18),
//                                 label: const Text("Chat with Brand"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: AppTheme.primaryColor,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: () async {
//                                   if (brandId == null || influencerId == null) return;
//                                   try {
//                                     final chat = await ChatService()
//                                         .getOrCreateChatForCampaign(
//                                       campaignId: campaignId,
//                                       brandId: brandId,
//                                       influencerId: influencerId,
//                                     );

//                                     if (chat != null && context.mounted) {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (_) =>
//                                               InfluencerChatScreen(chatId: chat.id),
//                                         ),
//                                       );
//                                     }
//                                   } catch (e) {
//                                     if (!mounted) return;
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(content: Text("Error opening chat: $e")),
//                                     );
//                                   }
//                                 },
//                               ),
//                               ElevatedButton.icon(
//                                 icon: const Icon(Icons.check, size: 18),
//                                 label: Text(isCompleted
//                                     ? "Completed"
//                                     : "Mark as Completed"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor:
//                                       isCompleted ? Colors.grey : Colors.green,
//                                   foregroundColor: Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 onPressed: isCompleted
//                                     ? null
//                                     : () async {
//                                         if (influencerId == null || brandId == null) return;

//                                         await provider.completeCampaign(
//                                             campaignId, influencerId);

//                                         final brandFcmToken =
//                                             await provider.getBrandFcmToken(brandId);
//                                         if (brandFcmToken != null) {
//                                           await NotificationService.sendPushMessage(
//                                             targetToken: brandFcmToken,
//                                             title: 'Campaign Completed!',
//                                             body:
//                                                 'The influencer completed your campaign "$title".',
//                                           );
//                                         }

//                                         final influencerFcmToken = await provider
//                                             .getInfluencerFcmToken(influencerId);
//                                         if (influencerFcmToken != null) {
//                                           await NotificationService.sendPushMessage(
//                                             targetToken: influencerFcmToken,
//                                             title: 'Earning Added!',
//                                             body:
//                                                 'You received payment for completing the campaign "$title".',
//                                           );
//                                         }
//                                       },
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final influencerId = context.read<AuthProvider>().currentUser?.id;
      final provider = context.read<InfluencerProvider>();

      if (influencerId != null) {
        // ✅ Fetch accepted campaigns for this influencer
        await provider.fetchAcceptedCampaigns(influencerId);

        // ✅ Collect unique brand IDs from campaigns
        final brandIds = provider.acceptedCampaigns
            .map((c) => c['campaigns']?['brand_id'] as String?)
            .whereType<String>()
            .toSet()
            .toList();

        // ✅ Fetch brand names (role = 'Brand')
        if (brandIds.isNotEmpty) {
          await provider.fetchBrandNames(brandIds);
        }
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
                final campaignId = campaignData['id'];
                final brandId = campaignData['brand_id'] as String?;
                final title = campaignData['title'] ?? 'Untitled Campaign';
                final budget = campaignData['budget'] ?? 'N/A';
                final description =
                    campaignData['description'] ?? 'No description';
                final status = c['status'] ?? 'in_progress';
                final isCompleted = status == 'completed';

                // ✅ Get brand name from provider (will show correctly now)
                final brandName =
                    provider.getBrandNameById(brandId) ?? 'Unknown';

                return Dismissible(
                  key: Key(campaignId ?? i.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.redAccent,
                    child:
                        const Icon(Icons.delete, color: Colors.white, size: 28),
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
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    );
                    return confirm ?? false;
                  },
                  onDismissed: (_) async {
                    if (influencerId != null) {
                      await provider.deleteCampaignCard(
                          campaignId, influencerId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("Campaign \"$title\" deleted successfully")),
                      );
                    }
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
                                  label: const Text(
                                    'Completed',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Brand: $brandName • Budget: \$$budget",
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
                                  if (brandId == null || influencerId == null)
                                    return;
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Error opening chat: $e")),
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
                                  backgroundColor:
                                      isCompleted ? Colors.grey : Colors.green,
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
                                            await provider
                                                .getBrandFcmToken(brandId);
                                        if (brandFcmToken != null) {
                                          await NotificationService
                                              .sendPushMessage(
                                            targetToken: brandFcmToken,
                                            title: 'Campaign Completed!',
                                            body:
                                                'The influencer completed your campaign "$title".',
                                          );
                                        }

                                        final influencerFcmToken =
                                            await provider.getInfluencerFcmToken(
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
