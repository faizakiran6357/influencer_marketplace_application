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
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/auth_provider.dart';
import '../../providers/influencer_provider.dart';
import '../../providers/theme_provider.dart';

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
    final themeProvider = context.watch<ThemeProvider>();
    final earnings = provider.earnings;
    final primary = Theme.of(context).primaryColor;
    final isDark = themeProvider.isDark;

    double total = 0;
    for (var e in earnings) {
      total += (e['amount'] ?? 0).toDouble();
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        title: const Text(
          "Earnings Overview",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: -0.3,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: primary,
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadEarnings,
              color: primary,
              child: earnings.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.wallet,
                            size: 64,
                            color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No earnings yet",
                            style: TextStyle(
                              fontSize: 15,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Your earnings will appear here",
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // Premium Total Earnings Card
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  primary,
                                  primary.withOpacity(0.8),
                                  const Color(0xFF10B981),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: const [0.0, 0.5, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: primary.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.25),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        LucideIcons.wallet,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      "Total Earnings",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              "\$${total.toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                                letterSpacing: -0.5,
                                                height: 1.0,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              "USD",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        LucideIcons.trendingUp,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Earnings List
                        Expanded(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                padding: const EdgeInsets.only(bottom: 12),
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
                                        backgroundColor: Colors.red.shade600,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete_outline,
                                        label: 'Delete',
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  const Color(0xFF10B981),
                                                  const Color(0xFF10B981).withOpacity(0.7),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius: BorderRadius.circular(14),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF10B981).withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              LucideIcons.dollarSign,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  description,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: isDark ? Colors.white : Colors.black87,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  formattedDate.isNotEmpty
                                                      ? formattedDate
                                                      : 'No date available',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "\$${amount.toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                  color: const Color(0xFF10B981),
                                                  letterSpacing: -0.3,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF10B981).withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: const Text(
                                                  "Paid",
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color: Color(0xFF10B981),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
            ),
    );
  }

  /// Handle delete earning item
  Future<void> _deleteEarning(Map<String, dynamic> e) async {
    final themeProvider = context.read<ThemeProvider>();
    final isDark = themeProvider.isDark;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              "Delete Earning",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to delete this earning record?",
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.grey.shade300 : Colors.black87,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade600, Colors.red.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await context
          .read<InfluencerProvider>()
          .deleteEarning(e['id']);
      if (mounted) _loadEarnings();
    } catch (err) {
      debugPrint('❌ deleteEarning error: $err');
    }
  }
}
