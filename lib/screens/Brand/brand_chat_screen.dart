
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/utils/app_theme.dart';
// import 'package:provider/provider.dart';
// import '../../providers/chat_provider.dart';
// import '../../widgets/message_bubble.dart';
// import '../../widgets/message_input.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class BrandChatScreen extends StatefulWidget {
//   final String chatId;
//   const BrandChatScreen({Key? key, required this.chatId}) : super(key: key);

//   @override
//   State<BrandChatScreen> createState() => _BrandChatScreenState();
// }

// class _BrandChatScreenState extends State<BrandChatScreen> {
//   late ChatProvider cp;
//   final ScrollController _sc = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     cp = Provider.of<ChatProvider>(context, listen: false);

//     // ✅ Defer provider calls to AFTER first build
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (!mounted) return;
//       await cp.loadMessages(widget.chatId);
//       cp.markAllRead(widget.chatId);
//       _jumpToBottom();
//     });
//   }

//   void _jumpToBottom() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (_sc.hasClients) _sc.jumpTo(_sc.position.maxScrollExtent);
//     });
//   }

//   Future<void> _onSendText(String text) async {
//     await cp.sendText(widget.chatId, text);
//     _jumpToBottom();
//   }

//   Future<void> _onSendImage(File image) async {
//     await cp.sendImage(widget.chatId, image);
//     _jumpToBottom();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = Supabase.instance.client.auth.currentUser;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat'),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Consumer<ChatProvider>(
//               builder: (context, cp, _) {
//                 final msgs = cp.messages[widget.chatId] ?? [];
//                 if (cp.loadingMessages[widget.chatId] == true && msgs.isEmpty) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 return ListView.builder(
//                   controller: _sc,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   itemCount: msgs.length,
//                   itemBuilder: (context, i) {
//                     final m = msgs[i];
//                     final isMine = user != null && m.senderId == user.id;
//                     return MessageBubble(message: m, isMine: isMine);
//                   },
//                 );
//               },
//             ),
//           ),
//           MessageInput(onSendText: _onSendText, onSendImage: _onSendImage),
//         ],
//       ),
//     );
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../providers/chat_provider.dart';
// import '../../models/message_model.dart';
// import '../../widgets/message_input.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../../utils/app_theme.dart';

// class BrandChatScreen extends StatefulWidget {
//   final String chatId;
//   const BrandChatScreen({Key? key, required this.chatId}) : super(key: key);

//   @override
//   State<BrandChatScreen> createState() => _BrandChatScreenState();
// }

// class _BrandChatScreenState extends State<BrandChatScreen> {
//   late ChatProvider cp;
//   final ScrollController _sc = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     cp = Provider.of<ChatProvider>(context, listen: false);

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (!mounted) return;
//       await cp.loadMessages(widget.chatId);
//       cp.markAllRead(widget.chatId);
//       _jumpToBottom();
//     });
//   }

//   void _jumpToBottom() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (_sc.hasClients) _sc.jumpTo(_sc.position.maxScrollExtent);
//     });
//   }

//   Future<void> _onSendText(String text) async {
//     await cp.sendText(widget.chatId, text);
//     _jumpToBottom();
//   }

//   Future<void> _onSendImage(File image) async {
//     await cp.sendImage(widget.chatId, image);
//     _jumpToBottom();
//   }

//   /// Bottom sheet for long-press actions
//   void _showMessageOptions(MessageModel msg) {
//     final user = Supabase.instance.client.auth.currentUser;
//     final isMine = user != null && msg.senderId == user.id;

