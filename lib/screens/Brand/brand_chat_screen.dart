
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../providers/chat_provider.dart';
// import '../../providers/theme_provider.dart';
// import '../../providers/brand_provider.dart';
// import '../../models/message_model.dart';
// import '../../widgets/message_input.dart';
// import '../../utils/app_theme.dart';

// class BrandChatScreen extends StatefulWidget {
//   final String chatId;
//   final String partnerName;
//   final String partnerProfileUrl;

//   const BrandChatScreen({
//     Key? key,
//     required this.chatId,
//     required this.partnerName,
//     required this.partnerProfileUrl,
//   }) : super(key: key);

//   @override
//   State<BrandChatScreen> createState() => _BrandChatScreenState();
// }

// class _BrandChatScreenState extends State<BrandChatScreen> {
//   late ChatProvider cp;
//   final ScrollController _sc = ScrollController();
//   bool _hasScrolledToBottom = false;
//   final List<String> reactionsList = ['👍', '❤️', '😂', '😮', '😢', '👏'];

//   @override
//   void initState() {
//     super.initState();
//     cp = Provider.of<ChatProvider>(context, listen: false);

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (!mounted) return;
//       await cp.loadMessages(widget.chatId);
//       cp.markAllRead(widget.chatId);
//       // Wait for messages to be loaded and UI to rebuild
//       Future.delayed(const Duration(milliseconds: 500), () {
//         _scrollToBottom();
//         _hasScrolledToBottom = true;
//       });
//     });
//   }

