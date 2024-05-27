import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final bool isMe;
  final String text;
  final String timestamp;
  final bool isRead;
  final String? imageUrl;

  const ChatMessage({
    Key? key,
    required this.isMe,
    required this.text,
    required this.timestamp,
    required this.isRead,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: IntrinsicWidth(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 50.0,
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFFD0D4F1) : const Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null && imageUrl!.isNotEmpty)
                  Image.network(
                    imageUrl!,
                    width: 150,
                    height: 150,
                  ),
                if (text.isNotEmpty)
                  Text(
                    text,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                const SizedBox(height: 2),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timestamp,
                        style:
                            const TextStyle(fontSize: 10, color: Colors.black),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        isRead ? Icons.done_all : Icons.done,
                        size: 14,
                        color: isRead ? Color(0xFF6873D1) : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
