// // lib/widgets/message_input.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:influencer_marketplace_application/utils/app_theme.dart';


// typedef OnSendText = Future<void> Function(String text);
// typedef OnSendImage = Future<void> Function(File image);

// class MessageInput extends StatefulWidget {
//   final OnSendText onSendText;
//   final OnSendImage onSendImage;

//   const MessageInput({Key? key, required this.onSendText, required this.onSendImage}) : super(key: key);

//   @override
//   State<MessageInput> createState() => _MessageInputState();
// }

// class _MessageInputState extends State<MessageInput> {
//   final TextEditingController _controller = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   bool _sending = false;

//   void _send() async {
//     final t = _controller.text.trim();
//     if (t.isEmpty) return;
//     setState(() => _sending = true);
//     await widget.onSendText(t);
//     _controller.clear();
//     setState(() => _sending = false);
//   }

//   Future<void> _pickImage() async {
//     final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
//     if (picked == null) return;
//     final file = File(picked.path);
//     setState(() => _sending = true);
//     await widget.onSendImage(file);
//     setState(() => _sending = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         child: Row(
//           children: [
//             IconButton(
//               onPressed: _pickImage,
//               icon: Icon(Icons.image, color: AppTheme.primaryColor),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: TextField(
//                 controller: _controller,
//                 textInputAction: TextInputAction.send,
//                 onSubmitted: (_) => _send(),
//                 decoration: InputDecoration(
//                   hintText: 'Type a message',
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             ElevatedButton(
//               onPressed: _sending ? null : _send,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppTheme.primaryColor,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               child: _sending ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/app_theme.dart';

class MessageInput extends StatefulWidget {
  final Function(String) onSendText;
  final Function(File) onSendImage;
  final VoidCallback? onCameraTap; // ✅ new optional parameter

  const MessageInput({
    Key? key,
    required this.onSendText,
    required this.onSendImage,
    this.onCameraTap,
  }) : super(key: key);

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();

  void _sendText() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendText(text);
      _controller.clear();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        widget.onSendImage(File(pickedFile.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.camera_alt, color: AppTheme.primaryColor),
            onPressed: () {
              if (widget.onCameraTap != null) {
                widget.onCameraTap!(); // ✅ call the callback
              } else {
                _pickImage(); // fallback to default camera/gallery picker
              }
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
          ),
          const SizedBox(width: 6),
          CircleAvatar(
            backgroundColor: AppTheme.primaryColor,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendText,
            ),
          ),
        ],
      ),
    );
  }
}
