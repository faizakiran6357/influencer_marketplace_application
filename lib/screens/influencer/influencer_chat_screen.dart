
// // lib/screens/influencer/influencer_chat_screen.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/utils/app_theme.dart';
// import 'package:provider/provider.dart';
// import '../../providers/chat_provider.dart';
// import '../../widgets/message_bubble.dart';
// import '../../widgets/message_input.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class InfluencerChatScreen extends StatefulWidget {
//   final String chatId;
//   const InfluencerChatScreen({Key? key, required this.chatId}) : super(key: key);

//   @override
//   State<InfluencerChatScreen> createState() => _InfluencerChatScreenState();
// }

// class _InfluencerChatScreenState extends State<InfluencerChatScreen> {
//   late ChatProvider cp;
//   final ScrollController _sc = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     cp = Provider.of<ChatProvider>(context, listen: false);

//     // ✅ Fix: Defer provider updates until after first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await cp.loadMessages(widget.chatId);
//       await cp.markAllRead(widget.chatId);
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
// import 'package:influencer_marketplace_application/utils/app_theme.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../providers/chat_provider.dart';
// import '../../widgets/message_bubble.dart';
// import '../../widgets/message_input.dart';

// class InfluencerChatScreen extends StatefulWidget {
//   final String chatId;
//   const InfluencerChatScreen({Key? key, required this.chatId}) : super(key: key);

//   @override
//   State<InfluencerChatScreen> createState() => _InfluencerChatScreenState();
// }

// class _InfluencerChatScreenState extends State<InfluencerChatScreen> {
//   late ChatProvider cp;
//   final ScrollController _sc = ScrollController();
//   Map<String, dynamic>? partnerProfile; // brand profile

//   @override
//   void initState() {
//     super.initState();
//     cp = Provider.of<ChatProvider>(context, listen: false);
//     _loadChatData();
//   }

//   Future<void> _loadChatData() async {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user == null) return;

//     try {
//       // ✅ Get chat participants with their profiles
//       final res = await Supabase.instance.client
//           .from('chat_participants')
//           .select('user_id, profiles(id, name, profile_image), role')
//           .eq('chat_id', widget.chatId);

//       if (res != null && res is List && res.isNotEmpty) {
//         // find the other participant (brand)
//         final others = res.where((p) => p['user_id'] != user.id).toList();
//         if (others.isNotEmpty) {
//           final profile = others.first['profiles'];
//           setState(() {
//             partnerProfile = {
//               'name': profile['name'] ?? 'User',
//               'profile_image': profile['profile_image'] ?? '',
//             };
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint('Error fetching chat partner: $e');
//     }

//     // ✅ Load messages AFTER profile
//     await cp.loadMessages(widget.chatId);
//     await cp.markAllRead(widget.chatId);
//     _jumpToBottom();
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
//         backgroundColor: AppTheme.primaryColor,
//         titleSpacing: 0,
//         title: Row(
//           children: [
//             // ✅ Partner profile image
//             CircleAvatar(
//               radius: 20,
//               backgroundColor: Colors.grey.shade300,
//               backgroundImage: partnerProfile?['profile_image'] != null &&
//                       partnerProfile!['profile_image'].toString().isNotEmpty
//                   ? NetworkImage(partnerProfile!['profile_image'])
//                   : null,
//               child: partnerProfile?['profile_image'] == null ||
//                       partnerProfile!['profile_image'].toString().isEmpty
//                   ? const Icon(Icons.person, color: Colors.white)
//                   : null,
//             ),
//             const SizedBox(width: 10),
//             // ✅ Partner name
//             Text(
//               partnerProfile?['name'] ?? 'Chat',
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
// import 'package:influencer_marketplace_application/utils/app_theme.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../providers/chat_provider.dart';
// import '../../widgets/message_bubble.dart';
// import '../../widgets/message_input.dart';

// class InfluencerChatScreen extends StatefulWidget {
//   final String chatId;
//   const InfluencerChatScreen({Key? key, required this.chatId}) : super(key: key);

//   @override
//   State<InfluencerChatScreen> createState() => _InfluencerChatScreenState();
// }

// class _InfluencerChatScreenState extends State<InfluencerChatScreen> {
//   late ChatProvider cp;
//   final ScrollController _sc = ScrollController();
//   Map<String, dynamic>? partnerProfile;

//   @override
//   void initState() {
//     super.initState();
//     cp = Provider.of<ChatProvider>(context, listen: false);
//     _loadChatData();
//   }

//   Future<void> _loadChatData() async {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user == null) return;

//     try {
//       // ✅ Correct Supabase join syntax
//       final res = await Supabase.instance.client
//           .from('chat_participants')
//           .select('user_id, role, profiles!inner(id, name, profile_image)')
//           .eq('chat_id', widget.chatId);

