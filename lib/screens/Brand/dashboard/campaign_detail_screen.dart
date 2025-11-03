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
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/screens/Brand/dashboard/compaign_edit_screen.dart';
import '../../../models/campaign_model.dart';
import '../../../services/compaign_service.dart';

class CampaignDetailScreen extends StatefulWidget {
  final CampaignModel campaign;
  const CampaignDetailScreen({super.key, required this.campaign});

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  final CampaignService _service = CampaignService();
  bool _isLoading = false;
  late CampaignModel campaign;

  @override
  void initState() {
    super.initState();
    campaign = widget.campaign;
  }

  Future<void> _activateCampaign() async {
    setState(() => _isLoading = true);

    try {
      final updated = campaign.copyWith(status: 'active');
      await _service.updateCampaign(updated);

      setState(() {
        campaign = updated;
      });

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

  @override
  Widget build(BuildContext context) {
    final isDraft = campaign.status.toLowerCase() == 'draft';

    return Scaffold(
      appBar: AppBar(
        title: Text(campaign.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CampaignEditScreen(campaign: campaign),
                ),
              );
              setState(() {}); // refresh on return
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(campaign.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("💰 Budget: \$${campaign.budget}",
                style: const TextStyle(fontSize: 16)),
            Text("💸 Spent: \$${campaign.spent}",
                style: const TextStyle(fontSize: 16)),
            Text("📊 Status: ${campaign.status}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            // ✅ Activate button (only for drafts)
            if (isDraft)
              Center(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _activateCampaign,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.campaign),
                  label: const Text("Activate Campaign"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
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
          ],
        ),
      ),
    );
  }
}