//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SafeArea(
//         child: Wrap(
//           children: [
//             if (isMine)
//               ListTile(
//                 leading: const Icon(Icons.edit),
//                 title: const Text('Edit'),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   final newText = await _showEditDialog(msg.text);
//                   if (newText != null && newText.trim().isNotEmpty) {
//                     await cp.editMessage(msg, newText.trim());
//                   }
//                 },
//               ),
//             if (isMine)
//               ListTile(
//                 leading: const Icon(Icons.delete),
//                 title: const Text('Delete'),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await cp.deleteMessage(msg);
//                 },
//               ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text('React', style: TextStyle(fontWeight: FontWeight.bold)),
//             ),
//             GridView.count(
//               crossAxisCount: 5,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               children: ['❤️', '😂', '😮', '😢', '👍', '👎', '🔥', '🎉', '😡', '🙏']
//                   .map((e) => GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                           cp.addReaction(msg, e);
//                         },
//                         child: Center(child: Text(e, style: const TextStyle(fontSize: 24))),
//                       ))
//                   .toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Dialog to edit message
//   Future<String?> _showEditDialog(String oldText) {
//     final controller = TextEditingController(text: oldText);
//     return showDialog<String>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Edit Message'),
//         content: TextField(controller: controller),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//           TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Save')),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessage(MessageModel msg, bool isMine) {
//     final ts = TimeOfDay.fromDateTime(msg.createdAt).format(context);
//     final bg = isMine ? AppTheme.primaryColor : Colors.grey.shade200;
//     final textColor = isMine ? Colors.white : Colors.black87;

