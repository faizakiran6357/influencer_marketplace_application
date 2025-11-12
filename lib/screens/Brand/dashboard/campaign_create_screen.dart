
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/services/notification_service.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/brand_provider.dart';
// import '../../../models/campaign_model.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class CampaignCreateScreen extends StatefulWidget {
//   const CampaignCreateScreen({super.key});

//   @override
//   State<CampaignCreateScreen> createState() => _CampaignCreateScreenState();
// }

// class _CampaignCreateScreenState extends State<CampaignCreateScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descController = TextEditingController();
//   final _budgetController = TextEditingController();
//   bool _loading = false;

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.read<BrandProvider>();
//     final brandId = provider.brand?.id;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Create Campaign")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(labelText: "Title"),
//                 validator: (v) =>
//                     v == null || v.isEmpty ? "Title is required" : null,
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: _descController,
//                 decoration: const InputDecoration(labelText: "Description"),
//                 validator: (v) =>
//                     v == null || v.isEmpty ? "Description is required" : null,
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: _budgetController,
//                 decoration: const InputDecoration(labelText: "Budget"),
//                 keyboardType: TextInputType.number,
//                 validator: (v) => v == null || double.tryParse(v) == null
//                     ? "Enter valid number"
//                     : null,
//               ),
//               const SizedBox(height: 25),
//               _loading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton.icon(
//                       icon: const Icon(Icons.check),
//                       label: const Text("Create Campaign"),
//                       onPressed: () async {
//                         if (!_formKey.currentState!.validate() || brandId == null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text(
//                                     "Please fill all fields correctly")),
//                           );
//                           return;
//                         }

//                         setState(() => _loading = true);

//                         final campaign = CampaignModel(
//                           id: DateTime.now()
//                               .millisecondsSinceEpoch
//                               .toString(),
//                           brandId: brandId,
//                           title: _titleController.text.trim(),
//                           description: _descController.text.trim(),
//                           budget: double.parse(_budgetController.text.trim()),
//                           spent: 0,
//                           status: 'draft',
//                         );

//                         // 1️⃣ Create campaign in Supabase
//                         await provider.createCampaign(campaign);

//                         // 2️⃣ Send notification to all influencers
//                         try {
//                           final response = await Supabase.instance.client
//                               .from('profiles')
//                               .select('fcm_token')
//                               .eq('role', 'influencer')
//                               .not('fcm_token', 'is', null)
//                               .select();

//                           if (response != null && response is List) {
//                             for (var t in response) {
//                               final token = t['fcm_token'];
//                               if (token != null) {
//                                 await NotificationService.sendPushMessage(
//                                   targetToken: token,
//                                   title: 'New Campaign Posted!',
//                                   body: campaign.title,
//                                 );
//                               }
//                             }
//                           }
//                         } catch (e) {
//                           print('❌ Error sending campaign notification: $e');
//                         }

//                         setState(() => _loading = false);
//                         if (mounted) Navigator.pop(context);
//                       },
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/services/notification_service.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/brand_provider.dart';
// import '../../../models/campaign_model.dart';
// import '../../../utils/app_theme.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class CampaignCreateScreen extends StatefulWidget {
//   const CampaignCreateScreen({super.key});

//   @override
//   State<CampaignCreateScreen> createState() => _CampaignCreateScreenState();
// }

// class _CampaignCreateScreenState extends State<CampaignCreateScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descController = TextEditingController();
//   final _budgetController = TextEditingController();
//   bool _loading = false;

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
//     final brandId = provider.brand?.id;
//     final theme = Theme.of(context);
//     final textTheme = theme.textTheme.apply(fontFamily: 'Montserrat');

