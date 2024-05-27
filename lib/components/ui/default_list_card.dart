import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class DefaultListCard extends StatelessWidget {
  final int id;
  final String name;
  final String address;
  final String imageUrl;
  final PageRouteInfo<dynamic> route;

  const DefaultListCard({
    super.key,
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () => AutoRouter.of(context).push(route),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 19),
                  child: Image.asset(imageUrl),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6,
                      ),
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width *
                            0.6, // Set the maximum width for the text
                      ),
                      child: Text(
                        address,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFA5A5A7),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }
}
