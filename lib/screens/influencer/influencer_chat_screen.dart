// lib/screens/influencer/influencer_chat_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/utils/app_theme.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/message_input.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class InfluencerChatScreen extends StatefulWidget {
  final String chatId;
  const InfluencerChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  State<InfluencerChatScreen> createState() => _InfluencerChatScreenState();
}

class _InfluencerChatScreenState extends State<InfluencerChatScreen> {
  late ChatProvider cp;
  final ScrollController _sc = ScrollController();

  @override
  void initState() {
    super.initState();
    cp = Provider.of<ChatProvider>(context, listen: false);
    cp.loadMessages(widget.chatId).then((_) {
      cp.markAllRead(widget.chatId);
      _jumpToBottom();
    });
  }

  void _jumpToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_sc.hasClients) _sc.jumpTo(_sc.position.maxScrollExtent);
    });
  }

  Future<void> _onSendText(String text) async {
    await cp.sendText(widget.chatId, text);
    _jumpToBottom();
  }

  Future<void> _onSendImage(File image) async {
    await cp.sendImage(widget.chatId, image);
    _jumpToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, cp, _) {
                final msgs = cp.messages[widget.chatId] ?? [];
                if (cp.loadingMessages[widget.chatId] == true && msgs.isEmpty) return const Center(child: CircularProgressIndicator());
                return ListView.builder(
                  controller: _sc,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: msgs.length,
                  itemBuilder: (context, i) {
                    final m = msgs[i];
                    final isMine = user != null && m.senderId == user.id;
                    return MessageBubble(message: m, isMine: isMine);
                  },
                );
              },
            ),
          ),
          MessageInput(onSendText: _onSendText, onSendImage: _onSendImage),
        ],
      ),
    );
  }
}
