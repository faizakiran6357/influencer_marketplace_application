// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/services/auth_service.dart';
// import 'package:influencer_marketplace_application/screens/auth/profile_setup_screen.dart';
// import '../../utils/app_theme.dart';
// import '../../widgets/custom_button.dart';

// class RoleSelectionScreen extends StatefulWidget {
//   final String userId; // 👈 passed from Google sign-up flow
//   final String email;
//   final String name;

//   const RoleSelectionScreen({
//     super.key,
//     required this.userId,
//     required this.email,
//     required this.name,
//   });

//   @override
//   State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
// }

// class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
//   String? selectedRole;
//   bool _isSaving = false;

//   Future<void> _saveRole() async {
//     if (selectedRole == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select a role")),
//       );
//       return;
//     }

//     setState(() => _isSaving = true);

//     try {
//       // ✅ Update Supabase profile with selected role
//       await SupabaseAuthService().supabase.from('profiles').upsert({
//         'id': widget.userId,
//         'email': widget.email,
//         'name': widget.name,
//         'role': selectedRole,
//       });

//       // ✅ Go to Profile Setup Screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ProfileSetupScreen(role: selectedRole!),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error saving role: $e")),
//       );
//     } finally {
//       setState(() => _isSaving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         title: const Text("Select Your Role"),
//         backgroundColor: AppTheme.primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Choose your account type",
//               style: TextStyle(
//                 color: AppTheme.textColor,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 30),

//             // Influencer option
//             _buildRoleCard(
//               title: "Influencer",
//               icon: Icons.person_outline,
//               isSelected: selectedRole == "influencer",
//               onTap: () => setState(() => selectedRole = "influencer"),
//             ),
//             const SizedBox(height: 16),

//             // Brand option
//             _buildRoleCard(
//               title: "Brand",
//               icon: Icons.business_outlined,
//               isSelected: selectedRole == "brand",
//               onTap: () => setState(() => selectedRole = "brand"),
//             ),
//             const Spacer(),

//             CustomButton(
//               text: _isSaving ? "Saving..." : "Continue",
//               onPressed: _isSaving ? null : _saveRole,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRoleCard({
//     required String title,
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: isSelected ? AppTheme.primaryColor : Colors.grey),
//             const SizedBox(width: 12),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/services/auth_service.dart';
// import 'package:influencer_marketplace_application/screens/auth/profile_setup_screen.dart';
// import '../../utils/app_theme.dart';
// import '../../widgets/custom_button.dart';

// class RoleSelectionScreen extends StatefulWidget {
//   final String userId; // 👈 passed from Google sign-up flow
//   final String email;
//   final String name;

//   const RoleSelectionScreen({
//     super.key,
//     required this.userId,
//     required this.email,
//     required this.name,
//   });

//   @override
//   State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
// }

// class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
//   String? selectedRole;
//   bool _isSaving = false;

//   Future<void> _saveRole() async {
//     if (selectedRole == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select a role")),
//       );
//       return;
//     }

//     setState(() => _isSaving = true);

//     try {
//       // Update Supabase profile with selected role
//       await SupabaseAuthService().supabase.from('profiles').upsert({
//         'id': widget.userId,
//         'email': widget.email,
//         'name': widget.name,
//         'role': selectedRole,
//       });

//       // Go to Profile Setup Screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ProfileSetupScreen(role: selectedRole!),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error saving role: $e")),
//       );
//     } finally {
//       setState(() => _isSaving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         title: const Text("Select Your Role"),
//         backgroundColor: AppTheme.primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Choose your account type",
//               style: TextStyle(
//                 color: AppTheme.textColor,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 30),

//             // Influencer option
//             _buildRoleCard(
//               title: "Influencer",
//               icon: Icons.person_outline,
//               isSelected: selectedRole == "influencer",
//               onTap: () => setState(() => selectedRole = "influencer"),
//             ),
//             const SizedBox(height: 16),

//             // Brand option
//             _buildRoleCard(
//               title: "Brand",
//               icon: Icons.business_outlined,
//               isSelected: selectedRole == "brand",
//               onTap: () => setState(() => selectedRole = "brand"),
//             ),
//             const Spacer(),

