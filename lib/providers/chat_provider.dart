
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';
import '../services/notification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _svc = ChatService();
  List<ChatModel> chats = [];
  Map<String, List<MessageModel>> messages = {};
  bool loadingChats = false;
  Map<String, bool> loadingMessages = {};
  Timer? _pollTimer;

  ChatProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPolling();
      refreshChats();
    });
  }

  void disposeProvider() {
    _pollTimer?.cancel();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      await refreshChats();
    });
  }

  void safeNotify() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasListeners) notifyListeners();
    });
  }

  Future<void> refreshChats() async {
    loadingChats = true;
    safeNotify();
    try {
      final list = await _svc.getUserChats();
      chats = list;
    } catch (e) {
      debugPrint('refreshChats error: $e');
    }
    loadingChats = false;
    safeNotify();
  }

  Future<void> loadMessages(String chatId) async {
    loadingMessages[chatId] = true;
    safeNotify();
    try {
      final msgs = await _svc.getMessages(chatId, limit: 500);
      messages[chatId] = msgs;
    } catch (e) {
      debugPrint('loadMessages error: $e');
      messages[chatId] = [];
    }
    loadingMessages[chatId] = false;
    safeNotify();
  }

  /// ✅ Send text message with optional notification to receiver
  Future<void> sendText(String chatId, String text, {String? receiverId}) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || text.trim().isEmpty) return;

    final msg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      senderId: user.id,
      text: text.trim(),
      createdAt: DateTime.now(),
    );

    messages.putIfAbsent(chatId, () => []);
    messages[chatId]!.add(msg);
    safeNotify();

    try {
      await _svc.sendMessage(msg);

      // ✅ Send notification if receiverId provided
      if (receiverId != null) {
        final token = await _getUserFcmToken(receiverId);
        if (token != null) {
          await NotificationService.sendPushMessage(
            targetToken: token,
            title: 'New Message',
            body: text.trim(),
          );
        }
      }
    } catch (e) {
      debugPrint('sendText error: $e');
    }

    await loadMessages(chatId);
  }

  /// ✅ Send image message with optional notification to receiver
  Future<void> sendImage(String chatId, File file, {String? receiverId}) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final filename = file.path.split('/').last;
    final path = '$chatId/${DateTime.now().millisecondsSinceEpoch}_$filename';
    String? url;
    try {
      url = await _svc.uploadAttachment(file, path);
      if (url == null) return;
    } catch (e) {
      debugPrint('sendImage upload error: $e');
      return;
    }

    final msg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      senderId: user.id,
      type: 'image',
      attachmentUrl: url,
      attachmentMeta: {'name': filename, 'size': file.lengthSync()},
      createdAt: DateTime.now(),
    );

    messages.putIfAbsent(chatId, () => []);
    messages[chatId]!.add(msg);
    safeNotify();

    try {
      await _svc.sendMessage(msg);

      // ✅ Send notification if receiverId provided
      if (receiverId != null) {
        final token = await _getUserFcmToken(receiverId);
        if (token != null) {
          await NotificationService.sendPushMessage(
            targetToken: token,
            title: 'New Image',
            body: 'Sent an image',
          );
        }
      }
    } catch (e) {
      debugPrint('sendImage sendMessage error: $e');
    }

    await loadMessages(chatId);
  }

  Future<void> markAllRead(String chatId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final list = messages[chatId] ?? [];
    for (final m in list) {
      if (!m.readBy.contains(user.id)) {
        try {
          await _svc.markMessageRead(m.id, user.id);
        } catch (e) {
          debugPrint('markAllRead error: $e');
        }
      }
    }
    await loadMessages(chatId);
  }

  // Future<void> deleteMessage(MessageModel msg) async {
  //   try {
  //     await _svc.deleteMessage(msg.id);
  //     msg.deleted = true;
  //     safeNotify();
  //   } catch (e) {
  //     debugPrint('deleteMessage error: $e');
  //   }
  // }
  Future<void> deleteMessage(MessageModel msg) async {
  try {
    await _svc.deleteMessage(msg.id); // delete from backend
    final chatMsgs = messages[msg.chatId];
    if (chatMsgs != null) {
      chatMsgs.removeWhere((m) => m.id == msg.id); // remove from local list
    }
    safeNotify();
  } catch (e) {
    debugPrint('deleteMessage error: $e');
  }
}


  Future<void> editMessage(MessageModel msg, String newText) async {
    msg.text = newText;
    try {
      await _svc.updateMessage(msg);
      safeNotify();
    } catch (e) {
      debugPrint('editMessage error: $e');
    }
  }

  Future<void> addReaction(MessageModel msg, String emoji) async {
    if (!msg.reactions.contains(emoji)) msg.reactions.add(emoji);
    try {
      await _svc.updateMessage(msg);
      safeNotify();
    } catch (e) {
      debugPrint('addReaction error: $e');
    }
  }

  /// Helper to get FCM token of a user
  Future<String?> _getUserFcmToken(String userId) async {
    try {
      final profile = await Supabase.instance.client
          .from('profiles')
          .select('fcm_token')
          .eq('id', userId)
          .maybeSingle();
      return profile?['fcm_token'];
    } catch (e) {
      debugPrint('getUserFcmToken error: $e');
      return null;
    }
  }
}