//       if (res is List && res.isNotEmpty) {
//         // Find other participant (brand)
//         final others = res.where((p) => p['user_id'] != user.id).toList();
//         if (others.isNotEmpty) {
//           final profile = others.first['profiles'];
//           if (profile != null) {
//             setState(() {
//               partnerProfile = {
//                 'name': profile['name'] ?? 'User',
//                 'profile_image': profile['profile_image'] ?? '',
//               };
//             });
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint('❌ Error fetching chat partner: $e');
//     }

//     // Load messages after fetching profile
//     await cp.loadMessages(widget.chatId);
//     await cp.markAllRead(widget.chatId);
//     _jumpToBottom();
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
//         backgroundColor: AppTheme.primaryColor,
//         titleSpacing: 0,
//         title: Row(
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundColor: Colors.grey.shade300,
//               backgroundImage: (partnerProfile != null &&
//                       partnerProfile!['profile_image'] != null &&
//                       partnerProfile!['profile_image'].toString().isNotEmpty)
//                   ? NetworkImage(partnerProfile!['profile_image'])
//                   : null,
//               child: (partnerProfile == null ||
//                       partnerProfile!['profile_image'] == null ||
//                       partnerProfile!['profile_image'].toString().isEmpty)
//                   ? const Icon(Icons.person, color: Colors.white)
//                   : null,
//             ),
//             const SizedBox(width: 10),
//             Text(
//               partnerProfile?['name'] ?? 'Chat',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               overflow: TextOverflow.ellipsis,
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
// import 'package:influencer_marketplace_application/utils/app_theme.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../providers/chat_provider.dart';
// import '../../widgets/message_bubble.dart';
// import '../../widgets/message_input.dart';

// class InfluencerChatScreen extends StatefulWidget {
//   final String chatId;
//   const InfluencerChatScreen({Key? key, required this.chatId}) : super(key: key);

//   @override
//   State<InfluencerChatScreen> createState() => _InfluencerChatScreenState();
// }

// class _InfluencerChatScreenState extends State<InfluencerChatScreen> {
//   late ChatProvider cp;
//   final ScrollController _sc = ScrollController();
//   String partnerName = 'User';
//   String partnerProfileUrl = '';

//   @override
//   void initState() {
//     super.initState();
//     cp = Provider.of<ChatProvider>(context, listen: false);

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await cp.loadMessages(widget.chatId);
//       await cp.markAllRead(widget.chatId);
//       await _loadPartnerInfo();
//       _jumpToBottom();
//     });
//   }

//   Future<void> _loadPartnerInfo() async {
//     final userId = Supabase.instance.client.auth.currentUser?.id;
//     if (userId == null) return;

//     try {
//       final rows = await Supabase.instance.client
//           .from('chat_participants')
//           .select('user_id, profiles(id, name, profile_image)')
//           .eq('chat_id', widget.chatId);

//       final partner = (rows as List)
//           .cast<Map<String, dynamic>>()
//           .firstWhere(
//             (p) => p['user_id'] != userId,
//             orElse: () => {},
//           );

//       final profile = partner['profiles'] as Map<String, dynamic>?;

//       setState(() {
//         partnerName = profile?['name'] ?? 'User';
//         partnerProfileUrl = profile?['profile_image'] ?? '';
//       });
//     } catch (e) {
//       debugPrint('❌ Load partner info error: $e');
//     }
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
//         backgroundColor: AppTheme.primaryColor,
//         title: Row(
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: partnerProfileUrl.isNotEmpty
//                   ? NetworkImage(partnerProfileUrl)
//                   : const AssetImage('assets/images/default_avatar.png')
//                       as ImageProvider,
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 partnerName,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                 overflow: TextOverflow.ellipsis,
//               ),
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
// import 'package:influencer_marketplace_application/utils/app_theme.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../providers/chat_provider.dart';
// import '../../widgets/message_bubble.dart';
// import '../../widgets/message_input.dart';

// class InfluencerChatScreen extends StatefulWidget {
//   final String chatId;
//   const InfluencerChatScreen({Key? key, required this.chatId}) : super(key: key);

//   @override
//   State<InfluencerChatScreen> createState() => _InfluencerChatScreenState();
// }

// class _InfluencerChatScreenState extends State<InfluencerChatScreen> {
//   late ChatProvider cp;
//   final ScrollController _sc = ScrollController();
//   String partnerName = 'User';
//   String partnerProfileUrl = '';

