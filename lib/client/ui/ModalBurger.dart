import 'package:flutter/material.dart';

class ModalBurger extends StatefulWidget {
  const ModalBurger({Key? key}) : super(key: key);

  @override
  State<ModalBurger> createState() => _ModalBurgerState();
}

class _ModalBurgerState extends State<ModalBurger> {
  void _onMenuItemTap(String route) {
    // Здесь вы можете реализовать логику перехода на другую страницу
    // Например, используя Navigator.of(context).pushNamed(route);
    print("Переход к $route"); // Временный вывод в консоль для демонстрации
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 7),
              width: 37,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xFFE2E2E2),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 30, top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Равномерно распределяем элементы по горизонтали
                children: [
                  _buildMenuItem(
                      'Finances', 'assets/img/menu-item-1.png', '/finance'),
                  _buildMenuItem(
                      'Meters', 'assets/img/menu-item-2.png', '/meters'),
                  _buildMenuItem(
                      'Inquiries', 'assets/img/menu-item-3.png', '/inquiries'),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Равномерно распределяем элементы по горизонтали
                children: [
                  _buildMenuItem(
                      'Proposals', 'assets/img/menu-item-4.png', '/proposals'),
                  _buildMenuItem('News', 'assets/img/menu-item-5.png', '/news'),
                  _buildMenuItem('Notifications', 'assets/img/menu-item-6.png',
                      '/notifications'),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(23.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Image.asset('assets/img/support.png'),
                              margin: EdgeInsets.only(bottom: 9),
                            ),
                            const Text(
                              'Contacts',
                              style: TextStyle(
                                  color: Color(0xFF73797C),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(23.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Image.asset('assets/img/share.png'),
                              margin: EdgeInsets.only(bottom: 9),
                            ),
                            const Text(
                              'Share with',
                              style: TextStyle(
                                  color: Color(0xFF73797C),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 19),
                      child: Image.asset('assets/img/faq.png'),
                    ),
                    const Text(
                      'FAQ',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF73797C)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, String iconPath, String route) {
    return Container(
      width: 95,
      child: GestureDetector(
        onTap: () => _onMenuItemTap(route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Image.asset(iconPath,
                  width: 50, height: 50), // Установка размера изображения
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF73797C),
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
