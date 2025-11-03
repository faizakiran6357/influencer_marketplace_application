// // lib/providers/chat_provider.dart
// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/chat_model.dart';
// import '../models/message_model.dart';
// import '../services/chat_service.dart';

// class ChatProvider with ChangeNotifier {
//   final ChatService _svc = ChatService();
//   List<ChatModel> chats = [];
//   Map<String, List<MessageModel>> messages = {};
//   bool loadingChats = false;
//   Map<String, bool> loadingMessages = {};
//   Timer? _pollTimer;

//   ChatProvider() {
//     _startPolling();
//     refreshChats();
//   }

//   void disposeProvider() {
//     _pollTimer?.cancel();
//   }

//   void _startPolling() {
//     _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
//       await refreshChats();
//     });
//   }

//   Future<void> refreshChats() async {
//     loadingChats = true;
//     notifyListeners();
//     final list = await _svc.getUserChats();
//     chats = list;
//     loadingChats = false;
//     notifyListeners();
//   }

//   Future<void> loadMessages(String chatId) async {
//     loadingMessages[chatId] = true;
//     notifyListeners();
//     final msgs = await _svc.getMessages(chatId, limit: 500);
//     messages[chatId] = msgs;
//     loadingMessages[chatId] = false;
//     notifyListeners();
//   }

//   Future<void> sendText(String chatId, String text) async {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user == null) return;
//     final msg = MessageModel(
//       id: '',
//       chatId: chatId,
//       senderId: user.id,
//       content: text,
//       createdAt: DateTime.now(),
//     );
//     messages.putIfAbsent(chatId, () => []);
//     messages[chatId]!.add(msg);
//     notifyListeners();
//     await _svc.sendMessage(msg);
//     await loadMessages(chatId);
//   }

//   Future<void> sendImage(String chatId, File file) async {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user == null) return;
//     final filename = file.path.split('/').last;
//     final path = '$chatId/${DateTime.now().millisecondsSinceEpoch}_$filename';
//     final url = await _svc.uploadAttachment(file, path);
//     if (url == null) return;
//     final msg = MessageModel(
//       id: '',
//       chatId: chatId,
//       senderId: user.id,
//       content: null,
//       attachmentUrl: url,
//       attachmentMeta: {'name': filename, 'size': file.lengthSync()},
//       createdAt: DateTime.now(),
//     );
//     messages.putIfAbsent(chatId, () => []);
//     messages[chatId]!.add(msg);
//     notifyListeners();
//     await _svc.sendMessage(msg);
//     await loadMessages(chatId);
//   }

//   Future<void> markAllRead(String chatId) async {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user == null) return;
//     final list = messages[chatId] ?? [];
//     for (final m in list) {
//       if (!m.readBy.contains(user.id)) {
//         await _svc.markMessageRead(m.id, user.id);
//       }
//     }
//     await loadMessages(chatId);
//   }
// }
// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/chat_model.dart';
// import '../models/message_model.dart';
// import '../services/chat_service.dart';

// class ChatProvider with ChangeNotifier {
//   final ChatService _svc = ChatService();
//   List<ChatModel> chats = [];
//   Map<String, List<MessageModel>> messages = {};
//   bool loadingChats = false;
//   Map<String, bool> loadingMessages = {};
//   Timer? _pollTimer;

//   ChatProvider() {
//     _startPolling();
//     refreshChats();
//   }

//   /// Cancel polling when provider is disposed
//   void disposeProvider() {
//     _pollTimer?.cancel();
//   }

//   void _startPolling() {
//     _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
//       await refreshChats();
//     });
//   }

//   /// Fetch all chats
//   Future<void> refreshChats() async {
//     loadingChats = true;
//     notifyListeners();
//     try {
//       final list = await _svc.getUserChats();
//       chats = list;
//     } catch (e) {
//       debugPrint('refreshChats error: $e');
//     }
//     loadingChats = false;
//     notifyListeners();
//   }

//   /// Load messages for a chat
//   Future<void> loadMessages(String chatId) async {
//     loadingMessages[chatId] = true;
//     notifyListeners();
//     try {
//       final msgs = await _svc.getMessages(chatId, limit: 500);
//       messages[chatId] = msgs;
//     } catch (e) {
//       debugPrint('loadMessages error: $e');
//       messages[chatId] = [];
//     }
//     loadingMessages[chatId] = false;
//     notifyListeners();
//   }

//   /// Send a text message
//   Future<void> sendText(String chatId, String text) async {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user == null || text.trim().isEmpty) return;

//     final msg = MessageModel(
//       id: '',
//       chatId: chatId,
//       senderId: user.id,
//       content: text.trim(),
//       createdAt: DateTime.now(),
//     );

//     messages.putIfAbsent(chatId, () => []);
//     messages[chatId]!.add(msg);
//     notifyListeners();

