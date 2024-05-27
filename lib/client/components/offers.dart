import 'package:flutter/material.dart';

class Offers extends StatefulWidget {
  const Offers({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OffersState createState() => _OffersState();
}

class OffersItem {
  final String img;
  final String title;
  final String link;

  OffersItem({required this.img, required this.title, required this.link});
}

class _OffersState extends State<Offers> {
  final List<OffersItem> offersList = [
    OffersItem(
        img: 'assets/img/offers.jpg',
        title: 'Business Center TWIST. Offices and retail right there...',
        link: '/offers-1'),
    OffersItem(
        img: 'assets/img/offers.jpg',
        title: 'Business Center TWIST. Offices and retail right there...',
        link: '/offers-1'),
    OffersItem(
        img: 'assets/img/offers.jpg',
        title: 'Business Center TWIST. Offices and retail right there...',
        link: '/offers-1'),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Offers',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 11),
                      child: const Text(
                        'All',
                        style: TextStyle(color: Color(0xFFA9A9AB)),
                      ),
                    ),
                    Image.asset('assets/img/arrow-right.png')
                  ],
                ))
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 173,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: offersList.length,
            itemBuilder: (context, index) {
              OffersItem offersItem = offersList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  width: 239,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, offersItem.link);
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height:
                              133, // Установите желаемую высоту для изображения
                          child: SizedBox(
                            height: 133, // Задайте высоту, если необходимо
                            width: double
                                .infinity, // Задайте ширину, если необходимо
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                offersItem.img,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.only(
                                bottom: 20, right: 8, left: 8, top: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.2), // цвет тени
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              offersItem.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 41)
      ],
    );
  }
}
