// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:provider/provider.dart';
// import '../../providers/influencer_provider.dart';

// class AudienceAnalyticsScreen extends StatelessWidget {
//   const AudienceAnalyticsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final audience = context.watch<InfluencerProvider>().audience;

//     if (audience == null) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text("Audience Analytics")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Text("Followers by Gender"),
//             SizedBox(
//               height: 200,
//               child: PieChart(
//                 PieChartData(sections: [
//                   PieChartSectionData(
//                       value: audience.genderMale.toDouble(),
//                       color: Colors.blue,
//                       title: 'Male'),
//                   PieChartSectionData(
//                       value: audience.genderFemale.toDouble(),
//                       color: Colors.pink,
//                       title: 'Female'),
//                   PieChartSectionData(
//                       value: audience.genderOther.toDouble(),
//                       color: Colors.green,
//                       title: 'Other'),
//                 ]),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text("Followers by Age Group"),
//             SizedBox(
//               height: 200,
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   maxY: (audience.age18_24 +
//                           audience.age25_34 +
//                           audience.age35Plus)
//                       .toDouble(),
//                   barGroups: [
//                     BarChartGroupData(
//                         x: 0,
//                         barRods: [
//                           BarChartRodData(
//                               toY: audience.age18_24.toDouble(),
//                               color: Colors.blue)
//                         ],
//                         showingTooltipIndicators: [0]),
//                     BarChartGroupData(
//                         x: 1,
//                         barRods: [
//                           BarChartRodData(
//                               toY: audience.age25_34.toDouble(),
//                               color: Colors.pink)
//                         ],
//                         showingTooltipIndicators: [0]),
//                     BarChartGroupData(
//                         x: 2,
//                         barRods: [
//                           BarChartRodData(
//                               toY: audience.age35Plus.toDouble(),
//                               color: Colors.green)
//                         ],
//                         showingTooltipIndicators: [0]),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../providers/influencer_provider.dart';

class AudienceAnalyticsScreen extends StatelessWidget {
  const AudienceAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audience = context.watch<InfluencerProvider>().audience;

    if (audience == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Audience Analytics")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Followers by Gender",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: SfCircularChart(
                series: <PieSeries<GenderData, String>>[
                  PieSeries<GenderData, String>(
                    dataSource: [
                      GenderData('Male', audience.genderMale),
                      GenderData('Female', audience.genderFemale),
                      GenderData('Other', audience.genderOther),
                    ],
                    xValueMapper: (GenderData data, _) => data.label,
                    yValueMapper: (GenderData data, _) => data.value,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Followers by Age Group",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                series: <CartesianSeries<AgeData, String>>[
                  ColumnSeries<AgeData, String>(
                    dataSource: [
                      AgeData('18-24', audience.age18_24),
                      AgeData('25-34', audience.age25_34),
                      AgeData('35+', audience.age35Plus),
                    ],
                    xValueMapper: (AgeData data, _) => data.label,
                    yValueMapper: (AgeData data, _) => data.value.toDouble(),
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GenderData {
  final String label;
  final int value;
  GenderData(this.label, this.value);
}

class AgeData {
  final String label;
  final int value;
  AgeData(this.label, this.value);
}