//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       appBar: AppBar(
//         title: Text(
//           "Create Campaign",
//           style: textTheme.titleLarge?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: AppTheme.primaryColor,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 400),
//           curve: Curves.easeInOut,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12.withOpacity(0.05),
//                 blurRadius: 12,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.all(20),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildTextField(
//                   label: "Campaign Title",
//                   controller: _titleController,
//                   icon: Icons.title_rounded,
//                 ),
//                 const SizedBox(height: 16),
//                 _buildTextField(
//                   label: "Description",
//                   controller: _descController,
//                   icon: Icons.description_outlined,
//                   maxLines: 4,
//                 ),
//                 const SizedBox(height: 16),
//                 _buildTextField(
//                   label: "Budget (\$)",
//                   controller: _budgetController,
//                   icon: Icons.attach_money_rounded,
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 32),
//                 Center(
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     width: _loading ? 60 : double.infinity,
//                     height: 55,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppTheme.primaryColor,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         elevation: 4,
//                       ),
//                       onPressed: _loading
//                           ? null
//                           : () async {
//                               if (!_formKey.currentState!.validate() ||
//                                   brandId == null) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                       content: Text(
//                                           "Please fill all fields correctly")),
//                                 );
//                                 return;
//                               }

//                               setState(() => _loading = true);

//                               final campaign = CampaignModel(
//                                 id: DateTime.now()
//                                     .millisecondsSinceEpoch
//                                     .toString(),
//                                 brandId: brandId,
//                                 title: _titleController.text.trim(),
//                                 description: _descController.text.trim(),
//                                 budget: double.parse(
//                                     _budgetController.text.trim()),
//                                 spent: 0,
//                                 status: 'draft',
//                               );

//                               await provider.createCampaign(campaign);

//                               // Send push notification to influencers
//                               try {
//                                 final response = await Supabase.instance.client
//                                     .from('profiles')
//                                     .select('fcm_token')
//                                     .eq('role', 'influencer')
//                                     .not('fcm_token', 'is', null)
//                                     .select();

//                                 if (response != null && response is List) {
//                                   for (var t in response) {
//                                     final token = t['fcm_token'];
//                                     if (token != null) {
//                                       await NotificationService.sendPushMessage(
//                                         targetToken: token,
//                                         title: 'New Campaign Posted!',
//                                         body: campaign.title,
//                                       );
//                                     }
//                                   }
//                                 }
//                               } catch (e) {
//                                 print(
//                                     '❌ Error sending campaign notification: $e');
//                               }

//                               setState(() => _loading = false);
//                               if (mounted) Navigator.pop(context);
//                             },
//                       child: _loading
//                           ? const CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             )
//                           : Text(
//                               "Create Campaign",
//                               style: textTheme.titleMedium?.copyWith(
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// 🔹 Modern styled reusable text field
//   Widget _buildTextField({
//     required String label,
//     required TextEditingController controller,
//     required IconData icon,
//     TextInputType? keyboardType,
//     int maxLines = 1,
//   }) {
//     return TextFormField(
//       controller: controller,
//       maxLines: maxLines,
//       keyboardType: keyboardType,
//       style: const TextStyle(fontFamily: 'Montserrat', fontSize: 15),
//       validator: (v) {
//         if (v == null || v.isEmpty) return '$label is required';
//         if (keyboardType == TextInputType.number &&
//             double.tryParse(v) == null) return 'Enter valid number';
//         return null;
//       },
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: AppTheme.primaryColor),
//         labelText: label,
//         labelStyle: const TextStyle(fontFamily: 'Montserrat'),
//         filled: true,
//         fillColor: const Color(0xFFF2F4F5),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide:
//               BorderSide(color: AppTheme.primaryColor.withOpacity(0.7), width: 1.2),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/services/notification_service.dart';
import 'package:provider/provider.dart';
import '../../../providers/brand_provider.dart';
import '../../../models/campaign_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
                                content: Text(
                                    "Please fill all fields correctly")),
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

                        // 1️⃣ Create campaign in Supabase
                        await provider.createCampaign(campaign);

                        // 2️⃣ Send notification to all influencers
                        try {
                          final response = await Supabase.instance.client
                              .from('profiles')
                              .select('fcm_token')
                              .eq('role', 'influencer')
                              .not('fcm_token', 'is', null)
                              .select();

                          if (response != null && response is List) {
                            for (var t in response) {
                              final token = t['fcm_token'];
                              if (token != null) {
                                await NotificationService.sendPushMessage(
                                  targetToken: token,
                                  title: 'New Campaign Posted!',
                                  body: campaign.title,
                                );
                              }
                            }
                          }
                        } catch (e) {
                          print('❌ Error sending campaign notification: $e');
                        }

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
