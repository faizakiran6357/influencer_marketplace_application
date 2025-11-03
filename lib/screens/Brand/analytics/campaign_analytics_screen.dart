// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class CampaignAnalyticsScreen extends StatefulWidget {
//   const CampaignAnalyticsScreen({super.key});

//   @override
//   State<CampaignAnalyticsScreen> createState() =>
//       _CampaignAnalyticsScreenState();
// }

// class _CampaignAnalyticsScreenState extends State<CampaignAnalyticsScreen> {
//   final supabase = Supabase.instance.client;

//   Map<String, dynamic> analytics = {
//     'totalBudget': 0.0,
//     'totalSpent': 0.0,
//     'active': 0,
//     'draft': 0,
//     'completed': 0,
//     'totalCampaigns': 0,
//     'acceptedOffers': 0,
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadAnalytics();
//     _listenForChanges();
//   }

//   /// 🔹 Fetch initial data
//   Future<void> _loadAnalytics() async {
//     final user = supabase.auth.currentUser;
//     if (user == null) return;

//     try {
//       // Fetch all campaigns for this brand
//       final campaignsRes = await supabase
//           .from('campaigns')
//           .select()
//           .eq('brand_id', user.id);

//       final campaigns = List<Map<String, dynamic>>.from(campaignsRes);
//       double totalBudget = 0;
//       double totalSpent = 0;
//       int active = 0, draft = 0, completed = 0;

//       for (var c in campaigns) {
//         totalBudget += (c['budget'] ?? 0).toDouble();
//         totalSpent += (c['spent'] ?? 0).toDouble();
//         switch (c['status']) {
//           case 'active':
//             active++;
//             break;
//           case 'draft':
//             draft++;
//             break;
//           case 'completed':
//             completed++;
//             break;
//         }
//       }

//       // Fetch accepted influencer offers for this brand's campaigns
//       final acceptedOffersRes = await supabase
//           .from('campaign_influencers')
//           .select('id')
//           .in_('campaign_id', campaigns.map((c) => c['id']).toList())
//           .eq('status', 'accepted');

//       setState(() {
//         analytics = {
//           'totalBudget': totalBudget,
//           'totalSpent': totalSpent,
//           'active': active,
//           'draft': draft,
//           'completed': completed,
//           'totalCampaigns': campaigns.length,
//           'acceptedOffers': (acceptedOffersRes as List).length,
//         };
//       });
//     } catch (e) {
//       print("❌ loadAnalytics error: $e");
//     }
//   }

//   /// 🔹 Listen for real-time updates in campaigns or campaign_influencers
//   void _listenForChanges() {
//     final user = supabase.auth.currentUser;
//     if (user == null) return;

//     supabase
//         .channel('brand_analytics')
//         .onPostgresChanges(
//           event: PostgresChangeEvent.all,
//           schema: 'public',
//           table: 'campaigns',
//           filter: PostgresChangeFilter(
//             type: PostgresChangeFilterType.eq,
//             column: 'brand_id',
//             value: user.id,
//           ),
//           callback: (_) => _loadAnalytics(),
//         )
//         .onPostgresChanges(
//           event: PostgresChangeEvent.all,
//           schema: 'public',
//           table: 'campaign_influencers',
//           callback: (_) => _loadAnalytics(),
//         )
//         .subscribe();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double spent = analytics['totalSpent'];
//     final double budget = analytics['totalBudget'];
//     final double utilization =
//         budget > 0 ? (spent / budget * 100).clamp(0, 100) : 0;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Campaign Analytics")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Campaign Overview",
//                 style: Theme.of(context).textTheme.titleMedium),
//             const SizedBox(height: 12),
//             SizedBox(
//               height: 250,
//               child: SfCircularChart(
//                 legend: const Legend(isVisible: true),
//                 series: <CircularSeries>[
//                   PieSeries<_ChartData, String>(
//                     dataSource: [
//                       _ChartData('Active', analytics['active']),
//                       _ChartData('Draft', analytics['draft']),
//                       _ChartData('Completed', analytics['completed']),
//                     ],
//                     xValueMapper: (_ChartData data, _) => data.label,
//                     yValueMapper: (_ChartData data, _) => data.value,
//                     dataLabelSettings:
//                         const DataLabelSettings(isVisible: true),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text("Budget Overview",
//                 style: Theme.of(context).textTheme.titleMedium),
//             const SizedBox(height: 12),
//             SizedBox(
//               height: 200,
//               child: SfCartesianChart(
//                 primaryXAxis: CategoryAxis(),
//                 series: <CartesianSeries>[
//                   ColumnSeries<_ChartData, String>(
//                     dataSource: [
//                       _ChartData('Total Budget', budget),
//                       _ChartData('Total Spent', spent),
//                       _ChartData('Remaining', budget - spent),
//                     ],
//                     xValueMapper: (_ChartData data, _) => data.label,
//                     yValueMapper: (_ChartData data, _) => data.value,
//                     dataLabelSettings:
//                         const DataLabelSettings(isVisible: true),
//                     color: Colors.teal,
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text("📊 Total Campaigns: ${analytics['totalCampaigns']}"),
//             Text("✅ Accepted Offers: ${analytics['acceptedOffers']}"),
//             Text("💰 Budget Utilization: ${utilization.toStringAsFixed(1)}%"),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ChartData {
//   final String label;
//   final num value;
//   _ChartData(this.label, this.value);
// }
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CampaignAnalyticsScreen extends StatefulWidget {
  const CampaignAnalyticsScreen({super.key});

  @override
  State<CampaignAnalyticsScreen> createState() =>
      _CampaignAnalyticsScreenState();
}