//   void _scrollToBottom({bool animated = false}) {
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (_sc.hasClients) {
//         if (animated) {
//           _sc.animateTo(
//             _sc.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//           );
//         } else {
//           _sc.jumpTo(_sc.position.maxScrollExtent);
//         }
//       }
//     });
//   }

//   Future<void> _onSendText(String text) async {
//     if (text.trim().isEmpty) return;

//     // Get partner id
//     final participants = await Supabase.instance.client
//         .from('chat_participants')
//         .select('user_id')
//         .eq('chat_id', widget.chatId);

//     final currentUserId = Supabase.instance.client.auth.currentUser?.id;
//     String? partnerId;
//     for (final p in (participants as List)) {
//       if (p['user_id'] != currentUserId) {
//         partnerId = p['user_id'];
//         break;
//       }
//     }

//     await cp.sendText(widget.chatId, text, receiverId: partnerId);
//     Future.delayed(const Duration(milliseconds: 100), () {
//       _scrollToBottom(animated: true);
//     });
//   }

//   Future<void> _onSendImage(File image) async {
//     // Get partner id first
//     final participants = await Supabase.instance.client
//         .from('chat_participants')
//         .select('user_id')
//         .eq('chat_id', widget.chatId);

//     final currentUserId = Supabase.instance.client.auth.currentUser?.id;
//     String? partnerId;
//     for (final p in (participants as List)) {
//       if (p['user_id'] != currentUserId) {
//         partnerId = p['user_id'];
//         break;
//       }
//     }

//     // Send image and track the URL
//     await cp.sendImage(widget.chatId, image, receiverId: partnerId);
    
//     // Wait a bit for the message to be added, then scroll
//     Future.delayed(const Duration(milliseconds: 100), () {
//       _scrollToBottom(animated: true);
//     });
//   }

//   void _showMessageOptions(MessageModel msg) {
//     final themeProvider = context.read<ThemeProvider>();
//     final isDark = themeProvider.isDark;
    
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => Container(
//         decoration: BoxDecoration(
//           color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 12, bottom: 8),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                 child: Column(
//                   children: [
//                     _buildOptionTile(
//                       icon: LucideIcons.edit3,
//                       title: 'Edit',
//                       color: AppTheme.primaryColor,
//                       isDark: isDark,
//                       onTap: () {
//                         Navigator.pop(context);
//                         _showEditDialog(msg);
//                       },
//                     ),
//                     _buildOptionTile(
//                       icon: LucideIcons.trash2,
//                       title: 'Delete',
//                       color: Colors.red.shade600,
//                       isDark: isDark,
//                       onTap: () {
//                         Navigator.pop(context);
//                         cp.deleteMessage(msg);
//                       },
//                     ),
//                     _buildOptionTile(
//                       icon: LucideIcons.smile,
//                       title: 'React',
//                       color: Colors.amber.shade600,
//                       isDark: isDark,
//                       onTap: () {
//                         Navigator.pop(context);
//                         _showReactions(msg);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionTile({
//     required IconData icon,
//     required String title,
//     required Color color,
//     required bool isDark,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: color, size: 20),
//             ),
//             const SizedBox(width: 16),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: isDark ? Colors.white : Colors.black87,
//               ),
//             ),
//             const Spacer(),
//             Icon(
//               LucideIcons.chevronRight,
//               size: 20,
//               color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showEditDialog(MessageModel msg) {
//     final themeProvider = context.read<ThemeProvider>();
//     final isDark = themeProvider.isDark;
//     final controller = TextEditingController(text: msg.text);
    
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: AppTheme.primaryColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(
//                 LucideIcons.edit3,
//                 color: AppTheme.primaryColor,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text(
//               'Edit Message',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: isDark ? Colors.white : Colors.black87,
//               ),
//             ),
//           ],
//         ),
//         content: TextField(
//           controller: controller,
//           autofocus: true,
//           maxLines: 4,
//           style: TextStyle(
//             color: isDark ? Colors.white : Colors.black87,
//             fontSize: 15,
//           ),
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: AppTheme.primaryColor,
//                 width: 2,
//               ),
//             ),
//             contentPadding: const EdgeInsets.all(16),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             style: TextButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               cp.editMessage(msg, controller.text.trim());
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppTheme.primaryColor,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               'Save',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showReactions(MessageModel msg) {
//     final themeProvider = context.read<ThemeProvider>();
//     final isDark = themeProvider.isDark;
    
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => Container(
//         decoration: BoxDecoration(
//           color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 12, bottom: 8),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: reactionsList.map((emoji) {
//                     return GestureDetector(
//                       onTap: () {
//                         cp.addReaction(msg, emoji);
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         width: 56,
//                         height: 56,
//                         decoration: BoxDecoration(
//                           color: isDark
//                               ? Colors.grey.shade800
//                               : Colors.grey.shade100,
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: isDark
//                                 ? Colors.grey.shade700
//                                 : Colors.grey.shade300,
//                             width: 1,
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             emoji,
//                             style: const TextStyle(fontSize: 28),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               const SizedBox(height: 8),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageBubble(MessageModel msg, bool isMine) {
//     final themeProvider = context.watch<ThemeProvider>();
//     final brandProvider = context.watch<BrandProvider>();
//     final isDark = themeProvider.isDark;
//     final currentUserProfileImage = brandProvider.brand?.profileImage ?? '';

//     return GestureDetector(
//       onLongPress: () => _showMessageOptions(msg),
//       child: Container(
//         margin: EdgeInsets.only(
//           left: isMine ? 60 : 16,
//           right: isMine ? 16 : 60,
//           top: 4,
//           bottom: 4,
//         ),
//         child: Row(
//           mainAxisAlignment:
//               isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             if (!isMine) ...[
//               CircleAvatar(
//                 radius: 14,
//                 backgroundImage: widget.partnerProfileUrl.isNotEmpty
//                     ? NetworkImage(widget.partnerProfileUrl)
//                     : null,
//                 backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//                 child: widget.partnerProfileUrl.isEmpty
//                     ? Icon(
//                         LucideIcons.user,
//                         size: 14,
//                         color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
//                       )
//                     : null,
//               ),
//               const SizedBox(width: 8),
//             ],
//             Flexible(
//               child: Column(
//                 crossAxisAlignment:
//                     isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     constraints: const BoxConstraints(maxWidth: 280),
//                     padding: msg.type == 'text'
//                         ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
//                         : EdgeInsets.zero,
//                     decoration: BoxDecoration(
//                       color: isMine
//                           ? AppTheme.primaryColor
//                           : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
//                       borderRadius: BorderRadius.only(
//                         topLeft: const Radius.circular(20),
//                         topRight: const Radius.circular(20),
//                         bottomLeft: Radius.circular(isMine ? 20 : 4),
//                         bottomRight: Radius.circular(isMine ? 4 : 20),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: msg.type == 'text'
//                         ? Text(
//                             msg.text,
//                             style: TextStyle(
//                               color: isMine
//                                   ? Colors.white
//                                   : (isDark ? Colors.white : Colors.black87),
//                               fontSize: 15,
//                               height: 1.4,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           )
//                         : Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(16),
//                                 child: Image.network(
//                                   msg.attachmentUrl ?? '',
//                                   fit: BoxFit.cover,
//                                   width: 240,
//                                   height: 240,
//                                   loadingBuilder: (context, child, loadingProgress) {
//                                     if (loadingProgress == null) return child;
//                                     return Container(
//                                       width: 240,
//                                       height: 240,
//                                       color: isDark
//                                           ? Colors.grey.shade800
//                                           : Colors.grey.shade200,
//                                       child: Center(
//                                         child: CircularProgressIndicator(
//                                           value: loadingProgress.expectedTotalBytes != null
//                                               ? loadingProgress.cumulativeBytesLoaded /
//                                                   loadingProgress.expectedTotalBytes!
//                                               : null,
//                                           color: AppTheme.primaryColor,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   errorBuilder: (_, __, ___) => Container(
//                                     width: 240,
//                                     height: 240,
//                                     color: isDark
//                                         ? Colors.grey.shade800
//                                         : Colors.grey.shade200,
//                                     child: Icon(
//                                       LucideIcons.image,
//                                       size: 40,
//                                       color: isDark
//                                           ? Colors.grey.shade600
//                                           : Colors.grey.shade400,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                   if (msg.reactions.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 6, left: 8, right: 8),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isDark
//                               ? Colors.grey.shade800
//                               : Colors.grey.shade100,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Wrap(
//                           spacing: 4,
//                           children: msg.reactions
//                               .map((r) => Text(
//                                     r,
//                                     style: const TextStyle(fontSize: 16),
//                                   ))
//                               .toList(),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             if (isMine) ...[
//               const SizedBox(width: 8),
//               CircleAvatar(
//                 radius: 14,
//                 backgroundImage: currentUserProfileImage.isNotEmpty
//                     ? NetworkImage(currentUserProfileImage)
//                     : null,
//                 backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//                 child: currentUserProfileImage.isEmpty
//                     ? Icon(
//                         LucideIcons.user,
//                         size: 14,
//                         color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
//                       )
//                     : null,
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = Supabase.instance.client.auth.currentUser;
//     final themeProvider = context.watch<ThemeProvider>();
//     final isDark = themeProvider.isDark;
//     final primary = AppTheme.primaryColor;

//     return Scaffold(
//       backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: primary,
//         titleSpacing: 0,
//         leading: IconButton(
//           icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: InkWell(
//           onTap: () {
//             // Could navigate to partner profile if needed
//           },
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(2),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: CircleAvatar(
//                     radius: 20,
//                     backgroundImage: widget.partnerProfileUrl.isNotEmpty
//                         ? NetworkImage(widget.partnerProfileUrl)
//                         : null,
//                     backgroundColor: Colors.white,
//                     child: widget.partnerProfileUrl.isEmpty
//                         ? Icon(
//                             LucideIcons.user,
//                             size: 20,
//                             color: primary,
//                           )
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         widget.partnerName,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                           letterSpacing: -0.3,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         'Online',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.white.withOpacity(0.8),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Consumer<ChatProvider>(
//               builder: (context, cp, _) {
//                 final msgs = cp.messages[widget.chatId] ?? [];
//                 if (cp.loadingMessages[widget.chatId] == true && msgs.isEmpty) {
//                   return Center(
//                     child: CircularProgressIndicator(
//                       color: primary,
//                     ),
//                   );
//                 }
//                 if (msgs.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           LucideIcons.messageCircle,
//                           size: 64,
//                           color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'No messages yet',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: isDark
//                                 ? Colors.grey.shade400
//                                 : Colors.grey.shade600,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'Start the conversation!',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: isDark
//                                 ? Colors.grey.shade600
//                                 : Colors.grey.shade500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//                 // Scroll to bottom on first load
//                 if (!_hasScrolledToBottom && msgs.isNotEmpty) {
//                   WidgetsBinding.instance.addPostFrameCallback((_) {
//                     _scrollToBottom();
//                     _hasScrolledToBottom = true;
//                   });
//                 }
                
//                 return ListView.builder(
//                   controller: _sc,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
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
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../providers/chat_provider.dart';
// import '../../providers/theme_provider.dart';
// import '../../providers/brand_provider.dart';
// import '../../models/message_model.dart';
// import '../../widgets/message_input.dart';
// import '../../utils/app_theme.dart';

// class BrandChatScreen extends StatefulWidget {
//   final String chatId;
//   final String partnerName;
//   final String partnerProfileUrl;

//   const BrandChatScreen({
//     Key? key,
//     required this.chatId,
//     required this.partnerName,
//     required this.partnerProfileUrl,
//   }) : super(key: key);

//   @override
//   State<BrandChatScreen> createState() => _BrandChatScreenState();
// }

// class _BrandChatScreenState extends State<BrandChatScreen> {
//   late ChatProvider cp;
//   final ScrollController _sc = ScrollController();
//   bool _hasScrolledToBottom = false;
//   final List<String> reactionsList = ['👍', '❤️', '😂', '😮', '😢', '👏'];

//   @override
//   void initState() {
//     super.initState();
//     cp = Provider.of<ChatProvider>(context, listen: false);

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (!mounted) return;
//       await cp.loadMessages(widget.chatId);
//       cp.markAllRead(widget.chatId);

//       // ✅ FIX: wait for list to build, then scroll to bottom
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Future.delayed(const Duration(milliseconds: 300), () {
//           _scrollToBottom();
//           _hasScrolledToBottom = true;
//         });
//       });
//     });
//   }

//   void _scrollToBottom({bool animated = false}) {
//     if (!_sc.hasClients) return;
//     if (animated) {
//       _sc.animateTo(
//         _sc.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     } else {
//       _sc.jumpTo(_sc.position.maxScrollExtent);
//     }
//   }

//   Future<void> _onSendText(String text) async {
//     if (text.trim().isEmpty) return;

//     final participants = await Supabase.instance.client
//         .from('chat_participants')
//         .select('user_id')
//         .eq('chat_id', widget.chatId);

//     final currentUserId = Supabase.instance.client.auth.currentUser?.id;
//     String? partnerId;
//     for (final p in (participants as List)) {
//       if (p['user_id'] != currentUserId) {
//         partnerId = p['user_id'];
//         break;
//       }
//     }

//     await cp.sendText(widget.chatId, text, receiverId: partnerId);
//     Future.delayed(const Duration(milliseconds: 100), () {
//       _scrollToBottom(animated: true);
//     });
//   }

//   Future<void> _onSendImage(File image) async {
//     final participants = await Supabase.instance.client
//         .from('chat_participants')
//         .select('user_id')
//         .eq('chat_id', widget.chatId);

//     final currentUserId = Supabase.instance.client.auth.currentUser?.id;
//     String? partnerId;
//     for (final p in (participants as List)) {
//       if (p['user_id'] != currentUserId) {
//         partnerId = p['user_id'];
//         break;
//       }
//     }

//     await cp.sendImage(widget.chatId, image, receiverId: partnerId);
//     Future.delayed(const Duration(milliseconds: 100), () {
//       _scrollToBottom(animated: true);
//     });
//   }

//   void _showMessageOptions(MessageModel msg) {
//     final themeProvider = context.read<ThemeProvider>();
//     final isDark = themeProvider.isDark;

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => Container(
//         decoration: BoxDecoration(
//           color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 12, bottom: 8),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                 child: Column(
//                   children: [
//                     _buildOptionTile(
//                       icon: LucideIcons.edit3,
//                       title: 'Edit',
//                       color: AppTheme.primaryColor,
//                       isDark: isDark,
//                       onTap: () {
//                         Navigator.pop(context);
//                         _showEditDialog(msg);
//                       },
//                     ),
//                     _buildOptionTile(
//                       icon: LucideIcons.trash2,
//                       title: 'Delete',
//                       color: Colors.red.shade600,
//                       isDark: isDark,
//                       onTap: () {
//                         Navigator.pop(context);
//                         cp.deleteMessage(msg);
//                       },
//                     ),
//                     _buildOptionTile(
//                       icon: LucideIcons.smile,
//                       title: 'React',
//                       color: Colors.amber.shade600,
//                       isDark: isDark,
//                       onTap: () {
//                         Navigator.pop(context);
//                         _showReactions(msg);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionTile({
//     required IconData icon,
//     required String title,
//     required Color color,
//     required bool isDark,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: color, size: 20),
//             ),
//             const SizedBox(width: 16),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: isDark ? Colors.white : Colors.black87,
//               ),
//             ),
//             const Spacer(),
//             Icon(
//               LucideIcons.chevronRight,
//               size: 20,
//               color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showEditDialog(MessageModel msg) {
//     final themeProvider = context.read<ThemeProvider>();
//     final isDark = themeProvider.isDark;
//     final controller = TextEditingController(text: msg.text);

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: AppTheme.primaryColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(
//                 LucideIcons.edit3,
//                 color: AppTheme.primaryColor,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text(
//               'Edit Message',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: isDark ? Colors.white : Colors.black87,
//               ),
//             ),
//           ],
//         ),
//         content: TextField(
//           controller: controller,
//           autofocus: true,
//           maxLines: 4,
//           style: TextStyle(
//             color: isDark ? Colors.white : Colors.black87,
//             fontSize: 15,
//           ),
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: AppTheme.primaryColor,
//                 width: 2,
//               ),
//             ),
//             contentPadding: const EdgeInsets.all(16),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             style: TextButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                 color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               cp.editMessage(msg, controller.text.trim());
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppTheme.primaryColor,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               'Save',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showReactions(MessageModel msg) {
//     final themeProvider = context.read<ThemeProvider>();
//     final isDark = themeProvider.isDark;

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => Container(
//         decoration: BoxDecoration(
//           color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 12, bottom: 8),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: reactionsList.map((emoji) {
//                     return GestureDetector(
//                       onTap: () {
//                         cp.addReaction(msg, emoji);
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         width: 56,
//                         height: 56,
//                         decoration: BoxDecoration(
//                           color: isDark
//                               ? Colors.grey.shade800
//                               : Colors.grey.shade100,
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: isDark
//                                 ? Colors.grey.shade700
//                                 : Colors.grey.shade300,
//                             width: 1,
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             emoji,
//                             style: const TextStyle(fontSize: 28),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               const SizedBox(height: 8),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageBubble(MessageModel msg, bool isMine) {
//     final themeProvider = context.watch<ThemeProvider>();
//     final brandProvider = context.watch<BrandProvider>();
//     final isDark = themeProvider.isDark;
//     final currentUserProfileImage = brandProvider.brand?.profileImage ?? '';

//     return GestureDetector(
//       onLongPress: () => _showMessageOptions(msg),
//       child: Container(
//         margin: EdgeInsets.only(
//           left: isMine ? 60 : 16,
//           right: isMine ? 16 : 60,
//           top: 4,
//           bottom: 4,
//         ),
//         child: Row(
//           mainAxisAlignment:
//               isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             if (!isMine) ...[
//               CircleAvatar(
//                 radius: 14,
//                 backgroundImage: widget.partnerProfileUrl.isNotEmpty
//                     ? NetworkImage(widget.partnerProfileUrl)
//                     : null,
//                 backgroundColor:
//                     isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//                 child: widget.partnerProfileUrl.isEmpty
//                     ? Icon(
//                         LucideIcons.user,
//                         size: 14,
//                         color:
//                             isDark ? Colors.grey.shade400 : Colors.grey.shade600,
//                       )
//                     : null,
//               ),
//               const SizedBox(width: 8),
//             ],
//             Flexible(
//               child: Column(
//                 crossAxisAlignment:
//                     isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     constraints: const BoxConstraints(maxWidth: 280),
//                     padding: msg.type == 'text'
//                         ? const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 12)
//                         : EdgeInsets.zero,
//                     decoration: BoxDecoration(
//                       color: isMine
//                           ? AppTheme.primaryColor
//                           : (isDark
//                               ? Colors.grey.shade800
//                               : Colors.grey.shade200),
//                       borderRadius: BorderRadius.only(
//                         topLeft: const Radius.circular(20),
//                         topRight: const Radius.circular(20),
//                         bottomLeft: Radius.circular(isMine ? 20 : 4),
//                         bottomRight: Radius.circular(isMine ? 4 : 20),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: msg.type == 'text'
//                         ? Text(
//                             msg.text,
//                             style: TextStyle(
//                               color: isMine
//                                   ? Colors.white
//                                   : (isDark
//                                       ? Colors.white
//                                       : Colors.black87),
//                               fontSize: 15,
//                               height: 1.4,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           )
//                         : Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(16),
//                                 child: Image.network(
//                                   msg.attachmentUrl ?? '',
//                                   fit: BoxFit.cover,
//                                   width: 240,
//                                   height: 240,
//                                   loadingBuilder:
//                                       (context, child, loadingProgress) {
//                                     if (loadingProgress == null) return child;
//                                     return Container(
//                                       width: 240,
//                                       height: 240,
//                                       color: isDark
//                                           ? Colors.grey.shade800
//                                           : Colors.grey.shade200,
//                                       child: Center(
//                                         child: CircularProgressIndicator(
//                                           value:
//                                               loadingProgress.expectedTotalBytes !=
//                                                       null
//                                                   ? loadingProgress
//                                                           .cumulativeBytesLoaded /
//                                                       loadingProgress
//                                                           .expectedTotalBytes!
//                                                   : null,
//                                           color: AppTheme.primaryColor,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                   errorBuilder: (_, __, ___) => Container(
//                                     width: 240,
//                                     height: 240,
//                                     color: isDark
//                                         ? Colors.grey.shade800
//                                         : Colors.grey.shade200,
//                                     child: Icon(
//                                       LucideIcons.image,
//                                       size: 40,
//                                       color: isDark
//                                           ? Colors.grey.shade600
//                                           : Colors.grey.shade400,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                   if (msg.reactions.isNotEmpty)
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(top: 6, left: 8, right: 8),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isDark
//                               ? Colors.grey.shade800
//                               : Colors.grey.shade100,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Wrap(
//                           spacing: 4,
//                           children: msg.reactions
//                               .map((r) => Text(
//                                     r,
//                                     style: const TextStyle(fontSize: 16),
//                                   ))
//                               .toList(),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             if (isMine) ...[
//               const SizedBox(width: 8),
//               CircleAvatar(
//                 radius: 14,
//                 backgroundImage: currentUserProfileImage.isNotEmpty
//                     ? NetworkImage(currentUserProfileImage)
//                     : null,
//                 backgroundColor:
//                     isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//                 child: currentUserProfileImage.isEmpty
//                     ? Icon(
//                         LucideIcons.user,
//                         size: 14,
//                         color:
//                             isDark ? Colors.grey.shade400 : Colors.grey.shade600,
//                       )
//                     : null,
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = Supabase.instance.client.auth.currentUser;
//     final themeProvider = context.watch<ThemeProvider>();
//     final isDark = themeProvider.isDark;
//     final primary = AppTheme.primaryColor;

//     return Scaffold(
//       backgroundColor:
//           isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: primary,
//         titleSpacing: 0,
//         leading: IconButton(
//           icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: InkWell(
//           onTap: () {},
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(2),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: CircleAvatar(
//                     radius: 20,
//                     backgroundImage: widget.partnerProfileUrl.isNotEmpty
//                         ? NetworkImage(widget.partnerProfileUrl)
//                         : null,
//                     backgroundColor: Colors.white,
//                     child: widget.partnerProfileUrl.isEmpty
//                         ? Icon(
//                             LucideIcons.user,
//                             size: 20,
//                             color: primary,
//                           )
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         widget.partnerName,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                           letterSpacing: -0.3,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         'Online',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.white.withOpacity(0.8),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Consumer<ChatProvider>(
//               builder: (context, cp, _) {
//                 final msgs = cp.messages[widget.chatId] ?? [];
//                 if (cp.loadingMessages[widget.chatId] == true && msgs.isEmpty) {
//                   return Center(
//                     child: CircularProgressIndicator(
//                       color: primary,
//                     ),
//                   );
//                 }
//                 if (msgs.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           LucideIcons.messageCircle,
//                           size: 64,
//                           color: isDark
//                               ? Colors.grey.shade700
//                               : Colors.grey.shade400,
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'No messages yet',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: isDark
//                                 ? Colors.grey.shade400
//                                 : Colors.grey.shade600,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'Start the conversation!',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: isDark
//                                 ? Colors.grey.shade600
//                                 : Colors.grey.shade500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 // ✅ FIX: ensure scroll only happens once after first load
//                 if (!_hasScrolledToBottom && msgs.isNotEmpty) {
//                   WidgetsBinding.instance.addPostFrameCallback((_) {
//                     _scrollToBottom();
//                     _hasScrolledToBottom = true;
//                   });
//                 }

//                 return ListView.builder(
//                   controller: _sc,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
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
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/chat_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/brand_provider.dart';
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
  bool _hasScrolledToBottom = false;
  final List<String> reactionsList = ['👍', '❤️', '😂', '😮', '😢', '👏'];

  @override
  void initState() {
    super.initState();
    cp = Provider.of<ChatProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await cp.loadMessages(widget.chatId);
      cp.markAllRead(widget.chatId);

      // Scroll to bottom after first load
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _scrollToBottom();
          _hasScrolledToBottom = true;
        });
      });
    });
  }

  void _scrollToBottom({bool animated = false}) {
    if (!_sc.hasClients) return;
    if (animated) {
      _sc.animateTo(
        _sc.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _sc.jumpTo(_sc.position.maxScrollExtent);
    }
  }

  Future<void> _onSendText(String text) async {
    if (text.trim().isEmpty) return;

    final participants = await Supabase.instance.client
        .from('chat_participants')
        .select('user_id')
        .eq('chat_id', widget.chatId);

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    String? partnerId;
    for (final p in (participants as List)) {
      if (p['user_id'] != currentUserId) {
        partnerId = p['user_id'];
        break;
      }
    }

    await cp.sendText(widget.chatId, text, receiverId: partnerId);
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom(animated: true);
    });
  }

  Future<void> _onSendImage(File image) async {
    final participants = await Supabase.instance.client
        .from('chat_participants')
        .select('user_id')
        .eq('chat_id', widget.chatId);

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    String? partnerId;
    for (final p in (participants as List)) {
      if (p['user_id'] != currentUserId) {
        partnerId = p['user_id'];
        break;
      }
    }

    await cp.sendImage(widget.chatId, image, receiverId: partnerId);
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom(animated: true);
    });
  }

  void _showMessageOptions(MessageModel msg) {
    final themeProvider = context.read<ThemeProvider>();
    final isDark = themeProvider.isDark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  children: [
                    _buildOptionTile(
                      icon: LucideIcons.edit3,
                      title: 'Edit',
                      color: AppTheme.primaryColor,
                      isDark: isDark,
                      onTap: () {
                        Navigator.pop(context);
                        _showEditDialog(msg);
                      },
                    ),
                    _buildOptionTile(
                      icon: LucideIcons.trash2,
                      title: 'Delete',
                      color: Colors.red.shade600,
                      isDark: isDark,
                      onTap: () {
                        Navigator.pop(context);
                        // ✅ FIX: deleteMessage only needs MessageModel
                        cp.deleteMessage(msg);
                      },
                    ),
                    _buildOptionTile(
                      icon: LucideIcons.smile,
                      title: 'React',
                      color: Colors.amber.shade600,
                      isDark: isDark,
                      onTap: () {
                        Navigator.pop(context);
                        _showReactions(msg);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const Spacer(),
            Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(MessageModel msg) {
    final themeProvider = context.read<ThemeProvider>();
    final isDark = themeProvider.isDark;
    final controller = TextEditingController(text: msg.text);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                LucideIcons.edit3,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Edit Message',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 4,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.primaryColor,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              cp.editMessage(msg, controller.text.trim());
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReactions(MessageModel msg) {
    final themeProvider = context.read<ThemeProvider>();
    final isDark = themeProvider.isDark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: reactionsList.map((emoji) {
                    return GestureDetector(
                      onTap: () {
                        cp.addReaction(msg, emoji);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade100,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel msg, bool isMine) {
    final themeProvider = context.watch<ThemeProvider>();
    final brandProvider = context.watch<BrandProvider>();
    final isDark = themeProvider.isDark;
    final currentUserProfileImage = brandProvider.brand?.profileImage ?? '';

    return GestureDetector(
      onLongPress: () => _showMessageOptions(msg),
      child: Container(
        margin: EdgeInsets.only(
          left: isMine ? 60 : 16,
          right: isMine ? 16 : 60,
          top: 4,
          bottom: 4,
        ),
        child: Row(
          mainAxisAlignment:
              isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMine) ...[
              CircleAvatar(
                radius: 14,
                backgroundImage: widget.partnerProfileUrl.isNotEmpty
                    ? NetworkImage(widget.partnerProfileUrl)
                    : null,
                backgroundColor:
                    isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                child: widget.partnerProfileUrl.isEmpty
                    ? Icon(
                        LucideIcons.user,
                        size: 14,
                        color:
                            isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      )
                    : null,
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment:
                    isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 280),
                    padding: msg.type == 'text'
                        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                        : EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: isMine
                          ? AppTheme.primaryColor
                          : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isMine ? 20 : 4),
                        bottomRight: Radius.circular(isMine ? 4 : 20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: msg.type == 'text'
                        ? Text(
                            msg.text,
                            style: TextStyle(
                              color: isMine
                                  ? Colors.white
                                  : (isDark ? Colors.white : Colors.black87),
                              fontSize: 15,
                              height: 1.4,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              msg.attachmentUrl ?? '',
                              fit: BoxFit.cover,
                              width: 240,
                              height: 240,
                            ),
                          ),
                  ),
                  if (msg.reactions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 8, right: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Wrap(
                          spacing: 4,
                          children: msg.reactions
                              .map((r) => Text(
                                    r,
                                    style: const TextStyle(fontSize: 16),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isMine) ...[
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 14,
                backgroundImage: currentUserProfileImage.isNotEmpty
                    ? NetworkImage(currentUserProfileImage)
                    : null,
                backgroundColor:
                    isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                child: currentUserProfileImage.isEmpty
                    ? Icon(
                        LucideIcons.user,
                        size: 14,
                        color:
                            isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      )
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;
    final primary = AppTheme.primaryColor;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: widget.partnerProfileUrl.isNotEmpty
                      ? NetworkImage(widget.partnerProfileUrl)
                      : null,
                  backgroundColor: Colors.white,
                  child: widget.partnerProfileUrl.isEmpty
                      ? Icon(
                          LucideIcons.user,
                          size: 20,
                          color: primary,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.partnerName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Online',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, cp, _) {
                final msgs = cp.messages[widget.chatId] ?? [];
                if (cp.loadingMessages[widget.chatId] == true && msgs.isEmpty) {
                  return Center(child: CircularProgressIndicator(color: primary));
                }
                if (msgs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.messageCircle, size: 64, color: isDark ? Colors.grey.shade700 : Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text('No messages yet', style: TextStyle(fontSize: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text('Start the conversation!', style: TextStyle(fontSize: 14, color: isDark ? Colors.grey.shade600 : Colors.grey.shade500)),
                      ],
                    ),
                  );
                }

                if (!_hasScrolledToBottom && msgs.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                    _hasScrolledToBottom = true;
                  });
                }

                return ListView.builder(
                  controller: _sc,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
