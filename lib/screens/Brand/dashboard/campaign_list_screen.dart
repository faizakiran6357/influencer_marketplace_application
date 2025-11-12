
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_slidable/flutter_slidable.dart'; // <-- add this import
// import '../../../providers/brand_provider.dart';
// import '../../../models/campaign_model.dart';
// import 'campaign_create_screen.dart';
// import 'campaign_detail_screen.dart';

// class CampaignListScreen extends StatefulWidget {
//   const CampaignListScreen({super.key});

//   @override
//   State<CampaignListScreen> createState() => _CampaignListScreenState();
// }

// class _CampaignListScreenState extends State<CampaignListScreen> {
//   bool _initialized = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_initialized) {
//       final provider = context.read<BrandProvider>();
//       final brandId = provider.brand?.id;
//       if (brandId != null) {
//         provider.fetchCampaigns(brandId);
//       }
//       _initialized = true;
//     }
//   }

//   Future<void> _confirmAndDeleteCampaign(String campaignId) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Delete Campaign'),
//         content: const Text(
//           'Are you sure you want to delete this campaign? This action cannot be undone.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       try {
//         await context.read<BrandProvider>().deleteCampaign(campaignId);
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Campaign deleted')),
//         );
//       } catch (e) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error deleting campaign: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<BrandProvider>();
//     final campaigns = provider.campaigns;
//     final loading = provider.loading;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Campaigns")),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : campaigns.isEmpty
//               ? const Center(child: Text("No campaigns yet"))
//               : RefreshIndicator(
//                   onRefresh: () async {
//                     final brandId = provider.brand?.id;
//                     if (brandId != null) {
//                       await provider.fetchCampaigns(brandId);
//                     }
//                   },
//                   child: ListView.builder(
//                     itemCount: campaigns.length,
//                     itemBuilder: (_, index) {
//                       final CampaignModel c = campaigns[index];
//                       return Padding(
//                         padding:
//                             const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         child: Slidable(
//                           key: ValueKey(c.id),
//                           endActionPane: ActionPane(
//                             motion: const DrawerMotion(),
//                             children: [
//                               SlidableAction(
//                                 onPressed: (_) => _confirmAndDeleteCampaign(c.id),
//                                 backgroundColor: Colors.red,
//                                 foregroundColor: Colors.white,
//                                 icon: Icons.delete,
//                                 label: 'Delete',
//                               ),
//                             ],
//                           ),
//                           child: Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             elevation: 2,
//                             child: ListTile(
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 8,
//                               ),
//                               title: Text(
//                                 c.title,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               subtitle: Text(
//                                 c.description,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               trailing: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "\$${c.spent}/${c.budget}",
//                                     style: const TextStyle(fontSize: 14),
//                                   ),
//                                   Text(
//                                     c.status,
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: c.status == 'active'
//                                           ? Colors.green
//                                           : Colors.grey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               onTap: () => Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) =>
//                                       CampaignDetailScreen(campaign: c),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const CampaignCreateScreen()),
//           );
//           // refresh when user returns
//           final brandId = provider.brand?.id;
//           if (brandId != null) {
//             await provider.fetchCampaigns(brandId);
//           }
//         },
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/brand_provider.dart';
// import '../../../models/campaign_model.dart';
// import 'campaign_create_screen.dart';
// import 'campaign_detail_screen.dart';

// class CampaignListScreen extends StatefulWidget {
//   const CampaignListScreen({super.key});

//   @override
//   State<CampaignListScreen> createState() => _CampaignListScreenState();
// }

// class _CampaignListScreenState extends State<CampaignListScreen> {
//   @override
//   void initState() {
//     super.initState();
//     final provider = context.read<BrandProvider>();
//     final brandId = provider.brand?.id;
//     if (brandId != null) provider.fetchCampaigns(brandId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<BrandProvider>();
//     final campaigns = provider.campaigns;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Campaigns")),
//       body: campaigns.isEmpty
//           ? const Center(child: Text("No campaigns yet"))
//           : ListView.builder(
//               itemCount: campaigns.length,
//               itemBuilder: (_, index) {
//                 final c = campaigns[index];
//                 return ListTile(
//                   title: Text(c.title),
//                   subtitle: Text(c.description),
//                   trailing: Text("\$${c.spent}/${c.budget}"),
//                   onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => CampaignDetailScreen(campaign: c),
//                     ),
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const CampaignCreateScreen()),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/brand_provider.dart';
// import '../../../models/campaign_model.dart';
// import 'campaign_create_screen.dart';
// import 'campaign_detail_screen.dart';

