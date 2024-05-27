import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController messageController;
  final void Function({String? imageUrl}) onSendMessage;
  final void Function() onPickImage;

  const ChatInput({
    Key? key,
    required this.messageController,
    required this.onSendMessage,
    required this.onPickImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            iconSize: 30,
            icon: const Icon(Icons.attach_file, color: Color(0xFF878E92)),
            onPressed: onPickImage,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: messageController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter message...',
                ),
              ),
            ),
          ),
          IconButton(
            iconSize: 20,
            icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Color(0xFF6873D1),
                    borderRadius: BorderRadius.circular(100)),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                )),
            onPressed: () => onSendMessage(),
          ),
        ],
      ),
    );
  }
}
