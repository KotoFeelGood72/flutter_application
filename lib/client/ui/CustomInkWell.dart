import 'package:flutter/material.dart';

// Определение кастомного InkWell виджета
class CustomInkWell extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomInkWell({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(10)),
        child: ListTile(
            title: Text(
              title,
              style: TextStyle(color: Color(0xFF242527)),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Color(0xFF9F9F9F),
            )),
      ),
    );
  }
}