// class CampaignListScreen extends StatefulWidget {
//   const CampaignListScreen({super.key});

//   @override
//   State<CampaignListScreen> createState() => _CampaignListScreenState();
// }

// class _CampaignListScreenState extends State<CampaignListScreen> {
//   bool _initialized = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_initialized) {
//       final provider = context.read<BrandProvider>();
//       final brandId = provider.brand?.id;
//       if (brandId != null) {
//         provider.fetchCampaigns(brandId);
//       }
//       _initialized = true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<BrandProvider>();
//     final campaigns = provider.campaigns;
//     final loading = provider.loading;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Campaigns")),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : campaigns.isEmpty
//               ? const Center(child: Text("No campaigns yet"))
//               : RefreshIndicator(
//                   onRefresh: () async {
//                     final brandId = provider.brand?.id;
//                     if (brandId != null) {
//                       await provider.fetchCampaigns(brandId);
//                     }
//                   },
//                   child: ListView.builder(
//                     itemCount: campaigns.length,
//                     itemBuilder: (_, index) {
//                       final c = campaigns[index];
//                       return Card(
//                         margin:
//                             const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         child: ListTile(
//                           title: Text(c.title,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 16)),
//                           subtitle: Text(
//                             c.description,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           trailing: Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text("\$${c.spent}/${c.budget}",
//                                   style: const TextStyle(fontSize: 14)),
//                               Text(c.status,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: c.status == 'active'
//                                         ? Colors.green
//                                         : Colors.grey,
//                                   )),
//                             ],
//                           ),
//                           onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => CampaignDetailScreen(campaign: c),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (_) => const CampaignCreateScreen()),
//           );
//           // refresh when user returns
//           final brandId = provider.brand?.id;
//           if (brandId != null) {
//             await provider.fetchCampaigns(brandId);
//           }
//         },
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import '../../../providers/brand_provider.dart';
// import '../../../providers/theme_provider.dart';
// import '../../../utils/app_theme.dart';
// import '../../../models/campaign_model.dart';
// import 'campaign_create_screen.dart';
// import 'campaign_detail_screen.dart';

// class CampaignListScreen extends StatefulWidget {
//   const CampaignListScreen({super.key});

//   @override
//   State<CampaignListScreen> createState() => _CampaignListScreenState();
// }

// class _CampaignListScreenState extends State<CampaignListScreen> {
//   bool _initialized = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_initialized) {
//       final provider = context.read<BrandProvider>();
//       final brandId = provider.brand?.id;
//       if (brandId != null) {
//         provider.fetchCampaigns(brandId);
//       }
//       _initialized = true;
//     }
//   }

//   Future<void> _confirmAndDeleteCampaign(String campaignId) async {
//     final themeProvider = context.watch<ThemeProvider>();
//     final isDark = themeProvider.isDark;
    
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.red.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(
//                 LucideIcons.trash2,
//                 color: Colors.red,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Expanded(
//               child: Text(
//                 'Delete Campaign',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         content: Text(
//           'Are you sure you want to delete this campaign? This action cannot be undone.',
//           style: TextStyle(
//             fontSize: 14,
//             color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.red.shade600,
//                   Colors.red.shade700,
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               style: TextButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               ),
//               child: const Text(
//                 'Delete',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       try {
//         await context.read<BrandProvider>().deleteCampaign(campaignId);
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Campaign deleted')),
//         );
//       } catch (e) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error deleting campaign: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<BrandProvider>();
//     final themeProvider = context.watch<ThemeProvider>();
//     final campaigns = provider.campaigns;
//     final loading = provider.loading;
//     final isDark = themeProvider.isDark;
//     final primary = AppTheme.primaryColor;

