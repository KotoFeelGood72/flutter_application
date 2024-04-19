import 'package:flutter/material.dart';

enum CardGradient { first, second, third }

class CardSmall extends StatelessWidget {
  final String name;
  final String img;
  final CardGradient gradient;
  final Widget modal;

  const CardSmall({
    super.key,
    required this.name,
    this.gradient = CardGradient.first,
    required this.img,
    required this.modal,
  });

  @override
  Widget build(BuildContext context) {
    LinearGradient gradientColors;
    switch (gradient) {
      case CardGradient.first:
        gradientColors = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF464E92), Color(0xFF959BCE)],
        );
        break;
      case CardGradient.second:
        gradientColors = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0C1822), Color(0xFF1F3863)],
        );
        break;
      case CardGradient.third:
        gradientColors = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF17202B), Color(0xFF3A4752)],
        );
        break;
    }

    return Container(
      decoration: BoxDecoration(
          gradient: gradientColors, borderRadius: BorderRadius.circular(15)),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            builder: (BuildContext context) {
              final double maxHeight = MediaQuery.of(context).size.height * 0.8;
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: maxHeight,
                ),
                child: modal,
              );
            },
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -7,
              right: -7,
              child: Container(
                alignment: Alignment.center,
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: const Color(0xFFBE6161),
                    borderRadius: BorderRadius.circular(100)),
                child: const Text(
                  '1',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
            Container(
              width: 116,
              padding: const EdgeInsets.only(
                  left: 12, top: 7, bottom: 15, right: 10),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: Image.asset('assets/img/${img}.png'),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      name,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
