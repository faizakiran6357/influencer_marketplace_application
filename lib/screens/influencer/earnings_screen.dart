// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';

// class EarningsScreen extends StatefulWidget {
//   const EarningsScreen({super.key});

//   @override
//   State<EarningsScreen> createState() => _EarningsScreenState();
// }

// class _EarningsScreenState extends State<EarningsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     final userId = context.read<AuthProvider>().currentUser?.id;
//     if (userId != null) {
//       context.read<InfluencerProvider>().fetchEarnings(userId);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final earnings = context.watch<InfluencerProvider>().earnings;

//     double total = 0;
//     for (var e in earnings) {
//       total += (e['amount'] ?? 0) as double;
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text("Earnings Overview")),
//       body: earnings.isEmpty
//           ? const Center(child: Text("No earnings yet"))
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Card(
//                     color: Colors.green.shade100,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             "Total Earnings",
//                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                           ),
//                           Text("\$${total.toStringAsFixed(2)}",
//                               style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.green)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: earnings.length,
//                     itemBuilder: (_, i) {
//                       final e = earnings[i];
//                       return ListTile(
//                         leading: const Icon(Icons.attach_money, color: Colors.green),
//                         title: Text(e['description'] ?? 'Payment'),
//                         subtitle: Text(e['created_at'] ?? ''),
//                         trailing: Text("\$${e['amount']}"),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';

// class EarningsScreen extends StatefulWidget {
//   const EarningsScreen({super.key});

//   @override
//   State<EarningsScreen> createState() => _EarningsScreenState();
// }

// class _EarningsScreenState extends State<EarningsScreen> {
//   bool _isLoading = false;

//   Future<void> _loadEarnings() async {
//     final userId = context.read<AuthProvider>().currentUser?.id;
//     if (userId == null) return;

//     setState(() => _isLoading = true);
//     await context.read<InfluencerProvider>().fetchEarnings(userId);
//     setState(() => _isLoading = false);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadEarnings();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final earnings = context.watch<InfluencerProvider>().earnings;

//     double total = 0;
//     for (var e in earnings) {
//       total += (e['amount'] ?? 0).toDouble();
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text("Earnings Overview")),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : RefreshIndicator(
//               onRefresh: _loadEarnings,
//               child: earnings.isEmpty
//                   ? const Center(child: Text("No earnings yet"))
//                   : Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Card(
//                             color: Colors.green.shade100,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const Text(
//                                     "Total Earnings",
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                   Text(
//                                     "\$${total.toStringAsFixed(2)}",
//                                     style: const TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.green),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: ListView.builder(
//                             physics: const AlwaysScrollableScrollPhysics(),
//                             itemCount: earnings.length,
//                             itemBuilder: (_, i) {
//                               final e = earnings[i];
//                               return Card(
//                                 margin:
//                                     const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                 child: ListTile(
//                                   leading: const Icon(Icons.attach_money,
//                                       color: Colors.green),
//                                   title: Text(e['description'] ?? 'Payment'),
//                                   subtitle: Text(e['created_at'] ?? ''),
//                                   trailing:
//                                       Text("\$${e['amount']?.toStringAsFixed(2) ?? '0.00'}"),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/influencer_provider.dart';

// class EarningsScreen extends StatefulWidget {
//   const EarningsScreen({super.key});

//   @override
//   State<EarningsScreen> createState() => _EarningsScreenState();
// }

// class _EarningsScreenState extends State<EarningsScreen> {
//   bool _isLoading = false;

//   Future<void> _loadEarnings() async {
//     final userId = context.read<AuthProvider>().currentUser?.id;
//     if (userId == null) return;

//     setState(() => _isLoading = true);
//     await context.read<InfluencerProvider>().fetchEarnings(userId);
//     setState(() => _isLoading = false);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadEarnings();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final earnings = context.watch<InfluencerProvider>().earnings;

//     double total = 0;
//     for (var e in earnings) {
//       total += (e['amount'] ?? 0).toDouble();
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text("Earnings Overview")),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : RefreshIndicator(
//               onRefresh: _loadEarnings,
//               child: earnings.isEmpty
//                   ? const Center(child: Text("No earnings yet"))
//                   : Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Card(
//                             color: Colors.green.shade100,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const Text(
//                                     "Total Earnings",
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                   Text(
//                                     "\$${total.toStringAsFixed(2)}",
//                                     style: const TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.green),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: ListView.builder(
//                             physics: const AlwaysScrollableScrollPhysics(),
//                             itemCount: earnings.length,
//                             itemBuilder: (_, i) {
//                               final e = earnings[i];
//                               final amount = (e['amount'] ?? 0).toDouble();
//                               final description =
//                                   e['description'] ?? 'Payment received';
//                               final createdAt = e['created_at'];
//                               String formattedDate = '';

//                               if (createdAt != null &&
//                                   createdAt.toString().isNotEmpty) {
//                                 try {
//                                   final date = DateTime.parse(createdAt);
//                                   formattedDate =
//                                       DateFormat('MMM d, yyyy • hh:mm a')
//                                           .format(date);
//                                 } catch (_) {
//                                   formattedDate = createdAt.toString();
//                                 }
//                               }

//                               return Card(
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 12, vertical: 6),
//                                 child: ListTile(
//                                   leading: const Icon(Icons.attach_money,
//                                       color: Colors.green),
//                                   title: Text(description),
//                                   subtitle: Text(
//                                     formattedDate.isNotEmpty
//                                         ? formattedDate
//                                         : 'No date available',
//                                   ),
//                                   trailing: Text(
//                                     "\$${amount.toStringAsFixed(2)}",
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/influencer_provider.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  bool _isLoading = false;

  Future<void> _loadEarnings() async {
    final userId = context.read<AuthProvider>().currentUser?.id;
    if (userId == null) return;

    setState(() => _isLoading = true);
    await context.read<InfluencerProvider>().fetchEarnings(userId);
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _loadEarnings();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InfluencerProvider>();
    final earnings = provider.earnings;

    double total = 0;
    for (var e in earnings) {
      total += (e['amount'] ?? 0).toDouble();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Earnings Overview")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadEarnings,
              child: earnings.isEmpty
                  ? const Center(child: Text("No earnings yet"))
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Card(
                            color: Colors.green.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Total Earnings",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "\$${total.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFB25640),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: earnings.length,
                            itemBuilder: (_, i) {
                              final e = earnings[i];
                              final amount = (e['amount'] ?? 0).toDouble();
                              final description =
                                  e['description'] ?? 'Payment received';
                              final createdAt = e['created_at'];
                              String formattedDate = '';

                              if (createdAt != null &&
                                  createdAt.toString().isNotEmpty) {
                                try {
                                  final date = DateTime.parse(createdAt);
                                  formattedDate =
                                      DateFormat('MMM d, yyyy • hh:mm a')
                                          .format(date);
                                } catch (_) {
                                  formattedDate = createdAt.toString();
                                }
                              }

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Slidable(
                                  key: ValueKey(e['id'] ?? i),
                                  endActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    extentRatio: 0.25,
                                    children: [
                                      SlidableAction(
                                        onPressed: (_) async {
                                          await _deleteEarning(e);
                                        },
                                        backgroundColor: Colors.red,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 6),
                                    child: ListTile(
                                      leading: const Icon(Icons.attach_money,
                                          color: Color(0xFFB25640)),
                                      title: Text(
                                        description,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Text(
                                        formattedDate.isNotEmpty
                                            ? formattedDate
                                            : 'No date available',
                                      ),
                                      trailing: Text(
                                        "\$${amount.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  /// Handle delete earning item
  Future<void> _deleteEarning(Map<String, dynamic> e) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Earning"),
        content:
            const Text("Are you sure you want to delete this earning record?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await context
          .read<InfluencerProvider>()
          .deleteEarning(e['id']); // assumes your provider has this
      if (mounted) _loadEarnings();
    } catch (err) {
      debugPrint('❌ deleteEarning error: $err');
    }
  }
}