//     return Scaffold(
//       backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: primary,
//         title: const Text(
//           "Campaigns",
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
//                         LucideIcons.megaphone,
//                         size: 80,
//                         color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         "No campaigns yet",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         "Create your first campaign to get started",
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : RefreshIndicator(
//                   onRefresh: () async {
//                     final brandId = provider.brand?.id;
//                     if (brandId != null) {
//                       await provider.fetchCampaigns(brandId);
//                     }
//                   },
//                   color: primary,
//                   child: ListView.builder(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.all(16),
//                     itemCount: campaigns.length,
//                     itemBuilder: (_, index) {
//                       final CampaignModel c = campaigns[index];
//                       final isActive = c.status == 'active';
//                       final spentPercentage = c.budget > 0 ? (c.spent / c.budget).clamp(0.0, 1.0) : 0.0;
                      
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 16),
//                         child: Slidable(
//                           key: ValueKey(c.id),
//                           endActionPane: ActionPane(
//                             motion: const DrawerMotion(),
//                             extentRatio: 0.25,
//                             children: [
//                               SlidableAction(
//                                 onPressed: (_) => _confirmAndDeleteCampaign(c.id),
//                                 backgroundColor: Colors.red.shade600,
//                                 foregroundColor: Colors.white,
//                                 icon: LucideIcons.trash2,
//                                 label: 'Delete',
//                                 borderRadius: BorderRadius.circular(18),
//                               ),
//                             ],
//                           ),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//                               borderRadius: BorderRadius.circular(20),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
//                                   blurRadius: 15,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: Material(
//                               color: Colors.transparent,
//                               child: InkWell(
//                                 onTap: () => Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => CampaignDetailScreen(campaign: c),
//                                   ),
//                                 ),
//                                 borderRadius: BorderRadius.circular(20),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(18),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Container(
//                                             padding: const EdgeInsets.all(12),
//                                             decoration: BoxDecoration(
//                                               gradient: LinearGradient(
//                                                 colors: [
//                                                   primary,
//                                                   primary.withOpacity(0.7),
//                                                 ],
//                                                 begin: Alignment.topLeft,
//                                                 end: Alignment.bottomRight,
//                                               ),
//                                               borderRadius: BorderRadius.circular(14),
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: primary.withOpacity(0.3),
//                                                   blurRadius: 8,
//                                                   offset: const Offset(0, 4),
//                                                 ),
//                                               ],
//                                             ),
//                                             child: const Icon(
//                                               LucideIcons.megaphone,
//                                               color: Colors.white,
//                                               size: 22,
//                                             ),
//                                           ),
//                                           const SizedBox(width: 16),
//                                           Expanded(
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   c.title,
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.w700,
//                                                     fontSize: 17,
//                                                     color: isDark ? Colors.white : Colors.black87,
//                                                     letterSpacing: -0.3,
//                                                   ),
//                                                   maxLines: 1,
//                                                   overflow: TextOverflow.ellipsis,
//                                                 ),
//                                                 const SizedBox(height: 6),
//                                                 Text(
//                                                   c.description,
//                                                   style: TextStyle(
//                                                     fontSize: 13,
//                                                     color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
//                                                     height: 1.4,
//                                                   ),
//                                                   maxLines: 2,
//                                                   overflow: TextOverflow.ellipsis,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 20),
//                                       // Budget and Status Row
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: Container(
//                                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                                               decoration: BoxDecoration(
//                                                 color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
//                                                 borderRadius: BorderRadius.circular(12),
//                                               ),
//                                               child: Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   Icon(
//                                                     LucideIcons.dollarSign,
//                                                     size: 16,
//                                                     color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
//                                                   ),
//                                                   const SizedBox(width: 6),
//                                                   Flexible(
//                                                     child: Text(
//                                                       "\$${c.spent.toStringAsFixed(0)} / \$${c.budget.toStringAsFixed(0)}",
//                                                       style: TextStyle(
//                                                         fontSize: 13,
//                                                         fontWeight: FontWeight.w700,
//                                                         color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
//                                                       ),
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 10),
//                                           Container(
//                                             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                                             decoration: BoxDecoration(
//                                               color: isActive
//                                                   ? const Color(0xFF10B981).withOpacity(0.15)
//                                                   : Colors.grey.withOpacity(0.15),
//                                               borderRadius: BorderRadius.circular(20),
//                                             ),
//                                             child: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 Container(
//                                                   width: 8,
//                                                   height: 8,
//                                                   decoration: BoxDecoration(
//                                                     color: isActive
//                                                         ? const Color(0xFF10B981)
//                                                         : Colors.grey.shade500,
//                                                     shape: BoxShape.circle,
//                                                   ),
//                                                 ),
//                                                 const SizedBox(width: 6),
//                                                 Text(
//                                                   c.status.toUpperCase(),
//                                                   style: TextStyle(
//                                                     fontSize: 11,
//                                                     fontWeight: FontWeight.w700,
//                                                     color: isActive
//                                                         ? const Color(0xFF10B981)
//                                                         : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
//                                                     letterSpacing: 0.5,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       if (c.budget > 0) ...[
//                                         const SizedBox(height: 14),
//                                         // Progress Bar
//                                         Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 Text(
//                                                   "Budget Usage",
//                                                   style: TextStyle(
//                                                     fontSize: 11,
//                                                     color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
//                                                     fontWeight: FontWeight.w600,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   "${(spentPercentage * 100).toStringAsFixed(0)}%",
//                                                   style: TextStyle(
//                                                     fontSize: 11,
//                                                     color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
//                                                     fontWeight: FontWeight.w700,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             const SizedBox(height: 6),
//                                             ClipRRect(
//                                               borderRadius: BorderRadius.circular(4),
//                                               child: LinearProgressIndicator(
//                                                 value: spentPercentage,
//                                                 minHeight: 6,
//                                                 backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
//                                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                                   spentPercentage > 0.8
//                                                       ? Colors.orange
//                                                       : spentPercentage > 0.5
//                                                           ? Colors.amber
//                                                           : const Color(0xFF10B981),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//       floatingActionButton: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               primary,
//               primary.withOpacity(0.8),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: primary.withOpacity(0.4),
//               blurRadius: 15,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: FloatingActionButton.extended(
//           onPressed: () async {
//             await Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const CampaignCreateScreen()),
//             );
//             // refresh when user returns
//             final brandId = provider.brand?.id;
//             if (brandId != null) {
//               await provider.fetchCampaigns(brandId);
//             }
//           },
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           icon: const Icon(LucideIcons.plus, color: Colors.white, size: 22),
//           label: const Text(
//             "New Campaign",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//               fontSize: 15,
//               letterSpacing: 0.3,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import '../../../providers/brand_provider.dart';
// import '../../../providers/theme_provider.dart';
// import '../../../utils/app_theme.dart';
// import '../../../models/campaign_model.dart';
// import 'campaign_create_screen.dart';
// import 'campaign_detail_screen.dart';

