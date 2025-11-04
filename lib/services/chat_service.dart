// // lib/services/chat_service.dart
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/chat_model.dart';
// import '../models/message_model.dart';

// class ChatService {
//   final SupabaseClient client = Supabase.instance.client;
//   final String bucket = 'chat-attachments';

//   /// 🟢 Fetch all chats for the current user (brand or influencer)
//   Future<List<ChatModel>> getUserChats() async {
//     final userId = client.auth.currentUser?.id;
//     if (userId == null) return [];

//     final rows = await client
//         .from('chats')
//         .select()
//         .order('last_message_at', ascending: false);

//     // filter only chats where user is participant
//     final participantRows = await client
//         .from('chat_participants')
//         .select('chat_id')
//         .eq('user_id', userId);

//     final chatIds = (participantRows as List).map((r) => r['chat_id'] as String).toList();
//     final filtered = (rows as List).where((r) => chatIds.contains(r['id'])).toList();

//     return filtered.map((r) => ChatModel.fromMap(Map<String, dynamic>.from(r))).toList();
//   }

//   /// 🟢 Create a new chat manually (not usually used — trigger does this)
//   Future<ChatModel?> createChat({
//     required List<String> participantIds,
//     String? title,
//     String? campaignId,
//   }) async {
//     try {
//       final inserted = await client.from('chats').insert({
//         'title': title ?? 'Chat',
//         'campaign_id': campaignId,
//         'is_group': participantIds.length > 2,
//         'created_by': client.auth.currentUser?.id,
//       }).select().single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));
//       final participants = participantIds.map((id) => {
//             'chat_id': chat.id,
//             'user_id': id,
//           });

//       await client.from('chat_participants').insert(participants.toList());
//       return chat;
//     } catch (e) {
//       debugPrint('createChat error: $e');
//       return null;
//     }
//   }

//   /// 🟢 Get chat participants
//   Future<List<String>> getParticipants(String chatId) async {
//     try {
//       final rows = await client
//           .from('chat_participants')
//           .select('user_id')
//           .eq('chat_id', chatId);
//       return (rows as List).map((r) => r['user_id'] as String).toList();
//     } catch (e) {
//       debugPrint('getParticipants error: $e');
//       return [];
//     }
//   }

//   /// 🟢 Get messages in a chat
//   Future<List<MessageModel>> getMessages(String chatId, {int limit = 200}) async {
//     try {
//       final rows = await client
//           .from('messages')
//           .select()
//           .eq('chat_id', chatId)
//           .order('created_at', ascending: true)
//           .limit(limit);

//       return (rows as List)
//           .map((r) => MessageModel.fromMap(Map<String, dynamic>.from(r)))
//           .toList();
//     } catch (e) {
//       debugPrint('getMessages error: $e');
//       return [];
//     }
//   }

//   /// 🟢 Send a message (text or with attachment)
//   Future<bool> sendMessage(MessageModel msg) async {
//     try {
//       await client.from('messages').insert(msg.toInsertMap());
//       return true;
//     } catch (e) {
//       debugPrint('sendMessage error: $e');
//       return false;
//     }
//   }

//   /// 🟢 Upload a file (image/video/document) to Supabase Storage
//   Future<String?> uploadAttachment(File file, String pathInBucket) async {
//     try {
//       final fileBytes = await file.readAsBytes();

//       await client.storage.from(bucket).uploadBinary(
//             pathInBucket,
//             fileBytes,
//             fileOptions: const FileOptions(upsert: true),
//           );

//       final signedUrl =
//           await client.storage.from(bucket).createSignedUrl(pathInBucket, 60 * 60 * 24);
//       return signedUrl;
//     } catch (e) {
//       debugPrint('uploadAttachment error: $e');
//       return null;
//     }
//   }

//   /// 🟢 Mark a message as read by current user
//   Future<void> markMessageRead(String messageId, String userId) async {
//     try {
//       final res = await client.from('messages').select('read_by').eq('id', messageId).single();
//       final existing = (res['read_by'] as List?)?.map((e) => e.toString()).toList() ?? [];
//       if (!existing.contains(userId)) existing.add(userId);
//       await client.from('messages').update({'read_by': existing}).eq('id', messageId);
//     } catch (e) {
//       debugPrint('markMessageRead error: $e');
//     }
//   }
//   Future<ChatModel?> getOrCreateChatForCampaign({required String campaignId}) async {
//   try {
//     final userId = client.auth.currentUser?.id;
//     if (userId == null) return null;

//     // 1️⃣ Check if chat already exists for this campaign
//     final rows = await client
//         .from('chats')
//         .select()
//         .eq('campaign_id', campaignId);

//     if (rows.isNotEmpty) {
//       return ChatModel.fromMap(Map<String, dynamic>.from(rows.first));
//     }

//     // 2️⃣ If not found, create a new chat manually (fallback)
//     final inserted = await client
//         .from('chats')
//         .insert({
//           'title': 'Campaign Chat',
//           'campaign_id': campaignId,
//           'created_by': userId,
//         })
//         .select()
//         .single();

//     // (Participants will be added automatically by your trigger)
//     return ChatModel.fromMap(Map<String, dynamic>.from(inserted));
//   } catch (e) {
//     debugPrint('getOrCreateChatForCampaign error: $e');
//     return null;
//   }
// }

// // }
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/chat_model.dart';
// import '../models/message_model.dart';

// class ChatService {
//   final SupabaseClient client = Supabase.instance.client;
//   final String bucket = 'chat-attachments';

//   /// 🟢 Fetch all chats where current user is a participant
//   Future<List<ChatModel>> getUserChats() async {
//     try {
//       final userId = client.auth.currentUser?.id;
//       if (userId == null) return [];

//       // ✅ fetch chats joined through chat_participants
//       final rows = await client
//           .from('chats')
//           .select('*, chat_participants!inner(user_id)')
//           .eq('chat_participants.user_id', userId)
//           .order('last_message_at', ascending: false);

//       return (rows as List)
//           .map((r) => ChatModel.fromMap(Map<String, dynamic>.from(r)))
//           .toList();
//     } catch (e) {
//       debugPrint('getUserChats error: $e');
//       return [];
//     }
//   }

//   /// 🟢 Create a new chat and add participants
//   Future<ChatModel?> createChat({
//     required List<String> participantIds,
//     String? title,
//     String? campaignId,
//   }) async {
//     try {
//       final creatorId = client.auth.currentUser?.id;
//       if (creatorId == null) return null;

//       // Create chat
//       final inserted = await client
//           .from('chats')
//           .insert({
//             'title': title ?? 'Chat',
//             'campaign_id': campaignId,
//             'is_group': participantIds.length > 2,
//             'created_by': creatorId,
//           })
//           .select()
//           .single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

//       // Add participants (creator + others)
//       final participants = participantIds.toSet().map((id) => {
//             'chat_id': chat.id,
//             'user_id': id,
//             'role': id == creatorId ? 'creator' : 'member',
//           });

