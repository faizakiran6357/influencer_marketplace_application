import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/influencer_provider.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId != null) {
      context.read<InfluencerProvider>().fetchEarnings(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final earnings = context.watch<InfluencerProvider>().earnings;

    double total = 0;
    for (var e in earnings) {
      total += (e['amount'] ?? 0) as double;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Earnings Overview")),
      body: earnings.isEmpty
          ? const Center(child: Text("No earnings yet"))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    color: Colors.green.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Earnings",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Text("\$${total.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: earnings.length,
                    itemBuilder: (_, i) {
                      final e = earnings[i];
                      return ListTile(
                        leading: const Icon(Icons.attach_money, color: Colors.green),
                        title: Text(e['description'] ?? 'Payment'),
                        subtitle: Text(e['created_at'] ?? ''),
                        trailing: Text("\$${e['amount']}"),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