//             // Custom Button
//             CustomButton(
//               text: _isSaving ? "Saving..." : "Continue",
//               onPressed: () {
//                 if (!_isSaving) _saveRole();
//               },
//               isLoading: _isSaving,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRoleCard({
//     required String title,
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: isSelected ? AppTheme.primaryColor : Colors.grey),
//             const SizedBox(width: 12),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/services/auth_service.dart';
// import 'package:influencer_marketplace_application/screens/auth/profile_setup_screen.dart';
// import '../../utils/app_theme.dart';
// import '../../widgets/custom_button.dart';

// class RoleSelectionScreen extends StatefulWidget {
//   final String userId; // passed from Google sign-up flow
//   final String email;
//   final String name;

//   const RoleSelectionScreen({
//     super.key,
//     required this.userId,
//     required this.email,
//     required this.name,
//   });

//   @override
//   State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
// }

// class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
//   String? selectedRole;
//   bool _isSaving = false;

//   // ---------------- ONPRESS WRAPPER ----------------
//   void _onContinuePressed() {
//     _saveRole();
//   }

//   // ---------------- SAVE ROLE ----------------
//   Future<void> _saveRole() async {
//     if (selectedRole == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select a role")),
//       );
//       return;
//     }

//     setState(() => _isSaving = true);

//     try {
//       // Lowercase role to match Supabase constraint
//       final roleToInsert = selectedRole!.toLowerCase();

//       // Insert profile in Supabase
//       await SupabaseAuthService().supabase.from('profiles').insert({
//         'id': widget.userId,
//         'email': widget.email,
//         'name': widget.name,
//         'role': roleToInsert,
//       });

//       // Navigate to Profile Setup Screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ProfileSetupScreen(role: roleToInsert),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error saving role: $e")),
//       );
//     } finally {
//       setState(() => _isSaving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         title: const Text("Select Your Role"),
//         backgroundColor: AppTheme.primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Choose your account type",
//               style: TextStyle(
//                 color: AppTheme.textColor,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 30),

//             // Influencer option
//             _buildRoleCard(
//               title: "Influencer",
//               icon: Icons.person_outline,
//               isSelected: selectedRole == "influencer",
//               onTap: () => setState(() => selectedRole = "influencer"),
//             ),
//             const SizedBox(height: 16),

//             // Brand option
//             _buildRoleCard(
//               title: "Brand",
//               icon: Icons.business_outlined,
//               isSelected: selectedRole == "brand",
//               onTap: () => setState(() => selectedRole = "brand"),
//             ),
//             const Spacer(),

//             // CustomButton
         
//             CustomButton(
//               text: _isSaving ? "Saving..." : "Continue",
//               onPressed: () {
//                 if (!_isSaving) _saveRole();
//               },
//               isLoading: _isSaving,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ---------------- ROLE CARD ----------------
//   Widget _buildRoleCard({
//     required String title,
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color:
//               isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: isSelected ? AppTheme.primaryColor : Colors.grey),
//             const SizedBox(width: 12),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/services/auth_service.dart';
// import '../../utils/app_theme.dart';
// import '../../widgets/custom_button.dart';
// import '../auth/profile_setup_screen.dart';


// class RoleSelectionScreen extends StatefulWidget {
//   final String userId;
//   final String email;
//   final String name;

//   const RoleSelectionScreen({
//     super.key,
//     required this.userId,
//     required this.email,
//     required this.name,
//   });

//   @override
//   State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
// }

// class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
//   String? selectedRole;
//   bool _isSaving = false;

//   Future<void> _saveRole() async {
//     if (selectedRole == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select a role")),
//       );
//       return;
//     }

//     setState(() => _isSaving = true);

//     try {
//       final roleToInsert = selectedRole!.toLowerCase(); // must match Supabase constraint

//       // Insert new profile row after role selection
//       await SupabaseAuthService().supabase.from('profiles').insert({
//         'id': widget.userId,
//         'name': widget.name,
//         'email': widget.email,
//         'role': roleToInsert,
//       });

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ProfileSetupScreen(role: roleToInsert),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error saving role: $e")),
//       );
//     } finally {
//       setState(() => _isSaving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         title: const Text("Select Your Role"),
//         backgroundColor: AppTheme.primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Choose your account type",
//               style: TextStyle(
//                 color: AppTheme.textColor,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 30),

