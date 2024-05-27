import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget implements PreferredSizeWidget {
  const PageHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(13.0),
        child: InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
