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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // <-- add this import
import '../../../providers/brand_provider.dart';
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

  Future<void> _confirmAndDeleteCampaign(String campaignId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Campaign'),
        content: const Text(
          'Are you sure you want to delete this campaign? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await context.read<BrandProvider>().deleteCampaign(campaignId);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Campaign deleted')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting campaign: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BrandProvider>();
    final campaigns = provider.campaigns;
    final loading = provider.loading;

    return Scaffold(
      appBar: AppBar(title: const Text("Campaigns")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : campaigns.isEmpty
              ? const Center(child: Text("No campaigns yet"))
              : RefreshIndicator(
                  onRefresh: () async {
                    final brandId = provider.brand?.id;
                    if (brandId != null) {
                      await provider.fetchCampaigns(brandId);
                    }
                  },
                  child: ListView.builder(
                    itemCount: campaigns.length,
                    itemBuilder: (_, index) {
                      final CampaignModel c = campaigns[index];
                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Slidable(
                          key: ValueKey(c.id),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) => _confirmAndDeleteCampaign(c.id),
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              title: Text(
                                c.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                c.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "\$${c.spent}/${c.budget}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    c.status,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: c.status == 'active'
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CampaignDetailScreen(campaign: c),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CampaignCreateScreen()),
          );
          // refresh when user returns
          final brandId = provider.brand?.id;
          if (brandId != null) {
            await provider.fetchCampaigns(brandId);
          }
        },
      ),
    );
  }
}