//       await client.from('chat_participants').insert(participants.toList());
//       return chat;
//     } catch (e) {
//       debugPrint('createChat error: $e');
//       return null;
//     }
//   }

//   /// 🟢 Get chat participants (returns user IDs)
//   Future<List<String>> getParticipants(String chatId) async {
//     try {
//       final rows = await client
//           .from('chat_participants')
//           .select('user_id')
//           .eq('chat_id', chatId);

//       return (rows as List).map((r) => r['user_id'] as String).toList();
//     } catch (e) {
//       debugPrint('getParticipants error: $e');
//       return [];
//     }
//   }

//   /// 🟢 Get messages of a chat
//   Future<List<MessageModel>> getMessages(String chatId,
//       {int limit = 200}) async {
//     try {
//       final rows = await client
//           .from('messages')
//           .select()
//           .eq('chat_id', chatId)
//           .order('created_at', ascending: true)
//           .limit(limit);

//       return (rows as List)
//           .map((r) => MessageModel.fromMap(Map<String, dynamic>.from(r)))
//           .toList();
//     } catch (e) {
//       debugPrint('getMessages error: $e');
//       return [];
//     }
//   }

//   /// 🟢 Send a message
//   Future<bool> sendMessage(MessageModel msg) async {
//     try {
//       await client.from('messages').insert(msg.toInsertMap());
//       return true;
//     } catch (e) {
//       debugPrint('sendMessage error: $e');
//       return false;
//     }
//   }

//   /// 🟢 Upload file to Supabase Storage
//   Future<String?> uploadAttachment(File file, String pathInBucket) async {
//     try {
//       final fileBytes = await file.readAsBytes();

//       await client.storage.from(bucket).uploadBinary(
//             pathInBucket,
//             fileBytes,
//             fileOptions: const FileOptions(upsert: true),
//           );

//       final signedUrl = await client.storage
//           .from(bucket)
//           .createSignedUrl(pathInBucket, 60 * 60 * 24);

//       return signedUrl;
//     } catch (e) {
//       debugPrint('uploadAttachment error: $e');
//       return null;
//     }
//   }

//   /// 🟢 Get or create a campaign chat (used for brand↔influencer)
//   Future<ChatModel?> getOrCreateChatForCampaign({
//     required String campaignId,
//     required String brandId,
//     required String influencerId,
//   }) async {
//     try {
//       // 1️⃣ Check if chat exists for this campaign
//       final rows = await client
//           .from('chats')
//           .select('id')
//           .eq('campaign_id', campaignId)
//           .limit(1);

//       if (rows.isNotEmpty) {
//         // ✅ Chat already exists
//         final chatRow = rows.first;
//         return ChatModel.fromMap(Map<String, dynamic>.from(chatRow));
//       }

//       // 2️⃣ Create new chat
//       final inserted = await client
//           .from('chats')
//           .insert({
//             'title': 'Campaign Chat',
//             'campaign_id': campaignId,
//             'is_group': false,
//             'created_by': client.auth.currentUser?.id,
//           })
//           .select()
//           .single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

//       // 3️⃣ Add participants (brand + influencer)
//       await client.from('chat_participants').insert([
//         {'chat_id': chat.id, 'user_id': brandId, 'role': 'brand'},
//         {'chat_id': chat.id, 'user_id': influencerId, 'role': 'influencer'},
//       ]);

//       return chat;
//     } catch (e) {
//       debugPrint('getOrCreateChatForCampaign error: $e');
//       return null;
//     }
//   }

//   /// 🟢 Mark message as read
//   Future<void> markMessageRead(String messageId, String userId) async {
//     try {
//       final res =
//           await client.from('messages').select('read_by').eq('id', messageId).single();
//       final existing =
//           (res['read_by'] as List?)?.map((e) => e.toString()).toList() ?? [];
//       if (!existing.contains(userId)) existing.add(userId);
//       await client.from('messages').update({'read_by': existing}).eq('id', messageId);
//     } catch (e) {
//       debugPrint('markMessageRead error: $e');
//     }
//   }
// }
// lib/services/chat_service.dart
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/chat_model.dart';
// import '../models/message_model.dart';

// class ChatService {
//   final SupabaseClient client = Supabase.instance.client;
//   final String bucket = 'chat_images'; // <-- your bucket name

//   /// 🟢 Fetch all chats where current user is a participant
//   Future<List<ChatModel>> getUserChats() async {
//     try {
//       final userId = client.auth.currentUser?.id;
//       if (userId == null) return [];

//       final rows = await client
//           .from('chats')
//           .select('*, chat_participants!inner(user_id)')
//           .eq('chat_participants.user_id', userId)
//           .order('last_message_at', ascending: false);

//       return (rows as List)
//           .map((r) => ChatModel.fromMap(Map<String, dynamic>.from(r)))
//           .toList();
//     } catch (e) {
//       debugPrint('getUserChats error: $e');
//       return [];
//     }
//   }

//   /// 🟢 Create a new chat and add participants
//   Future<ChatModel?> createChat({
//     required List<String> participantIds,
//     String? title,
//     String? campaignId,
//   }) async {
//     try {
//       final creatorId = client.auth.currentUser?.id;
//       if (creatorId == null) return null;

//       final inserted = await client
//           .from('chats')
//           .insert({
//             'title': title ?? 'Chat',
//             'campaign_id': campaignId,
//             'is_group': participantIds.length > 2,
//             'created_by': creatorId,
//           })
//           .select()
//           .single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

//       final participants = participantIds.toSet().map((id) => {
//             'chat_id': chat.id,
//             'user_id': id,
//             'role': id == creatorId ? 'creator' : 'member',
//           });

//       await client.from('chat_participants').insert(participants.toList());
//       return chat;
//     } catch (e) {
//       debugPrint('createChat error: $e');
//       return null;
//     }
//   }

//   /// 🟢 Get chat participants (returns user IDs)
//   Future<List<String>> getParticipants(String chatId) async {
//     try {
//       final rows = await client
//           .from('chat_participants')
//           .select('user_id')
//           .eq('chat_id', chatId);

//       return (rows as List).map((r) => r['user_id'] as String).toList();
//     } catch (e) {
//       debugPrint('getParticipants error: $e');
//       return [];
//     }
//   }

//   /// 🟢 Get messages of a chat
//   Future<List<MessageModel>> getMessages(String chatId,
//       {int limit = 200}) async {
//     try {
//       final rows = await client
//           .from('messages')
//           .select()
//           .eq('chat_id', chatId)
//           .order('created_at', ascending: true)
//           .limit(limit);

//       return (rows as List)
//           .map((r) => MessageModel.fromMap(Map<String, dynamic>.from(r)))
//           .toList();
//     } catch (e) {
//       debugPrint('getMessages error: $e');
//       return [];
//     }
//   }

