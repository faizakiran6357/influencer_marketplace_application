// // import 'package:flutter/material.dart';
// // import '../../../models/campaign_model.dart';

// // class CampaignDetailScreen extends StatelessWidget {
// //   final CampaignModel campaign;
// //   const CampaignDetailScreen({super.key, required this.campaign});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text(campaign.title)),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(campaign.description, style: const TextStyle(fontSize: 16)),
// //             const SizedBox(height: 10),
// //             Text("Budget: \$${campaign.budget}", style: const TextStyle(fontSize: 16)),
// //             Text("Spent: \$${campaign.spent}", style: const TextStyle(fontSize: 16)),
// //             Text("Status: ${campaign.status}", style: const TextStyle(fontSize: 16)),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import '../../../models/campaign_model.dart';

// class CampaignDetailScreen extends StatelessWidget {
//   final CampaignModel campaign;
//   const CampaignDetailScreen({super.key, required this.campaign});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(campaign.title)),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(campaign.description,
//                 style: const TextStyle(fontSize: 16, height: 1.5)),
//             const SizedBox(height: 20),
//             _infoRow("Budget", "\$${campaign.budget}"),
//             _infoRow("Spent", "\$${campaign.spent}"),
//             _infoRow("Status", campaign.status),
//             const Spacer(),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {},
//                 child: const Text("Edit Campaign (Coming soon)"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _infoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label,
//               style: const TextStyle(
//                   fontSize: 16, fontWeight: FontWeight.w500)),
//           Text(value,
//               style: const TextStyle(
//                   fontSize: 16, fontWeight: FontWeight.w400)),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/Brand/dashboard/compaign_edit_screen.dart';
// import '../../../models/campaign_model.dart';


// class CampaignDetailScreen extends StatelessWidget {
//   final CampaignModel campaign;
//   const CampaignDetailScreen({super.key, required this.campaign});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(campaign.title),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CampaignEditScreen(campaign: campaign),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(campaign.description, style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             Text("Budget: \$${campaign.budget}", style: const TextStyle(fontSize: 16)),
//             Text("Spent: \$${campaign.spent}", style: const TextStyle(fontSize: 16)),
//             Text("Status: ${campaign.status}", style: const TextStyle(fontSize: 16)),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/Brand/dashboard/compaign_edit_screen.dart';
// import '../../../models/campaign_model.dart';
// import '../../../services/compaign_service.dart';

// class CampaignDetailScreen extends StatefulWidget {
//   final CampaignModel campaign;
//   const CampaignDetailScreen({super.key, required this.campaign});

//   @override
//   State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
// }

// class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
//   final CampaignService _service = CampaignService();
//   bool _isLoading = false;
//   late CampaignModel campaign;

//   @override
//   void initState() {
//     super.initState();
//     campaign = widget.campaign;
//   }

//   Future<void> _activateCampaign() async {
//     setState(() => _isLoading = true);

//     try {
//       final updated = campaign.copyWith(status: 'active');
//       await _service.updateCampaign(updated);

