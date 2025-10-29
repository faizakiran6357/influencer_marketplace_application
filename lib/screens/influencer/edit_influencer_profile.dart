import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/models/influencer_model.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/influencer_provider.dart';
import '../../services/influencer_service.dart';

class EditInfluencerProfile extends StatelessWidget {
  const EditInfluencerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser!;
    final service = InfluencerService();
    final nameCtrl = TextEditingController();
    final bioCtrl = TextEditingController();
    final nicheCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Name")),
          TextField(controller: bioCtrl, decoration: const InputDecoration(labelText: "Bio")),
          TextField(controller: nicheCtrl, decoration: const InputDecoration(labelText: "Niche")),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await service.upsertInfluencer(
                InfluencerModel(id: user.id, name: nameCtrl.text, bio: bioCtrl.text, niche: nicheCtrl.text),
              );
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile saved")));
            },
            child: const Text("Save"),
          ),
        ]),
      ),
    );
  }
}
