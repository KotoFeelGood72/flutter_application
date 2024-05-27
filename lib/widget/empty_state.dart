import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyState extends StatefulWidget {
  final String? url;
  final String title;
  final String text;

  const EmptyState({
    super.key,
    this.url,
    required this.title,
    required this.text,
  });

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState> {
  @override
  Widget build(BuildContext context) {
    final String animationUrl = widget.url ??
        'https://lottie.host/5268f534-057c-41e8-a452-caae0c1a1307/8G8EI88wA5.json';

    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            child: Lottie.network(animationUrl),
          ),
          const SizedBox(height: 20),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.blueGrey,
            ),
            textAlign: TextAlign.center, // Выравнивание текста по центру
          ),
          const SizedBox(
              height: 10), // Добавлен отступ между заголовком и текстом
          Text(
            widget.text,
            textAlign: TextAlign.center, // Выравнивание текста по центру
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