//   /// 🟢 Send a message
//   Future<bool> sendMessage(MessageModel msg) async {
//     try {
//       await client.from('messages').insert(msg.toInsertMap());
//       return true;
//     } catch (e) {
//       debugPrint('sendMessage error: $e');
//       return false;
//     }
//   }

//   /// 🟢 Upload file to Supabase Storage
//   Future<String?> uploadAttachment(File file, String pathInBucket) async {
//     try {
//       final fileBytes = await file.readAsBytes();

//       // Upload file to your bucket
//       await client.storage.from(bucket).uploadBinary(
//             pathInBucket,
//             fileBytes,
//             fileOptions: const FileOptions(upsert: true),
//           );

//       // Generate signed URL (valid 24 hours)
//       final signedUrl = await client.storage
//           .from(bucket)
//           .createSignedUrl(pathInBucket, 60 * 60 * 24);

//       return signedUrl;
//     } catch (e) {
//       debugPrint('uploadAttachment error: $e');
//       return null;
//     }
//   }

//   /// 🟢 Get or create a campaign chat (brand ↔ influencer)
//   Future<ChatModel?> getOrCreateChatForCampaign({
//     required String campaignId,
//     required String brandId,
//     required String influencerId,
//   }) async {
//     try {
//       final rows = await client
//           .from('chats')
//           .select('id')
//           .eq('campaign_id', campaignId)
//           .limit(1);

//       if (rows.isNotEmpty) {
//         final chatRow = rows.first;
//         return ChatModel.fromMap(Map<String, dynamic>.from(chatRow));
//       }

//       final inserted = await client
//           .from('chats')
//           .insert({
//             'title': 'Campaign Chat',
//             'campaign_id': campaignId,
//             'is_group': false,
//             'created_by': client.auth.currentUser?.id,
//           })
//           .select()
//           .single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

//       await client.from('chat_participants').insert([
//         {'chat_id': chat.id, 'user_id': brandId, 'role': 'brand'},
//         {'chat_id': chat.id, 'user_id': influencerId, 'role': 'influencer'},
//       ]);

//       return chat;
//     } catch (e) {
//       debugPrint('getOrCreateChatForCampaign error: $e');
//       return null;
//     }
//   }

//   /// 🟢 Mark message as read
//   Future<void> markMessageRead(String messageId, String userId) async {
//     try {
//       final res = await client.from('messages').select('read_by').eq('id', messageId).single();
//       final existing = (res['read_by'] as List?)?.map((e) => e.toString()).toList() ?? [];
//       if (!existing.contains(userId)) existing.add(userId);
//       await client.from('messages').update({'read_by': existing}).eq('id', messageId);
//     } catch (e) {
//       debugPrint('markMessageRead error: $e');
//     }
//   }
// }
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/chat_model.dart';
// import '../models/message_model.dart';

// class ChatService {
//   final SupabaseClient client = Supabase.instance.client;
//   final String bucket = 'chat_images';

//   /// Fetch all chats where current user is a participant
//   Future<List<ChatModel>> getUserChats() async {
//     try {
//       final userId = client.auth.currentUser?.id;
//       if (userId == null) return [];

//       final rows = await client
//           .from('chats')
//           .select('*, chat_participants!inner(user_id)')
//           .eq('chat_participants.user_id', userId)
//           .order('last_message_at', ascending: false);

//       return (rows as List)
//           .map((r) => ChatModel.fromMap(Map<String, dynamic>.from(r)))
//           .toList();
//     } catch (e) {
//       debugPrint('getUserChats error: $e');
//       return [];
//     }
//   }

//   /// Create a new chat
//   Future<ChatModel?> createChat({
//     required List<String> participantIds,
//     String? title,
//     String? campaignId,
//   }) async {
//     try {
//       final creatorId = client.auth.currentUser?.id;
//       if (creatorId == null) return null;

//       final inserted = await client.from('chats').insert({
//         'title': title ?? 'Chat',
//         'campaign_id': campaignId,
//         'is_group': participantIds.length > 2,
//         'created_by': creatorId,
//       }).select().single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

//       final participants = participantIds.toSet().map((id) => {
//             'chat_id': chat.id,
//             'user_id': id,
//             'role': id == creatorId ? 'creator' : 'member',
//           });

//       await client.from('chat_participants').insert(participants.toList());

//       return chat;
//     } catch (e) {
//       debugPrint('createChat error: $e');
//       return null;
//     }
//   }

//   /// Get messages
//   Future<List<MessageModel>> getMessages(String chatId, {int limit = 200}) async {
//     try {
//       final rows = await client
//           .from('messages')
//           .select()
//           .eq('chat_id', chatId)
//           .order('created_at', ascending: true)
//           .limit(limit);

//       return (rows as List)
//           .map((r) => MessageModel.fromMap(Map<String, dynamic>.from(r)))
//           .toList();
//     } catch (e) {
//       debugPrint('getMessages error: $e');
//       return [];
//     }
//   }

//   Future<bool> sendMessage(MessageModel msg) async {
//   try {
//     await client.from('messages').insert(msg.toInsertMap());
//     return true;
//   } catch (e) {
//     debugPrint('sendMessage error: $e');
//     return false;
//   }
// }


//   /// Upload file to Supabase Storage
//   Future<String?> uploadAttachment(File file, String pathInBucket) async {
//     try {
//       final fileBytes = await file.readAsBytes();
//       await client.storage.from(bucket).uploadBinary(
//             pathInBucket,
//             fileBytes,
//             fileOptions: const FileOptions(upsert: true),
//           );

//       final signedUrl = await client.storage.from(bucket).createSignedUrl(
//             pathInBucket,
//             60 * 60 * 24,
//           );

//       return signedUrl;
//     } catch (e) {
//       debugPrint('uploadAttachment error: $e');
//       return null;
//     }
//   }

//   /// Mark message as read
//   Future<void> markMessageRead(String messageId, String userId) async {
//     try {
//       final existing = await client
//           .from('messages')
//           .select('read_by')
//           .eq('id', messageId)
//           .single();

//       List<String> readByList = (existing['read_by'] as List?)?.map((e) => e.toString()).toList() ?? [];
//       if (!readByList.contains(userId)) readByList.add(userId);

//       await client.from('messages').update({'read_by': readByList}).eq('id', messageId);
//     } catch (e) {
//       debugPrint('markMessageRead error: $e');
//     }
//   }

//   /// Delete message
//   Future<void> deleteMessage(String messageId) async {
//     try {
//       await client.from('messages').update({'deleted': true}).eq('id', messageId);
//     } catch (e) {
//       debugPrint('deleteMessage error: $e');
//     }
//   }

//   /// Update message (edit text, reactions, attachment)
//   Future<void> updateMessage(MessageModel msg) async {
//     try {
//       await client.from('messages').update(msg.toUpdateMap()).eq('id', msg.id);
//     } catch (e) {
//       debugPrint('updateMessage error: $e');
//     }
//   }

