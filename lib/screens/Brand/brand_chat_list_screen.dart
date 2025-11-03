
// lib/screens/brand/brand_chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/utils/app_theme.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/chat_model.dart';
import 'brand_chat_screen.dart';

class BrandChatListScreen extends StatefulWidget {
  const BrandChatListScreen({Key? key}) : super(key: key);

  @override
  State<BrandChatListScreen> createState() => _BrandChatListScreenState();
}

class _BrandChatListScreenState extends State<BrandChatListScreen> {
  @override
  void initState() {
    super.initState();

    // ✅ Fix: call provider only after widget build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).refreshChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages (Brand)'),
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
                  borderRadius: BorderRadius.circular(12),
                ),
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
                    builder: (_) => BrandChatScreen(chatId: c.id,
                   ),
                  ),
                )
              );
            },
          );
        },
      ),
    );
  }
}
