// import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";

class AccessItem {
  final String title;
  final String routeName;
  final List<String> imageAssets;

  AccessItem(
      {required this.title,
      required this.routeName,
      required this.imageAssets});
}

final List<List<Color>> gradients = [
  [const Color(0xFF464E92), const Color(0xFF959BCE)],
  [const Color(0xFF0C1822), const Color(0xFF1F3863)],
  [const Color(0xFF17202B), const Color(0xFF3A4752)],
  [const Color(0xFF16212B), const Color(0xFF414A53)],
];

class AccessItemWidget extends StatelessWidget {
  final AccessItem item;
  final int index;
  final VoidCallback onPressed;

  const AccessItemWidget(
      {Key? key,
      required this.item,
      required this.index,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradientIndex = index % gradients.length;
    final gradient = gradients[gradientIndex];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    item.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset(item.imageAssets[0], fit: BoxFit.cover),
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset(item.imageAssets[1], fit: BoxFit.cover),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