//   /// Get or create campaign chat
//   Future<ChatModel?> getOrCreateChatForCampaign({
//     required String campaignId,
//     required String brandId,
//     required String influencerId,
//   }) async {
//     try {
//       final rows = await client
//           .from('chats')
//           .select('id')
//           .eq('campaign_id', campaignId)
//           .limit(1);

//       if ((rows as List).isNotEmpty) {
//         return ChatModel.fromMap(Map<String, dynamic>.from(rows.first));
//       }

//       final inserted = await client.from('chats').insert({
//         'title': 'Campaign Chat',
//         'campaign_id': campaignId,
//         'is_group': false,
//         'created_by': client.auth.currentUser?.id,
//       }).select().single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

//       await client.from('chat_participants').insert([
//         {'chat_id': chat.id, 'user_id': brandId, 'role': 'brand'},
//         {'chat_id': chat.id, 'user_id': influencerId, 'role': 'influencer'},
//       ]);

//       return chat;
//     } catch (e) {
//       debugPrint('getOrCreateChatForCampaign error: $e');
//       return null;
//     }
//   }
// }
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/chat_model.dart';
// import '../models/message_model.dart';

// class ChatService {
//   final SupabaseClient client = Supabase.instance.client;
//   final String bucket = 'chat_images';

//   /// Fetch all chats where current user is a participant
//   Future<List<ChatModel>> getUserChats() async {
//     try {
//       final userId = client.auth.currentUser?.id;
//       if (userId == null) return [];

//       final rows = await client
//           .from('chats')
//           .select('*, chat_participants!inner(user_id)')
//           .eq('chat_participants.user_id', userId)
//           .order('last_message_at', ascending: false);

//       return (rows as List)
//           .map((r) => ChatModel.fromMap(Map<String, dynamic>.from(r)))
//           .toList();
//     } catch (e) {
//       debugPrint('getUserChats error: $e');
//       return [];
//     }
//   }

//   /// Create a new chat
//   Future<ChatModel?> createChat({
//     required List<String> participantIds,
//     String? title,
//     String? campaignId,
//   }) async {
//     try {
//       final creatorId = client.auth.currentUser?.id;
//       if (creatorId == null) return null;

//       final inserted = await client
//           .from('chats')
//           .insert({
//             'title': title ?? 'Chat',
//             'campaign_id': campaignId,
//             'is_group': participantIds.length > 2,
//             'created_by': creatorId,
//           })
//           .select()
//           .single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

//       final participants = participantIds.toSet().map((id) => {
//             'chat_id': chat.id,
//             'user_id': id,
//             'role': id == creatorId ? 'creator' : 'member',
//           });

//       await client.from('chat_participants').insert(participants.toList());

//       return chat;
//     } catch (e) {
//       debugPrint('createChat error: $e');
//       return null;
//     }
//   }

//   /// Get messages
//   Future<List<MessageModel>> getMessages(String chatId, {int limit = 200}) async {
//     try {
//       final rows = await client
//           .from('messages')
//           .select()
//           .eq('chat_id', chatId)
//           .order('created_at', ascending: true)
//           .limit(limit);

//       return (rows as List)
//           .map((r) => MessageModel.fromMap(Map<String, dynamic>.from(r)))
//           .toList();
//     } catch (e) {
//       debugPrint('getMessages error: $e');
//       return [];
//     }
//   }

//   /// Send message
//   Future<bool> sendMessage(MessageModel msg) async {
//     try {
//       // IMPORTANT: cast reactions to text[] for PostgREST
//       final map = msg.toInsertMap();
//       map['reactions'] = map['reactions'] ?? <String>[];

//       await client.from('messages').insert(map);
//       return true;
//     } catch (e) {
//       debugPrint('sendMessage error: $e');
//       return false;
//     }
//   }

//   /// Upload attachment
//   Future<String?> uploadAttachment(File file, String pathInBucket) async {
//     try {
//       final fileBytes = await file.readAsBytes();
//       await client.storage.from(bucket).uploadBinary(
//             pathInBucket,
//             fileBytes,
//             fileOptions: const FileOptions(upsert: true),
//           );

//       final signedUrl = await client.storage
//           .from(bucket)
//           .createSignedUrl(pathInBucket, 60 * 60 * 24);

//       return signedUrl;
//     } catch (e) {
//       debugPrint('uploadAttachment error: $e');
//       return null;
//     }
//   }

//   /// Mark message read
//   Future<void> markMessageRead(String messageId, String userId) async {
//     try {
//       final existing = await client
//           .from('messages')
//           .select('read_by')
//           .eq('id', messageId)
//           .single();

//       List<String> readByList =
//           (existing['read_by'] as List?)?.map((e) => e.toString()).toList() ?? [];
//       if (!readByList.contains(userId)) readByList.add(userId);

//       await client.from('messages').update({'read_by': readByList}).eq('id', messageId);
//     } catch (e) {
//       debugPrint('markMessageRead error: $e');
//     }
//   }

//   /// Delete message
//   Future<void> deleteMessage(String messageId) async {
//     try {
//       await client.from('messages').update({'deleted': true}).eq('id', messageId);
//     } catch (e) {
//       debugPrint('deleteMessage error: $e');
//     }
//   }

//   /// Update message (edit, reactions)
//   Future<void> updateMessage(MessageModel msg) async {
//     try {
//       final map = msg.toUpdateMap();
//       map['reactions'] = map['reactions'] ?? <String>[];
//       await client.from('messages').update(map).eq('id', msg.id);
//     } catch (e) {
//       debugPrint('updateMessage error: $e');
//     }
//   }

//   /// Get or create campaign chat
//   Future<ChatModel?> getOrCreateChatForCampaign({
//     required String campaignId,
//     required String brandId,
//     required String influencerId,
//   }) async {
//     try {
//       final rows = await client.from('chats').select('id').eq('campaign_id', campaignId).limit(1);

//       if ((rows as List).isNotEmpty) {
//         return ChatModel.fromMap(Map<String, dynamic>.from(rows.first));
//       }

//       final inserted = await client.from('chats').insert({
//         'title': 'Campaign Chat',
//         'campaign_id': campaignId,
//         'is_group': false,
//         'created_by': client.auth.currentUser?.id,
//       }).select().single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

//       await client.from('chat_participants').insert([
//         {'chat_id': chat.id, 'user_id': brandId, 'role': 'brand'},
//         {'chat_id': chat.id, 'user_id': influencerId, 'role': 'influencer'},
//       ]);

//       return chat;
//     } catch (e) {
//       debugPrint('getOrCreateChatForCampaign error: $e');
//       return null;
//     }
//   }
// }
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/chat_model.dart';
// import '../models/message_model.dart';

// class ChatService {
//   final SupabaseClient client = Supabase.instance.client;
//   final String bucket = 'chat_images';

