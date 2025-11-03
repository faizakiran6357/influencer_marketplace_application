// import 'package:flutter/material.dart';
// import 'add_team_member_screen.dart';

// class TeamListScreen extends StatelessWidget {
//   const TeamListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Team Members")),
//       body: const Center(child: Text("Team members will be listed here")),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTeamMemberScreen())),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/providers/auth_provider.dart';
import 'package:influencer_marketplace_application/services/team_service.dart';
import 'package:provider/provider.dart';
import 'add_team_member_screen.dart';

class TeamListScreen extends StatefulWidget {
  const TeamListScreen({super.key});

  @override
  State<TeamListScreen> createState() => _TeamListScreenState();
}

class _TeamListScreenState extends State<TeamListScreen> {
  final _teamService = TeamService();
  List<Map<String, dynamic>> _team = [];
  bool _isLoading = true;

  Future<void> _loadTeam() async {
    final brandId = context.read<AuthProvider>().currentUser?.id;
    if (brandId == null) return;

    final team = await _teamService.fetchTeamMembers(brandId);
    setState(() {
      _team = team;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTeam();
  }

  Future<void> _deleteMember(String memberId) async {
    await _teamService.deleteTeamMember(memberId);
    _loadTeam();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Team Members")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _team.isEmpty
              ? const Center(child: Text("No team members added yet"))
              : ListView.builder(
                  itemCount: _team.length,
                  itemBuilder: (_, i) {
                    final member = _team[i];
                    return ListTile(
                      title: Text(member['name']),
                      subtitle: Text("${member['role']} • ${member['email']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteMember(member['id']),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTeamMemberScreen()),
          );
          if (result == true) _loadTeam();
        },
      ),
    );
  }
}