// class CampaignListScreen extends StatefulWidget {
//   const CampaignListScreen({super.key});

//   @override
//   State<CampaignListScreen> createState() => _CampaignListScreenState();
// }

// class _CampaignListScreenState extends State<CampaignListScreen> {
//   bool _initialized = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_initialized) {
//       final provider = context.read<BrandProvider>();
//       final brandId = provider.brand?.id;
//       if (brandId != null) {
//         provider.fetchCampaigns(brandId);
//       }
//       _initialized = true;
//     }
//   }

//   Future<void> _confirmAndDeleteCampaign(String campaignId) async {
//     final themeProvider = context.watch<ThemeProvider>();
//     final isDark = themeProvider.isDark;

//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.red.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(
//                 LucideIcons.trash2,
//                 color: Colors.red,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Expanded(
//               child: Text(
//                 'Delete Campaign',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         content: Text(
//           'Are you sure you want to delete this campaign? This action cannot be undone.',
//           style: TextStyle(
//             fontSize: 14,
//             color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.red.shade600,
//                   Colors.red.shade700,
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               style: TextButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               ),
//               child: const Text(
//                 'Delete',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       try {
//         await context.read<BrandProvider>().deleteCampaign(campaignId);
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Campaign deleted')),
//         );
//       } catch (e) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error deleting campaign: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<BrandProvider>();
//     final themeProvider = context.watch<ThemeProvider>();
//     final campaigns = provider.campaigns;
//     final loading = provider.loading;
//     final isDark = themeProvider.isDark;
//     final primary = AppTheme.primaryColor;

