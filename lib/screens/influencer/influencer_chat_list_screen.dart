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
//   State<InfluencerChatListScreen> createState() => _InfluencerChatListScreenState();
// }

// class _InfluencerChatListScreenState extends State<InfluencerChatListScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<ChatProvider>(context, listen: false).refreshChats();
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
//           if (cp.loadingChats) return const Center(child: CircularProgressIndicator());
//           if (cp.chats.isEmpty) return const Center(child: Text('No conversations yet'));
//           return ListView.separated(
//             padding: const EdgeInsets.all(12),
//             separatorBuilder: (_, __) => const SizedBox(height: 8),
//             itemCount: cp.chats.length,
//             itemBuilder: (context, i) {
//               final ChatModel c = cp.chats[i];
//               return ListTile(
//                 tileColor: Theme.of(context).cardColor,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 title: Text(c.title ?? 'Conversation'),
//                 subtitle: Text(c.lastMessageText ?? ''),
//                 trailing: c.lastMessageAt != null ? Text(TimeOfDay.fromDateTime(c.lastMessageAt!).format(context)) : null,
//                 onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InfluencerChatScreen(chatId: c.id))),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
// lib/screens/influencer/influencer_chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/utils/app_theme.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    super.initState();

    // ✅ Fix: Delay provider call until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).refreshChats();
    });
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
              return ListTile(
                tileColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                title: Text(
                  c.title ?? 'Conversation',
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
      ),
    );
  }
}