//   /// Fetch all chats where current user is a participant
//   Future<List<ChatModel>> getUserChats() async {
//     try {
//       final userId = client.auth.currentUser?.id;
//       if (userId == null) return [];

//       // Join with chat_participants and users table to get participant info
//       final rows = await client
//           .from('chats')
//           .select('*, chat_participants!inner(user_id), chat_participants:user_id(full_name, avatar_url)')
//           .eq('chat_participants.user_id', userId)
//           .order('last_message_at', ascending: false);

//       return (rows as List)
//           .map((r) => ChatModel.fromMap(Map<String, dynamic>.from(r)))
//           .toList();
//     } catch (e) {
//       debugPrint('getUserChats error: $e');
//       return [];
//     }
//   }

//   /// Create a new chat
//   Future<ChatModel?> createChat({
//     required List<String> participantIds,
//     String? title,
//     String? campaignId,
//   }) async {
//     try {
//       final creatorId = client.auth.currentUser?.id;
//       if (creatorId == null) return null;

//       final inserted = await client
//           .from('chats')
//           .insert({
//             'title': title ?? 'Chat',
//             'campaign_id': campaignId,
//             'is_group': participantIds.length > 2,
//             'created_by': creatorId,
//           })
//           .select()
//           .single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

//       final participants = participantIds.toSet().map((id) => {
//             'chat_id': chat.id,
//             'user_id': id,
//             'role': id == creatorId ? 'creator' : 'member',
//           });

//       await client.from('chat_participants').insert(participants.toList());

//       return chat;
//     } catch (e) {
//       debugPrint('createChat error: $e');
//       return null;
//     }
//   }

//   /// Get messages
//   Future<List<MessageModel>> getMessages(String chatId, {int limit = 200}) async {
//     try {
//       final rows = await client
//           .from('messages')
//           .select()
//           .eq('chat_id', chatId)
//           .order('created_at', ascending: true)
//           .limit(limit);

//       return (rows as List)
//           .map((r) => MessageModel.fromMap(Map<String, dynamic>.from(r)))
//           .toList();
//     } catch (e) {
//       debugPrint('getMessages error: $e');
//       return [];
//     }
//   }

//   /// Send message
//   Future<bool> sendMessage(MessageModel msg) async {
//     try {
//       final map = msg.toInsertMap();
//       map['reactions'] = map['reactions'] ?? <String>[];
//       await client.from('messages').insert(map);
//       return true;
//     } catch (e) {
//       debugPrint('sendMessage error: $e');
//       return false;
//     }
//   }

//   /// Upload attachment
//   Future<String?> uploadAttachment(File file, String pathInBucket) async {
//     try {
//       final fileBytes = await file.readAsBytes();
//       await client.storage.from(bucket).uploadBinary(
//             pathInBucket,
//             fileBytes,
//             fileOptions: const FileOptions(upsert: true),
//           );

//       final signedUrl = await client.storage
//           .from(bucket)
//           .createSignedUrl(pathInBucket, 60 * 60 * 24);

//       return signedUrl;
//     } catch (e) {
//       debugPrint('uploadAttachment error: $e');
//       return null;
//     }
//   }

//   /// Mark message read
//   Future<void> markMessageRead(String messageId, String userId) async {
//     try {
//       final existing = await client
//           .from('messages')
//           .select('read_by')
//           .eq('id', messageId)
//           .single();

//       List<String> readByList =
//           (existing['read_by'] as List?)?.map((e) => e.toString()).toList() ?? [];
//       if (!readByList.contains(userId)) readByList.add(userId);

//       await client.from('messages').update({'read_by': readByList}).eq('id', messageId);
//     } catch (e) {
//       debugPrint('markMessageRead error: $e');
//     }
//   }

//   /// Delete message
//   Future<void> deleteMessage(String messageId) async {
//     try {
//       await client.from('messages').update({'deleted': true}).eq('id', messageId);
//     } catch (e) {
//       debugPrint('deleteMessage error: $e');
//     }
//   }

//   /// Update message (edit, reactions)
//   Future<void> updateMessage(MessageModel msg) async {
//     try {
//       final map = msg.toUpdateMap();
//       map['reactions'] = map['reactions'] ?? <String>[];
//       await client.from('messages').update(map).eq('id', msg.id);
//     } catch (e) {
//       debugPrint('updateMessage error: $e');
//     }
//   }

//   /// Get or create campaign chat
//   Future<ChatModel?> getOrCreateChatForCampaign({
//     required String campaignId,
//     required String brandId,
//     required String influencerId,
//   }) async {
//     try {
//       final rows = await client.from('chats').select('id').eq('campaign_id', campaignId).limit(1);

//       if ((rows as List).isNotEmpty) {
//         return ChatModel.fromMap(Map<String, dynamic>.from(rows.first));
//       }

//       final inserted = await client.from('chats').insert({
//         'title': 'Campaign Chat',
//         'campaign_id': campaignId,
//         'is_group': false,
//         'created_by': client.auth.currentUser?.id,
//       }).select().single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

//       await client.from('chat_participants').insert([
//         {'chat_id': chat.id, 'user_id': brandId, 'role': 'brand'},
//         {'chat_id': chat.id, 'user_id': influencerId, 'role': 'influencer'},
//       ]);

//       return chat;
//     } catch (e) {
//       debugPrint('getOrCreateChatForCampaign error: $e');
//       return null;
//     }
//   }
// }
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/chat_model.dart';
// import '../models/message_model.dart';

// class ChatService {
//   final SupabaseClient client = Supabase.instance.client;
//   final String bucket = 'chat_images';

//   /// Fetch all chats where current user is a participant
//   Future<List<ChatModel>> getUserChats() async {
//     try {
//       final userId = client.auth.currentUser?.id;
//       if (userId == null) return [];

//       // ✅ Fixed: join through chat_participants and profiles instead of user_id
//      final rows = await client
//     .from('chats')
//     .select('''
//       id,
//       title,
//       campaign_id,
//       is_group,
//       last_message_at,
//       chat_participants!inner(
//         user_id,
//         profiles!inner(id, name, profile_image)
//       )
//     ''')
//     .eq('chat_participants.user_id', userId)
//     .order('last_message_at', ascending: false);


//       return (rows as List)
//           .map((r) => ChatModel.fromMap(Map<String, dynamic>.from(r)))
//           .toList();
//     } catch (e) {
//       debugPrint('getUserChats error: $e');
//       return [];
//     }
//   }

//   /// Create a new chat
//   Future<ChatModel?> createChat({
//     required List<String> participantIds,
//     String? title,
//     String? campaignId,
//   }) async {
//     try {
//       final creatorId = client.auth.currentUser?.id;
//       if (creatorId == null) return null;

