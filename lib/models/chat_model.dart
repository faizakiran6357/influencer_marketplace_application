// // lib/models/chat_model.dart
// import 'package:flutter/foundation.dart';

// class ChatModel {
//   final String id;
//   final String? campaignId;
//   final String? title;
//   final bool isGroup;
//   final String? lastMessageText;
//   final DateTime? lastMessageAt;

//   ChatModel({
//     required this.id,
//     this.campaignId,
//     this.title,
//     this.isGroup = false,
//     this.lastMessageText,
//     this.lastMessageAt,
//   });

//   factory ChatModel.fromMap(Map<String, dynamic> m) {
//     return ChatModel(
//       id: m['id'] as String,
//       campaignId: m['campaign_id'] as String?,
//       title: m['title'] as String?,
//       isGroup: (m['is_group'] as bool?) ?? false,
//       lastMessageText: m['last_message_text'] as String?,
//       lastMessageAt: m['last_message_at'] != null ? DateTime.parse(m['last_message_at'] as String) : null,
//     );
//   }
// }
// lib/models/chat_model.dart
// import 'package:flutter/foundation.dart';

// class ChatModel {
//   final String id;
//   final String? campaignId;
//   final String? title;
//   final bool isGroup;
//   final String? lastMessageText;
//   final DateTime? lastMessageAt;

//   // ✅ Add influencer name
//   final String? influencerName;

//   ChatModel({
//     required this.id,
//     this.campaignId,
//     this.title,
//     this.isGroup = false,
//     this.lastMessageText,
//     this.lastMessageAt,
//     this.influencerName, // new field
//   });

//   factory ChatModel.fromMap(Map<String, dynamic> m) {
//     return ChatModel(
//       id: m['id'] as String,
//       campaignId: m['campaign_id'] as String?,
//       title: m['title'] as String?,
//       isGroup: (m['is_group'] as bool?) ?? false,
//       lastMessageText: m['last_message_text'] as String?,
//       lastMessageAt: m['last_message_at'] != null
//           ? DateTime.parse(m['last_message_at'] as String)
//           : null,
//       influencerName: m['influencer_name'] as String?, // map from API/RPC
//     );
//   }
// }
// import 'package:flutter/foundation.dart';

// class ChatModel {
//   final String id;
//   final String? campaignId;
//   final String? title;
//   final bool isGroup;
//   final String? lastMessageText;
//   final DateTime? lastMessageAt;

//   // Participant info for AppBar
//   final String participantName;
//   final String participantProfileUrl;

//   ChatModel({
//     required this.id,
//     this.campaignId,
//     this.title,
//     this.isGroup = false,
//     this.lastMessageText,
//     this.lastMessageAt,
//     required this.participantName,       // make required
//     required this.participantProfileUrl, // make required
//   });

//   factory ChatModel.fromMap(Map<String, dynamic> m) {
//     // Fetch participant info from joined user data
//     // Adjust keys depending on your Supabase join structure
//     final user = m['user'] ?? {};
//     final name = user['full_name'] ?? 'User';
//     final avatar = user['avatar_url'] ?? '';

//     return ChatModel(
//       id: m['id'] as String,
//       campaignId: m['campaign_id'] as String?,
//       title: m['title'] as String?,
//       isGroup: (m['is_group'] as bool?) ?? false,
//       lastMessageText: m['last_message_text'] as String?,
//       lastMessageAt: m['last_message_at'] != null
//           ? DateTime.parse(m['last_message_at'] as String)
//           : null,
//       participantName: name,
//       participantProfileUrl: avatar,
//     );
//   }
// }
// lib/models/chat_model.dart
import 'package:flutter/foundation.dart';

class ChatModel {
  final String id;
  final String? campaignId;
  final String? title;
  final bool isGroup;
  final String? lastMessageText;
  final DateTime? lastMessageAt;

  // ✅ Add influencer info
  final String? influencerName;
  final String? influencerProfileUrl;

  ChatModel({
    required this.id,
    this.campaignId,
    this.title,
    this.isGroup = false,
    this.lastMessageText,
    this.lastMessageAt,
    this.influencerName,        // new field
    this.influencerProfileUrl,  // new field
  });

  factory ChatModel.fromMap(Map<String, dynamic> m) {
    return ChatModel(
      id: m['id'] as String,
      campaignId: m['campaign_id'] as String?,
      title: m['title'] as String?,
      isGroup: (m['is_group'] as bool?) ?? false,
      lastMessageText: m['last_message_text'] as String?,
      lastMessageAt: m['last_message_at'] != null
          ? DateTime.parse(m['last_message_at'] as String)
          : null,
      influencerName: m['influencer_name'] as String?,          // map from API/RPC
      influencerProfileUrl: m['influencer_profile_url'] as String?, // map from API/RPC
    );
  }
}