class _CampaignAnalyticsScreenState extends State<CampaignAnalyticsScreen> {
  final supabase = Supabase.instance.client;

  Map<String, dynamic> analytics = {
    'totalBudget': 0.0,
    'totalSpent': 0.0,
    'active': 0,
    'draft': 0,
    'completed': 0,
    'totalCampaigns': 0,
    'acceptedOffers': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
    _listenForChanges();
  }

  /// 🔹 Fetch campaign + influencer analytics
  Future<void> _loadAnalytics() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      // ✅ Fetch all campaigns by this brand
      final campaignsRes = await supabase
          .from('campaigns')
          .select()
          .eq('brand_id', user.id);

      final campaigns = List<Map<String, dynamic>>.from(campaignsRes);
      double totalBudget = 0;
      double totalSpent = 0;
      int active = 0, draft = 0, completed = 0;

      for (var c in campaigns) {
        totalBudget += (c['budget'] ?? 0).toDouble();
        totalSpent += (c['spent'] ?? 0).toDouble();

        switch (c['status']) {
          case 'active':
            active++;
            break;
          case 'draft':
            draft++;
            break;
          case 'completed':
            completed++;
            break;
        }
      }

      // ✅ Fetch accepted influencer offers for brand's campaigns
      int acceptedCount = 0;
      if (campaigns.isNotEmpty) {
        final ids = campaigns.map((c) => c['id']).toList();

        // 👇 Correct replacement for `.in_()` in Supabase Dart v2+
        final acceptedOffersRes = await supabase
            .from('campaign_influencers')
            .select('id')
            .filter('campaign_id', 'in', '(${ids.join(",")})')
            .eq('status', 'accepted');

        acceptedCount = (acceptedOffersRes as List).length;
      }

      setState(() {
        analytics = {
          'totalBudget': totalBudget,
          'totalSpent': totalSpent,
          'active': active,
          'draft': draft,
          'completed': completed,
          'totalCampaigns': campaigns.length,
          'acceptedOffers': acceptedCount,
        };
      });
    } catch (e) {
      print("❌ loadAnalytics error: $e");
    }
  }

  /// 🔹 Listen for realtime changes in campaigns or influencers
  void _listenForChanges() {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    supabase
        .channel('brand_analytics')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'campaigns',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'brand_id',
            value: user.id,
          ),
          callback: (_) => _loadAnalytics(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'campaign_influencers',
          callback: (_) => _loadAnalytics(),
        )
        .subscribe();
  }

  @override
  Widget build(BuildContext context) {
    final double spent = analytics['totalSpent'];
    final double budget = analytics['totalBudget'];
    final double utilization =
        budget > 0 ? (spent / budget * 100).clamp(0, 100) : 0;

    return Scaffold(
      appBar: AppBar(title: const Text("Campaign Analytics")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Campaign Overview",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: SfCircularChart(
                legend: const Legend(isVisible: true),
                series: <CircularSeries>[
                  PieSeries<_ChartData, String>(
                    dataSource: [
                      _ChartData('Active', analytics['active']),
                      _ChartData('Draft', analytics['draft']),
                      _ChartData('Completed', analytics['completed']),
                    ],
                    xValueMapper: (_ChartData data, _) => data.label,
                    yValueMapper: (_ChartData data, _) => data.value,
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text("Budget Overview",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries>[
                  ColumnSeries<_ChartData, String>(
                    dataSource: [
                      _ChartData('Total Budget', budget),
                      _ChartData('Total Spent', spent),
                      _ChartData('Remaining', budget - spent),
                    ],
                    xValueMapper: (_ChartData data, _) => data.label,
                    yValueMapper: (_ChartData data, _) => data.value,
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: true),
                    color: Colors.teal,
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text("📊 Total Campaigns: ${analytics['totalCampaigns']}"),
            Text("✅ Accepted Offers: ${analytics['acceptedOffers']}"),
            Text("💰 Budget Utilization: ${utilization.toStringAsFixed(1)}%"),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  final String label;
  final num value;
  _ChartData(this.label, this.value);
}
