import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color color;
  final double height;
  final double borderRadius;

  const CustomBtn({
    super.key,
    required this.title,
    required this.onPressed,
    this.color = const Color(0xFF6873D1),
    this.height = 60.0,
    this.borderRadius = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: color,
      ),
      // ignore: avoid_unnecessary_containers
      child: Container(
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
