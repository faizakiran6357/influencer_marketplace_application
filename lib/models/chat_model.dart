
// // lib/models/chat_model.dart
// import 'package:flutter/foundation.dart';

// class ChatModel {
//   final String id;
//   final String? campaignId;
//   final String? title;
//   final bool isGroup;
//   final String? lastMessageText;
//   final DateTime? lastMessageAt;

//   // ✅ Add influencer info
//   final String? influencerName;
//   final String? influencerProfileUrl;

//   ChatModel({
//     required this.id,
//     this.campaignId,
//     this.title,
//     this.isGroup = false,
//     this.lastMessageText,
//     this.lastMessageAt,
//     this.influencerName,        // new field
//     this.influencerProfileUrl,  // new field
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
//       influencerName: m['influencer_name'] as String?,          // map from API/RPC
//       influencerProfileUrl: m['influencer_profile_url'] as String?, // map from API/RPC
//     );
//   }
// }
// class ChatModel {
//   final String id;
//   final String? campaignId;
//   final String? title;
//   final bool isGroup;
//   final String? lastMessageText;
//   final DateTime? lastMessageAt;

//   // ✅ Generic partner info
//   final String? partnerName;
//   final String? partnerProfileUrl;

//   ChatModel({
//     required this.id,
//     this.campaignId,
//     this.title,
//     this.isGroup = false,
//     this.lastMessageText,
//     this.lastMessageAt,
//     this.partnerName,
//     this.partnerProfileUrl,
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
//       partnerName: m['partner_name'] as String?,
//       partnerProfileUrl: m['partner_profile_url'] as String?,
//     );
//   }
// }
import 'package:flutter/foundation.dart';

class ChatModel {
  final String id;
  final String? campaignId;
  final String? title;
  final bool isGroup;
  final String? lastMessageText;
  final DateTime? lastMessageAt;

  // ✅ Unified partner info (works for both brand and influencer)
  final String? partnerName;
  final String? partnerProfileUrl;

  ChatModel({
    required this.id,
    this.campaignId,
    this.title,
    this.isGroup = false,
    this.lastMessageText,
    this.lastMessageAt,
    this.partnerName,
    this.partnerProfileUrl,
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
      partnerName: m['partner_name'] as String?,         // new unified field
      partnerProfileUrl: m['partner_profile_url'] as String?, // new unified field
    );
  }
}