//   @override
//   void initState() {
//     super.initState();
//     cp = Provider.of<ChatProvider>(context, listen: false);

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await cp.loadMessages(widget.chatId);
//       await cp.markAllRead(widget.chatId);
//       await _loadPartnerInfo();
//       _jumpToBottom();
//     });
//   }
// Future<void> _loadPartnerInfo() async {
//   final userId = Supabase.instance.client.auth.currentUser?.id;
//   if (userId == null) return;

//   try {
//     // Step 1: Fetch all participants of this chat
//     final participants = await Supabase.instance.client
//         .from('chat_participants')
//         .select('user_id')
//         .eq('chat_id', widget.chatId);

//     debugPrint('🟦 Chat participants for ${widget.chatId}: $participants');

//     if (participants == null || participants.isEmpty) {
//       debugPrint('⚠️ No participants found for chat ${widget.chatId}');
//       return;
//     }

//     // Step 2: Find the partner (not current user)
//     final partnerUser = (participants as List)
//         .cast<Map<String, dynamic>>()
//         .firstWhere(
//           (p) => p['user_id'] != userId,
//           orElse: () => {},
//         );

//     if (partnerUser.isEmpty) {
//       debugPrint('⚠️ Partner not found (maybe only 1 participant in chat)');
//       return;
//     }

//     final partnerUserId = partnerUser['user_id'];
//     debugPrint('🟩 Partner user ID: $partnerUserId');

//     // Step 3: Fetch partner info from profiles
//     final partnerProfile = await Supabase.instance.client
//         .from('profiles')
//         .select('name, profile_image')
//         .eq('id', partnerUserId)
//         .maybeSingle();

//     debugPrint('🟨 Partner profile data: $partnerProfile');

//     if (partnerProfile != null) {
//       setState(() {
//         partnerName = partnerProfile['name'] ?? 'User';
//         partnerProfileUrl = partnerProfile['profile_image'] ?? '';
//       });
//       debugPrint('✅ Partner loaded: $partnerName');
//     } else {
//       debugPrint('⚠️ No profile found for $partnerUserId');
//     }
//   } catch (e) {
//     debugPrint('❌ Load partner info error: $e');
//   }
// }


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
//         backgroundColor: AppTheme.primaryColor,
//         title: Row(
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: partnerProfileUrl.isNotEmpty
//                   ? NetworkImage(partnerProfileUrl)
//                   : const AssetImage('assets/images/default_avatar.png')
//                       as ImageProvider,
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 partnerName,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                 overflow: TextOverflow.ellipsis,
//               ),
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
// import 'package:influencer_marketplace_application/utils/app_theme.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../providers/chat_provider.dart';
// import '../../widgets/message_bubble.dart';
// import '../../widgets/message_input.dart';

// class InfluencerChatScreen extends StatefulWidget {
//   final String chatId;
//   const InfluencerChatScreen({Key? key, required this.chatId}) : super(key: key);

//   @override
//   State<InfluencerChatScreen> createState() => _InfluencerChatScreenState();
// }

// class _InfluencerChatScreenState extends State<InfluencerChatScreen> {
//   late ChatProvider cp;
//   final ScrollController _sc = ScrollController();
//   String partnerName = 'User';
//   String partnerProfileUrl = '';
//   bool _loadingPartner = true;

//   @override
//   void initState() {
//     super.initState();
//     cp = Provider.of<ChatProvider>(context, listen: false);
//     _initializeChat();
//   }

//   Future<void> _initializeChat() async {
//     await _loadPartnerInfo(); // ✅ Load first before build
//     await cp.loadMessages(widget.chatId);
//     await cp.markAllRead(widget.chatId);
//     _jumpToBottom();
//   }

//   Future<void> _loadPartnerInfo() async {
//     final userId = Supabase.instance.client.auth.currentUser?.id;
//     if (userId == null) return;

//     try {
//       // Step 1: Fetch participants
//       final participants = await Supabase.instance.client
//           .from('chat_participants')
//           .select('user_id')
//           .eq('chat_id', widget.chatId);

//       if (participants == null || participants.isEmpty) return;

//       // Step 2: Find partner user
//       final partnerUser = (participants as List)
//           .cast<Map<String, dynamic>>()
//           .firstWhere((p) => p['user_id'] != userId, orElse: () => {});

//       if (partnerUser.isEmpty) return;

//       final partnerUserId = partnerUser['user_id'];

//       // Step 3: Fetch partner profile
//       final partnerProfile = await Supabase.instance.client
//           .from('profiles')
//           .select('name, profile_image')
//           .eq('id', partnerUserId)
//           .maybeSingle();

//       if (mounted) {
//         setState(() {
//           partnerName = partnerProfile?['name'] ?? 'User';
//           partnerProfileUrl = partnerProfile?['profile_image'] ?? '';
//           _loadingPartner = false;
//         });
//       }
//     } catch (e) {
//       debugPrint('❌ Load partner info error: $e');
//     }
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

