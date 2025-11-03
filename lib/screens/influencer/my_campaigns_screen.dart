import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/influencer_provider.dart';

class MyCampaignsScreen extends StatefulWidget {
  const MyCampaignsScreen({super.key});

  @override
  State<MyCampaignsScreen> createState() => _MyCampaignsScreenState();
}

class _MyCampaignsScreenState extends State<MyCampaignsScreen> {
  @override
  void initState() {
    super.initState();
    final influencerId = context.read<AuthProvider>().currentUser?.id;
    if (influencerId != null) {
      context.read<InfluencerProvider>().fetchAcceptedCampaigns(influencerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final campaigns = context.watch<InfluencerProvider>().acceptedCampaigns;

    return Scaffold(
      appBar: AppBar(title: const Text("My Campaigns")),
      body: campaigns.isEmpty
          ? const Center(child: Text("No accepted campaigns yet"))
          : ListView.builder(
              itemCount: campaigns.length,
              itemBuilder: (_, i) {
                final c = campaigns[i];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(c['title'] ?? 'Untitled'),
                    subtitle: Text(
                        "Brand: ${c['brands']?['name'] ?? 'Unknown'} • Budget: \$${c['budget']}"),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(c['title'] ?? 'Campaign'),
                          content: Text(c['description'] ?? 'No description'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Close"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
