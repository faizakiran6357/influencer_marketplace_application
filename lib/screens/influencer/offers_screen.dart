import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/influencer_provider.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _campaignController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId != null) {
      context.read<InfluencerProvider>().fetchOffers(userId);
    }
  }

  Future<void> _addOffer() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<InfluencerProvider>();
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId == null) return;

    await provider.addOffer(
      influencerId: userId,
      brandName: _brandController.text.trim(),
      campaignName: _campaignController.text.trim(),
      description: _descriptionController.text.trim(),
      budget: double.parse(_budgetController.text.trim()),
    );

    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Offer added successfully!")),
    );
  }

  void _showAddOfferDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add New Offer"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(labelText: "Brand Name"),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                TextFormField(
                  controller: _campaignController,
                  decoration: const InputDecoration(labelText: "Campaign Name"),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                TextFormField(
                  controller: _budgetController,
                  decoration: const InputDecoration(labelText: "Budget (\$)"),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(onPressed: _addOffer, child: const Text("Save")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final offers = context.watch<InfluencerProvider>().offers;

    return Scaffold(
      appBar: AppBar(title: const Text("Collaboration Offers")),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOfferDialog,
        child: const Icon(Icons.add),
      ),
      body: offers.isEmpty
          ? const Center(child: Text("No offers yet"))
          : ListView.builder(
              itemCount: offers.length,
              itemBuilder: (_, i) {
                final o = offers[i];
                return ListTile(
                  leading: const Icon(Icons.local_offer, color: Colors.green),
                  title: Text(o['campaign_name'] ?? 'Untitled'),
                  subtitle: Text("Brand: ${o['brand_name']} • \$${o['budget']}"),
                );
              },
            ),
    );
  }
}
