import 'package:flutter/material.dart';

class ListInfoItem extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback? onTap;

  const ListInfoItem(
      {super.key, required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 13),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFF5F5F5)),
        child: ListTile(
          leading: Image.asset(icon),
          title: Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
