import 'package:flutter/material.dart';
import '../../../utils/app_theme.dart';
import '../../influencer/influencer_dashboard.dart';

class ViewAllInfluencersScreen extends StatefulWidget {
  final List<Map<String, dynamic>> popularInfluencers;
  final List<Map<String, dynamic>> trendingInfluencers;
  final String initialTab; // "popular" or "trending"

  const ViewAllInfluencersScreen({
    super.key,
    required this.popularInfluencers,
    required this.trendingInfluencers,
    this.initialTab = "popular",
  });

  @override
  State<ViewAllInfluencersScreen> createState() =>
      _ViewAllInfluencersScreenState();
}

class _ViewAllInfluencersScreenState extends State<ViewAllInfluencersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.initialTab == "trending") _tabController.index = 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Influencers"),
        backgroundColor: AppTheme.primaryColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Popular"),
            Tab(text: "Trending"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _influencerList(widget.popularInfluencers),
          _influencerList(widget.trendingInfluencers),
        ],
      ),
    );
  }

  Widget _influencerList(List<Map<String, dynamic>> influencers) {
    if (influencers.isEmpty) {
      return const Center(child: Text("No influencers found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: influencers.length,
      itemBuilder: (context, i) {
        final inf = influencers[i];
        final image = (inf['profile_image'] ?? '').toString().isNotEmpty
            ? inf['profile_image']
            : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800&auto=format&fit=crop&q=80';
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => FractionallySizedBox(
                heightFactor: 0.92,
                child: InfluencerDashboard(influencerId: inf['id']),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(image),
              ),
              title: Text(inf['name'] ?? "Unknown"),
              subtitle: Text('${inf['follower_count']} followers | Eng: ${inf['engagement_rate']}%'),
            ),
          ),
        );
      },
    );
  }
}
