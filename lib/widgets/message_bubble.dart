// // lib/widgets/message_bubble.dart
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/utils/app_theme.dart';
// import 'package:intl/intl.dart';
// import '../models/message_model.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class MessageBubble extends StatelessWidget {
//   final MessageModel message;
//   final bool isMine;

//   const MessageBubble({Key? key, required this.message, required this.isMine}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final ts = DateFormat('hh:mm a').format(message.createdAt.toLocal());
//     final radius = BorderRadius.circular(14);
//     final bg = isMine ? AppTheme.primaryColor : Colors.grey.shade200;
//     final textColor = isMine ? Colors.white : AppTheme.textColor;

//     return Align(
//       alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//         padding: const EdgeInsets.all(10),
//         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
//         decoration: BoxDecoration(
//           color: bg,
//           borderRadius: isMine
//               ? radius.subtract(const BorderRadius.only(bottomRight: Radius.circular(6)))
//               : radius.subtract(const BorderRadius.only(bottomLeft: Radius.circular(6))),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.03),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             )
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             if (message.attachmentUrl != null)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 8.0),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: CachedNetworkImage(
//                     imageUrl: message.attachmentUrl!,
//                     placeholder: (c, s) => Container(height: 160, color: Colors.grey.shade300),
//                     errorWidget: (c, s, e) => Container(height: 160, color: Colors.grey.shade300, child: const Icon(Icons.broken_image)),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             if (message.content != null)
//               Text(
//                 message.content!,
//                 style: TextStyle(color: textColor),
//               ),
//             const SizedBox(height: 6),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(ts, style: TextStyle(fontSize: 10, color: isMine ? Colors.white70 : Colors.black54)),
//                 const SizedBox(width: 6),
//                 if (isMine)
//                   Icon(
//                     message.readBy.isNotEmpty ? Icons.done_all : Icons.check,
//                     size: 14,
//                     color: isMine ? Colors.white70 : Colors.black45,
//                   ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
// lib/widgets/message_bubble.dart
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/utils/app_theme.dart';
// import 'package:intl/intl.dart';
// import '../models/message_model.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class MessageBubble extends StatelessWidget {
//   final MessageModel message;
//   final bool isMine;
//   final void Function()? onLongPress;

//   const MessageBubble({
//     Key? key,
//     required this.message,
//     required this.isMine,
//     this.onLongPress,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final ts = DateFormat('hh:mm a').format(message.createdAt.toLocal());
//     final radius = BorderRadius.circular(14);
//     final bg = isMine ? AppTheme.primaryColor : Colors.grey.shade200;
//     final textColor = isMine ? Colors.white : AppTheme.textColor;

//     return Align(
//       alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
//       child: GestureDetector(
//         onLongPress: onLongPress,
//         child: Container(
//           margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//           padding: const EdgeInsets.all(10),
//           constraints:
//               BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
//           decoration: BoxDecoration(
//             color: bg,
//             borderRadius: isMine
//                 ? radius.subtract(const BorderRadius.only(bottomRight: Radius.circular(6)))
//                 : radius.subtract(const BorderRadius.only(bottomLeft: Radius.circular(6))),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.03),
//                 blurRadius: 4,
//                 offset: const Offset(0, 2),
//               )
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               if (message.attachmentUrl != null)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 8.0),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: CachedNetworkImage(
//                       imageUrl: message.attachmentUrl!,
//                       placeholder: (c, s) =>
//                           Container(height: 160, color: Colors.grey.shade300),
//                       errorWidget: (c, s, e) => Container(
//                         height: 160,
//                         color: Colors.grey.shade300,
//                         child: const Icon(Icons.broken_image),
//                       ),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               if (message.text.isNotEmpty)
//                 Text(
//                   message.text,
//                   style: TextStyle(color: textColor),
//                 ),
//               const SizedBox(height: 6),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(ts,
//                       style: TextStyle(
//                           fontSize: 10, color: isMine ? Colors.white70 : Colors.black54)),
//                   const SizedBox(width: 6),
//                   if (isMine)
//                     Icon(
//                       message.readBy.isNotEmpty ? Icons.done_all : Icons.check,
//                       size: 14,
//                       color: isMine ? Colors.white70 : Colors.black45,
//                     ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../models/message_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../utils/app_theme.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMine;

  const MessageBubble({Key? key, required this.message, required this.isMine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ts = DateFormat('hh:mm a').format(message.createdAt.toLocal());
    final radius = BorderRadius.circular(16);
    final bg = isMine ? AppTheme.primaryColor : Colors.grey.shade200;
    final textColor = isMine ? Colors.white : AppTheme.textColor;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: isMine
              ? radius.subtract(const BorderRadius.only(bottomRight: Radius.circular(6)))
              : radius.subtract(const BorderRadius.only(bottomLeft: Radius.circular(6))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.attachmentUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: message.attachmentUrl!,
                  placeholder: (c, s) => Container(height: 160, color: Colors.grey.shade300),
                  errorWidget: (c, s, e) =>
                      Container(height: 160, color: Colors.grey.shade300, child: const Icon(Icons.broken_image)),
                  fit: BoxFit.cover,
                ),
              ),
            if (message.text.isNotEmpty)
              Text(message.text, style: TextStyle(color: textColor)),
            if (message.reactions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Wrap(
                  spacing: 4,
                  children: message.reactions
                      .map((r) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(r),
                          ))
                      .toList(),
                ),
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(ts, style: TextStyle(fontSize: 10, color: isMine ? Colors.white70 : Colors.black54)),
                const SizedBox(width: 4),
                if (isMine)
                  Icon(message.readBy.isNotEmpty ? Icons.done_all : Icons.check,
                      size: 14, color: isMine ? Colors.white70 : Colors.black45),
              ],
            )
          ],
        ),
      ),
    );
  }
}