//       final inserted = await client
//           .from('chats')
//           .insert({
//             'title': title ?? 'Chat',
//             'campaign_id': campaignId,
//             'is_group': participantIds.length > 2,
//             'created_by': creatorId,
//           })
//           .select()
//           .single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

//       final participants = participantIds.toSet().map((id) => {
//             'chat_id': chat.id,
//             'user_id': id,
//             'role': id == creatorId ? 'creator' : 'member',
//           });

//       await client.from('chat_participants').insert(participants.toList());

//       return chat;
//     } catch (e) {
//       debugPrint('createChat error: $e');
//       return null;
//     }
//   }

//   /// Get messages
//   Future<List<MessageModel>> getMessages(String chatId, {int limit = 200}) async {
//     try {
//       final rows = await client
//           .from('messages')
//           .select()
//           .eq('chat_id', chatId)
//           .order('created_at', ascending: true)
//           .limit(limit);

//       return (rows as List)
//           .map((r) => MessageModel.fromMap(Map<String, dynamic>.from(r)))
//           .toList();
//     } catch (e) {
//       debugPrint('getMessages error: $e');
//       return [];
//     }
//   }

//   /// Send message
//   Future<bool> sendMessage(MessageModel msg) async {
//     try {
//       final map = msg.toInsertMap();
//       map['reactions'] = map['reactions'] ?? <String>[];
//       await client.from('messages').insert(map);
//       return true;
//     } catch (e) {
//       debugPrint('sendMessage error: $e');
//       return false;
//     }
//   }

//   /// Upload attachment
//   Future<String?> uploadAttachment(File file, String pathInBucket) async {
//     try {
//       final fileBytes = await file.readAsBytes();
//       await client.storage.from(bucket).uploadBinary(
//             pathInBucket,
//             fileBytes,
//             fileOptions: const FileOptions(upsert: true),
//           );

//       final signedUrl = await client.storage
//           .from(bucket)
//           .createSignedUrl(pathInBucket, 60 * 60 * 24);

//       return signedUrl;
//     } catch (e) {
//       debugPrint('uploadAttachment error: $e');
//       return null;
//     }
//   }

//   /// Mark message read
//   Future<void> markMessageRead(String messageId, String userId) async {
//     try {
//       final existing = await client
//           .from('messages')
//           .select('read_by')
//           .eq('id', messageId)
//           .single();

//       List<String> readByList =
//           (existing['read_by'] as List?)?.map((e) => e.toString()).toList() ?? [];
//       if (!readByList.contains(userId)) readByList.add(userId);

//       await client.from('messages').update({'read_by': readByList}).eq('id', messageId);
//     } catch (e) {
//       debugPrint('markMessageRead error: $e');
//     }
//   }

//   /// Delete message
//   Future<void> deleteMessage(String messageId) async {
//     try {
//       await client.from('messages').update({'deleted': true}).eq('id', messageId);
//     } catch (e) {
//       debugPrint('deleteMessage error: $e');
//     }
//   }

//   /// Update message (edit, reactions)
//   Future<void> updateMessage(MessageModel msg) async {
//     try {
//       final map = msg.toUpdateMap();
//       map['reactions'] = map['reactions'] ?? <String>[];
//       await client.from('messages').update(map).eq('id', msg.id);
//     } catch (e) {
//       debugPrint('updateMessage error: $e');
//     }
//   }

//   /// Get or create campaign chat
//   Future<ChatModel?> getOrCreateChatForCampaign({
//     required String campaignId,
//     required String brandId,
//     required String influencerId,
//   }) async {
//     try {
//       final rows = await client
//           .from('chats')
//           .select('id')
//           .eq('campaign_id', campaignId)
//           .limit(1);

//       if ((rows as List).isNotEmpty) {
//         return ChatModel.fromMap(Map<String, dynamic>.from(rows.first));
//       }

//       final inserted = await client.from('chats').insert({
//         'title': 'Campaign Chat',
//         'campaign_id': campaignId,
//         'is_group': false,
//         'created_by': client.auth.currentUser?.id,
//       }).select().single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

//       // ✅ brandId & influencerId are from profiles table (not brands)
//       await client.from('chat_participants').insert([
//         {'chat_id': chat.id, 'user_id': brandId, 'role': 'brand'},
//         {'chat_id': chat.id, 'user_id': influencerId, 'role': 'influencer'},
//       ]);

//       return chat;
//     } catch (e) {
//       debugPrint('getOrCreateChatForCampaign error: $e');
//       return null;
//     }
//   }
// }
// lib/services/chat_service.dart
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/chat_model.dart';
// import '../models/message_model.dart';

// class ChatService {
//   final SupabaseClient client = Supabase.instance.client;
//   final String bucket = 'chat_images';

//   /// Fetch all chats where current user is a participant
//   Future<List<ChatModel>> getUserChats() async {
//     try {
//       final userId = client.auth.currentUser?.id;
//       if (userId == null) return [];

//       // select chats and embed chat_participants + their profiles
//       final rows = await client
//           .from('chats')
//           .select('''
//             id,
//             title,
//             campaign_id,
//             is_group,
//             last_message_text,
//             last_message_at,
//             chat_participants!inner(
//               user_id,
//               role,
//               profiles!inner(id, name, profile_image)
//             )
//           ''')
//           .eq('chat_participants.user_id', userId)
//           .order('last_message_at', ascending: false);

//       // rows is a List of maps. We need to flatten partner profile info
//       final List<Map<String, dynamic>> list = (rows as List)
//           .map((r) => Map<String, dynamic>.from(r))
//           .toList();

//       final List<Map<String, dynamic>> normalized = [];

//       for (final r in list) {
//         // find partner participant whose user_id != current user
//         final participants = (r['chat_participants'] as List?)?.cast<Map<String, dynamic>>() ?? [];

//         Map<String, dynamic>? partnerProfile;

//         for (final p in participants) {
//           final pid = p['user_id']?.toString();
//           // pick the other participant (the chat partner)
//           if (pid != null && pid != userId) {
//             // profiles may be nested under 'profiles'
//             if (p.containsKey('profiles') && p['profiles'] is Map) {
//               partnerProfile = Map<String, dynamic>.from(p['profiles'] as Map);
//             } else {
//               partnerProfile = Map<String, dynamic>.from(p);
//             }
//             break;
//           }
//         }

//         // if partnerProfile still null (e.g., group chat or only one row), try first participant's profile
//         if (partnerProfile == null && participants.isNotEmpty) {
//           final p = participants.first;
//           if (p.containsKey('profiles') && p['profiles'] is Map) {
//             partnerProfile = Map<String, dynamic>.from(p['profiles'] as Map);
//           } else {
//             partnerProfile = Map<String, dynamic>.from(p);
//           }
//         }

