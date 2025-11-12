
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

//   /// 🔹 Fetch campaign + influencer analytics
//   Future<void> _loadAnalytics() async {
//     final user = supabase.auth.currentUser;
//     if (user == null) return;

//     try {
//       // ✅ Fetch all campaigns by this brand
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

//       // ✅ Fetch accepted influencer offers for brand's campaigns
//       int acceptedCount = 0;
//       if (campaigns.isNotEmpty) {
//         final ids = campaigns.map((c) => c['id']).toList();

//         // 👇 Correct replacement for `.in_()` in Supabase Dart v2+
//         final acceptedOffersRes = await supabase
//             .from('campaign_influencers')
//             .select('id')
//             .filter('campaign_id', 'in', '(${ids.join(",")})')
//             .eq('status', 'accepted');

//         acceptedCount = (acceptedOffersRes as List).length;
//       }

//       setState(() {
//         analytics = {
//           'totalBudget': totalBudget,
//           'totalSpent': totalSpent,
//           'active': active,
//           'draft': draft,
//           'completed': completed,
//           'totalCampaigns': campaigns.length,
//           'acceptedOffers': acceptedCount,
//         };
//       });
//     } catch (e) {
//       print("❌ loadAnalytics error: $e");
//     }
//   }

//   /// 🔹 Listen for realtime changes in campaigns or influencers
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
import 'package:influencer_marketplace_application/utils/app_theme.dart';
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
    'remainingBudget': 0.0,
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
      final campaignsRes = await supabase
          .from('campaigns')
          .select()
          .eq('brand_id', user.id);

      final campaigns = List<Map<String, dynamic>>.from(campaignsRes);
      double totalBudget = 0;
      double totalSpent = 0;
      int active = 0, draft = 0, completed = 0;

      for (var c in campaigns) {
        final double budget = (c['budget'] ?? 0).toDouble();
        totalBudget += budget;

        switch (c['status']) {
          case 'active':
            active++;
            // If you track exact spent, replace this logic with actual spent field.
            // For now active shows a simulated partial spend (50%).
            totalSpent += budget * 0.5;
            break;
          case 'draft':
            draft++;
            break;
          case 'completed':
            completed++;
            // Completed campaigns consume their full budget as spent
            totalSpent += budget;
            break;
        }
      }

      double remaining = (totalBudget - totalSpent).clamp(0, totalBudget);

      // ✅ Fetch accepted influencer offers
      int acceptedCount = 0;
      if (campaigns.isNotEmpty) {
        final ids = campaigns.map((c) => c['id']).toList();
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
          'remainingBudget': remaining,
          'active': active,
          'draft': draft,
          'completed': completed,
          'totalCampaigns': campaigns.length,
          'acceptedOffers': acceptedCount,
        };
      });
    } catch (e) {
      debugPrint("❌ loadAnalytics error: $e");
    }
  }

  /// 🔹 Listen for realtime changes
  void _listenForChanges() {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    supabase
        .channel('brand_analytics')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'campaigns',
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
    final double remaining = analytics['remainingBudget'];
    final double utilization =
        budget > 0 ? (spent / budget * 100).clamp(0, 100) : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Campaign Analytics"),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadAnalytics,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Row 1: two summary cards (Total Campaigns, Accepted Offers)
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      "Total Campaigns",
                      analytics['totalCampaigns'].toString(),
                      Icons.campaign_outlined,
                      Colors.indigo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      "Accepted Offers",
                      analytics['acceptedOffers'].toString(),
                      Icons.check_circle_outline,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Row 2: two summary cards (Total Budget, Spent)
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      "Total Budget",
                      "\$${budget.toStringAsFixed(0)}",
                      Icons.account_balance_wallet_outlined,
                      Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      "Spent",
                      "\$${spent.toStringAsFixed(0)}",
                      Icons.trending_down_outlined,
                      Colors.redAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Full width remaining budget card
              _buildStatCard(
                "Remaining Budget",
                "\$${remaining.toStringAsFixed(0)}",
                Icons.savings_outlined,
                Colors.teal,
                fullWidth: true,
              ),

              const SizedBox(height: 20),
              _buildSectionTitle("📊 Campaign Status Overview"),
              const SizedBox(height: 12),
              _buildPieChart(),

              const SizedBox(height: 28),
              _buildSectionTitle("💰 Budget Distribution"),
              const SizedBox(height: 12),
              _buildBudgetChart(budget, spent, remaining),

              const SizedBox(height: 28),
              _buildUtilizationMeter(utilization),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Chart + UI Widgets

  Widget _buildStatCard(String title, String value, IconData icon, Color color,
      {bool fullWidth = false}) {
    // Card contents (no fixed width). Parent Row uses Expanded to control width preventing overflow.
    final card = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.18), color.withOpacity(0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(height: 4),
                Text(title,
                    style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: card);
    } else {
      return card;
    }
  }

  Widget _buildPieChart() {
    return SizedBox(
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
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetChart(double budget, double spent, double remaining) {
    return SizedBox(
      height: 220,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <CartesianSeries>[
          ColumnSeries<_ChartData, String>(
            dataSource: [
              _ChartData('Total Budget', budget),
              _ChartData('Spent', spent),
              _ChartData('Remaining', remaining),
            ],
            xValueMapper: (_ChartData data, _) => data.label,
            yValueMapper: (_ChartData data, _) => data.value,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            color: AppTheme.primaryColor,
          )
        ],
      ),
    );
  }

  Widget _buildUtilizationMeter(double utilization) {
    return Column(
      children: [
        Text(
          "Budget Utilization",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: utilization / 100,
                strokeWidth: 10,
                backgroundColor: Colors.grey.shade300,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            ),
            Text(
              "${utilization.toStringAsFixed(1)}%",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) => Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
      );
}

class _ChartData {
  final String label;
  final num value;
  _ChartData(this.label, this.value);
}