//       setState(() {
//         campaign = updated;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('✅ Campaign activated successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ Failed to activate campaign: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDraft = campaign.status.toLowerCase() == 'draft';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(campaign.title),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () async {
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CampaignEditScreen(campaign: campaign),
//                 ),
//               );
//               setState(() {}); // refresh on return
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(campaign.description, style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             Text("💰 Budget: \$${campaign.budget}",
//                 style: const TextStyle(fontSize: 16)),
//             Text("💸 Spent: \$${campaign.spent}",
//                 style: const TextStyle(fontSize: 16)),
//             Text("📊 Status: ${campaign.status}",
//                 style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 20),

//             // ✅ Activate button (only for drafts)
//             if (isDraft)
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: _isLoading ? null : _activateCampaign,
//                   icon: _isLoading
//                       ? const SizedBox(
//                           width: 18,
//                           height: 18,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                       : const Icon(Icons.campaign),
//                   label: const Text("Activate Campaign"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 24, vertical: 12),
//                   ),
//                 ),
//               )
//             else
//               const Center(
//                 child: Text(
//                   "✅ This campaign is active and visible to influencers.",
//                   style: TextStyle(color: Colors.green, fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/Brand/dashboard/compaign_edit_screen.dart';
// import 'package:influencer_marketplace_application/utils/app_theme.dart';
// import '../../../models/campaign_model.dart';
// import '../../../services/compaign_service.dart';
// import '../../../services/chat_service.dart';
// import '../../brand/brand_chat_screen.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class CampaignDetailScreen extends StatefulWidget {
//   final CampaignModel campaign;
//   const CampaignDetailScreen({super.key, required this.campaign});

//   @override
//   State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
// }

// class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
//   final CampaignService _service = CampaignService();
//   final ChatService _chatService = ChatService();
//   final SupabaseClient _client = Supabase.instance.client;

//   bool _isLoading = false;
//   bool _loadingInfluencers = true;
//   List<Map<String, dynamic>> _acceptedInfluencers = [];
//   late CampaignModel campaign;

//   @override
//   void initState() {
//     super.initState();
//     campaign = widget.campaign;
//     _fetchAcceptedInfluencers();
//   }

//   Future<void> _fetchAcceptedInfluencers() async {
//     try {
//       final res = await _client
//         .from('campaign_influencers')
// .select('influencer_id, profiles!campaign_influencers_influencer_id_fkey(name, profile_image)')
// .eq('campaign_id', campaign.id)
// .eq('status', 'accepted');


//       setState(() {
//         _acceptedInfluencers = List<Map<String, dynamic>>.from(res);
//         _loadingInfluencers = false;
//       });
//     } catch (e) {
//       debugPrint("Error loading influencers: $e");
//       setState(() => _loadingInfluencers = false);
//     }
//   }

//   Future<void> _activateCampaign() async {
//     setState(() => _isLoading = true);

//     try {
//       final updated = campaign.copyWith(status: 'active');
//       await _service.updateCampaign(updated);

//       setState(() {
//         campaign = updated;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('✅ Campaign activated successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ Failed to activate campaign: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _openChat(String campaignId) async {
//     final chat =
//         await _chatService.getOrCreateChatForCampaign(campaignId: campaignId);

//     if (chat != null && mounted) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => BrandChatScreen(chatId: chat.id),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to open chat. Try again.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDraft = campaign.status.toLowerCase() == 'draft';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(campaign.title),
//         backgroundColor: AppTheme.primaryColor,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () async {
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CampaignEditScreen(campaign: campaign),
//                 ),
//               );
//               setState(() {}); // refresh on return
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(campaign.description, style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             Text("💰 Budget: \$${campaign.budget}",
//                 style: const TextStyle(fontSize: 16)),
//             Text("💸 Spent: \$${campaign.spent}",
//                 style: const TextStyle(fontSize: 16)),
//             Text("📊 Status: ${campaign.status}",
//                 style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 20),

//             // ✅ Activate button (only for drafts)
//             if (isDraft)
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: _isLoading ? null : _activateCampaign,
//                   icon: _isLoading
//                       ? const SizedBox(
//                           width: 18,
//                           height: 18,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                       : const Icon(Icons.campaign),
//                   label: const Text("Activate Campaign"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.primaryColor,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 24, vertical: 12),
//                   ),
//                 ),
//               )
//             else
//               const Center(
//                 child: Text(
//                   "✅ This campaign is active and visible to influencers.",
//                   style: TextStyle(color: Colors.green, fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//               ),

//             const SizedBox(height: 24),
//             const Divider(),

//             // ✅ Accepted Influencers Section
//             Text(
//               "Accepted Influencers",
//               style: Theme.of(context)
//                   .textTheme
//                   .titleMedium
//                   ?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),

//             if (_loadingInfluencers)
//               const Center(child: CircularProgressIndicator())
//             else if (_acceptedInfluencers.isEmpty)
//               const Center(
//                   child: Text("No influencers have accepted this campaign yet."))
//             else
//               Column(
//                 children: _acceptedInfluencers.map((inf) {
//                   final profile = inf['profiles'] ?? {};
//                   final name = profile['name'] ?? 'Unknown Influencer';
//                   final profileImage = profile['profile_image'] ?? '';

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: profileImage.isNotEmpty
//                             ? NetworkImage(profileImage)
//                             : const AssetImage(
//                                     'assets/images/default_avatar.png')
//                                 as ImageProvider,
//                       ),
//                       title: Text(name),
//                       trailing: ElevatedButton.icon(
//                         icon: const Icon(Icons.chat_bubble_outline, size: 18),
//                         label: const Text("Chat"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppTheme.primaryColor,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                         ),
//                         onPressed: () => _openChat(campaign.id),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../models/campaign_model.dart';
// import '../../../services/compaign_service.dart';
// import '../../../services/chat_service.dart';
// import '../../brand/brand_chat_screen.dart';
// import '../../../utils/app_theme.dart';
// import 'compaign_edit_screen.dart';

// class CampaignDetailScreen extends StatefulWidget {
//   final CampaignModel campaign;
//   const CampaignDetailScreen({super.key, required this.campaign});

//   @override
//   State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
// }

// class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
//   final CampaignService _service = CampaignService();
//   final ChatService _chatService = ChatService();
//   final SupabaseClient _client = Supabase.instance.client;

//   bool _isLoading = false;
//   bool _loadingInfluencers = true;
//   List<Map<String, dynamic>> _acceptedInfluencers = [];
//   late CampaignModel campaign;

//   @override
//   void initState() {
//     super.initState();
//     campaign = widget.campaign;
//     _fetchAcceptedInfluencers();
//   }

//   Future<void> _fetchAcceptedInfluencers() async {
//     try {
//       final res = await _client
//           .from('campaign_influencers')
//           .select(
//               'influencer_id, profiles!campaign_influencers_influencer_id_fkey(name, profile_image)')
//           .eq('campaign_id', campaign.id)
//           .eq('status', 'accepted');

//       setState(() {
//         _acceptedInfluencers = List<Map<String, dynamic>>.from(res);
//         _loadingInfluencers = false;
//       });
//     } catch (e) {
//       debugPrint("Error loading influencers: $e");
//       setState(() => _loadingInfluencers = false);
//     }
//   }

//   Future<void> _activateCampaign() async {
//     setState(() => _isLoading = true);
//     try {
//       final updated = campaign.copyWith(status: 'active');
//       await _service.updateCampaign(updated);
//       setState(() {
//         campaign = updated;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('✅ Campaign activated successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ Failed to activate campaign: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   /// 🟢 Start or open chat with a specific influencer
//   Future<void> _openChatWithInfluencer(String influencerId) async {
//     try {
//       final brandId = _client.auth.currentUser?.id;
//       if (brandId == null) return;

//       final chat = await _chatService.getOrCreateChatForCampaign(
//         campaignId: campaign.id,
//         brandId: brandId,
//         influencerId: influencerId,
//       );

//       if (chat != null && mounted) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => BrandChatScreen(chatId: chat.id),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to open chat. Try again.')),
//         );
//       }
//     } catch (e) {
//       debugPrint('openChatWithInfluencer error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDraft = campaign.status.toLowerCase() == 'draft';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(campaign.title),
//         backgroundColor: AppTheme.primaryColor,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () async {
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CampaignEditScreen(campaign: campaign),
//                 ),
//               );
//               setState(() {});
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(campaign.description, style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             Text("💰 Budget: \$${campaign.budget}",
//                 style: const TextStyle(fontSize: 16)),
//             Text("💸 Spent: \$${campaign.spent}",
//                 style: const TextStyle(fontSize: 16)),
//             Text("📊 Status: ${campaign.status}",
//                 style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 20),

//             // ✅ Activate button for drafts
//             if (isDraft)
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: _isLoading ? null : _activateCampaign,
//                   icon: _isLoading
//                       ? const SizedBox(
//                           width: 18,
//                           height: 18,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                       : const Icon(Icons.campaign),
//                   label: const Text("Activate Campaign"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.primaryColor,
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   ),
//                 ),
//               )
//             else
//               const Center(
//                 child: Text(
//                   "✅ This campaign is active and visible to influencers.",
//                   style: TextStyle(color: Colors.green, fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//               ),

//             const SizedBox(height: 24),
//             const Divider(),

//             // ✅ Accepted Influencers
//             Text(
//               "Accepted Influencers",
//               style: Theme.of(context)
//                   .textTheme
//                   .titleMedium
//                   ?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),

//             if (_loadingInfluencers)
//               const Center(child: CircularProgressIndicator())
//             else if (_acceptedInfluencers.isEmpty)
//               const Center(
//                 child: Text("No influencers have accepted this campaign yet."),
//               )
//             else
//               Column(
//                 children: _acceptedInfluencers.map((inf) {
//                   final profile = inf['profiles'] ?? {};
//                   final name = profile['name'] ?? 'Unknown';
//                   final image = profile['profile_image'] ?? '';
//                   final influencerId = inf['influencer_id'] ?? '';

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: image.isNotEmpty
//                             ? NetworkImage(image)
//                             : const AssetImage('assets/images/default_avatar.png')
//                                 as ImageProvider,
//                       ),
//                       title: Text(name),
//                       trailing: ElevatedButton.icon(
//                         icon: const Icon(Icons.chat_bubble_outline, size: 18),
//                         label: const Text("Chat"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppTheme.primaryColor,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                         ),
//                         onPressed: () => _openChatWithInfluencer(influencerId),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../models/campaign_model.dart';
// import '../../../services/compaign_service.dart';
// import '../../../services/chat_service.dart';
// import '../../brand/brand_chat_screen.dart';
// import '../../../utils/app_theme.dart';
// import 'compaign_edit_screen.dart';

// class CampaignDetailScreen extends StatefulWidget {
//   final CampaignModel campaign;
//   const CampaignDetailScreen({super.key, required this.campaign});

//   @override
//   State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
// }

// class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
//   final CampaignService _service = CampaignService();
//   final ChatService _chatService = ChatService();
//   final SupabaseClient _client = Supabase.instance.client;

//   bool _isLoading = false;
//   bool _loadingInfluencers = true;
//   List<Map<String, dynamic>> _acceptedInfluencers = [];
//   late CampaignModel campaign;

//   @override
//   void initState() {
//     super.initState();
//     campaign = widget.campaign;
//     _fetchAcceptedInfluencers();
//   }

//   /// Fetch influencers from the `influencers` table instead of profiles
//   Future<void> _fetchAcceptedInfluencers() async {
//     try {
//       final res = await _client
//           .from('campaign_influencers')
//           .select('influencer_id, influencers(id, name, profile_image)')
//           .eq('campaign_id', campaign.id)
//           .eq('status', 'accepted');

//       setState(() {
//         _acceptedInfluencers = List<Map<String, dynamic>>.from(res);
//         _loadingInfluencers = false;
//       });
//     } catch (e) {
//       debugPrint("Error loading influencers: $e");
//       setState(() => _loadingInfluencers = false);
//     }
//   }

//   Future<void> _activateCampaign() async {
//     setState(() => _isLoading = true);
//     try {
//       final updated = campaign.copyWith(status: 'active');
//       await _service.updateCampaign(updated);
//       setState(() {
//         campaign = updated;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('✅ Campaign activated successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ Failed to activate campaign: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   /// 🟢 Start or open chat with a specific influencer
//   Future<void> _openChatWithInfluencer(String influencerId) async {
//     try {
//       final brandId = _client.auth.currentUser?.id;
//       if (brandId == null) return;

//       final chat = await _chatService.getOrCreateChatForCampaign(
//         campaignId: campaign.id,
//         brandId: brandId,
//         influencerId: influencerId,
//       );

//       if (chat != null && mounted) {
//         // Navigate after current frame to avoid Flutter build error
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => BrandChatScreen(chatId: chat.id),
//             ),
//           );
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to open chat. Try again.')),
//         );
//       }
//     } catch (e) {
//       debugPrint('openChatWithInfluencer error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDraft = campaign.status.toLowerCase() == 'draft';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(campaign.title),
//         backgroundColor: AppTheme.primaryColor,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () async {
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CampaignEditScreen(campaign: campaign),
//                 ),
//               );
//               setState(() {});
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(campaign.description, style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             Text("💰 Budget: \$${campaign.budget}",
//                 style: const TextStyle(fontSize: 16)),
//             Text("💸 Spent: \$${campaign.spent}",
//                 style: const TextStyle(fontSize: 16)),
//             Text("📊 Status: ${campaign.status}",
//                 style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 20),

//             // ✅ Activate button for drafts
//             if (isDraft)
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: _isLoading ? null : _activateCampaign,
//                   icon: _isLoading
//                       ? const SizedBox(
//                           width: 18,
//                           height: 18,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                       : const Icon(Icons.campaign),
//                   label: const Text("Activate Campaign"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.primaryColor,
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   ),
//                 ),
//               )
//             else
//               const Center(
//                 child: Text(
//                   "✅ This campaign is active and visible to influencers.",
//                   style: TextStyle(color: Colors.green, fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//               ),

//             const SizedBox(height: 24),
//             const Divider(),

//             // ✅ Accepted Influencers
//             Text(
//               "Accepted Influencers",
//               style: Theme.of(context)
//                   .textTheme
//                   .titleMedium
//                   ?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),

//             if (_loadingInfluencers)
//               const Center(child: CircularProgressIndicator())
//             else if (_acceptedInfluencers.isEmpty)
//               const Center(
//                 child: Text("No influencers have accepted this campaign yet."),
//               )
//             else
//               Column(
//                 children: _acceptedInfluencers.map((inf) {
//                   final influencer = inf['influencers'] ?? {};
//                   final name = influencer['name'] ?? 'Unknown';
//                   final image = influencer['profile_image'] ?? '';
//                   final influencerId = inf['influencer_id'] ?? '';

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: image.isNotEmpty
//                             ? NetworkImage(image)
//                             : const AssetImage(
//                                 'assets/images/default_avatar.png') as ImageProvider,
//                       ),
//                       title: Text(name),
//                       trailing: ElevatedButton.icon(
//                         icon: const Icon(Icons.chat_bubble_outline, size: 18),
//                         label: const Text("Chat"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppTheme.primaryColor,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                         ),
//                         onPressed: () => _openChatWithInfluencer(influencerId),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../models/campaign_model.dart';
// import '../../../services/compaign_service.dart';
// import '../../../services/chat_service.dart';
// import '../../brand/brand_chat_screen.dart';
// import '../../../utils/app_theme.dart';
// import 'compaign_edit_screen.dart';

// class CampaignDetailScreen extends StatefulWidget {
//   final CampaignModel campaign;
//   const CampaignDetailScreen({super.key, required this.campaign});

//   @override
//   State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
// }

// class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
//   final CampaignService _service = CampaignService();
//   final ChatService _chatService = ChatService();
//   final SupabaseClient _client = Supabase.instance.client;

//   bool _isLoading = false;
//   bool _loadingInfluencers = true;
//   List<Map<String, dynamic>> _acceptedInfluencers = [];
//   late CampaignModel campaign;

//   @override
//   void initState() {
//     super.initState();
//     campaign = widget.campaign;
//     _fetchAcceptedInfluencers();
//   }

//   /// Fetch accepted influencers using RPC
//   Future<void> _fetchAcceptedInfluencers() async {
//     setState(() => _loadingInfluencers = true);

//     try {
//       final res = await _client.rpc(
//         'get_accepted_influencers',
//         params: {'camp_id': campaign.id},
//       );

//       setState(() {
//         _acceptedInfluencers = List<Map<String, dynamic>>.from(res);
//         _loadingInfluencers = false;
//       });

//       debugPrint('✅ Accepted influencers fetched: $_acceptedInfluencers');
//     } catch (e) {
//       debugPrint('❌ Error loading influencers: $e');
//       setState(() => _loadingInfluencers = false);
//     }
//   }

//   Future<void> _activateCampaign() async {
//     setState(() => _isLoading = true);
//     try {
//       final updated = campaign.copyWith(status: 'active');
//       await _service.updateCampaign(updated);
//       setState(() {
//         campaign = updated;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('✅ Campaign activated successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ Failed to activate campaign: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   /// Open chat with influencer safely using Future.microtask
//   Future<void> _openChatWithInfluencer(String influencerId) async {
//     final brandId = _client.auth.currentUser?.id;
//     if (brandId == null) return;

//     try {
//       final chat = await _chatService.getOrCreateChatForCampaign(
//         campaignId: campaign.id,
//         brandId: brandId,
//         influencerId: influencerId,
//       );

//       if (chat != null && mounted) {
//         // ✅ Defer navigation to avoid setState during build error
//         Future.microtask(() {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => BrandChatScreen(chatId: chat.id),
//             ),
//           );
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to open chat. Try again.')),
//         );
//       }
//     } catch (e) {
//       debugPrint('openChatWithInfluencer error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDraft = campaign.status.toLowerCase() == 'draft';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(campaign.title),
//         backgroundColor: AppTheme.primaryColor,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () async {
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CampaignEditScreen(campaign: campaign),
//                 ),
//               );
//               setState(() {});
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(campaign.description, style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             Text("💰 Budget: \$${campaign.budget}",
//                 style: const TextStyle(fontSize: 16)),
//             Text("💸 Spent: \$${campaign.spent}",
//                 style: const TextStyle(fontSize: 16)),
//             Text("📊 Status: ${campaign.status}",
//                 style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 20),

//             if (isDraft)
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: _isLoading ? null : _activateCampaign,
//                   icon: _isLoading
//                       ? const SizedBox(
//                           width: 18,
//                           height: 18,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                       : const Icon(Icons.campaign),
//                   label: const Text("Activate Campaign"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.primaryColor,
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   ),
//                 ),
//               )
//             else
//               const Center(
//                 child: Text(
//                   "✅ This campaign is active and visible to influencers.",
//                   style: TextStyle(color: Colors.green, fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//               ),

//             const SizedBox(height: 24),
//             const Divider(),

//             Text(
//               "Accepted Influencers",
//               style: Theme.of(context)
//                   .textTheme
//                   .titleMedium
//                   ?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),

//             if (_loadingInfluencers)
//               const Center(child: CircularProgressIndicator())
//             else if (_acceptedInfluencers.isEmpty)
//               const Center(
//                 child: Text("No influencers have accepted this campaign yet."),
//               )
//             else
//               Column(
//                 children: _acceptedInfluencers.map((inf) {
//                   final name = inf['name'] ?? 'Unknown';
//                   final email = inf['email'] ?? '';
//                   final image = inf['profile_image'] ?? '';
//                   final influencerId = inf['influencer_id'] ?? '';

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: image.isNotEmpty
//                             ? NetworkImage(image)
//                             : const AssetImage(
//                                 'assets/images/default_avatar.png') as ImageProvider,
//                       ),
//                       title: Text(name),
//                       subtitle: Text(email),
//                       trailing: ElevatedButton.icon(
//                         icon: const Icon(Icons.chat_bubble_outline, size: 18),
//                         label: const Text("Chat"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppTheme.primaryColor,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                         ),
//                         onPressed: () => _openChatWithInfluencer(influencerId),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../models/campaign_model.dart';
// import '../../../services/compaign_service.dart';
// import '../../../services/chat_service.dart';
// import '../../brand/brand_chat_screen.dart';
// import '../../../utils/app_theme.dart';
// import 'compaign_edit_screen.dart';

// class CampaignDetailScreen extends StatefulWidget {
//   final CampaignModel campaign;
//   const CampaignDetailScreen({super.key, required this.campaign});

//   @override
//   State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
// }

// class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
//   final CampaignService _service = CampaignService();
//   final ChatService _chatService = ChatService();
//   final SupabaseClient _client = Supabase.instance.client;

//   bool _isLoading = false;
//   bool _loadingInfluencers = true;
//   List<Map<String, dynamic>> _acceptedInfluencers = [];
//   late CampaignModel campaign;

//   @override
//   void initState() {
//     super.initState();
//     campaign = widget.campaign;
//     _fetchAcceptedInfluencers();
//   }

//   Future<void> _fetchAcceptedInfluencers() async {
//     setState(() => _loadingInfluencers = true);

//     try {
//       final res = await _client.rpc(
//         'get_accepted_influencers',
//         params: {'camp_id': campaign.id},
//       );

//       setState(() {
//         _acceptedInfluencers = List<Map<String, dynamic>>.from(res);
//         _loadingInfluencers = false;
//       });

//       debugPrint('✅ Accepted influencers fetched: $_acceptedInfluencers');
//     } catch (e) {
//       debugPrint('❌ Error loading influencers: $e');
//       setState(() => _loadingInfluencers = false);
//     }
//   }

//   Future<void> _activateCampaign() async {
//     setState(() => _isLoading = true);
//     try {
//       final updated = campaign.copyWith(status: 'active');
//       await _service.updateCampaign(updated);
//       setState(() => campaign = updated);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('✅ Campaign activated successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ Failed to activate campaign: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   /// Open chat safely after build
//   Future<void> _openChatWithInfluencer(String influencerId) async {
//     final brandId = _client.auth.currentUser?.id;
//     if (brandId == null) return;

//     try {
//       final chat = await _chatService.getOrCreateChatForCampaign(
//         campaignId: campaign.id,
//         brandId: brandId,
//         influencerId: influencerId,
//       );

//       if (chat != null && mounted) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (!mounted) return;
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => BrandChatScreen(chatId: chat.id),
//             ),
//           );
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to open chat. Try again.')),
//         );
//       }
//     } catch (e) {
//       debugPrint('openChatWithInfluencer error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDraft = campaign.status.toLowerCase() == 'draft';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(campaign.title),
//         backgroundColor: AppTheme.primaryColor,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () async {
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CampaignEditScreen(campaign: campaign),
//                 ),
//               );
//               setState(() {});
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(campaign.description, style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             Text("💰 Budget: \$${campaign.budget}", style: const TextStyle(fontSize: 16)),
//             Text("💸 Spent: \$${campaign.spent}", style: const TextStyle(fontSize: 16)),
//             Text("📊 Status: ${campaign.status}", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 20),

//             if (isDraft)
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: _isLoading ? null : _activateCampaign,
//                   icon: _isLoading
//                       ? const SizedBox(
//                           width: 18,
//                           height: 18,
//                           child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                         )
//                       : const Icon(Icons.campaign),
//                   label: const Text("Activate Campaign"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.primaryColor,
//                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   ),
//                 ),
//               )
//             else
//               const Center(
//                 child: Text(
//                   "✅ This campaign is active and visible to influencers.",
//                   style: TextStyle(color: Colors.green, fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//               ),

//             const SizedBox(height: 24),
//             const Divider(),

//             Text(
//               "Accepted Influencers",
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),

//             if (_loadingInfluencers)
//               const Center(child: CircularProgressIndicator())
//             else if (_acceptedInfluencers.isEmpty)
//               const Center(child: Text("No influencers have accepted this campaign yet."))
//             else
//               Column(
//                 children: _acceptedInfluencers.map((inf) {
//                   final name = inf['name'] ?? 'Unknown';
//                   final email = inf['email'] ?? '';
//                   final image = inf['profile_image'] ?? '';
//                   final influencerId = inf['influencer_id'] ?? '';

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: image.isNotEmpty
//                             ? NetworkImage(image)
//                             : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
//                       ),
//                       title: Text(name),
//                       subtitle: Text(email),
//                       trailing: ElevatedButton.icon(
//                         icon: const Icon(Icons.chat_bubble_outline, size: 18),
//                         label: const Text("Chat"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppTheme.primaryColor,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                         ),
//                         onPressed: () => _openChatWithInfluencer(influencerId),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// corect//
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../models/campaign_model.dart';
// import '../../../services/compaign_service.dart';
// import '../../../services/chat_service.dart';
// import '../../brand/brand_chat_screen.dart';
// import '../../../utils/app_theme.dart';
// import 'compaign_edit_screen.dart';

// class CampaignDetailScreen extends StatefulWidget {
//   final CampaignModel campaign;
//   const CampaignDetailScreen({super.key, required this.campaign});

//   @override
//   State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
// }

// class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
//   final CampaignService _service = CampaignService();
//   final ChatService _chatService = ChatService();
//   final SupabaseClient _client = Supabase.instance.client;

//   bool _isLoading = false;
//   bool _loadingInfluencers = true;
//   List<Map<String, dynamic>> _acceptedInfluencers = [];
//   late CampaignModel campaign;

//   @override
//   void initState() {
//     super.initState();
//     campaign = widget.campaign;
//     _fetchAcceptedInfluencers();
//   }

//   Future<void> _fetchAcceptedInfluencers() async {
//     setState(() => _loadingInfluencers = true);

//     try {
//       final res = await _client.rpc(
//         'get_accepted_influencers',
//         params: {'camp_id': campaign.id},
//       );

//       setState(() {
//         _acceptedInfluencers = List<Map<String, dynamic>>.from(res);
//         _loadingInfluencers = false;
//       });

//       debugPrint('✅ Accepted influencers fetched: $_acceptedInfluencers');
//     } catch (e) {
//       debugPrint('❌ Error loading influencers: $e');
//       setState(() => _loadingInfluencers = false);
//     }
//   }

//   Future<void> _activateCampaign() async {
//     setState(() => _isLoading = true);
//     try {
//       final updated = campaign.copyWith(status: 'active');
//       await _service.updateCampaign(updated);
//       setState(() => campaign = updated);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('✅ Campaign activated successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ Failed to activate campaign: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   /// Open chat safely after build
//   Future<void> _openChatWithInfluencer(Map<String, dynamic> influencer) async {
//     final brandId = _client.auth.currentUser?.id;
//     if (brandId == null) return;

//     final influencerId = influencer['influencer_id'] ?? '';
//     if (influencerId.isEmpty) return;

//     try {
//       final chat = await _chatService.getOrCreateChatForCampaign(
//         campaignId: campaign.id,
//         brandId: brandId,
//         influencerId: influencerId,
//       );

//       if (chat != null && mounted) {
//         final participantName = influencer['name'] ?? 'User';
//         final participantProfileUrl = influencer['profile_image'] ?? '';

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (!mounted) return;
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => BrandChatScreen(
//                 chatId: chat.id,
//                 participantName: participantName,
//                 participantProfileUrl: participantProfileUrl,
//               ),
//             ),
//           );
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to open chat. Try again.')),
//         );
//       }
//     } catch (e) {
//       debugPrint('openChatWithInfluencer error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDraft = campaign.status.toLowerCase() == 'draft';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(campaign.title),
//         backgroundColor: AppTheme.primaryColor,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () async {
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CampaignEditScreen(campaign: campaign),
//                 ),
//               );
//               setState(() {});
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(campaign.description, style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             Text("💰 Budget: \$${campaign.budget}", style: const TextStyle(fontSize: 16)),
//             Text("💸 Spent: \$${campaign.spent}", style: const TextStyle(fontSize: 16)),
//             Text("📊 Status: ${campaign.status}", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 20),

//             if (isDraft)
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: _isLoading ? null : _activateCampaign,
//                   icon: _isLoading
//                       ? const SizedBox(
//                           width: 18,
//                           height: 18,
//                           child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                         )
//                       : const Icon(Icons.campaign),
//                   label: const Text("Activate Campaign"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.primaryColor,
//                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   ),
//                 ),
//               )
//             else
//               const Center(
//                 child: Text(
//                   "✅ This campaign is active and visible to influencers.",
//                   style: TextStyle(color: Colors.green, fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//               ),

//             const SizedBox(height: 24),
//             const Divider(),

//             Text(
//               "Accepted Influencers",
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),

//             if (_loadingInfluencers)
//               const Center(child: CircularProgressIndicator())
//             else if (_acceptedInfluencers.isEmpty)
//               const Center(child: Text("No influencers have accepted this campaign yet."))
//             else
//               Column(
//                 children: _acceptedInfluencers.map((inf) {
//                   final name = inf['name'] ?? 'Unknown';
//                   final email = inf['email'] ?? '';
//                   final image = inf['profile_image'] ?? '';

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: image.isNotEmpty
//                             ? NetworkImage(image)
//                             : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
//                       ),
//                       title: Text(name),
//                       subtitle: Text(email),
//                       trailing: ElevatedButton.icon(
//                         icon: const Icon(Icons.chat_bubble_outline, size: 18),
//                         label: const Text("Chat"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppTheme.primaryColor,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                         ),
//                         onPressed: () => _openChatWithInfluencer(inf),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/campaign_model.dart';
import '../../../services/compaign_service.dart';
import '../../../services/chat_service.dart';
import '../../brand/brand_chat_screen.dart';
import '../../../utils/app_theme.dart';
import 'compaign_edit_screen.dart';

class CampaignDetailScreen extends StatefulWidget {
  final CampaignModel campaign;
  const CampaignDetailScreen({super.key, required this.campaign});

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  final CampaignService _service = CampaignService();
  final ChatService _chatService = ChatService();
  final SupabaseClient _client = Supabase.instance.client;

  bool _isLoading = false;
  bool _loadingInfluencers = true;
  List<Map<String, dynamic>> _acceptedInfluencers = [];
  late CampaignModel campaign;

  @override
  void initState() {
    super.initState();
    campaign = widget.campaign;
    _fetchAcceptedInfluencers();
  }

  Future<void> _fetchAcceptedInfluencers() async {
    setState(() => _loadingInfluencers = true);

    try {
      final res = await _client.rpc(
        'get_accepted_influencers',
        params: {'camp_id': campaign.id},
      );

      setState(() {
        _acceptedInfluencers = List<Map<String, dynamic>>.from(res);
        _loadingInfluencers = false;
      });

      debugPrint('✅ Accepted influencers fetched: $_acceptedInfluencers');
    } catch (e) {
      debugPrint('❌ Error loading influencers: $e');
      setState(() => _loadingInfluencers = false);
    }
  }

  Future<void> _activateCampaign() async {
    setState(() => _isLoading = true);
    try {
      final updated = campaign.copyWith(status: 'active');
      await _service.updateCampaign(updated);
      setState(() => campaign = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Campaign activated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to activate campaign: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Open chat safely after build
  Future<void> _openChatWithInfluencer(Map<String, dynamic> influencer) async {
    final brandId = _client.auth.currentUser?.id;
    if (brandId == null) return;

    final influencerId = influencer['influencer_id'] ?? '';
    if (influencerId.isEmpty) return;

    try {
      final chat = await _chatService.getOrCreateChatForCampaign(
        campaignId: campaign.id,
        brandId: brandId,
        influencerId: influencerId,
      );

      if (chat != null && mounted) {
        // ✅ Correct partner info mapping
        final partnerName = influencer['name'] ?? 'User';
        final partnerProfileUrl = influencer['profile_image'] ?? '';

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BrandChatScreen(
                chatId: chat.id,
                partnerName: partnerName,
                partnerProfileUrl: partnerProfileUrl,
              ),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to open chat. Try again.')),
        );
      }
    } catch (e) {
      debugPrint('openChatWithInfluencer error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDraft = campaign.status.toLowerCase() == 'draft';

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(campaign.title),
      //   backgroundColor: AppTheme.primaryColor,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.edit),
      //       onPressed: () async {
      //         await Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (_) => CampaignEditScreen(campaign: campaign),
      //           ),
      //         );
      //         setState(() {});
      //       },
      //     ),
      //   ],
      // ),
      appBar: AppBar(
  title: Text(campaign.title),
  backgroundColor: AppTheme.primaryColor,
  actions: [
    // Show edit button only if campaign is not completed
    if (campaign.status.toLowerCase() != 'completed')
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CampaignEditScreen(campaign: campaign),
            ),
          );
          setState(() {}); // Refresh screen after editing
        },
      ),
  ],
),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(campaign.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("💰 Budget: \$${campaign.budget}", style: const TextStyle(fontSize: 16)),
            Text("💸 Spent: \$${campaign.spent}", style: const TextStyle(fontSize: 16)),
            Text("📊 Status: ${campaign.status}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            if (isDraft)
              Center(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _activateCampaign,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.campaign),
                  label: const Text("Activate Campaign"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              )
            else
              const Center(
                child: Text(
                  "✅ This campaign is active and visible to influencers.",
                  style: TextStyle(color: Colors.green, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 24),
            const Divider(),

            Text(
              "Accepted Influencers",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (_loadingInfluencers)
              const Center(child: CircularProgressIndicator())
            else if (_acceptedInfluencers.isEmpty)
              const Center(child: Text("No influencers have accepted this campaign yet."))
            else
              Column(
                children: _acceptedInfluencers.map((inf) {
                  final partnerName = inf['name'] ?? 'Unknown';
                  final email = inf['email'] ?? '';
                  final partnerProfileUrl = inf['profile_image'] ?? '';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: partnerProfileUrl.isNotEmpty
                            ? NetworkImage(partnerProfileUrl)
                            : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                      ),
                      title: Text(partnerName),
                      subtitle: Text(email),
                      trailing: ElevatedButton.icon(
                        icon: const Icon(Icons.chat_bubble_outline, size: 18),
                        label: const Text("Chat"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => _openChatWithInfluencer(inf),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
