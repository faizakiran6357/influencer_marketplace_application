
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
//     final userId = Supabase.instance.client.auth.currentUser?.id;
//     if (userId == null) return;

//     // Temporary local message
//     final tempMsg = MessageModel(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       chatId: widget.chatId,
//       senderId: userId,
//       type: 'image',
//       attachmentUrl: image.path, // local file path for preview
//       createdAt: DateTime.now(),
//     );

//     cp.messages.putIfAbsent(widget.chatId, () => []);
//     cp.messages[widget.chatId]!.add(tempMsg);
//     setState(() {});
//     _scrollToBottom();

//     try {
//       final filename = image.path.split('/').last;
//       final path = '${widget.chatId}/${DateTime.now().millisecondsSinceEpoch}_$filename';

//       // Upload to Supabase storage
//       final fileBytes = await image.readAsBytes();
//       await Supabase.instance.client.storage.from('chat_images').uploadBinary(
//         path,
//         fileBytes,
//         fileOptions: const FileOptions(upsert: true),
//       );

//       final url = await Supabase.instance.client.storage
//           .from('chat_images')
//           .createSignedUrl(path, 60 * 60 * 24);

//       // Update temp message with remote URL
//       tempMsg.attachmentUrl = url;

//       // Send the message to backend
//       await cp.sendImage(widget.chatId, image);
//     } catch (e) {
//       debugPrint('sendImage error: $e');
//     } finally {
//       setState(() {});
//       _scrollToBottom();
//     }
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
//     final isUploading = msg.type == 'image' && !msg.attachmentUrl!.startsWith('http');

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
//               padding: msg.type == 'text'
//                   ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
//                   : const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: isMine ? AppTheme.primaryColor : Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: msg.type == 'text'
//                   ? Text(
//                       msg.text,
//                       style: TextStyle(
//                         color: isMine ? Colors.white : Colors.black,
//                       ),
//                     )
//                   : Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: isUploading
//                               ? Image.file(
//                                   File(msg.attachmentUrl!),
//                                   width: 200,
//                                   height: 200,
//                                   fit: BoxFit.cover,
//                                 )
//                               : Image.network(
//                                   msg.attachmentUrl!,
//                                   width: 200,
//                                   height: 200,
//                                   fit: BoxFit.cover,
//                                 ),
//                         ),
//                         if (isUploading)
//                           Container(
//                             width: 200,
//                             height: 200,
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.4),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: const Center(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   CircularProgressIndicator(color: Colors.white),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     'Sending...',
//                                     style: TextStyle(color: Colors.white, fontSize: 14),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                       ],
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
//   final String participantName;
//   final String participantProfileUrl;

//   const BrandChatScreen({
//     Key? key,
//     required this.chatId,
//     required this.participantName,
//     required this.participantProfileUrl,
//   }) : super(key: key);

//   @override
//   State<BrandChatScreen> createState() => _BrandChatScreenState();
// }

// class _BrandChatScreenState extends State<BrandChatScreen> {
//   late ChatProvider cp;
//   final ScrollController _sc = ScrollController();
//   final List<String> reactionsList = ['👍', '❤️', '😂', '😮', '😢', '👏'];
//   Set<String> sendingImageIds = {};

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
//     final tempId = DateTime.now().millisecondsSinceEpoch.toString();
//     sendingImageIds.add(tempId);
//     setState(() {});

//     await cp.sendImage(widget.chatId, image);
//     sendingImageIds.remove(tempId);
//     setState(() {});

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
//               constraints: const BoxConstraints(
//                   maxWidth: 250, maxHeight: 250), // WhatsApp style
//               padding: msg.type == 'text'
//                   ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
//                   : EdgeInsets.zero,
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
//                   : Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.network(
//                             msg.attachmentUrl ?? '',
//                             fit: BoxFit.cover,
//                             width: 200,
//                             height: 200,
//                           ),
//                         ),
//                         if (sendingImageIds.contains(msg.id))
//                           Container(
//                             width: 200,
//                             height: 200,
//                             color: Colors.black38,
//                             child: const Center(
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                       ],
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
//         backgroundColor: AppTheme.primaryColor,
//         titleSpacing: 0,
//         title: Row(
//           children: [
//             const SizedBox(width: 8),
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: widget.participantProfileUrl.isNotEmpty
//                   ? NetworkImage(widget.participantProfileUrl)
//                   : null,
//               child: widget.participantProfileUrl.isEmpty
//                   ? const Icon(Icons.person)
//                   : null,
//             ),
//             const SizedBox(width: 12),
//             Text(
//               widget.participantName,
//               style:
//                   const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
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
//   final String participantName;
//   final String participantProfileUrl;

