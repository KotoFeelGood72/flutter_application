import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color color;

  const CustomBtn({
    super.key,
    required this.title,
    required this.onPressed,
    this.color = const Color(0xFF6873D1),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
