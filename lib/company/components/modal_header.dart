import 'package:flutter/material.dart';

class ModalHeader extends StatelessWidget {
  final String title;
  const ModalHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color.fromARGB(255, 235, 234, 234),
            ),
            child: IconButton(
                color: const Color(0xFFB4B7B8),
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
                iconSize: 12,
                icon: const Icon(
                  Icons.close,
                )),
          ),
        ],
      ),
    );
  }
}
