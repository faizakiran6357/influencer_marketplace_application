
// // lib/screens/influencer/influencer_chat_list_screen.dart
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/utils/app_theme.dart';
// import 'package:provider/provider.dart';
// import '../../providers/chat_provider.dart';
// import '../../models/chat_model.dart';
// import 'influencer_chat_screen.dart';

// class InfluencerChatListScreen extends StatefulWidget {
//   const InfluencerChatListScreen({Key? key}) : super(key: key);

//   @override
//   State<InfluencerChatListScreen> createState() =>
//       _InfluencerChatListScreenState();
// }

// class _InfluencerChatListScreenState extends State<InfluencerChatListScreen> {
//   @override
//   void initState() {
//     super.initState();

//     // ✅ Fix: Delay provider call until after the first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ChatProvider>(context, listen: false).refreshChats();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Messages (Influencer)'),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: Consumer<ChatProvider>(
//         builder: (context, cp, _) {
//           if (cp.loadingChats) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (cp.chats.isEmpty) {
//             return const Center(child: Text('No conversations yet'));
//           }

//           return ListView.separated(
//             padding: const EdgeInsets.all(12),
//             separatorBuilder: (_, __) => const SizedBox(height: 8),
//             itemCount: cp.chats.length,
//             itemBuilder: (context, i) {
//               final ChatModel c = cp.chats[i];
//               return ListTile(
//                 tileColor: Theme.of(context).cardColor,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 title: Text(
//                   c.title ?? 'Conversation',
//                   style: const TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 subtitle: Text(
//                   c.lastMessageText ?? '',
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 trailing: c.lastMessageAt != null
//                     ? Text(
//                         TimeOfDay.fromDateTime(c.lastMessageAt!)
//                             .format(context),
//                         style: const TextStyle(fontSize: 12),
//                       )
//                     : null,
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => InfluencerChatScreen(chatId: c.id),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/utils/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/chat_provider.dart';
import '../../models/chat_model.dart';
import 'influencer_chat_screen.dart';

class InfluencerChatListScreen extends StatefulWidget {
  const InfluencerChatListScreen({Key? key}) : super(key: key);

  @override
  State<InfluencerChatListScreen> createState() =>
      _InfluencerChatListScreenState();
}

class _InfluencerChatListScreenState extends State<InfluencerChatListScreen> {
  final Map<String, Map<String, dynamic>> _partnerCache = {}; // chatId → {name, profile_image}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).refreshChats();
    });
  }

  Future<Map<String, dynamic>?> _loadPartnerInfo(String chatId) async {
    if (_partnerCache.containsKey(chatId)) return _partnerCache[chatId];

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      // Get participants
      final participants = await Supabase.instance.client
          .from('chat_participants')
          .select('user_id')
          .eq('chat_id', chatId);

      final partner = (participants as List)
          .cast<Map<String, dynamic>>()
          .firstWhere((p) => p['user_id'] != userId, orElse: () => {});

      if (partner.isEmpty) return null;

      // Fetch partner profile
      final partnerProfile = await Supabase.instance.client
          .from('profiles')
          .select('name, profile_image')
          .eq('id', partner['user_id'])
          .maybeSingle();

      if (partnerProfile != null) {
        _partnerCache[chatId] = partnerProfile;
        return partnerProfile;
      }
    } catch (e) {
      debugPrint('❌ Error loading partner for $chatId: $e');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages (Influencer)'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Consumer<ChatProvider>(
        builder: (context, cp, _) {
          if (cp.loadingChats) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cp.chats.isEmpty) {
            return const Center(child: Text('No conversations yet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: cp.chats.length,
            itemBuilder: (context, i) {
              final ChatModel c = cp.chats[i];

              return FutureBuilder<Map<String, dynamic>?>(
                future: _loadPartnerInfo(c.id),
                builder: (context, snapshot) {
                  final partner = snapshot.data;
                  final name = partner?['name'] ?? 'User';
                  final image = partner?['profile_image'];

                  return ListTile(
                    tileColor: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          image != null && image.isNotEmpty ? NetworkImage(image) : null,
                      child: image == null || image.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      c.lastMessageText ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: c.lastMessageAt != null
                        ? Text(
                            TimeOfDay.fromDateTime(c.lastMessageAt!)
                                .format(context),
                            style: const TextStyle(fontSize: 12),
                          )
                        : null,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InfluencerChatScreen(chatId: c.id),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