//     return Align(
//       alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
//       child: GestureDetector(
//         onLongPress: () => _showMessageOptions(msg),
//         child: Container(
//           margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
//           padding: const EdgeInsets.all(10),
//           constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
//           decoration: BoxDecoration(
//             color: bg,
//             borderRadius: BorderRadius.circular(16).subtract(
//               BorderRadius.only(
//                 bottomRight: isMine ? const Radius.circular(0) : const Radius.circular(16),
//                 bottomLeft: !isMine ? const Radius.circular(0) : const Radius.circular(16),
//               ),
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               if (msg.type == 'image' && msg.attachmentUrl != null)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 6),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: CachedNetworkImage(
//                       imageUrl: msg.attachmentUrl!,
//                       placeholder: (_, __) => Container(height: 160, color: Colors.grey.shade300),
//                       errorWidget: (_, __, ___) =>
//                           Container(height: 160, color: Colors.grey.shade300, child: const Icon(Icons.broken_image)),
//                     ),
//                   ),
//                 ),
//               if (msg.type == 'text')
//                 Text(msg.text, style: TextStyle(color: textColor, fontSize: 16)),
//               if (msg.reactions.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4),
//                   child: Wrap(
//                     spacing: 4,
//                     children: msg.reactions.map((e) => Text(e, style: const TextStyle(fontSize: 16))).toList(),
//                   ),
//                 ),
//               const SizedBox(height: 4),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(ts, style: TextStyle(fontSize: 10, color: isMine ? Colors.white70 : Colors.black54)),
//                   const SizedBox(width: 4),
//                   if (isMine)
//                     Icon(
//                       msg.readBy.isNotEmpty ? Icons.done_all : Icons.check,
//                       size: 14,
//                       color: isMine ? Colors.white70 : Colors.black45,
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = Supabase.instance.client.auth.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat'),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Consumer<ChatProvider>(
//               builder: (_, cp, __) {
//                 final msgs = cp.messages[widget.chatId] ?? [];
//                 if ((cp.loadingMessages[widget.chatId] ?? false) && msgs.isEmpty) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 return ListView.builder(
//                   controller: _sc,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   itemCount: msgs.length,
//                   itemBuilder: (_, i) {
//                     final m = msgs[i];
//                     final isMine = user != null && m.senderId == user.id;
//                     return _buildMessage(m, isMine);
//                   },
//                 );
//               },
//             ),
//           ),
//           MessageInput(onSendText: _onSendText, onSendImage: _onSendImage),
//         ],
//       ),
//     );
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../providers/chat_provider.dart';
// import '../../models/message_model.dart';
// import '../../widgets/message_input.dart';
// import '../../utils/app_theme.dart';

// class BrandChatScreen extends StatefulWidget {
//   final String chatId;
//   const BrandChatScreen({Key? key, required this.chatId}) : super(key: key);

//   @override
//   State<BrandChatScreen> createState() => _BrandChatScreenState();
// }

// class _BrandChatScreenState extends State<BrandChatScreen> {
//   late ChatProvider cp;
//   final ScrollController _sc = ScrollController();
//   final List<String> reactionsList = ['👍','❤️','😂','😮','😢','👏'];

//   @override
//   void initState() {
//     super.initState();
//     cp = Provider.of<ChatProvider>(context, listen: false);
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (!mounted) return;
//       await cp.loadMessages(widget.chatId);
//       cp.markAllRead(widget.chatId);
//       _scrollToBottom();
//     });
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (_sc.hasClients) _sc.jumpTo(_sc.position.maxScrollExtent);
//     });
//   }

//   Future<void> _onSendText(String text) async {
//     if (text.trim().isEmpty) return;
//     await cp.sendText(widget.chatId, text);
//     _scrollToBottom();
//   }

//   Future<void> _onSendImage(File image) async {
//     await cp.sendImage(widget.chatId, image);
//     _scrollToBottom();
//   }

//   void _showMessageOptions(MessageModel msg) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) {
//         return SizedBox(
//           height: 180,
//           child: Column(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.edit),
//                 title: const Text('Edit'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showEditDialog(msg);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.delete),
//                 title: const Text('Delete'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   cp.deleteMessage(msg);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.emoji_emotions),
//                 title: const Text('React'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showReactions(msg);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showEditDialog(MessageModel msg) {
//     final controller = TextEditingController(text: msg.text);
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Edit Message'),
//         content: TextField(controller: controller),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               cp.editMessage(msg, controller.text.trim());
//               Navigator.pop(context);
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showReactions(MessageModel msg) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SizedBox(
//         height: 80,
//         child: GridView.builder(
//           scrollDirection: Axis.horizontal,
//           padding: const EdgeInsets.all(8),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 1,
//             mainAxisSpacing: 10,
//           ),
//           itemCount: reactionsList.length,
//           itemBuilder: (_, index) {
//             final emoji = reactionsList[index];
//             return GestureDetector(
//               onTap: () {
//                 cp.addReaction(msg, emoji);
//                 Navigator.pop(context);
//               },
//               child: CircleAvatar(
//                 radius: 25,
//                 child: Text(emoji, style: const TextStyle(fontSize: 24)),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageBubble(MessageModel msg, bool isMine) {
//     final user = Supabase.instance.client.auth.currentUser;
//     return GestureDetector(
//       onLongPress: () => _showMessageOptions(msg),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
//         child: Column(
//           crossAxisAlignment:
//               isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 color: isMine
//                     ? AppTheme.primaryColor
//                     : Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: msg.type == 'text'
//                   ? Text(
//                       msg.text,
//                       style: TextStyle(
//                         color: isMine ? Colors.white : Colors.black,
//                       ),
//                     )
//                   : ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.network(msg.attachmentUrl ?? ''),
//                     ),
//             ),
//             if (msg.reactions.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
//                 child: Wrap(
//                   spacing: 4,
//                   children: msg.reactions
//                       .map((r) => Text(r, style: const TextStyle(fontSize: 16)))
//                       .toList(),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = Supabase.instance.client.auth.currentUser;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat'),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Consumer<ChatProvider>(
//               builder: (context, cp, _) {
//                 final msgs = cp.messages[widget.chatId] ?? [];
//                 if (cp.loadingMessages[widget.chatId] == true &&
//                     msgs.isEmpty) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 return ListView.builder(
//                   controller: _sc,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   itemCount: msgs.length,
//                   itemBuilder: (context, i) {
//                     final m = msgs[i];
//                     final isMine = user != null && m.senderId == user.id;
//                     return _buildMessageBubble(m, isMine);
//                   },
//                 );
//               },
//             ),
//           ),
//           MessageInput(onSendText: _onSendText, onSendImage: _onSendImage),
//         ],
//       ),
//     );
//   }
// }
// correct code above//
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/chat_provider.dart';
import '../../models/message_model.dart';
import '../../widgets/message_input.dart';
import '../../utils/app_theme.dart';

class BrandChatScreen extends StatefulWidget {
  final String chatId;
  const BrandChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  State<BrandChatScreen> createState() => _BrandChatScreenState();
}

class _BrandChatScreenState extends State<BrandChatScreen> {
  late ChatProvider cp;
  final ScrollController _sc = ScrollController();
  final List<String> reactionsList = ['👍','❤️','😂','😮','😢','👏'];

  @override
  void initState() {
    super.initState();
    cp = Provider.of<ChatProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await cp.loadMessages(widget.chatId);
      cp.markAllRead(widget.chatId);
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_sc.hasClients) _sc.jumpTo(_sc.position.maxScrollExtent);
    });
  }

  Future<void> _onSendText(String text) async {
    if (text.trim().isEmpty) return;
    await cp.sendText(widget.chatId, text);
    _scrollToBottom();
  }

  Future<void> _onSendImage(File image) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    // Temporary local message
    final tempMsg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: widget.chatId,
      senderId: userId,
      type: 'image',
      attachmentUrl: image.path, // local file path for preview
      createdAt: DateTime.now(),
    );

    cp.messages.putIfAbsent(widget.chatId, () => []);
    cp.messages[widget.chatId]!.add(tempMsg);
    setState(() {});
    _scrollToBottom();

    try {
      final filename = image.path.split('/').last;
      final path = '${widget.chatId}/${DateTime.now().millisecondsSinceEpoch}_$filename';

      // Upload to Supabase storage
      final fileBytes = await image.readAsBytes();
      await Supabase.instance.client.storage.from('chat_images').uploadBinary(
        path,
        fileBytes,
        fileOptions: const FileOptions(upsert: true),
      );

      final url = await Supabase.instance.client.storage
          .from('chat_images')
          .createSignedUrl(path, 60 * 60 * 24);

      // Update temp message with remote URL
      tempMsg.attachmentUrl = url;

      // Send the message to backend
      await cp.sendImage(widget.chatId, image);
    } catch (e) {
      debugPrint('sendImage error: $e');
    } finally {
      setState(() {});
      _scrollToBottom();
    }
  }

  void _showMessageOptions(MessageModel msg) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SizedBox(
          height: 180,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(msg);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  cp.deleteMessage(msg);
                },
              ),
              ListTile(
                leading: const Icon(Icons.emoji_emotions),
                title: const Text('React'),
                onTap: () {
                  Navigator.pop(context);
                  _showReactions(msg);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditDialog(MessageModel msg) {
    final controller = TextEditingController(text: msg.text);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Message'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cp.editMessage(msg, controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showReactions(MessageModel msg) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        height: 80,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 10,
          ),
          itemCount: reactionsList.length,
          itemBuilder: (_, index) {
            final emoji = reactionsList[index];
            return GestureDetector(
              onTap: () {
                cp.addReaction(msg, emoji);
                Navigator.pop(context);
              },
              child: CircleAvatar(
                radius: 25,
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel msg, bool isMine) {
    final isUploading = msg.type == 'image' && !msg.attachmentUrl!.startsWith('http');

    return GestureDetector(
      onLongPress: () => _showMessageOptions(msg),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: msg.type == 'text'
                  ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                  : const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isMine ? AppTheme.primaryColor : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: msg.type == 'text'
                  ? Text(
                      msg.text,
                      style: TextStyle(
                        color: isMine ? Colors.white : Colors.black,
                      ),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: isUploading
                              ? Image.file(
                                  File(msg.attachmentUrl!),
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  msg.attachmentUrl!,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        if (isUploading)
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(color: Colors.white),
                                  SizedBox(height: 8),
                                  Text(
                                    'Sending...',
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
            if (msg.reactions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
                child: Wrap(
                  spacing: 4,
                  children: msg.reactions
                      .map((r) => Text(r, style: const TextStyle(fontSize: 16)))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
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
                if (cp.loadingMessages[widget.chatId] == true && msgs.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  controller: _sc,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: msgs.length,
                  itemBuilder: (context, i) {
                    final m = msgs[i];
                    final isMine = user != null && m.senderId == user.id;
                    return _buildMessageBubble(m, isMine);
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
