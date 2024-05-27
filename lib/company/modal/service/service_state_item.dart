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
  final bool? isView;

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
    this.isView,
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

    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (img != null)
                  Container(
                    margin: const EdgeInsets.only(right: 11),
                    width: 41,
                    height: 42,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.network(img!),
                        if (isView == false)
                          Positioned(
                            top: -1,
                            right: -1,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Text('№ $id',
                          style: const TextStyle(
                              color: Color(0xFFA5A5A7), fontSize: 12)),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(time,
                              style: const TextStyle(
                                  color: Color(0xFFA5A5A7), fontSize: 12)),
                          if (price != null)
                            Text(price!,
                                style: const TextStyle(
                                    color: Color(0xFF5F6A73),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)),
                          if (statusOther != null)
                            ItemStatus(status: statusOther!),
                        ],
                      ),
                      if (description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: description!
                                .map((desc) => Text(desc,
                                    style: const TextStyle(
                                        color: Color(0xFF5F6A73),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)))
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                ),
                if (statusText != null && statusColor != null)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 7),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(statusText,
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w500)),
                  ),
                if (times != null)
                  Text(
                    times!,
                    style: const TextStyle(
                      color: Color(0xFFA5A5A7),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                child: const Icon(
                  Icons.chevron_right,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
