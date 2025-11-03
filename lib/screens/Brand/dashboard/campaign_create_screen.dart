// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/brand_provider.dart';
// import '../../../models/campaign_model.dart';

// class CampaignCreateScreen extends StatefulWidget {
//   const CampaignCreateScreen({super.key});

//   @override
//   State<CampaignCreateScreen> createState() => _CampaignCreateScreenState();
// }

// class _CampaignCreateScreenState extends State<CampaignCreateScreen> {
//   final _titleController = TextEditingController();
//   final _descController = TextEditingController();
//   final _budgetController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.read<BrandProvider>();
//     final brandId = provider.brand?.id;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Create Campaign")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Title")),
//             const SizedBox(height: 10),
//             TextField(controller: _descController, decoration: const InputDecoration(labelText: "Description")),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _budgetController,
//               decoration: const InputDecoration(labelText: "Budget"),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               child: const Text("Create"),
//               onPressed: () async {
//                 if (brandId == null) return;
//                 final campaign = CampaignModel(
//                   id: DateTime.now().millisecondsSinceEpoch.toString(),
//                   brandId: brandId,
//                   title: _titleController.text,
//                   description: _descController.text,
//                   budget: double.tryParse(_budgetController.text) ?? 0,
//                   spent: 0,
//                   status: 'draft',
//                 );
//                 await provider.createCampaign(campaign);
//                 Navigator.pop(context);
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/brand_provider.dart';
import '../../../models/campaign_model.dart';

class CampaignCreateScreen extends StatefulWidget {
  const CampaignCreateScreen({super.key});

  @override
  State<CampaignCreateScreen> createState() => _CampaignCreateScreenState();
}

class _CampaignCreateScreenState extends State<CampaignCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _budgetController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<BrandProvider>();
    final brandId = provider.brand?.id;

    return Scaffold(
      appBar: AppBar(title: const Text("Create Campaign")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Title is required" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Description is required" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _budgetController,
                decoration: const InputDecoration(labelText: "Budget"),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || double.tryParse(v) == null
                    ? "Enter valid number"
                    : null,
              ),
              const SizedBox(height: 25),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text("Create Campaign"),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate() || brandId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please fill all fields correctly")),
                          );
                          return;
                        }

                        setState(() => _loading = true);

                        final campaign = CampaignModel(
                          id: DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                          brandId: brandId,
                          title: _titleController.text.trim(),
                          description: _descController.text.trim(),
                          budget: double.parse(_budgetController.text.trim()),
                          spent: 0,
                          status: 'draft',
                        );

                        await provider.createCampaign(campaign);

                        setState(() => _loading = false);
                        if (mounted) Navigator.pop(context);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
