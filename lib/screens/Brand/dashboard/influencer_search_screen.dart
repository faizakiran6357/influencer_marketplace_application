import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InfluencerSearchScreen extends StatefulWidget {
  const InfluencerSearchScreen({super.key});

  @override
  State<InfluencerSearchScreen> createState() => _InfluencerSearchScreenState();
}

class _InfluencerSearchScreenState extends State<InfluencerSearchScreen> {
  final _client = Supabase.instance.client;
  List<Map<String, dynamic>> influencers = [];
  final _searchController = TextEditingController();

  Future<void> searchInfluencers(String query) async {
    final res = await _client
        .from('profiles')
        .select()
        .ilike('name', '%$query%')
        .eq('role', 'influencer');
    setState(() => influencers = List<Map<String, dynamic>>.from(res));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Influencers")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Search by name",
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => searchInfluencers(val),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: influencers.length,
              itemBuilder: (_, index) {
                final inf = influencers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: inf['profile_image'] != null ? NetworkImage(inf['profile_image']) : null,
                    child: inf['profile_image'] == null ? const Icon(Icons.person) : null,
                  ),
                  title: Text(inf['name'] ?? ''),
                  subtitle: Text(inf['bio'] ?? ''),
                  trailing: ElevatedButton(
                    child: const Text("Shortlist"),
                    onPressed: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
