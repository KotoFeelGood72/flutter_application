import 'package:flutter/material.dart';

class InvoiceComponent extends StatelessWidget {
  final String title;
  final String price;
  final String icon;
  final VoidCallback? onTap;

  const InvoiceComponent(
      {super.key,
      required this.title,
      required this.price,
      required this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Image.network(icon)),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                            color: Color(0xFF5D5D67),
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
