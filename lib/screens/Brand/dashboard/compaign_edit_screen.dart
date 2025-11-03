import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/campaign_model.dart';
import '../../../providers/brand_provider.dart';

class CampaignEditScreen extends StatefulWidget {
  final CampaignModel campaign;
  const CampaignEditScreen({super.key, required this.campaign});

  @override
  State<CampaignEditScreen> createState() => _CampaignEditScreenState();
}

class _CampaignEditScreenState extends State<CampaignEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.campaign.title);
    _descController = TextEditingController(text: widget.campaign.description);
    _budgetController =
        TextEditingController(text: widget.campaign.budget.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<BrandProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Campaign")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _budgetController,
              decoration: const InputDecoration(labelText: "Budget"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updated = CampaignModel(
                  id: widget.campaign.id,
                  brandId: widget.campaign.brandId,
                  title: _titleController.text,
                  description: _descController.text,
                  budget: double.tryParse(_budgetController.text) ?? 0,
                  spent: widget.campaign.spent,
                  status: widget.campaign.status,
                );

                await provider.updateCampaign(updated);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