//     return Scaffold(
//       backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: primary,
//         title: const Text(
//           "Campaigns",
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
//                         LucideIcons.megaphone,
//                         size: 80,
//                         color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         "No campaigns yet",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         "Create your first campaign to get started",
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : RefreshIndicator(
//                   onRefresh: () async {
//                     final brandId = provider.brand?.id;
//                     if (brandId != null) {
//                       await provider.fetchCampaigns(brandId);
//                     }
//                   },
//                   color: primary,
//                   child: ListView.builder(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.all(16),
//                     itemCount: campaigns.length,
//                     itemBuilder: (_, index) {
//                       final CampaignModel c = campaigns[index];
//                       final isActive = c.status == 'active';

//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 16),
//                         child: Slidable(
//                           key: ValueKey(c.id),
//                           endActionPane: ActionPane(
//                             motion: const DrawerMotion(),
//                             extentRatio: 0.25,
//                             children: [
//                               SlidableAction(
//                                 onPressed: (_) => _confirmAndDeleteCampaign(c.id),
//                                 backgroundColor: Colors.red.shade600,
//                                 foregroundColor: Colors.white,
//                                 icon: LucideIcons.trash2,
//                                 label: 'Delete',
//                                 borderRadius: BorderRadius.circular(18),
//                               ),
//                             ],
//                           ),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//                               borderRadius: BorderRadius.circular(20),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
//                                   blurRadius: 15,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: Material(
//                               color: Colors.transparent,
//                               child: InkWell(
//                                 onTap: () => Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => CampaignDetailScreen(campaign: c),
//                                   ),
//                                 ),
//                                 borderRadius: BorderRadius.circular(20),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(18),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Container(
//                                             padding: const EdgeInsets.all(12),
//                                             decoration: BoxDecoration(
//                                               gradient: LinearGradient(
//                                                 colors: [
//                                                   primary,
//                                                   primary.withOpacity(0.7),
//                                                 ],
//                                                 begin: Alignment.topLeft,
//                                                 end: Alignment.bottomRight,
//                                               ),
//                                               borderRadius: BorderRadius.circular(14),
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: primary.withOpacity(0.3),
//                                                   blurRadius: 8,
//                                                   offset: const Offset(0, 4),
//                                                 ),
//                                               ],
//                                             ),
//                                             child: const Icon(
//                                               LucideIcons.megaphone,
//                                               color: Colors.white,
//                                               size: 22,
//                                             ),
//                                           ),
//                                           const SizedBox(width: 16),
//                                           Expanded(
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   c.title,
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.w700,
//                                                     fontSize: 17,
//                                                     color: isDark ? Colors.white : Colors.black87,
//                                                     letterSpacing: -0.3,
//                                                   ),
//                                                   maxLines: 1,
//                                                   overflow: TextOverflow.ellipsis,
//                                                 ),
//                                                 const SizedBox(height: 6),
//                                                 Text(
//                                                   c.description,
//                                                   style: TextStyle(
//                                                     fontSize: 13,
//                                                     color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
//                                                     height: 1.4,
//                                                   ),
//                                                   maxLines: 2,
//                                                   overflow: TextOverflow.ellipsis,
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 20),
//                                       // Budget and Status Row
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: Container(
//                                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                                               decoration: BoxDecoration(
//                                                 color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
//                                                 borderRadius: BorderRadius.circular(12),
//                                               ),
//                                               child: Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   Icon(
//                                                     LucideIcons.dollarSign,
//                                                     size: 16,
//                                                     color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
//                                                   ),
//                                                   const SizedBox(width: 6),
//                                                   Flexible(
//                                                     child: Text(
//                                                       "\$${c.spent.toStringAsFixed(0)} / \$${c.budget.toStringAsFixed(0)}",
//                                                       style: TextStyle(
//                                                         fontSize: 13,
//                                                         fontWeight: FontWeight.w700,
//                                                         color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
//                                                       ),
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 10),
//                                           Container(
//                                             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                                             decoration: BoxDecoration(
//                                               color: isActive
//                                                   ? const Color(0xFF10B981).withOpacity(0.15)
//                                                   : Colors.grey.withOpacity(0.15),
//                                               borderRadius: BorderRadius.circular(20),
//                                             ),
//                                             child: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 Container(
//                                                   width: 8,
//                                                   height: 8,
//                                                   decoration: BoxDecoration(
//                                                     color: isActive ? const Color(0xFF10B981) : Colors.grey.shade500,
//                                                     shape: BoxShape.circle,
//                                                   ),
//                                                 ),
//                                                 const SizedBox(width: 6),
//                                                 Text(
//                                                   c.status.toUpperCase(),
//                                                   style: TextStyle(
//                                                     fontSize: 11,
//                                                     fontWeight: FontWeight.w700,
//                                                     color: isActive
//                                                         ? const Color(0xFF10B981)
//                                                         : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
//                                                     letterSpacing: 0.5,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//       floatingActionButton: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               primary,
//               primary.withOpacity(0.8),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: primary.withOpacity(0.4),
//               blurRadius: 15,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: FloatingActionButton.extended(
//           onPressed: () async {
//             await Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const CampaignCreateScreen()),
//             );
//             // refresh when user returns
//             final brandId = provider.brand?.id;
//             if (brandId != null) {
//               await provider.fetchCampaigns(brandId);
//             }
//           },
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           icon: const Icon(LucideIcons.plus, color: Colors.white, size: 22),
//           label: const Text(
//             "New Campaign",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//               fontSize: 15,
//               letterSpacing: 0.3,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../providers/brand_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../utils/app_theme.dart';
import '../../../models/campaign_model.dart';
import 'campaign_create_screen.dart';
import 'campaign_detail_screen.dart';