//             _buildRoleCard(
//               title: "Influencer",
//               icon: Icons.person_outline,
//               isSelected: selectedRole == "influencer",
//               onTap: () => setState(() => selectedRole = "influencer"),
//             ),
//             const SizedBox(height: 16),

//             _buildRoleCard(
//               title: "Brand",
//               icon: Icons.business_outlined,
//               isSelected: selectedRole == "brand",
//               onTap: () => setState(() => selectedRole = "brand"),
//             ),
//             const Spacer(),

//             CustomButton(
//               text: _isSaving ? "Saving..." : "Continue",
//               onPressed: () {
//                 if (!_isSaving) _saveRole();
//               },
//               isLoading: _isSaving,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRoleCard({
//     required String title,
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: isSelected ? AppTheme.primaryColor : Colors.grey),
//             const SizedBox(width: 12),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/services/auth_service.dart';
// import '../../utils/app_theme.dart';
// import '../../widgets/custom_button.dart';
// import '../auth/profile_setup_screen.dart';

// class RoleSelectionScreen extends StatefulWidget {
//   final String userId;
//   final String email;
//   final String name;

//   const RoleSelectionScreen({
//     super.key,
//     required this.userId,
//     required this.email,
//     required this.name,
//   });

//   @override
//   State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
// }

// class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
//   String? selectedRole;
//   bool _isSaving = false;

//   Future<void> _saveRole() async {
//     if (selectedRole == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select a role")),
//       );
//       return;
//     }

//     setState(() => _isSaving = true);

//     try {
//       final roleToInsert = selectedRole!.toLowerCase(); // must match Supabase constraint

//       // ✅ Check if profile already exists
//       final existing = await SupabaseAuthService().supabase
//           .from('profiles')
//           .select()
//           .eq('id', widget.userId)
//           .maybeSingle();

//       if (existing != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("User already exists.")),
//         );
//         setState(() => _isSaving = false);
//         return;
//       }

//       // Insert new profile row after role selection
//       await SupabaseAuthService().supabase.from('profiles').insert({
//         'id': widget.userId,
//         'name': widget.name,
//         'email': widget.email,
//         'role': roleToInsert,
//       });

//       // Navigate to Profile Setup Screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ProfileSetupScreen(role: roleToInsert),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error saving role: $e")),
//       );
//     } finally {
//       setState(() => _isSaving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         title: const Text("Select Your Role"),
//         backgroundColor: AppTheme.primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Choose your account type",
//               style: TextStyle(
//                 color: AppTheme.textColor,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 30),

//             _buildRoleCard(
//               title: "Influencer",
//               icon: Icons.person_outline,
//               isSelected: selectedRole == "influencer",
//               onTap: () => setState(() => selectedRole = "influencer"),
//             ),
//             const SizedBox(height: 16),

//             _buildRoleCard(
//               title: "Brand",
//               icon: Icons.business_outlined,
//               isSelected: selectedRole == "brand",
//               onTap: () => setState(() => selectedRole = "brand"),
//             ),
//             const Spacer(),

//             CustomButton(
//               text: _isSaving ? "Saving..." : "Continue",
//               onPressed: () {
//                 if (!_isSaving) _saveRole();
//               },
//               isLoading: _isSaving,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRoleCard({
//     required String title,
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: isSelected ? AppTheme.primaryColor : Colors.grey),
//             const SizedBox(width: 12),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/models/user_model.dart';
// import 'package:influencer_marketplace_application/providers/auth_provider.dart';
// import 'package:influencer_marketplace_application/services/auth_service.dart';
// import 'package:provider/provider.dart';
// import '../../utils/app_theme.dart';
// import '../../widgets/custom_button.dart';
// import '../auth/profile_setup_screen.dart';

// class RoleSelectionScreen extends StatefulWidget {
//   final String userId;
//   final String email;
//   final String name;

//   const RoleSelectionScreen({
//     super.key,
//     required this.userId,
//     required this.email,
//     required this.name,
//   });

//   @override
//   State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
// }

// class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
//   String? selectedRole;
//   bool _isSaving = false;

