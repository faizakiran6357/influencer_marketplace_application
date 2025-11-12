// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../models/campaign_model.dart';
// import '../../../providers/brand_provider.dart';

// class CampaignEditScreen extends StatefulWidget {
//   final CampaignModel campaign;
//   const CampaignEditScreen({super.key, required this.campaign});

//   @override
//   State<CampaignEditScreen> createState() => _CampaignEditScreenState();
// }

// class _CampaignEditScreenState extends State<CampaignEditScreen> {
//   late TextEditingController _titleController;
//   late TextEditingController _descController;
//   late TextEditingController _budgetController;

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.campaign.title);
//     _descController = TextEditingController(text: widget.campaign.description);
//     _budgetController =
//         TextEditingController(text: widget.campaign.budget.toString());
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descController.dispose();
//     _budgetController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.read<BrandProvider>();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Campaign")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: const InputDecoration(labelText: "Title"),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _descController,
//               decoration: const InputDecoration(labelText: "Description"),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _budgetController,
//               decoration: const InputDecoration(labelText: "Budget"),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final updated = CampaignModel(
//                   id: widget.campaign.id,
//                   brandId: widget.campaign.brandId,
//                   title: _titleController.text,
//                   description: _descController.text,
//                   budget: double.tryParse(_budgetController.text) ?? 0,
//                   spent: widget.campaign.spent,
//                   status: widget.campaign.status,
//                 );

//                 await provider.updateCampaign(updated);
//                 if (context.mounted) {
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text("Save Changes"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/campaign_model.dart';
import '../../../providers/brand_provider.dart';
import '../../../utils/app_theme.dart'; // ✅ Import your AppTheme

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
  bool _isSaving = false;

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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme.apply(fontFamily: 'Montserrat');

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          "Edit Campaign",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: "Campaign Title",
                controller: _titleController,
                icon: Icons.title_rounded,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Description",
                controller: _descController,
                icon: Icons.description_outlined,
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Budget (\$)",
                controller: _budgetController,
                icon: Icons.attach_money_rounded,
                keyboardType: TextInputType.number,
                suffixText: "USD",
              ),
              const SizedBox(height: 32),
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isSaving ? 60 : double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    onPressed: _isSaving
                        ? null
                        : () async {
                            setState(() => _isSaving = true);

                            final updated = CampaignModel(
                              id: widget.campaign.id,
                              brandId: widget.campaign.brandId,
                              title: _titleController.text.trim(),
                              description: _descController.text.trim(),
                              budget:
                                  double.tryParse(_budgetController.text) ?? 0,
                              spent: widget.campaign.spent,
                              status: widget.campaign.status,
                            );

                            await provider.updateCampaign(updated);

                            if (mounted) {
                              setState(() => _isSaving = false);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      '✅ Campaign updated successfully!'),
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                              );
                            }
                          },
                    child: _isSaving
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : Text(
                            "Save Changes",
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Reusable modern styled text field
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? suffixText,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 15,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8),
        ),
        suffixText: suffixText,
        suffixStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        filled: true,
        fillColor: const Color(0xFFF2F4F5),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: AppTheme.primaryColor.withOpacity(0.7), width: 1.2),
        ),
      ),
    );
  }
}
