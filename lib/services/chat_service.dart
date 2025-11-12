
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'notification_service.dart';

class ChatService {
  final SupabaseClient client = Supabase.instance.client;
  final String bucket = 'chat_images';

  /// Fetch all chats where current user is a participant
  Future<List<ChatModel>> getUserChats() async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) return [];

      final rows = await client
          .from('chats')
          .select('''
            id,
            title,
            campaign_id,
            is_group,
            last_message_text,
            last_message_at,
            chat_participants!inner(
              user_id,
              role,
              profiles!inner(id, name, profile_image)
            )
          ''')
          .eq('chat_participants.user_id', userId)
          .order('last_message_at', ascending: false);

      final List<Map<String, dynamic>> normalized = [];

      for (final chat in (rows as List)) {
        final Map<String, dynamic> c = Map<String, dynamic>.from(chat);
        final participants =
            (c['chat_participants'] as List?)?.cast<Map<String, dynamic>>() ?? [];

        Map<String, dynamic>? partnerProfile;

        // find the other participant (chat partner)
        for (final p in participants) {
          final pid = p['user_id']?.toString();
          if (pid != null && pid != userId) {
            partnerProfile = p['profiles'] != null
                ? Map<String, dynamic>.from(p['profiles'])
                : null;
            break;
          }
        }

        // normalize partner info
        if (partnerProfile != null) {
          c['partner_name'] = partnerProfile['name'] ?? 'User';
          c['partner_profile_url'] = partnerProfile['profile_image'] ?? '';
        } else {
          c['partner_name'] = c['title'] ?? 'Conversation';
          c['partner_profile_url'] = '';
        }

        normalized.add(c);
      }

      return normalized.map((e) => ChatModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint('❌ getUserChats error: $e');
      return [];
    }
  }

  /// Create a new chat
  Future<ChatModel?> createChat({
    required List<String> participantIds,
    String? title,
    String? campaignId,
  }) async {
    try {
      final creatorId = client.auth.currentUser?.id;
      if (creatorId == null) return null;

      final inserted = await client
          .from('chats')
          .insert({
            'title': title ?? 'Chat',
            'campaign_id': campaignId,
            'is_group': participantIds.length > 2,
            'created_by': creatorId,
          })
          .select()
          .single();

      final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

      final participants = participantIds.toSet().map((id) => {
            'chat_id': chat.id,
            'user_id': id,
            'role': id == creatorId ? 'creator' : 'member',
          });

      await client.from('chat_participants').insert(participants.toList());

      return chat;
    } catch (e) {
      debugPrint('❌ createChat error: $e');
      return null;
    }
  }

  /// Get messages
  Future<List<MessageModel>> getMessages(String chatId, {int limit = 200}) async {
    try {
      final rows = await client
          .from('messages')
          .select()
          .eq('chat_id', chatId)
          .order('created_at', ascending: true)
          .limit(limit);

      return (rows as List)
          .map((r) => MessageModel.fromMap(Map<String, dynamic>.from(r)))
          .toList();
    } catch (e) {
      debugPrint('❌ getMessages error: $e');
      return [];
    }
  }

  /// Send message with notification
  Future<bool> sendMessage(MessageModel msg, {String? receiverId}) async {
    try {
      final map = msg.toInsertMap();
      map['reactions'] = map['reactions'] ?? <String>[];
      await client.from('messages').insert(map);

      // Send push notification to receiver
      if (receiverId != null) {
        final res = await client
            .from('profiles')
            .select('fcm_token, name')
            .eq('id', receiverId)
            .single();

        if (res != null && res['fcm_token'] != null) {
          final receiverName = res['name'] ?? 'Someone';
          await NotificationService.sendPushMessage(
            targetToken: res['fcm_token'],
            title: 'New Message',
            body: msg.text.isNotEmpty
                ? msg.text
                : 'You received a new message from $receiverName',
          );
        }
      }

      return true;
    } catch (e) {
      debugPrint('❌ sendMessage error: $e');
      return false;
    }
  }

  /// ✅ Upload attachment (returns public URL)
  // Future<String?> uploadAttachment(File file, String pathInBucket) async {
  //   try {
  //     final fileBytes = await file.readAsBytes();

  //     // Upload to Supabase
  //     await client.storage.from(bucket).uploadBinary(
  //           pathInBucket,
  //           fileBytes,
  //           fileOptions: const FileOptions(upsert: true),
  //         );

  //     // ✅ Get permanent public URL (no signed URLs)
  //     final publicUrl = client.storage.from(bucket).getPublicUrl(pathInBucket);

  //     debugPrint('✅ Uploaded image public URL: $publicUrl');
  //     return publicUrl;
  //   } catch (e) {
  //     debugPrint('❌ uploadAttachment error: $e');
  //     return null;
  //   }
  // }
  Future<String?> uploadAttachment(File file, String pathInBucket) async {
  try {
    final fileBytes = await file.readAsBytes();
    await client.storage.from(bucket).uploadBinary(
          pathInBucket,
          fileBytes,
          fileOptions: const FileOptions(upsert: true),
        );

    // ✅ Use public URL instead of signed URL (never expires)
    final publicUrl = client.storage.from(bucket).getPublicUrl(pathInBucket);
    return publicUrl;
  } catch (e) {
    debugPrint('❌ uploadAttachment error: $e');
    return null;
  }
}

  /// Mark message as read
  Future<void> markMessageRead(String messageId, String userId) async {
    try {
      final existing = await client
          .from('messages')
          .select('read_by')
          .eq('id', messageId)
          .single();

      List<String> readByList =
          (existing['read_by'] as List?)?.map((e) => e.toString()).toList() ?? [];
      if (!readByList.contains(userId)) readByList.add(userId);

      await client.from('messages').update({'read_by': readByList}).eq('id', messageId);
    } catch (e) {
      debugPrint('❌ markMessageRead error: $e');
    }
  }

  /// Delete message
  Future<void> deleteMessage(String messageId) async {
    try {
      await client.from('messages').update({'deleted': true}).eq('id', messageId);
    } catch (e) {
      debugPrint('❌ deleteMessage error: $e');
    }
  }

  /// Update message (edit, reactions)
  Future<void> updateMessage(MessageModel msg) async {
    try {
      final map = msg.toUpdateMap();
      map['reactions'] = map['reactions'] ?? <String>[];
      await client.from('messages').update(map).eq('id', msg.id);
    } catch (e) {
      debugPrint('❌ updateMessage error: $e');
    }
  }

  /// Get or create chat for campaign
  Future<ChatModel?> getOrCreateChatForCampaign({
    required String campaignId,
    required String brandId,
    required String influencerId,
  }) async {
    try {
      final rows = await client
          .from('chats')
          .select('id')
          .eq('campaign_id', campaignId)
          .limit(1);

      if ((rows as List).isNotEmpty) {
        return ChatModel.fromMap(Map<String, dynamic>.from(rows.first));
      }

      final inserted = await client.from('chats').insert({
        'title': 'Campaign Chat',
        'campaign_id': campaignId,
        'is_group': false,
        'created_by': client.auth.currentUser?.id,
      }).select().single();

      final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

      // brandId & influencerId are from profiles table
      await client.from('chat_participants').insert([
        {'chat_id': chat.id, 'user_id': brandId, 'role': 'brand'},
        {'chat_id': chat.id, 'user_id': influencerId, 'role': 'influencer'},
      ]);

      return chat;
    } catch (e) {
      debugPrint('❌ getOrCreateChatForCampaign error: $e');
      return null;
    }
  }
}
