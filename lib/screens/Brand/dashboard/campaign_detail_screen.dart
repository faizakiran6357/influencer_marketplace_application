
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
//         // ✅ Correct partner info mapping
//         final partnerName = influencer['name'] ?? 'User';
//         final partnerProfileUrl = influencer['profile_image'] ?? '';

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (!mounted) return;
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => BrandChatScreen(
//                 chatId: chat.id,
//                 partnerName: partnerName,
//                 partnerProfileUrl: partnerProfileUrl,
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
//       // appBar: AppBar(
//       //   title: Text(campaign.title),
//       //   backgroundColor: AppTheme.primaryColor,
//       //   actions: [
//       //     IconButton(
//       //       icon: const Icon(Icons.edit),
//       //       onPressed: () async {
//       //         await Navigator.push(
//       //           context,
//       //           MaterialPageRoute(
//       //             builder: (_) => CampaignEditScreen(campaign: campaign),
//       //           ),
//       //         );
//       //         setState(() {});
//       //       },
//       //     ),
//       //   ],
//       // ),
//       appBar: AppBar(
//   title: Text(campaign.title),
//   backgroundColor: AppTheme.primaryColor,
//   actions: [
//     // Show edit button only if campaign is not completed
//     if (campaign.status.toLowerCase() != 'completed')
//       IconButton(
//         icon: const Icon(Icons.edit),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => CampaignEditScreen(campaign: campaign),
//             ),
//           );
//           setState(() {}); // Refresh screen after editing
//         },
//       ),
//   ],
// ),

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
//                   final partnerName = inf['name'] ?? 'Unknown';
//                   final email = inf['email'] ?? '';
//                   final partnerProfileUrl = inf['profile_image'] ?? '';

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: partnerProfileUrl.isNotEmpty
//                             ? NetworkImage(partnerProfileUrl)
//                             : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
//                       ),
//                       title: Text(partnerName),
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
//     } catch (e) {
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
//         final partnerName = influencer['name'] ?? 'User';
//         final partnerProfileUrl = influencer['profile_image'] ?? '';

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (!mounted) return;
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => BrandChatScreen(
//                 chatId: chat.id,
//                 partnerName: partnerName,
//                 partnerProfileUrl: partnerProfileUrl,
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
//     final isActive = campaign.status.toLowerCase() == 'active';
//     final isCompleted = campaign.status.toLowerCase() == 'completed';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(campaign.title,  style: TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 20,
//             letterSpacing: -0.3,
//             color: Colors.white,
//           ),),
//         backgroundColor: AppTheme.primaryColor,
//         actions: [
//           if (!isCompleted)
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: () async {
//                 await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => CampaignEditScreen(campaign: campaign),
//                   ),
//                 );
//                 setState(() {});
//               },
//             ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Modern Campaign Info Card
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 15,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     campaign.description,
//                     style: const TextStyle(fontSize: 16, height: 1.5),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       const Icon(Icons.attach_money, size: 20, color: AppTheme.primaryColor),
//                       const SizedBox(width: 6),
//                       Expanded(
//                         child: Text(
//                           "Budget: \$${campaign.budget}",
//                           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                       // Dynamic Status Badge
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: isActive
//                               ? Colors.green.withOpacity(0.15)
//                               : isDraft
//                                   ? Colors.orange.withOpacity(0.15)
//                                   : Colors.grey.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           campaign.status.toUpperCase(),
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: isActive
//                                 ? Colors.green
//                                 : isDraft
//                                     ? Colors.orange
//                                     : Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Campaign Status Actions
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
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               )
//             else if (isActive)
//               const Center(
//                 child: Text(
//                   "✅ This campaign is active and visible to influencers.",
//                   style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//               )
//             else if (isCompleted)
//               const Center(
//                 child: Text(
//                   "🏁 This campaign has been completed.",
//                   style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//               ),

//             const SizedBox(height: 24),
//             const Divider(),

//             // Accepted Influencers
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
//                   child: Text(
//                 "No influencers have accepted this campaign yet.",
//                 style: TextStyle(color: Colors.grey),
//               ))
//             else
//               Column(
//                 children: _acceptedInfluencers.map((inf) {
//                   final partnerName = inf['name'] ?? 'Unknown';
//                   final email = inf['email'] ?? '';
//                   final partnerProfileUrl = inf['profile_image'] ?? '';

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     elevation: 2,
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         radius: 24,
//                         backgroundImage: partnerProfileUrl.isNotEmpty
//                             ? NetworkImage(partnerProfileUrl)
//                             : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
//                       ),
//                       title: Text(partnerName, style: const TextStyle(fontWeight: FontWeight.w600)),
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
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
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
//   List<Map<String, dynamic>> _reports = [];

//   late CampaignModel campaign;

//   @override
//   void initState() {
//     super.initState();
//     campaign = widget.campaign;
//     _fetchAcceptedInfluencers();
//     _fetchReports();
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
//     } catch (e) {
//       setState(() => _loadingInfluencers = false);
//       debugPrint('Failed to fetch accepted influencers: $e');
//     }
//   }

//   Future<void> _fetchReports() async {
//     try {
//       // Fetch all reports for this campaign
//       final reportsData = await _client
//           .from('campaign_reports')
//           .select()
//           .eq('campaign_id', campaign.id)
//           .order('uploaded_at', ascending: false);

//       final reportsList = List<Map<String, dynamic>>.from(reportsData ?? []);

//       // Fetch influencer names for each report
//       for (var i = 0; i < reportsList.length; i++) {
//         final influencerId = reportsList[i]['influencer_id'];
//         if (influencerId != null) {
//           final inf = await _client
//               .from('profiles') // change if your influencer table is named differently
//               .select('name')
//               .eq('id', influencerId)
//               .maybeSingle();
//           reportsList[i]['influencer_name'] = inf?['name'] ?? 'Unknown';
//         } else {
//           reportsList[i]['influencer_name'] = 'Unknown';
//         }
//       }

//       setState(() {
//         _reports = reportsList;
//       });
//     } catch (e) {
//       debugPrint('Failed to fetch reports: $e');
//     }
//   }

//   Future<void> _viewReport(String fileUrl) async {
//     final uri = Uri.parse(fileUrl);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not open report')),
//       );
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
//         final partnerName = influencer['name'] ?? 'User';
//         final partnerProfileUrl = influencer['profile_image'] ?? '';

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (!mounted) return;
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => BrandChatScreen(
//                 chatId: chat.id,
//                 partnerName: partnerName,
//                 partnerProfileUrl: partnerProfileUrl,
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
//     final isActive = campaign.status.toLowerCase() == 'active';
//     final isCompleted = campaign.status.toLowerCase() == 'completed';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           campaign.title,
//           style: const TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 20,
//             letterSpacing: -0.3,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: AppTheme.primaryColor,
//         actions: [
//           if (!isCompleted)
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: () async {
//                 await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => CampaignEditScreen(campaign: campaign),
//                   ),
//                 );
//                 setState(() {});
//               },
//             ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Campaign Info Card
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 15,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     campaign.description,
//                     style: const TextStyle(fontSize: 16, height: 1.5),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       const Icon(Icons.attach_money,
//                           size: 20, color: AppTheme.primaryColor),
//                       const SizedBox(width: 6),
//                       Expanded(
//                         child: Text(
//                           "Budget: \$${campaign.budget}",
//                           style: const TextStyle(
//                               fontSize: 15, fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: isActive
//                               ? Colors.green.withOpacity(0.15)
//                               : isDraft
//                                   ? Colors.orange.withOpacity(0.15)
//                                   : Colors.grey.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           campaign.status.toUpperCase(),
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: isActive
//                                 ? Colors.green
//                                 : isDraft
//                                     ? Colors.orange
//                                     : Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Reports Section
//             if (_reports.isNotEmpty) ...[
//               const Text('Reports',
//                   style: TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: _reports.length,
//                 itemBuilder: (_, i) {
//                   final report = _reports[i];
//                   final fileName = report['file_url'].split('/').last;
//                   final fileUrl = report['file_url'] ?? '';
//                   final uploadedBy = report['influencer_name'] ?? 'Unknown';

//                   return ListTile(
//                     leading: const Icon(Icons.insert_drive_file),
//                     title: Text(fileName),
//                     subtitle: Text('Uploaded by: $uploadedBy'),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.remove_red_eye),
//                       onPressed: () => _viewReport(fileUrl),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//             ],

//             // Campaign Status Actions
//             if (isDraft)
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: _isLoading ? null : _activateCampaign,
//                   icon: _isLoading
//                       ? const SizedBox(
//                           width: 18,
//                           height: 18,
//                           child: CircularProgressIndicator(
//                               strokeWidth: 2, color: Colors.white),
//                         )
//                       : const Icon(Icons.campaign),
//                   label: const Text("Activate Campaign"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.primaryColor,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 24, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               )
//             else if (isActive)
//               const Center(
//                 child: Text(
//                   "✅ This campaign is active and visible to influencers.",
//                   style: TextStyle(
//                       color: Colors.green,
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//               )
//             else if (isCompleted)
//               const Center(
//                 child: Text(
//                   "🏁 This campaign has been completed.",
//                   style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//               ),

//             const SizedBox(height: 24),
//             const Divider(),

//             // Accepted Influencers
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
//                   child: Text(
//                 "No influencers have accepted this campaign yet.",
//                 style: TextStyle(color: Colors.grey),
//               ))
//             else
//               Column(
//                 children: _acceptedInfluencers.map((inf) {
//                   final partnerName = inf['name'] ?? 'Unknown';
//                   final email = inf['email'] ?? '';
//                   final partnerProfileUrl = inf['profile_image'] ?? '';

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     elevation: 2,
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         radius: 24,
//                         backgroundImage: partnerProfileUrl.isNotEmpty
//                             ? NetworkImage(partnerProfileUrl)
//                             : const AssetImage(
//                                     'assets/images/default_avatar.png')
//                                 as ImageProvider,
//                       ),
//                       title: Text(partnerName,
//                           style:
//                               const TextStyle(fontWeight: FontWeight.w600)),
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

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
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
//   List<Map<String, dynamic>> _reports = [];

//   late CampaignModel campaign;

//   @override
//   void initState() {
//     super.initState();
//     campaign = widget.campaign;
//     _fetchAcceptedInfluencers();
//     _fetchReports();
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
//     } catch (e) {
//       setState(() => _loadingInfluencers = false);
//       debugPrint('Failed to fetch accepted influencers: $e');
//     }
//   }

//   Future<void> _fetchReports() async {
//     try {
//       // Fetch all reports for this campaign
//       final reportsData = await _client
//           .from('campaign_reports')
//           .select()
//           .eq('campaign_id', campaign.id)
//           .order('uploaded_at', ascending: false);

//       final reportsList = List<Map<String, dynamic>>.from(reportsData ?? []);

//       // Fetch influencer names for each report
//       for (var i = 0; i < reportsList.length; i++) {
//         final influencerId = reportsList[i]['influencer_id'];
//         if (influencerId != null) {
//           final inf = await _client
//               .from('profiles') // Change if your influencer table is named differently
//               .select('name')
//               .eq('id', influencerId)
//               .maybeSingle();
//           reportsList[i]['influencer_name'] = inf?['name'] ?? 'Unknown';
//         } else {
//           reportsList[i]['influencer_name'] = 'Unknown';
//         }
//       }

//       setState(() {
//         _reports = reportsList;
//       });
//     } catch (e) {
//       debugPrint('Failed to fetch reports: $e');
//     }
//   }

//   Future<void> _viewReport(String fileUrl) async {
//     try {
//       final uri = Uri.parse(fileUrl);

//       // Open inside the app if image
//       if (fileUrl.endsWith('.jpg') ||
//           fileUrl.endsWith('.jpeg') ||
//           fileUrl.endsWith('.png') ||
//           fileUrl.endsWith('.gif')) {
//         if (!mounted) return;
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => Scaffold(
//               appBar: AppBar(title: const Text('Report')),
//               body: Center(child: Image.network(fileUrl)),
//             ),
//           ),
//         );
//       } else {
//         // Open in browser
//         if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Could not open report')),
//           );
//         }
//       }
//     } catch (e) {
//       debugPrint('Error opening report: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not open report')),
//       );
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
//         final partnerName = influencer['name'] ?? 'User';
//         final partnerProfileUrl = influencer['profile_image'] ?? '';

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (!mounted) return;
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => BrandChatScreen(
//                 chatId: chat.id,
//                 partnerName: partnerName,
//                 partnerProfileUrl: partnerProfileUrl,
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
//     final isActive = campaign.status.toLowerCase() == 'active';
//     final isCompleted = campaign.status.toLowerCase() == 'completed';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           campaign.title,
//           style: const TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 20,
//             letterSpacing: -0.3,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: AppTheme.primaryColor,
//         actions: [
//           if (!isCompleted)
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: () async {
//                 await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => CampaignEditScreen(campaign: campaign),
//                   ),
//                 );
//                 setState(() {});
//               },
//             ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Campaign Info Card
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 15,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     campaign.description,
//                     style: const TextStyle(fontSize: 16, height: 1.5),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       const Icon(Icons.attach_money,
//                           size: 20, color: AppTheme.primaryColor),
//                       const SizedBox(width: 6),
//                       Expanded(
//                         child: Text(
//                           "Budget: \$${campaign.budget}",
//                           style: const TextStyle(
//                               fontSize: 15, fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: isActive
//                               ? Colors.green.withOpacity(0.15)
//                               : isDraft
//                                   ? Colors.orange.withOpacity(0.15)
//                                   : Colors.grey.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           campaign.status.toUpperCase(),
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: isActive
//                                 ? Colors.green
//                                 : isDraft
//                                     ? Colors.orange
//                                     : Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Reports Section
//             if (_reports.isNotEmpty) ...[
//               const Text('Reports',
//                   style: TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: _reports.length,
//                 itemBuilder: (_, i) {
//                   final report = _reports[i];
//                   final fileName = report['file_url'].split('/').last;
//                   final fileUrl = report['file_url'] ?? '';
//                   final uploadedBy = report['influencer_name'] ?? 'Unknown';

//                   return ListTile(
//                     leading: const Icon(Icons.insert_drive_file),
//                     title: Text(fileName),
//                     subtitle: Text('Uploaded by: $uploadedBy'),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.remove_red_eye),
//                       onPressed: () => _viewReport(fileUrl),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//             ],

//             // Campaign Status Actions
//             if (isDraft)
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: _isLoading ? null : _activateCampaign,
//                   icon: _isLoading
//                       ? const SizedBox(
//                           width: 18,
//                           height: 18,
//                           child: CircularProgressIndicator(
//                               strokeWidth: 2, color: Colors.white),
//                         )
//                       : const Icon(Icons.campaign),
//                   label: const Text("Activate Campaign"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.primaryColor,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 24, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               )
//             else if (isActive)
//               const Center(
//                 child: Text(
//                   "✅ This campaign is active and visible to influencers.",
//                   style: TextStyle(
//                       color: Colors.green,
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//               )
//             else if (isCompleted)
//               const Center(
//                 child: Text(
//                   "🏁 This campaign has been completed.",
//                   style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//               ),

//             const SizedBox(height: 24),
//             const Divider(),

//             // Accepted Influencers
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
//                   child: Text(
//                 "No influencers have accepted this campaign yet.",
//                 style: TextStyle(color: Colors.grey),
//               ))
//             else
//               Column(
//                 children: _acceptedInfluencers.map((inf) {
//                   final partnerName = inf['name'] ?? 'Unknown';
//                   final email = inf['email'] ?? '';
//                   final partnerProfileUrl = inf['profile_image'] ?? '';

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     elevation: 2,
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         radius: 24,
//                         backgroundImage: partnerProfileUrl.isNotEmpty
//                             ? NetworkImage(partnerProfileUrl)
//                             : const AssetImage(
//                                     'assets/images/default_avatar.png')
//                                 as ImageProvider,
//                       ),
//                       title: Text(partnerName,
//                           style:
//                               const TextStyle(fontWeight: FontWeight.w600)),
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
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
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
//   List<Map<String, dynamic>> _reports = [];

//   late CampaignModel campaign;

//   @override
//   void initState() {
//     super.initState();
//     campaign = widget.campaign;
//     _fetchAcceptedInfluencers();
//     _fetchReports();
//   }

//   /// ✅ Fetch accepted and completed influencers for this campaign
//   Future<void> _fetchAcceptedInfluencers() async {
//     setState(() => _loadingInfluencers = true);
//     try {
//       final data = await _client
//           .from('campaign_influencers')
//           .select('*, profiles(name, email, profile_image)')
//           .eq('campaign_id', campaign.id)
//          .inFilter('status', ['accepted', 'completed']);


//       final influencers = List<Map<String, dynamic>>.from(data);
//       setState(() {
//         _acceptedInfluencers = influencers;
//         _loadingInfluencers = false;
//       });
//       debugPrint('✅ ${_acceptedInfluencers.length} influencers fetched');
//     } catch (e) {
//       debugPrint('❌ Failed to fetch accepted influencers: $e');
//       setState(() => _loadingInfluencers = false);
//     }
//   }

//   /// ✅ Fetch uploaded reports for this campaign
//   Future<void> _fetchReports() async {
//     try {
//       final reportsData = await _client
//           .from('campaign_reports')
//           .select()
//           .eq('campaign_id', campaign.id)
//           .order('uploaded_at', ascending: false);

//       final reportsList = List<Map<String, dynamic>>.from(reportsData ?? []);

//       for (var report in reportsList) {
//         final influencerId = report['influencer_id'];
//         if (influencerId != null) {
//           final inf = await _client
//               .from('profiles')
//               .select('name')
//               .eq('id', influencerId)
//               .maybeSingle();
//           report['influencer_name'] = inf?['name'] ?? 'Unknown';
//         } else {
//           report['influencer_name'] = 'Unknown';
//         }
//       }

//       setState(() => _reports = reportsList);
//     } catch (e) {
//       debugPrint('❌ Failed to fetch reports: $e');
//     }
//   }

//   Future<void> _viewReport(String fileUrl) async {
//     try {
//       final uri = Uri.parse(fileUrl);
//       if (fileUrl.endsWith('.jpg') ||
//           fileUrl.endsWith('.jpeg') ||
//           fileUrl.endsWith('.png') ||
//           fileUrl.endsWith('.gif')) {
//         if (!mounted) return;
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => Scaffold(
//               appBar: AppBar(title: const Text('Report')),
//               body: Center(child: Image.network(fileUrl)),
//             ),
//           ),
//         );
//       } else {
//         if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Could not open report')),
//           );
//         }
//       }
//     } catch (e) {
//       debugPrint('Error opening report: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not open report')),
//       );
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

//   Future<void> _openChatWithInfluencer(Map<String, dynamic> influencer) async {
//     final brandId = _client.auth.currentUser?.id;
//     if (brandId == null) return;

//     final influencerId = influencer['influencer_id'] ?? influencer['profiles']?['id'] ?? '';
//     if (influencerId.isEmpty) return;

//     try {
//       final chat = await _chatService.getOrCreateChatForCampaign(
//         campaignId: campaign.id,
//         brandId: brandId,
//         influencerId: influencerId,
//       );

//       if (chat != null && mounted) {
//         final partnerName = influencer['profiles']?['name'] ?? 'User';
//         final partnerProfileUrl = influencer['profiles']?['profile_image'] ?? '';

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (!mounted) return;
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => BrandChatScreen(
//                 chatId: chat.id,
//                 partnerName: partnerName,
//                 partnerProfileUrl: partnerProfileUrl,
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
//     final status = campaign.status.toLowerCase();
//     final isDraft = status == 'draft';
//     final isActive = status == 'active';
//     final isCompleted = status == 'completed';
//     final isInProgress = status == 'in_progress';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           campaign.title,
//           style: const TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 20,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: AppTheme.primaryColor,
//         actions: [
//           if (!isCompleted && !isInProgress)
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: () async {
//                 await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => CampaignEditScreen(campaign: campaign),
//                   ),
//                 );
//                 setState(() {});
//               },
//             ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildCampaignInfo(isDraft, isActive),
//             const SizedBox(height: 20),
//             _buildReportsSection(),
//             const SizedBox(height: 24),
//             _buildStatusSection(isDraft, isActive, isCompleted),
//             const SizedBox(height: 24),
//             const Divider(),
//             _buildInfluencersSection(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCampaignInfo(bool isDraft, bool isActive) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(campaign.description, style: const TextStyle(fontSize: 16, height: 1.5)),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               const Icon(Icons.attach_money, size: 20, color: AppTheme.primaryColor),
//               const SizedBox(width: 6),
//               Expanded(
//                 child: Text(
//                   "Budget: \$${campaign.budget}",
//                   style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: isActive
//                       ? Colors.green.withOpacity(0.15)
//                       : isDraft
//                           ? Colors.orange.withOpacity(0.15)
//                           : Colors.grey.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   campaign.status.toUpperCase(),
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: isActive
//                         ? Colors.green
//                         : isDraft
//                             ? Colors.orange
//                             : Colors.grey,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildReportsSection() {
//     if (_reports.isEmpty) return const SizedBox();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Reports', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: _reports.length,
//           itemBuilder: (_, i) {
//             final report = _reports[i];
//             final fileName = report['file_url'].split('/').last;
//             final fileUrl = report['file_url'] ?? '';
//             final uploadedBy = report['influencer_name'] ?? 'Unknown';
//             return ListTile(
//               leading: const Icon(Icons.insert_drive_file),
//               title: Text(fileName),
//               subtitle: Text('Uploaded by: $uploadedBy'),
//               trailing: IconButton(
//                 icon: const Icon(Icons.remove_red_eye),
//                 onPressed: () => _viewReport(fileUrl),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildStatusSection(bool isDraft, bool isActive, bool isCompleted) {
//     if (isDraft) {
//       return Center(
//         child: ElevatedButton.icon(
//           onPressed: _isLoading ? null : _activateCampaign,
//           icon: _isLoading
//               ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//               : const Icon(Icons.campaign),
//           label: const Text("Activate Campaign"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppTheme.primaryColor,
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//         ),
//       );
//     } else if (isActive) {
//       return const Center(
//         child: Text("✅ This campaign is active and visible to influencers.",
//             style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center),
//       );
//     } else if (isCompleted) {
//       return const Center(
//         child: Text("🏁 This campaign has been completed.",
//             style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center),
//       );
//     }
//     return const SizedBox();
//   }

//   Widget _buildInfluencersSection() {
//     if (_loadingInfluencers) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (_acceptedInfluencers.isEmpty) {
//       return const Center(
//           child: Text("No influencers have accepted this campaign yet.",
//               style: TextStyle(color: Colors.grey)));
//     } else {
//       return Column(
//         children: _acceptedInfluencers.map((inf) {
//           final profile = inf['profiles'] ?? {};
//           final partnerName = profile['name'] ?? 'Unknown';
//           final email = profile['email'] ?? '';
//           final partnerProfileUrl = profile['profile_image'] ?? '';

//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             elevation: 2,
//             child: ListTile(
//               leading: CircleAvatar(
//                 radius: 24,
//                 backgroundImage: partnerProfileUrl.isNotEmpty
//                     ? NetworkImage(partnerProfileUrl)
//                     : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
//               ),
//               title: Text(partnerName, style: const TextStyle(fontWeight: FontWeight.w600)),
//               subtitle: Text(email),
//               trailing: ElevatedButton.icon(
//                 icon: const Icon(Icons.chat_bubble_outline, size: 18),
//                 label: const Text("Chat"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppTheme.primaryColor,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 onPressed: () => _openChatWithInfluencer(inf),
//               ),
//             ),
//           );
//         }).toList(),
//       );
//     }
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
//         // ✅ Correct partner info mapping
//         final partnerName = influencer['name'] ?? 'User';
//         final partnerProfileUrl = influencer['profile_image'] ?? '';

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (!mounted) return;
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => BrandChatScreen(
//                 chatId: chat.id,
//                 partnerName: partnerName,
//                 partnerProfileUrl: partnerProfileUrl,
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
//   title: Text(campaign.title),
//   backgroundColor: AppTheme.primaryColor,
//   actions: [
//     // Show edit button only if campaign is not completed
//     if (campaign.status.toLowerCase() != 'completed')
//       IconButton(
//         icon: const Icon(Icons.edit),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => CampaignEditScreen(campaign: campaign),
//             ),
//           );
//           setState(() {}); // Refresh screen after editing
//         },
//       ),
//   ],
// ),

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
//                   final partnerName = inf['name'] ?? 'Unknown';
//                   final email = inf['email'] ?? '';
//                   final partnerProfileUrl = inf['profile_image'] ?? '';

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: partnerProfileUrl.isNotEmpty
//                             ? NetworkImage(partnerProfileUrl)
//                             : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
//                       ),
//                       title: Text(partnerName),
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
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
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
//   List<Map<String, dynamic>> _reports = [];
//   late CampaignModel campaign;

//   @override
//   void initState() {
//     super.initState();
//     campaign = widget.campaign;
//     _fetchAcceptedInfluencers();
//     _loadReports();
//   }

//   /// Fetch all influencer reports for this campaign
//   Future<void> _loadReports() async {
//     try {
//       final data = await _client
//           .from('campaign_reports')
//           .select('file_url, uploaded_at, influencer_id')
//           .eq('campaign_id', campaign.id)
//           .order('uploaded_at', ascending: false);

//       setState(() {
//         _reports = List<Map<String, dynamic>>.from(data ?? []);
//       });
//       debugPrint("✅ ${_reports.length} reports loaded for campaign ${campaign.id}");
//     } catch (e) {
//       debugPrint("❌ Failed to load reports: $e");
//     }
//   }

//   /// Open report in browser
//   Future<void> _viewReport(String fileUrl) async {
//     try {
//       final uri = Uri.parse(fileUrl);
//       if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Could not open report')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not open report')),
//       );
//     }
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

//   /// Open chat safely
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
//         final partnerName = influencer['name'] ?? 'User';
//         final partnerProfileUrl = influencer['profile_image'] ?? '';

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (!mounted) return;
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => BrandChatScreen(
//                 chatId: chat.id,
//                 partnerName: partnerName,
//                 partnerProfileUrl: partnerProfileUrl,
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
//     final isInProgress = campaign.status.toLowerCase() == 'in_progress';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(campaign.title),
//         backgroundColor: AppTheme.primaryColor,
//         actions: [
//           // Hide edit button if status is completed or in_progress
//           if (campaign.status.toLowerCase() != 'completed' &&
//               campaign.status.toLowerCase() != 'in_progress')
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: () async {
//                 await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => CampaignEditScreen(campaign: campaign),
//                   ),
//                 );
//                 setState(() {}); // Refresh screen after editing
//               },
//             ),
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
//                   final partnerName = inf['name'] ?? 'Unknown';
//                   final email = inf['email'] ?? '';
//                   final partnerProfileUrl = inf['profile_image'] ?? '';

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: partnerProfileUrl.isNotEmpty
//                             ? NetworkImage(partnerProfileUrl)
//                             : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
//                       ),
//                       title: Text(partnerName),
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

//             const SizedBox(height: 30),
//             const Divider(),

//             Text(
//               "Uploaded Reports",
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),

//             if (_reports.isEmpty)
//               const Text("No reports uploaded yet.")
//             else
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: _reports.length,
//                 itemBuilder: (_, i) {
//                   final report = _reports[i];
//                   final fileUrl = report['file_url'] ?? '';
//                   final fileName = fileUrl.split('/').last;
//                   final uploadedAt = report['uploaded_at'] ?? '';

//                   return Card(
//                     child: ListTile(
//                       leading: const Icon(Icons.insert_drive_file),
//                       title: Text(fileName),
//                       subtitle: Text("Uploaded: $uploadedAt"),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.remove_red_eye),
//                         onPressed: () => _viewReport(fileUrl),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool _uploading = false;

  List<Map<String, dynamic>> _acceptedInfluencers = [];
  List<Map<String, dynamic>> _reports = [];
  late CampaignModel campaign;

  @override
  void initState() {
    super.initState();
    campaign = widget.campaign;
    _fetchAcceptedInfluencers();
    _loadReports();
  }

  /// Load all reports (influencer + brand)
  Future<void> _loadReports() async {
    try {
      final data = await _client
          .from('campaign_reports')
          .select()
          .eq('campaign_id', campaign.id)
          .order('uploaded_at', ascending: false);

      setState(() {
        _reports = List<Map<String, dynamic>>.from(data ?? []);
      });

      debugPrint("✅ ${_reports.length} reports loaded for campaign ${campaign.id}");
    } catch (e) {
      debugPrint("❌ Failed to load reports: $e");
    }
  }

  /// Upload a report (by brand)
  Future<void> _pickAndUploadReport() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() => _uploading = true);

      final file = File(result.files.single.path!);
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}';

      try {
        // Upload to Supabase storage bucket
        await _client.storage.from('campaign-reports').upload(fileName, file);

        // Get public URL
        final publicUrl =
            _client.storage.from('campaign-reports').getPublicUrl(fileName);

        // Insert record into campaign_reports table
        await _client.from('campaign_reports').insert({
          'campaign_id': campaign.id,
          'influencer_id': _client.auth.currentUser?.id ?? '', // brand uploads can store their own ID
          'file_url': publicUrl,
          'uploaded_at': DateTime.now().toIso8601String(),
          'uploaded_by_brand': true, // new field to differentiate uploader
        });

        // Update local state
        setState(() {
          _reports.insert(0, {
            'file_url': publicUrl,
            'uploaded_at': DateTime.now().toIso8601String(),
            'uploaded_by_brand': true,
          });
          _uploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report uploaded successfully')),
        );
      } catch (e) {
        setState(() => _uploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report upload failed: $e')),
        );
      }
    }
  }

  /// Open report in browser
  Future<void> _viewReport(String fileUrl) async {
    try {
      final uri = Uri.parse(fileUrl);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open report')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open report')),
      );
    }
  }

  /// Fetch influencers accepted campaign
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
    final isInProgress = campaign.status.toLowerCase() == 'in_progress';

    return Scaffold(
      appBar: AppBar(
        title: Text(campaign.title),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          // Hide edit button if status is completed or in_progress
          if (!['completed', 'in_progress'].contains(campaign.status.toLowerCase()))
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CampaignEditScreen(campaign: campaign),
                  ),
                );
                setState(() {});
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

            const SizedBox(height: 30),
            const Divider(),

            // Brand report upload & list
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  " Reports",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                _uploading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: _pickAndUploadReport,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Upload'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 12),

            if (_reports.isEmpty)
              const Text("No reports uploaded yet.")
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _reports.length,
                itemBuilder: (_, i) {
                  final report = _reports[i];
                  final fileUrl = report['file_url'] ?? '';
                  final uploadedAt = report['uploaded_at'] ?? '';
                  final uploadedByBrand = report['uploaded_by_brand'] ?? false;
                  final uploader = uploadedByBrand ? "Brand" : "Influencer";
                  final fileName = fileUrl.split('/').last;

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.insert_drive_file),
                      title: Text(fileName),
                      subtitle: Text("Uploaded by: $uploader\nUploaded at: $uploadedAt"),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () => _viewReport(fileUrl),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