//     try {
//       final success = await _svc.sendMessage(msg);
//       if (!success) {
//         debugPrint('sendText failed to save message.');
//       }
//     } catch (e) {
//       debugPrint('sendText error: $e');
//     }

//     await loadMessages(chatId);
//   }

//   /// Send an image message
//   Future<void> sendImage(String chatId, File file) async {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user == null) return;

//     final filename = file.path.split('/').last;
//     final path = '$chatId/${DateTime.now().millisecondsSinceEpoch}_$filename';

//     String? url;
//     try {
//       url = await _svc.uploadAttachment(file, path);
//       if (url == null) {
//         debugPrint('sendImage: upload returned null');
//         return;
//       }
//     } catch (e) {
//       debugPrint('sendImage upload error: $e');
//       return;
//     }

//     final msg = MessageModel(
//       id: '',
//       chatId: chatId,
//       senderId: user.id,
//       content: null,
//       attachmentUrl: url,
//       attachmentMeta: {'name': filename, 'size': file.lengthSync()},
//       createdAt: DateTime.now(),
//     );

//     messages.putIfAbsent(chatId, () => []);
//     messages[chatId]!.add(msg);
//     notifyListeners();

//     try {
//       final success = await _svc.sendMessage(msg);
//       if (!success) {
//         debugPrint('sendImage failed to save message.');
//       }
//     } catch (e) {
//       debugPrint('sendImage sendMessage error: $e');
//     }

//     await loadMessages(chatId);
//   }

//   /// Mark all messages as read for a chat
//   Future<void> markAllRead(String chatId) async {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user == null) return;

//     final list = messages[chatId] ?? [];
//     for (final m in list) {
//       if (!m.readBy.contains(user.id)) {
//         try {
//           await _svc.markMessageRead(m.id, user.id);
//         } catch (e) {
//           debugPrint('markAllRead error: $e');
//         }
//       }
//     }
//     await loadMessages(chatId);
//   }
// }
// lib/providers/chat_provider.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _svc = ChatService();
  List<ChatModel> chats = [];
  Map<String, List<MessageModel>> messages = {};
  bool loadingChats = false;
  Map<String, bool> loadingMessages = {};
  Timer? _pollTimer;

  ChatProvider() {
    _startPolling();
    refreshChats();
  }

  void disposeProvider() {
    _pollTimer?.cancel();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      await refreshChats();
    });
  }

  Future<void> refreshChats() async {
    loadingChats = true;
    notifyListeners();
    try {
      final list = await _svc.getUserChats();
      chats = list;
    } catch (e) {
      debugPrint('refreshChats error: $e');
    }
    loadingChats = false;
    notifyListeners();
  }

  Future<void> loadMessages(String chatId) async {
    loadingMessages[chatId] = true;
    notifyListeners();
    try {
      final msgs = await _svc.getMessages(chatId, limit: 500);
      messages[chatId] = msgs;
    } catch (e) {
      debugPrint('loadMessages error: $e');
      messages[chatId] = [];
    }
    loadingMessages[chatId] = false;
    notifyListeners();
  }

  Future<void> sendText(String chatId, String text) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || text.trim().isEmpty) return;

    final msg = MessageModel(
      id: '',
      chatId: chatId,
      senderId: user.id,
      text: text.trim(),
      createdAt: DateTime.now(),
    );

    messages.putIfAbsent(chatId, () => []);
    messages[chatId]!.add(msg);
    notifyListeners();

    try {
      await _svc.sendMessage(msg);
    } catch (e) {
      debugPrint('sendText error: $e');
    }

    await loadMessages(chatId);
  }

  Future<void> sendImage(String chatId, File file) async {
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
      id: '',
      chatId: chatId,
      senderId: user.id,
      type: 'image',
      attachmentUrl: url,
      attachmentMeta: {'name': filename, 'size': file.lengthSync()},
      createdAt: DateTime.now(),
    );

    messages.putIfAbsent(chatId, () => []);
    messages[chatId]!.add(msg);
    notifyListeners();

    try {
      await _svc.sendMessage(msg);
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

  /// Delete message from backend
  Future<void> deleteMessage(MessageModel msg) async {
    try {
      await _svc.deleteMessage(msg.id);
      msg.deleted = true;
      notifyListeners();
    } catch (e) {
      debugPrint('deleteMessage error: $e');
    }
  }

  /// Edit message and update backend
  Future<void> editMessage(MessageModel msg, String newText) async {
    msg.text = newText;
    try {
      await _svc.updateMessage(msg);
      notifyListeners();
    } catch (e) {
      debugPrint('editMessage error: $e');
    }
  }

  /// Add reaction to message
  Future<void> addReaction(MessageModel msg, String emoji) async {
    if (!msg.reactions.contains(emoji)) msg.reactions.add(emoji);
    try {
      await _svc.updateMessage(msg);
      notifyListeners();
    } catch (e) {
      debugPrint('addReaction error: $e');
    }
  }
}
