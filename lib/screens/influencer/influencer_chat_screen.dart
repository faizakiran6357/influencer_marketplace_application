
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
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/utils/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/message_input.dart';

class InfluencerChatScreen extends StatefulWidget {
  final String chatId;
  const InfluencerChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  State<InfluencerChatScreen> createState() => _InfluencerChatScreenState();
}

class _InfluencerChatScreenState extends State<InfluencerChatScreen> {
  late ChatProvider cp;
  final ScrollController _sc = ScrollController();

  @override
  void initState() {
    super.initState();
    cp = Provider.of<ChatProvider>(context, listen: false);

    // ✅ Delay until first frame to avoid build conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await cp.loadMessages(widget.chatId);
      await cp.markAllRead(widget.chatId);
      _jumpToBottom();
    });
  }

  void _jumpToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_sc.hasClients) _sc.jumpTo(_sc.position.maxScrollExtent);
    });
  }

  Future<void> _onSendText(String text) async {
    await cp.sendText(widget.chatId, text);
    _jumpToBottom();
  }

  Future<void> _onSendImage(File image) async {
    await cp.sendImage(widget.chatId, image);
    _jumpToBottom();
  }

  /// ✅ Fetch chat partner (Brand) info
  Future<Map<String, dynamic>?> _fetchChatPartnerInfo() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return null;

    try {
      final rows = await Supabase.instance.client
          .from('chat_participants')
          .select('user_id, profiles(id, name, profile_image)')
          .eq('chat_id', widget.chatId)
          .neq('user_id', user.id);

      debugPrint('👤 Chat partner rows: $rows');

      if (rows == null || (rows as List).isEmpty) {
        debugPrint('⚠️ No partner found for chat ${widget.chatId}');
        return null;
      }

      final row = (rows as List).first;
      final profile = (row['profiles'] as Map?)?.cast<String, dynamic>();

      if (profile == null) {
        debugPrint('⚠️ Partner profile missing for chat ${widget.chatId}');
        return null;
      }

      debugPrint('✅ Partner profile found: $profile');
      return profile;
    } catch (e) {
      debugPrint('❌ fetchChatPartnerInfo error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: FutureBuilder<Map<String, dynamic>?>(
          future: _fetchChatPartnerInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Text('Chat');
            }

            final partner = snapshot.data!;
            final imageUrl = partner['profile_image']?.toString().trim() ?? '';
            final name = partner['name'] ?? 'Unknown';

            return Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : const AssetImage('assets/images/default_avatar.png')
                          as ImageProvider,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
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
                    return MessageBubble(message: m, isMine: isMine);
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