//         // inject normalized top-level keys expected by ChatModel.fromMap
//         if (partnerProfile != null) {
//           r['influencer_name'] = partnerProfile['name'] ?? partnerProfile['full_name'] ?? partnerProfile['username'] ?? 'User';
//           r['influencer_profile_url'] = partnerProfile['profile_image'] ?? partnerProfile['avatar_url'] ?? '';
//         } else {
//           r['influencer_name'] = r['title'] ?? 'Conversation';
//           r['influencer_profile_url'] = '';
//         }

//         normalized.add(r);
//       }

//       return normalized.map((r) => ChatModel.fromMap(r)).toList();
//     } catch (e) {
//       debugPrint('getUserChats error: $e');
//       return [];
//     }
//   }

//   /// Create a new chat
//   Future<ChatModel?> createChat({
//     required List<String> participantIds,
//     String? title,
//     String? campaignId,
//   }) async {
//     try {
//       final creatorId = client.auth.currentUser?.id;
//       if (creatorId == null) return null;

//       final inserted = await client
//           .from('chats')
//           .insert({
//             'title': title ?? 'Chat',
//             'campaign_id': campaignId,
//             'is_group': participantIds.length > 2,
//             'created_by': creatorId,
//           })
//           .select()
//           .single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

//       final participants = participantIds.toSet().map((id) => {
//             'chat_id': chat.id,
//             'user_id': id,
//             'role': id == creatorId ? 'creator' : 'member',
//           });

//       await client.from('chat_participants').insert(participants.toList());

//       return chat;
//     } catch (e) {
//       debugPrint('createChat error: $e');
//       return null;
//     }
//   }

//   /// Get messages
//   Future<List<MessageModel>> getMessages(String chatId, {int limit = 200}) async {
//     try {
//       final rows = await client
//           .from('messages')
//           .select()
//           .eq('chat_id', chatId)
//           .order('created_at', ascending: true)
//           .limit(limit);

//       return (rows as List)
//           .map((r) => MessageModel.fromMap(Map<String, dynamic>.from(r)))
//           .toList();
//     } catch (e) {
//       debugPrint('getMessages error: $e');
//       return [];
//     }
//   }

//   /// Send message
//   Future<bool> sendMessage(MessageModel msg) async {
//     try {
//       final map = msg.toInsertMap();
//       map['reactions'] = map['reactions'] ?? <String>[];
//       await client.from('messages').insert(map);
//       return true;
//     } catch (e) {
//       debugPrint('sendMessage error: $e');
//       return false;
//     }
//   }

//   /// Upload attachment
//   Future<String?> uploadAttachment(File file, String pathInBucket) async {
//     try {
//       final fileBytes = await file.readAsBytes();
//       await client.storage.from(bucket).uploadBinary(
//             pathInBucket,
//             fileBytes,
//             fileOptions: const FileOptions(upsert: true),
//           );

//       final signedUrl = await client.storage
//           .from(bucket)
//           .createSignedUrl(pathInBucket, 60 * 60 * 24);

//       return signedUrl;
//     } catch (e) {
//       debugPrint('uploadAttachment error: $e');
//       return null;
//     }
//   }

//   /// Mark message read
//   Future<void> markMessageRead(String messageId, String userId) async {
//     try {
//       final existing = await client
//           .from('messages')
//           .select('read_by')
//           .eq('id', messageId)
//           .single();

//       List<String> readByList =
//           (existing['read_by'] as List?)?.map((e) => e.toString()).toList() ?? [];
//       if (!readByList.contains(userId)) readByList.add(userId);

//       await client.from('messages').update({'read_by': readByList}).eq('id', messageId);
//     } catch (e) {
//       debugPrint('markMessageRead error: $e');
//     }
//   }

//   /// Delete message
//   Future<void> deleteMessage(String messageId) async {
//     try {
//       await client.from('messages').update({'deleted': true}).eq('id', messageId);
//     } catch (e) {
//       debugPrint('deleteMessage error: $e');
//     }
//   }

//   /// Update message (edit, reactions)
//   Future<void> updateMessage(MessageModel msg) async {
//     try {
//       final map = msg.toUpdateMap();
//       map['reactions'] = map['reactions'] ?? <String>[];
//       await client.from('messages').update(map).eq('id', msg.id);
//     } catch (e) {
//       debugPrint('updateMessage error: $e');
//     }
//   }

//   /// Get or create campaign chat
//   Future<ChatModel?> getOrCreateChatForCampaign({
//     required String campaignId,
//     required String brandId,
//     required String influencerId,
//   }) async {
//     try {
//       final rows = await client
//           .from('chats')
//           .select('id')
//           .eq('campaign_id', campaignId)
//           .limit(1);

//       if ((rows as List).isNotEmpty) {
//         return ChatModel.fromMap(Map<String, dynamic>.from(rows.first));
//       }

//       final inserted = await client.from('chats').insert({
//         'title': 'Campaign Chat',
//         'campaign_id': campaignId,
//         'is_group': false,
//         'created_by': client.auth.currentUser?.id,
//       }).select().single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

//       // brandId & influencerId are from profiles table (not brands)
//       await client.from('chat_participants').insert([
//         {'chat_id': chat.id, 'user_id': brandId, 'role': 'brand'},
//         {'chat_id': chat.id, 'user_id': influencerId, 'role': 'influencer'},
//       ]);

//       return chat;
//     } catch (e) {
//       debugPrint('getOrCreateChatForCampaign error: $e');
//       return null;
//     }
//   }
// }
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/chat_model.dart';
// import '../models/message_model.dart';

// class ChatService {
//   final SupabaseClient client = Supabase.instance.client;
//   final String bucket = 'chat_images';

//   /// Fetch all chats where current user is a participant
//   Future<List<ChatModel>> getUserChats() async {
//     try {
//       final userId = client.auth.currentUser?.id;
//       if (userId == null) return [];

//       // ✅ Correct join syntax for Supabase Flutter
//       final rows = await client
//           .from('chats')
//           .select('''
//             id,
//             title,
//             campaign_id,
//             is_group,
//             last_message_text,
//             last_message_at,
//             chat_participants!inner(
//               user_id,
//               role,
//               profiles!inner(id, name, profile_image)
//             )
//           ''')
//           .eq('chat_participants.user_id', userId)
//           .order('last_message_at', ascending: false);

//       final List<Map<String, dynamic>> list =
//           (rows as List).map((r) => Map<String, dynamic>.from(r)).toList();

//       final List<Map<String, dynamic>> normalized = [];

//       for (final chat in list) {
//         final participants =
//             (chat['chat_participants'] as List?)?.cast<Map<String, dynamic>>() ?? [];

//         Map<String, dynamic>? partnerProfile;

//         for (final p in participants) {
//           final pid = p['user_id']?.toString();
//           // find the *other* participant
//           if (pid != null && pid != userId) {
//             if (p['profiles'] is Map) {
//               partnerProfile = Map<String, dynamic>.from(p['profiles'] as Map);
//             }
//             break;
//           }
//         }

