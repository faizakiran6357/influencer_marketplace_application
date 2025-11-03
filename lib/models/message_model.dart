// // lib/models/message_model.dart
// class MessageModel {
//   final String id;
//   final String chatId;
//   final String? senderId;
//   final String? content;
//   final String? attachmentUrl;
//   final Map<String, dynamic>? attachmentMeta;
//   final DateTime createdAt;
//   final bool deleted;
//   final List<String> readBy;

//   MessageModel({
//     required this.id,
//     required this.chatId,
//     this.senderId,
//     this.content,
//     this.attachmentUrl,
//     this.attachmentMeta,
//     required this.createdAt,
//     this.deleted = false,
//     this.readBy = const [],
//   });

//   factory MessageModel.fromMap(Map<String, dynamic> m) {
//     return MessageModel(
//       id: m['id'] as String,
//       chatId: m['chat_id'] as String,
//       senderId: m['sender_id'] as String?,
//       content: m['content'] as String?,
//       attachmentUrl: m['attachment_url'] as String?,
//       attachmentMeta: (m['attachment_meta'] as Map<String, dynamic>?) ?? {},
//       createdAt: m['created_at'] != null ? DateTime.parse(m['created_at'] as String) : DateTime.now(),
//       deleted: (m['deleted'] as bool?) ?? false,
//       readBy: (m['read_by'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//     );
//   }

//   Map<String, dynamic> toInsertMap() {
//     return {
//       'chat_id': chatId,
//       'sender_id': senderId,
//       'content': content,
//       'attachment_url': attachmentUrl,
//       'attachment_meta': attachmentMeta,
//     };
//   }
// }
// lib/models/message_model.dart
// class MessageModel {
//   final String id;
//   final String chatId;
//   final String? senderId;
//   String text; // editable content
//   String type; // 'text' or 'image'
//   String? attachmentUrl;
//   Map<String, dynamic>? attachmentMeta;
//   List<String> reactions; // emoji reactions
//   final DateTime createdAt;
//   bool deleted;
//   List<String> readBy;

//   MessageModel({
//     required this.id,
//     required this.chatId,
//     this.senderId,
//     this.text = '',
//     this.type = 'text',
//     this.attachmentUrl,
//     this.attachmentMeta,
//     this.reactions = const [],
//     required this.createdAt,
//     this.deleted = false,
//     this.readBy = const [],
//   });

//   factory MessageModel.fromMap(Map<String, dynamic> m) {
//     return MessageModel(
//       id: m['id'] as String,
//       chatId: m['chat_id'] as String,
//       senderId: m['sender_id'] as String?,
//       text: m['content'] as String? ?? '',
//       type: m['type'] as String? ?? 'text',
//       attachmentUrl: m['attachment_url'] as String?,
//       attachmentMeta: (m['attachment_meta'] as Map<String, dynamic>?) ?? {},
//       reactions: (m['reactions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//       createdAt: m['created_at'] != null
//           ? DateTime.parse(m['created_at'] as String)
//           : DateTime.now(),
//       deleted: (m['deleted'] as bool?) ?? false,
//       readBy: (m['read_by'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
//     );
//   }

//   Map<String, dynamic> toInsertMap() {
//     return {
//       'chat_id': chatId,
//       'sender_id': senderId,
//       'content': text,
//       'type': type,
//       'attachment_url': attachmentUrl,
//       'attachment_meta': attachmentMeta,
//       'reactions': reactions,
//     };
//   }

//   Map<String, dynamic> toUpdateMap() {
//     return {
//       'content': text,
//       'type': type,
//       'attachment_url': attachmentUrl,
//       'attachment_meta': attachmentMeta,
//       'reactions': reactions,
//       'deleted': deleted,
//       'read_by': readBy,
//     };
//   }
// }
class MessageModel {
  final String id;
  final String chatId;
  final String? senderId;
  String text; // editable content
  String type; // 'text' or 'image'
  String? attachmentUrl;
  Map<String, dynamic>? attachmentMeta;
  List<String> reactions; // emoji reactions
  final DateTime createdAt;
  bool deleted;
  List<String> readBy;

  MessageModel({
    required this.id,
    required this.chatId,
    this.senderId,
    this.text = '',
    this.type = 'text',
    this.attachmentUrl,
    this.attachmentMeta,
    this.reactions = const [],
    required this.createdAt,
    this.deleted = false,
    this.readBy = const [],
  });

  factory MessageModel.fromMap(Map<String, dynamic> m) {
    return MessageModel(
      id: m['id'] as String,
      chatId: m['chat_id'] as String,
      senderId: m['sender_id'] as String?,
      text: m['content'] as String? ?? '',
      type: m['type'] as String? ?? 'text',
      attachmentUrl: m['attachment_url'] as String?,
      attachmentMeta: (m['attachment_meta'] as Map<String, dynamic>?) ?? {},
      reactions: (m['reactions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: m['created_at'] != null
          ? DateTime.parse(m['created_at'] as String)
          : DateTime.now(),
      deleted: (m['deleted'] as bool?) ?? false,
      readBy: (m['read_by'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'chat_id': chatId,
      'sender_id': senderId,
      'content': text,
      'type': type,
      'attachment_url': attachmentUrl,
      'attachment_meta': attachmentMeta,
      'reactions': reactions,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'content': text,
      'type': type,
      'attachment_url': attachmentUrl,
      'attachment_meta': attachmentMeta,
      'reactions': reactions,
      'deleted': deleted,
      'read_by': readBy,
    };
  }
}