class CampaignListScreen extends StatefulWidget {
  const CampaignListScreen({super.key});

  @override
  State<CampaignListScreen> createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends State<CampaignListScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final provider = context.read<BrandProvider>();
      final brandId = provider.brand?.id;
      if (brandId != null) {
        provider.fetchCampaigns(brandId);
      }
      _initialized = true;
    }
  }

  Future<void> _confirmAndDeleteCampaign(BuildContext ctx, String campaignId) async {
    final themeProvider = Provider.of<ThemeProvider>(ctx, listen: false);
    final isDark = themeProvider.isDark;

    final confirm = await showDialog<bool>(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(LucideIcons.trash2, color: Colors.red, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Delete Campaign',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this campaign? This action cannot be undone.',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade600, Colors.red.shade700],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await ctx.read<BrandProvider>().deleteCampaign(campaignId);
        if (!mounted) return;
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('Campaign deleted')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('Error deleting campaign: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BrandProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final campaigns = provider.campaigns;
    final loading = provider.loading;
    final isDark = themeProvider.isDark;
    final primary = AppTheme.primaryColor;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        title: const Text(
          "Campaigns",
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
          ? Center(child: CircularProgressIndicator(color: primary))
          : campaigns.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.megaphone,
                        size: 80,
                        color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "No campaigns yet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Create your first campaign to get started",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    final brandId = provider.brand?.id;
                    if (brandId != null) {
                      await provider.fetchCampaigns(brandId);
                    }
                  },
                  color: primary,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: campaigns.length,
                    itemBuilder: (_, index) {
                      final CampaignModel c = campaigns[index];
                      final isActive = c.status == 'active';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Slidable(
                          key: ValueKey(c.id),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.25,
                            children: [
                              SlidableAction(
                                onPressed: (_) => _confirmAndDeleteCampaign(context, c.id),
                                backgroundColor: Colors.red.shade600,
                                foregroundColor: Colors.white,
                                icon: LucideIcons.trash2,
                                label: 'Delete',
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CampaignDetailScreen(campaign: c),
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
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
                                                colors: [primary, primary.withOpacity(0.7)],
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
                                                  c.title,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 17,
                                                    color: isDark ? Colors.white : Colors.black87,
                                                    letterSpacing: -0.3,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  c.description,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: isDark
                                                        ? Colors.grey.shade400
                                                        : Colors.grey.shade600,
                                                    height: 1.4,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // ✅ Show only Budget cleanly
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? Colors.grey.shade800
                                                  : Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  LucideIcons.dollarSign,
                                                  size: 16,
                                                  color: isDark
                                                      ? Colors.grey.shade300
                                                      : Colors.grey.shade700,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  "\$${c.budget.toStringAsFixed(0)}",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: isDark
                                                        ? Colors.grey.shade300
                                                        : Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: isActive
                                                  ? const Color(0xFF10B981).withOpacity(0.15)
                                                  : Colors.grey.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color: isActive
                                                        ? const Color(0xFF10B981)
                                                        : Colors.grey.shade500,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  c.status.toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                    color: isActive
                                                        ? const Color(0xFF10B981)
                                                        : (isDark
                                                            ? Colors.grey.shade400
                                                            : Colors.grey.shade600),
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, primary.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CampaignCreateScreen()),
            );
            final brandId = provider.brand?.id;
            if (brandId != null) {
              await provider.fetchCampaigns(brandId);
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(LucideIcons.plus, color: Colors.white, size: 22),
          label: const Text(
            "New Campaign",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
