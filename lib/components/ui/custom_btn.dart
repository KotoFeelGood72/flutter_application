import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String? title;
  final VoidCallback onPressed;
  final Color color;
  final double height;
  final double borderRadius;
  final Icon? icon;

  const CustomBtn({
    super.key,
    this.title,
    required this.onPressed,
    this.color = const Color(0xFF6873D1),
    this.height = 60.0,
    this.borderRadius = 15.0,
    this.icon,
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
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            if (icon != null && title != null) const SizedBox(width: 8.0),
            if (title != null)
              Text(
                title!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
