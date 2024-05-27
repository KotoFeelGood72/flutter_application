import 'package:flutter/material.dart';

enum AddBtnMode { dark, light }

class AddBtn extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final AddBtnMode mode;

  const AddBtn({
    super.key,
    required this.title,
    required this.onPressed,
    this.mode = AddBtnMode.light,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = mode == AddBtnMode.light
        ? Colors.white
        : const Color.fromARGB(136, 54, 65, 75);
    Color iconColor =
        mode == AddBtnMode.light ? const Color(0xFF4B5395) : Colors.white;
    Color textColor = mode == AddBtnMode.light ? Colors.black : Colors.white;
    Color shadowColor =
        mode == AddBtnMode.light ? Colors.grey : Colors.transparent;
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(
              Icons.add,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 85,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