//   Future<void> _saveRole() async {
//     if (selectedRole == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select a role")),
//       );
//       return;
//     }

//     setState(() => _isSaving = true);

//     try {
//       // ✅ Use exact capitalization to match DB constraint
//       final roleToInsert = selectedRole!.trim() == 'influencer'
//           ? 'Influencer'
//           : 'Brand';

//       // ✅ Check if profile already exists
//       final existing = await SupabaseAuthService().supabase
//           .from('profiles')
//           .select()
//           .eq('id', widget.userId)
//           .maybeSingle();

//       if (existing != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("User already exists.")),
//         );
//         setState(() => _isSaving = false);
//         return;
//       }

//       // Insert new profile row after role selection
//       await SupabaseAuthService().supabase.from('profiles').insert({
//         'id': widget.userId,
//         'name': widget.name,
//         'email': widget.email,
//         'role': roleToInsert,
//       });

//       // Navigate to Profile Setup Screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ProfileSetupScreen(role: roleToInsert),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error saving role: $e")),
//       );
//     } finally {
//       setState(() => _isSaving = false);
//     }
//   }
  



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         title: const Text("Select Your Role"),
//         backgroundColor: AppTheme.primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Choose your account type",
//               style: TextStyle(
//                 color: AppTheme.textColor,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 30),

//             _buildRoleCard(
//               title: "Influencer",
//               icon: Icons.person_outline,
//               isSelected: selectedRole?.toLowerCase() == "influencer",
//               onTap: () => setState(() => selectedRole = "influencer"),
//             ),
//             const SizedBox(height: 16),

//             _buildRoleCard(
//               title: "Brand",
//               icon: Icons.business_outlined,
//               isSelected: selectedRole?.toLowerCase() == "brand",
//               onTap: () => setState(() => selectedRole = "brand"),
//             ),
//             const Spacer(),

//             // ✅ Fixed CustomButton to support nullable onPressed
//            CustomButton(
//   text: _isSaving ? "Saving..." : "Continue",
//   onPressed: () {
//     if (!_isSaving) _saveRole();
//   },
//   isLoading: _isSaving,
// )

//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRoleCard({
//     required String title,
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? AppTheme.primaryColor.withOpacity(0.1)
//               : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
//             width: 2,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: isSelected ? AppTheme.primaryColor : Colors.grey),
//             const SizedBox(width: 12),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:influencer_marketplace_application/providers/auth_provider.dart';
import 'package:influencer_marketplace_application/services/auth_service.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../auth/profile_setup_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String name;

  const RoleSelectionScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.name,
  });

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole;
  bool _isSaving = false;

  Future<void> _saveRole() async {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a role")),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Capitalize role to match Supabase constraint
      final roleToInsert =
          selectedRole![0].toUpperCase() + selectedRole!.substring(1).toLowerCase();

      // Insert profile row
      await SupabaseAuthService().supabase.from('profiles').insert({
        'id': widget.userId,
        'name': widget.name,
        'email': widget.email,
        'role': roleToInsert,
      });

      // Update currentUser in AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.currentUser = UserModel(
        id: widget.userId,
        name: widget.name,
        email: widget.email,
        role: roleToInsert,
      );

      // Navigate to Profile Setup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileSetupScreen(role: roleToInsert),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving role: $e")),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text("Select Your Role"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose your account type",
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),

            _buildRoleCard(
              title: "Influencer",
              icon: Icons.person_outline,
              isSelected: selectedRole?.toLowerCase() == "influencer",
              onTap: () => setState(() => selectedRole = "Influencer"),
            ),
            const SizedBox(height: 16),

            _buildRoleCard(
              title: "Brand",
              icon: Icons.business_outlined,
              isSelected: selectedRole?.toLowerCase() == "brand",
              onTap: () => setState(() => selectedRole = "Brand"),
            ),
            const Spacer(),
          //  ✅ Fixed CustomButton to support nullable onPressed
           CustomButton(
  text: _isSaving ? "Saving..." : "Continue",
  onPressed: () {
    if (!_isSaving) _saveRole();
  },
  isLoading: _isSaving,
)
            
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppTheme.primaryColor : Colors.grey),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
