import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  final String apartmentName;
  final Map<String, String> userNames;

  const ChatHeader({
    Key? key,
    required this.apartmentName,
    required this.userNames,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF242E38),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xFFF6F6F6).withOpacity(0.2),
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: const Icon(
                Icons.arrow_back,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: Image.asset(
                  'assets/img/white-chat.png',
                  width: 46,
                  height: 46,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apartmentName,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Row(
                    children: List.generate(userNames.values.length, (index) {
                      var name = userNames.values.elementAt(index);
                      var isLast = index == userNames.values.length - 1;
                      return Text(
                        isLast ? name : '$name · ',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
