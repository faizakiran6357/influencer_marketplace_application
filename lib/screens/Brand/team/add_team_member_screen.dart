// import 'package:flutter/material.dart';

// class AddTeamMemberScreen extends StatelessWidget {
//   const AddTeamMemberScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Team Member")),
//       body: const Center(child: Text("Form to add team member")),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/providers/auth_provider.dart';
import 'package:influencer_marketplace_application/services/team_service.dart';
import 'package:provider/provider.dart';


class AddTeamMemberScreen extends StatefulWidget {
  const AddTeamMemberScreen({super.key});

  @override
  State<AddTeamMemberScreen> createState() => _AddTeamMemberScreenState();
}

class _AddTeamMemberScreenState extends State<AddTeamMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();

  final _teamService = TeamService();

  Future<void> _saveTeamMember() async {
    if (!_formKey.currentState!.validate()) return;

    final brandId = context.read<AuthProvider>().currentUser?.id;
    if (brandId == null) return;

    await _teamService.addTeamMember(
      brandId: brandId,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      role: _roleController.text.trim(),
    );

    if (!mounted) return;
    Navigator.pop(context, true);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Team member added")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Team Member")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: "Role"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTeamMember,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