//         // fallback for group chats
//         if (partnerProfile == null && participants.isNotEmpty) {
//           final p = participants.first;
//           if (p['profiles'] is Map) {
//             partnerProfile = Map<String, dynamic>.from(p['profiles'] as Map);
//           }
//         }

//         // Normalize
//         if (partnerProfile != null) {
//           chat['influencer_name'] = partnerProfile['name'] ?? 'User';
//           chat['influencer_profile_url'] =
//               partnerProfile['profile_image'] ?? '';
//         } else {
//           chat['influencer_name'] = chat['title'] ?? 'Conversation';
//           chat['influencer_profile_url'] = '';
//         }

//         normalized.add(chat);
//       }

//       return normalized.map((r) => ChatModel.fromMap(r)).toList();
//     } catch (e) {
//       debugPrint('❌ getUserChats error: $e');
//       return [];
//     }
//   }

//   /// Create a new chat
//   Future<ChatModel?> createChat({
//     required List<String> participantIds,
//     String? title,
//     String? campaignId,
//   }) async {
//     try {
//       final creatorId = client.auth.currentUser?.id;
//       if (creatorId == null) return null;

//       final inserted = await client
//           .from('chats')
//           .insert({
//             'title': title ?? 'Chat',
//             'campaign_id': campaignId,
//             'is_group': participantIds.length > 2,
//             'created_by': creatorId,
//           })
//           .select()
//           .single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

//       final participants = participantIds.toSet().map((id) => {
//             'chat_id': chat.id,
//             'user_id': id,
//             'role': id == creatorId ? 'creator' : 'member',
//           });

//       await client.from('chat_participants').insert(participants.toList());

//       return chat;
//     } catch (e) {
//       debugPrint('createChat error: $e');
//       return null;
//     }
//   }

//   /// Get messages
//   Future<List<MessageModel>> getMessages(String chatId, {int limit = 200}) async {
//     try {
//       final rows = await client
//           .from('messages')
//           .select()
//           .eq('chat_id', chatId)
//           .order('created_at', ascending: true)
//           .limit(limit);

//       return (rows as List)
//           .map((r) => MessageModel.fromMap(Map<String, dynamic>.from(r)))
//           .toList();
//     } catch (e) {
//       debugPrint('getMessages error: $e');
//       return [];
//     }
//   }

//   /// Send message
//   Future<bool> sendMessage(MessageModel msg) async {
//     try {
//       final map = msg.toInsertMap();
//       map['reactions'] = map['reactions'] ?? <String>[];
//       await client.from('messages').insert(map);
//       return true;
//     } catch (e) {
//       debugPrint('sendMessage error: $e');
//       return false;
//     }
//   }

//   /// Upload attachment
//   Future<String?> uploadAttachment(File file, String pathInBucket) async {
//     try {
//       final fileBytes = await file.readAsBytes();
//       await client.storage.from(bucket).uploadBinary(
//             pathInBucket,
//             fileBytes,
//             fileOptions: const FileOptions(upsert: true),
//           );

//       final signedUrl = await client.storage
//           .from(bucket)
//           .createSignedUrl(pathInBucket, 60 * 60 * 24);

//       return signedUrl;
//     } catch (e) {
//       debugPrint('uploadAttachment error: $e');
//       return null;
//     }
//   }

//   /// Mark message read
//   Future<void> markMessageRead(String messageId, String userId) async {
//     try {
//       final existing = await client
//           .from('messages')
//           .select('read_by')
//           .eq('id', messageId)
//           .single();

//       List<String> readByList =
//           (existing['read_by'] as List?)?.map((e) => e.toString()).toList() ?? [];
//       if (!readByList.contains(userId)) readByList.add(userId);

//       await client.from('messages').update({'read_by': readByList}).eq('id', messageId);
//     } catch (e) {
//       debugPrint('markMessageRead error: $e');
//     }
//   }

//   /// Delete message
//   Future<void> deleteMessage(String messageId) async {
//     try {
//       await client.from('messages').update({'deleted': true}).eq('id', messageId);
//     } catch (e) {
//       debugPrint('deleteMessage error: $e');
//     }
//   }

//   /// Update message (edit, reactions)
//   Future<void> updateMessage(MessageModel msg) async {
//     try {
//       final map = msg.toUpdateMap();
//       map['reactions'] = map['reactions'] ?? <String>[];
//       await client.from('messages').update(map).eq('id', msg.id);
//     } catch (e) {
//       debugPrint('updateMessage error: $e');
//     }
//   }

//   /// Get or create campaign chat
//   Future<ChatModel?> getOrCreateChatForCampaign({
//     required String campaignId,
//     required String brandId,
//     required String influencerId,
//   }) async {
//     try {
//       final rows = await client
//           .from('chats')
//           .select('id')
//           .eq('campaign_id', campaignId)
//           .limit(1);

//       if ((rows as List).isNotEmpty) {
//         return ChatModel.fromMap(Map<String, dynamic>.from(rows.first));
//       }

//       final inserted = await client.from('chats').insert({
//         'title': 'Campaign Chat',
//         'campaign_id': campaignId,
//         'is_group': false,
//         'created_by': client.auth.currentUser?.id,
//       }).select().single();

//       final chat = ChatModel.fromMap(Map<String, dynamic>.from(inserted));

//       // brandId & influencerId are from profiles table
//       await client.from('chat_participants').insert([
//         {'chat_id': chat.id, 'user_id': brandId, 'role': 'brand'},
//         {'chat_id': chat.id, 'user_id': influencerId, 'role': 'influencer'},
//       ]);

//       return chat;
//     } catch (e) {
//       debugPrint('getOrCreateChatForCampaign error: $e');
//       return null;
//     }
//   }
// }
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatService {
  final SupabaseClient client = Supabase.instance.client;
  final String bucket = 'chat_images';

  /// Fetch all chats where current user is a participant
  Future<List<ChatModel>> getUserChats() async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) return [];

      // ✅ Fetch chats with participants and their profiles
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

  /// Send message
  Future<bool> sendMessage(MessageModel msg) async {
    try {
      final map = msg.toInsertMap();
      map['reactions'] = map['reactions'] ?? <String>[];
      await client.from('messages').insert(map);
      return true;
    } catch (e) {
      debugPrint('❌ sendMessage error: $e');
      return false;
    }
  }

  /// Upload attachment
  Future<String?> uploadAttachment(File file, String pathInBucket) async {
    try {
      final fileBytes = await file.readAsBytes();
      await client.storage.from(bucket).uploadBinary(
            pathInBucket,
            fileBytes,
            fileOptions: const FileOptions(upsert: true),
          );

      final signedUrl = await client.storage
          .from(bucket)
          .createSignedUrl(pathInBucket, 60 * 60 * 24);

      return signedUrl;
    } catch (e) {
      debugPrint('❌ uploadAttachment error: $e');
      return null;
    }
  }

  /// Mark message read
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

  /// Get or create campaign chat
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
