import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/item_status.dart';

class ServiceStateItem extends StatelessWidget {
  final String? img;
  final String name;
  final String id;
  final String time;
  final List<dynamic>? description;
  final String? status;
  final String? times;
  final String? price;
  final String? statusOther;
  final void Function()? onTap;

  const ServiceStateItem({
    super.key,
    this.img,
    required this.name,
    required this.id,
    this.description,
    required this.time,
    this.status,
    this.times,
    this.price,
    this.statusOther,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? statusColor;
    String? statusText;

    switch (status) {
      case 'new':
        statusColor = const Color(0xFF4FC0FF);
        statusText = 'new';
        break;
      case 'in progress':
        statusColor = const Color(0xFFBCBE61);
        statusText = 'in progress';
        break;
      case 'Completed':
        statusColor = const Color(0xFF61BE75);
        statusText = 'Completed';
        break;
      default:
        break;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 11),
                  width: 41,
                  height: 42,
                  child: (img != null)
                      ? Image.network(img!)
                      : Container(color: Colors.grey),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '№ ${id}',
                          style: const TextStyle(
                              color: Color(0xFFA5A5A7), fontSize: 12),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              time,
                              style: const TextStyle(
                                  color: Color(0xFFA5A5A7), fontSize: 12),
                            ),
                            if (price != null)
                              Text(
                                price!,
                                style: const TextStyle(
                                    color: Color(0xFF5F6A73),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            if (statusOther != null)
                              ItemStatus(status: statusOther.toString()),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            if (description != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: description!
                                    .map((desc) => Text(
                                          desc,
                                          style: const TextStyle(
                                              color: Color(0xFF5F6A73),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ))
                                    .toList(),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                if (statusText != null && statusColor != null)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 7),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(25)),
                    child: Text(statusText,
                        style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500)),
                  ),
                if (times != null)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      times!,
                      style: const TextStyle(
                        color: Color(0xFFA5A5A7),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 20),
              child: IconButton(
                onPressed: () {},
                iconSize: 22,
                icon: const Icon(Icons.chevron_right),
                color: const Color(0xFFA5A5A7),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