//   const BrandChatScreen({
//     Key? key,
//     required this.chatId,
//     required this.participantName,
//     required this.participantProfileUrl,
//   }) : super(key: key);

//   @override
//   State<BrandChatScreen> createState() => _BrandChatScreenState();
// }

// class _BrandChatScreenState extends State<BrandChatScreen> {
//   late ChatProvider cp;
//   final ScrollController _sc = ScrollController();
//   final List<String> reactionsList = ['👍', '❤️', '😂', '😮', '😢', '👏'];
//   final Set<String> sendingImageIds = {};

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
//     final tempId = DateTime.now().millisecondsSinceEpoch.toString();
//     sendingImageIds.add(tempId);
//     setState(() {});

//     await cp.sendImage(widget.chatId, image);

//     // Remove tempId after sending
//     sendingImageIds.remove(tempId);
//     setState(() {});

//     _scrollToBottom();
//   }

//   void _showMessageOptions(MessageModel msg) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SizedBox(
//         height: 180,
//         child: Column(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.edit),
//               title: const Text('Edit'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _showEditDialog(msg);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.delete),
//               title: const Text('Delete'),
//               onTap: () {
//                 Navigator.pop(context);
//                 cp.deleteMessage(msg);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.emoji_emotions),
//               title: const Text('React'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _showReactions(msg);
//               },
//             ),
//           ],
//         ),
//       ),
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
//               constraints: const BoxConstraints(maxWidth: 250, maxHeight: 250),
//               padding: msg.type == 'text'
//                   ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
//                   : EdgeInsets.zero,
//               decoration: BoxDecoration(
//                 color: isMine ? AppTheme.primaryColor : Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: msg.type == 'text'
//                   ? Text(
//                       msg.text,
//                       style: TextStyle(
//                         color: isMine ? Colors.white : Colors.black,
//                       ),
//                     )
//                   : Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Image.network(
//                             msg.attachmentUrl ?? '',
//                             fit: BoxFit.cover,
//                             width: 200,
//                             height: 200,
//                           ),
//                         ),
//                         if (sendingImageIds.contains(msg.id))
//                           Container(
//                             width: 200,
//                             height: 200,
//                             color: Colors.black38,
//                             child: const Center(
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                       ],
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
//         backgroundColor: AppTheme.primaryColor,
//         titleSpacing: 0,
//         title: Row(
//           children: [
//             const SizedBox(width: 8),
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: widget.participantProfileUrl.isNotEmpty
//                   ? NetworkImage(widget.participantProfileUrl)
//                   : null,
//               child: widget.participantProfileUrl.isEmpty
//                   ? const Icon(Icons.person)
//                   : null,
//             ),
//             const SizedBox(width: 12),
//             Text(
//               widget.participantName,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
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
  final String partnerName;
  final String partnerProfileUrl;

  const BrandChatScreen({
    Key? key,
    required this.chatId,
    required this.partnerName,
    required this.partnerProfileUrl,
  }) : super(key: key);

  @override
  State<BrandChatScreen> createState() => _BrandChatScreenState();
}

class _BrandChatScreenState extends State<BrandChatScreen> {
  late ChatProvider cp;
  final ScrollController _sc = ScrollController();
  final List<String> reactionsList = ['👍', '❤️', '😂', '😮', '😢', '👏'];
  final Set<String> sendingImageIds = {};

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
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    sendingImageIds.add(tempId);
    setState(() {});

    await cp.sendImage(widget.chatId, image);

    sendingImageIds.remove(tempId);
    setState(() {});
    _scrollToBottom();
  }

  void _showMessageOptions(MessageModel msg) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
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
      ),
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
    final user = Supabase.instance.client.auth.currentUser;

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
              constraints: const BoxConstraints(maxWidth: 250, maxHeight: 250),
              padding: msg.type == 'text'
                  ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                  : EdgeInsets.zero,
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
                          child: Image.network(
                            msg.attachmentUrl ?? '',
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          ),
                        ),
                        if (sendingImageIds.contains(msg.id))
                          Container(
                            width: 200,
                            height: 200,
                            color: Colors.black38,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
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
        backgroundColor: AppTheme.primaryColor,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 20,
              backgroundImage: widget.partnerProfileUrl.isNotEmpty
                  ? NetworkImage(widget.partnerProfileUrl)
                  : null,
              child: widget.partnerProfileUrl.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              widget.partnerName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
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