//   void _showMessageOptions(BuildContext context, MessageModel message, bool isMine) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (ctx) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (isMine)
//                 ListTile(
//                   leading: const Icon(Icons.edit, color: Colors.blue),
//                   title: const Text('Edit Message'),
//                   onTap: () async {
//                     Navigator.pop(ctx);
//                     final controller = TextEditingController(text: message.text ?? '');
//                     final newText = await showDialog<String>(
//                       context: context,
//                       builder: (_) => AlertDialog(
//                         title: const Text('Edit Message'),
//                         content: TextField(
//                           controller: controller,
//                           decoration: const InputDecoration(hintText: 'Enter new text'),
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text('Cancel'),
//                           ),
//                           ElevatedButton(
//                             onPressed: () => Navigator.pop(context, controller.text),
//                             child: const Text('Save'),
//                           ),
//                         ],
//                       ),
//                     );
//                     if (newText != null && newText.trim().isNotEmpty) {
//                       await cp.editMessage(widget.chatId, message.id, newText.trim());
//                     }
//                   },
//                 ),
//               if (isMine)
//                 ListTile(
//                   leading: const Icon(Icons.delete, color: Colors.red),
//                   title: const Text('Delete Message'),
//                   onTap: () async {
//                     Navigator.pop(ctx);
//                     await cp.deleteMessage(widget.chatId, message.id);
//                   },
//                 ),
//               ListTile(
//                 leading: const Icon(Icons.emoji_emotions_outlined, color: Colors.orange),
//                 title: const Text('Add Reaction'),
//                 onTap: () {
//                   Navigator.pop(ctx);
//                   _showReactionPicker(message);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showReactionPicker(MessageModel message) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) {
//         final reactions = ['👍', '❤️', '😂', '😮', '😢', '👏'];
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: reactions.map((emoji) {
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                   cp.addReaction(widget.chatId, message.id, emoji);
//                 },
//                 child: Text(
//                   emoji,
//                   style: const TextStyle(fontSize: 28),
//                 ),
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = Supabase.instance.client.auth.currentUser;

//     if (_loadingPartner) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppTheme.primaryColor,
//         title: Row(
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: partnerProfileUrl.isNotEmpty
//                   ? NetworkImage(partnerProfileUrl)
//                   : const AssetImage('assets/images/default_avatar.png')
//                       as ImageProvider,
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 partnerName,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                 overflow: TextOverflow.ellipsis,
//               ),
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
//                     return GestureDetector(
//                       onLongPress: () => _showMessageOptions(context, m, isMine),
//                       child: MessageBubble(message: m, isMine: isMine),
//                     );
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
// import 'package:influencer_marketplace_application/utils/app_theme.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../providers/chat_provider.dart';
// import '../../models/message_model.dart';
// import '../../widgets/message_bubble.dart';
// import '../../widgets/message_input.dart';

// class InfluencerChatScreen extends StatefulWidget {
//   final String chatId;
//   const InfluencerChatScreen({Key? key, required this.chatId}) : super(key: key);

//   @override
//   State<InfluencerChatScreen> createState() => _InfluencerChatScreenState();
// }

// class _InfluencerChatScreenState extends State<InfluencerChatScreen> {
//   late ChatProvider cp;
//   final ScrollController _sc = ScrollController();

//   String partnerName = 'User';
//   String partnerProfileUrl = '';
//   bool _loadingPartner = true;

//   @override
//   void initState() {
//     super.initState();
//     cp = Provider.of<ChatProvider>(context, listen: false);
//     _initializeChat();
//   }

//   Future<void> _initializeChat() async {
//     // Load partner info first so AppBar shows proper data immediately
//     await _loadPartnerInfo();
//     // Then load messages
//     await cp.loadMessages(widget.chatId);
//     await cp.markAllRead(widget.chatId);
//     _jumpToBottom();
//   }

//   Future<void> _loadPartnerInfo() async {
//     final userId = Supabase.instance.client.auth.currentUser?.id;
//     if (userId == null) return;

//     try {
//       // 1) Fetch participants (just user_id)
//       final participantsRaw = await Supabase.instance.client
//           .from('chat_participants')
//           .select('user_id')
//           .eq('chat_id', widget.chatId);

//       debugPrint('🟦 Chat participants for ${widget.chatId}: $participantsRaw');

//       if (participantsRaw == null || (participantsRaw as List).isEmpty) {
//         debugPrint('⚠️ No participants found for chat ${widget.chatId}');
//         setState(() => _loadingPartner = false);
//         return;
//       }

//       // 2) Find other participant (not current user)
//       final partnerUser = (participantsRaw as List)
//           .cast<Map<String, dynamic>>()
//           .firstWhere((p) => p['user_id'] != userId, orElse: () => {});

//       if (partnerUser.isEmpty) {
//         debugPrint('⚠️ Partner not found (maybe only 1 participant in chat)');
//         setState(() => _loadingPartner = false);
//         return;
//       }

//       final partnerUserId = partnerUser['user_id'];
//       debugPrint('🟩 Partner user ID: $partnerUserId');

//       // 3) Fetch partner profile from profiles table
//       final partnerProfile = await Supabase.instance.client
//           .from('profiles')
//           .select('name, profile_image')
//           .eq('id', partnerUserId)
//           .maybeSingle();

//       debugPrint('🟨 Partner profile data: $partnerProfile');

//       if (mounted) {
//         setState(() {
//           partnerName = partnerProfile?['name'] ?? 'User';
//           partnerProfileUrl = partnerProfile?['profile_image'] ?? '';
//           _loadingPartner = false;
//         });
//       }
//     } catch (e) {
//       debugPrint('❌ Load partner info error: $e');
//       if (mounted) setState(() => _loadingPartner = false);
//     }
//   }

//   void _jumpToBottom() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (_sc.hasClients) _sc.jumpTo(_sc.position.maxScrollExtent);
//     });
//   }

//   Future<void> _onSendText(String text) async {
//     if (text.trim().isEmpty) return;
//     await cp.sendText(widget.chatId, text.trim());
//     _jumpToBottom();
//   }

//   Future<void> _onSendImage(File image) async {
//     await cp.sendImage(widget.chatId, image);
//     _jumpToBottom();
//   }

//   // Long-press menu -> Edit / Delete / React
//   void _showMessageOptions(BuildContext ctx, MessageModel message, bool isMine) {
//     showModalBottomSheet(
//       context: ctx,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
//       builder: (_) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (isMine)
//                 ListTile(
//                   leading: const Icon(Icons.edit, color: Colors.blue),
//                   title: const Text('Edit'),
//                   onTap: () async {
//                     Navigator.pop(ctx);
//                     final controller = TextEditingController(text: message.text);
//                     final result = await showDialog<String>(
//                       context: ctx,
//                       builder: (_) => AlertDialog(
//                         title: const Text('Edit message'),
//                         content: TextField(controller: controller),
//                         actions: [
//                           TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
//                           ElevatedButton(
//                               onPressed: () => Navigator.pop(ctx, controller.text.trim()),
//                               child: const Text('Save')),
//                         ],
//                       ),
//                     );
//                     if (result != null && result.trim().isNotEmpty) {
//                       // Use provider's editMessage(MessageModel, String)
//                       await cp.editMessage(message, result.trim());
//                     }
//                   },
//                 ),
//               if (isMine)
//                 ListTile(
//                   leading: const Icon(Icons.delete, color: Colors.red),
//                   title: const Text('Delete'),
//                   onTap: () {
//                     Navigator.pop(ctx);
//                     // Use provider's deleteMessage(MessageModel)
//                     cp.deleteMessage(message);
//                   },
//                 ),
//               ListTile(
//                 leading: const Icon(Icons.emoji_emotions_outlined, color: Colors.orange),
//                 title: const Text('React'),
//                 onTap: () {
//                   Navigator.pop(ctx);
//                   _showReactionPicker(message);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showReactionPicker(MessageModel message) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
//       builder: (_) {
//         final reactions = ['👍', '❤️', '😂', '😮', '😢', '👏'];
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: reactions.map((emoji) {
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Use provider's addReaction(MessageModel, String)
//                   cp.addReaction(message, emoji);
//                 },
//                 child: Text(emoji, style: const TextStyle(fontSize: 28)),
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = Supabase.instance.client.auth.currentUser;

//     // While partner loading, show loader to avoid "User" flash
//     if (_loadingPartner) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppTheme.primaryColor,
//         title: Row(
//           children: [
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: partnerProfileUrl.isNotEmpty
//                   ? NetworkImage(partnerProfileUrl)
//                   : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 partnerName,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Consumer<ChatProvider>(
//               builder: (context, provider, _) {
//                 final msgs = provider.messages[widget.chatId] ?? [];
//                 if (provider.loadingMessages[widget.chatId] == true && msgs.isEmpty) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 return ListView.builder(
//                   controller: _sc,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   itemCount: msgs.length,
//                   itemBuilder: (context, i) {
//                     final m = msgs[i];
//                     final isMine = user != null && m.senderId == user.id;

//                     // Wrap MessageBubble with GestureDetector for long press
//                     return GestureDetector(
//                       onLongPress: () => _showMessageOptions(context, m, isMine),
//                       child: MessageBubble(message: m, isMine: isMine),
//                     );
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

// class InfluencerChatScreen extends StatefulWidget {
//   final String chatId;
//   const InfluencerChatScreen({Key? key, required this.chatId}) : super(key: key);

//   @override
//   State<InfluencerChatScreen> createState() => _InfluencerChatScreenState();
// }

// class _InfluencerChatScreenState extends State<InfluencerChatScreen> {
//   late ChatProvider cp;
//   final ScrollController _sc = ScrollController();

//   String partnerName = 'User';
//   String partnerProfileUrl = '';
//   bool _loadingPartner = true;

//   final List<String> reactionsList = ['👍', '❤️', '😂', '😮', '😢', '👏'];
//   final Set<String> sendingImageIds = {};

//   @override
//   void initState() {
//     super.initState();
//     cp = Provider.of<ChatProvider>(context, listen: false);
//     _initializeChat();
//   }

//   Future<void> _initializeChat() async {
//     await _loadPartnerInfo(); // load partner before showing chat
//     await cp.loadMessages(widget.chatId);
//     await cp.markAllRead(widget.chatId);
//     _jumpToBottom();
//   }

//   Future<void> _loadPartnerInfo() async {
//     final userId = Supabase.instance.client.auth.currentUser?.id;
//     if (userId == null) return;

//     try {
//       final participants = await Supabase.instance.client
//           .from('chat_participants')
//           .select('user_id')
//           .eq('chat_id', widget.chatId);

//       if (participants == null || participants.isEmpty) {
//         debugPrint('⚠️ No participants found for chat ${widget.chatId}');
//         setState(() => _loadingPartner = false);
//         return;
//       }

//       final partnerUser = (participants as List)
//           .cast<Map<String, dynamic>>()
//           .firstWhere((p) => p['user_id'] != userId, orElse: () => {});

//       if (partnerUser.isEmpty) {
//         debugPrint('⚠️ Partner not found');
//         setState(() => _loadingPartner = false);
//         return;
//       }

//       final partnerUserId = partnerUser['user_id'];
//       final partnerProfile = await Supabase.instance.client
//           .from('profiles')
//           .select('name, profile_image')
//           .eq('id', partnerUserId)
//           .maybeSingle();

//       if (mounted) {
//         setState(() {
//           partnerName = partnerProfile?['name'] ?? 'User';
//           partnerProfileUrl = partnerProfile?['profile_image'] ?? '';
//           _loadingPartner = false;
//         });
//       }
//     } catch (e) {
//       debugPrint('❌ Load partner info error: $e');
//       if (mounted) setState(() => _loadingPartner = false);
//     }
//   }

//   void _jumpToBottom() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (_sc.hasClients) _sc.jumpTo(_sc.position.maxScrollExtent);
//     });
//   }

//   Future<void> _onSendText(String text) async {
//     if (text.trim().isEmpty) return;
//     await cp.sendText(widget.chatId, text.trim());
//     _jumpToBottom();
//   }

//   Future<void> _onSendImage(File image) async {
//     final tempId = DateTime.now().millisecondsSinceEpoch.toString();
//     sendingImageIds.add(tempId);
//     setState(() {});
//     await cp.sendImage(widget.chatId, image);
//     sendingImageIds.remove(tempId);
//     setState(() {});
//     _jumpToBottom();
//   }

//   /// show edit/delete/react bottom sheet (same as brand)
//   void _showMessageOptions(MessageModel msg, bool isMine) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SizedBox(
//         height: 180,
//         child: Column(
//           children: [
//             if (isMine)
//               ListTile(
//                 leading: const Icon(Icons.edit),
//                 title: const Text('Edit'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showEditDialog(msg);
//                 },
//               ),
//             if (isMine)
//               ListTile(
//                 leading: const Icon(Icons.delete),
//                 title: const Text('Delete'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   cp.deleteMessage(msg);
//                 },
//               ),
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
//     return GestureDetector(
//       onLongPress: () => _showMessageOptions(msg, isMine),
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
//     if (_loadingPartner) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppTheme.primaryColor,
//         titleSpacing: 0,
//         title: Row(
//           children: [
//             const SizedBox(width: 8),
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: partnerProfileUrl.isNotEmpty
//                   ? NetworkImage(partnerProfileUrl)
//                   : null,
//               child: partnerProfileUrl.isEmpty
//                   ? const Icon(Icons.person)
//                   : null,
//             ),
//             const SizedBox(width: 12),
//             Text(
//               partnerName,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Consumer<ChatProvider>(
//               builder: (context, provider, _) {
//                 final msgs = provider.messages[widget.chatId] ?? [];
//                 if (provider.loadingMessages[widget.chatId] == true &&
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

// class InfluencerChatScreen extends StatefulWidget {
//   final String chatId;
//   const InfluencerChatScreen({Key? key, required this.chatId}) : super(key: key);

//   @override
//   State<InfluencerChatScreen> createState() => _InfluencerChatScreenState();
// }

// class _InfluencerChatScreenState extends State<InfluencerChatScreen> {
//   late ChatProvider cp;
//   final ScrollController _sc = ScrollController();

//   String partnerName = 'User';
//   String partnerProfileUrl = '';
//   bool _loadingPartner = true;

//   final List<String> reactionsList = ['👍', '❤️', '😂', '😮', '😢', '👏'];
//   final Set<String> sendingImageIds = {};

//   @override
//   void initState() {
//     super.initState();
//     cp = Provider.of<ChatProvider>(context, listen: false);
//     _initializeChat();
//   }

//   Future<void> _initializeChat() async {
//     await _loadPartnerInfo(); // load partner before showing chat
//     await cp.loadMessages(widget.chatId);
//     await cp.markAllRead(widget.chatId);
//     _jumpToBottom();
//   }

//   Future<void> _loadPartnerInfo() async {
//     final userId = Supabase.instance.client.auth.currentUser?.id;
//     if (userId == null) return;

//     try {
//       final participants = await Supabase.instance.client
//           .from('chat_participants')
//           .select('user_id')
//           .eq('chat_id', widget.chatId);

//       if (participants == null || participants.isEmpty) {
//         setState(() => _loadingPartner = false);
//         return;
//       }

//       final partnerUser = (participants as List)
//           .cast<Map<String, dynamic>>()
//           .firstWhere((p) => p['user_id'] != userId, orElse: () => {});

//       if (partnerUser.isEmpty) {
//         setState(() => _loadingPartner = false);
//         return;
//       }

//       final partnerUserId = partnerUser['user_id'];
//       final partnerProfile = await Supabase.instance.client
//           .from('profiles')
//           .select('name, profile_image')
//           .eq('id', partnerUserId)
//           .maybeSingle();

//       if (mounted) {
//         setState(() {
//           partnerName = partnerProfile?['name'] ?? 'User';
//           partnerProfileUrl = partnerProfile?['profile_image'] ?? '';
//           _loadingPartner = false;
//         });
//       }
//     } catch (e) {
//       debugPrint('❌ Load partner info error: $e');
//       if (mounted) setState(() => _loadingPartner = false);
//     }
//   }

//   void _jumpToBottom() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (_sc.hasClients) _sc.jumpTo(_sc.position.maxScrollExtent);
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
//     if (participants != null) {
//       for (final p in (participants as List)) {
//         if (p['user_id'] != currentUserId) {
//           partnerId = p['user_id'];
//           break;
//         }
//       }
//     }

//     await cp.sendText(widget.chatId, text.trim(), receiverId: partnerId);
//     _jumpToBottom();
//   }

//   Future<void> _onSendImage(File image) async {
//     final tempId = DateTime.now().millisecondsSinceEpoch.toString();
//     sendingImageIds.add(tempId);
//     setState(() {});

//     // Get partner id
//     final participants = await Supabase.instance.client
//         .from('chat_participants')
//         .select('user_id')
//         .eq('chat_id', widget.chatId);

//     final currentUserId = Supabase.instance.client.auth.currentUser?.id;
//     String? partnerId;
//     if (participants != null) {
//       for (final p in (participants as List)) {
//         if (p['user_id'] != currentUserId) {
//           partnerId = p['user_id'];
//           break;
//         }
//       }
//     }

//     await cp.sendImage(widget.chatId, image, receiverId: partnerId);

//     sendingImageIds.remove(tempId);
//     setState(() {});
//     _jumpToBottom();
//   }

//   void _showMessageOptions(MessageModel msg, bool isMine) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SizedBox(
//         height: 180,
//         child: Column(
//           children: [
//             if (isMine)
//               ListTile(
//                 leading: const Icon(Icons.edit),
//                 title: const Text('Edit'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showEditDialog(msg);
//                 },
//               ),
//             if (isMine)
//               ListTile(
//                 leading: const Icon(Icons.delete),
//                 title: const Text('Delete'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   cp.deleteMessage(msg);
//                 },
//               ),
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
//     return GestureDetector(
//       onLongPress: () => _showMessageOptions(msg, isMine),
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
//     if (_loadingPartner) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppTheme.primaryColor,
//         titleSpacing: 0,
//         title: Row(
//           children: [
//             const SizedBox(width: 8),
//             CircleAvatar(
//               radius: 20,
//               backgroundImage: partnerProfileUrl.isNotEmpty
//                   ? NetworkImage(partnerProfileUrl)
//                   : null,
//               child: partnerProfileUrl.isEmpty
//                   ? const Icon(Icons.person)
//                   : null,
//             ),
//             const SizedBox(width: 12),
//             Text(
//               partnerName,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Consumer<ChatProvider>(
//               builder: (context, provider, _) {
//                 final msgs = provider.messages[widget.chatId] ?? [];
//                 if (provider.loadingMessages[widget.chatId] == true &&
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
 import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/chat_provider.dart';
import '../../models/message_model.dart';
import '../../widgets/message_input.dart';
import '../../utils/app_theme.dart';

class InfluencerChatScreen extends StatefulWidget {
  final String chatId;
  const InfluencerChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  State<InfluencerChatScreen> createState() => _InfluencerChatScreenState();
}

class _InfluencerChatScreenState extends State<InfluencerChatScreen> {
  late ChatProvider cp;
  final ScrollController _sc = ScrollController();

  String partnerName = 'User';
  String partnerProfileUrl = '';
  bool _loadingPartner = true;

  final List<String> reactionsList = ['👍', '❤️', '😂', '😮', '😢', '👏'];
  final Set<String> sendingImageIds = {};

  @override
  void initState() {
    super.initState();
    cp = Provider.of<ChatProvider>(context, listen: false);
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _loadPartnerInfo(); // load partner before showing chat
    await cp.loadMessages(widget.chatId);
    await cp.markAllRead(widget.chatId);
    _jumpToBottom();
  }

  Future<void> _loadPartnerInfo() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final participants = await Supabase.instance.client
          .from('chat_participants')
          .select('user_id')
          .eq('chat_id', widget.chatId);

      if (participants == null || participants.isEmpty) {
        setState(() => _loadingPartner = false);
        return;
      }

      final partnerUser = (participants as List)
          .cast<Map<String, dynamic>>()
          .firstWhere((p) => p['user_id'] != userId, orElse: () => {});

      if (partnerUser.isEmpty) {
        setState(() => _loadingPartner = false);
        return;
      }

      final partnerUserId = partnerUser['user_id'];
      final partnerProfile = await Supabase.instance.client
          .from('profiles')
          .select('name, profile_image')
          .eq('id', partnerUserId)
          .maybeSingle();

      if (mounted) {
        setState(() {
          partnerName = partnerProfile?['name'] ?? 'User';
          partnerProfileUrl = partnerProfile?['profile_image'] ?? '';
          _loadingPartner = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Load partner info error: $e');
      if (mounted) setState(() => _loadingPartner = false);
    }
  }

  void _jumpToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_sc.hasClients) _sc.jumpTo(_sc.position.maxScrollExtent);
    });
  }

  Future<void> _onSendText(String text) async {
    if (text.trim().isEmpty) return;

    // Get partner id
    final participants = await Supabase.instance.client
        .from('chat_participants')
        .select('user_id')
        .eq('chat_id', widget.chatId);

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    String? partnerId;
    if (participants != null) {
      for (final p in (participants as List)) {
        if (p['user_id'] != currentUserId) {
          partnerId = p['user_id'];
          break;
        }
      }
    }

    await cp.sendText(widget.chatId, text.trim(), receiverId: partnerId);
    _jumpToBottom();
  }

  Future<void> _onSendImage(File image) async {
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    sendingImageIds.add(tempId);
    setState(() {});

    // Get partner id
    final participants = await Supabase.instance.client
        .from('chat_participants')
        .select('user_id')
        .eq('chat_id', widget.chatId);

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    String? partnerId;
    if (participants != null) {
      for (final p in (participants as List)) {
        if (p['user_id'] != currentUserId) {
          partnerId = p['user_id'];
          break;
        }
      }
    }

    await cp.sendImage(widget.chatId, image, receiverId: partnerId);

    sendingImageIds.remove(tempId);
    setState(() {});
    _jumpToBottom();
  }

  void _showMessageOptions(MessageModel msg, bool isMine) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        height: 180,
        child: Column(
          children: [
            if (isMine)
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(msg);
                },
              ),
            if (isMine)
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
    return GestureDetector(
      onLongPress: () => _showMessageOptions(msg, isMine),
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
    if (_loadingPartner) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 20,
              backgroundImage: partnerProfileUrl.isNotEmpty
                  ? NetworkImage(partnerProfileUrl)
                  : null,
              child: partnerProfileUrl.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              partnerName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, _) {
                final msgs = provider.messages[widget.chatId] ?? [];
                if (provider.loadingMessages[widget.chatId] == true &&
                    msgs.isEmpty) {
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
