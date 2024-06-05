import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/pages/articles/articles.dart';
import 'package:flutter_application/router/router.dart';

class ModalBurger extends StatefulWidget {
  const ModalBurger({Key? key}) : super(key: key);

  @override
  State<ModalBurger> createState() => _ModalBurgerState();
}

class _ModalBurgerState extends State<ModalBurger> {
  void _navigate(PageRouteInfo route) {
    AutoRouter.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: SizedBox(
              width: 37,
              child: Container(
                margin: const EdgeInsets.only(top: 7),
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xFFE2E2E2),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 30, top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMenuItem('Finances', 'assets/img/menu-item-1.png',
                    () => _navigate(const FinancesRoute())),
                _buildMenuItem('Meters', 'assets/img/menu-item-2.png',
                    () => _navigate(const MettersRoute())),
                _buildMenuItem('Inquiries', 'assets/img/menu-item-3.png',
                    () => _navigate(const InquiresRoute())),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMenuItem('Proposals', 'assets/img/menu-item-4.png',
                    () => _navigate(const FinancesRoute())),
                _buildMenuItem(
                    'News',
                    'assets/img/menu-item-5.png',
                    () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return ArticlesScreen(type: 'client');
                          },
                        )),
                _buildMenuItem('Notifications', 'assets/img/menu-item-6.png',
                    () => _navigate(const NotificationsRoute())),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      AutoRouter.of(context).push(const ContactsRoute());
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(23.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 9),
                              child: Image.asset('assets/img/support.png'),
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
                ),
                Expanded(
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      AutoRouter.of(context).push(const DevelopmentRoute());
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(23.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 9),
                              child: Image.asset('assets/img/share.png'),
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
                ),
              ],
            ),
          ),
          InkWell(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              AutoRouter.of(context).push(const DevelopmentRoute());
            },
            child: Container(
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
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, String iconPath, VoidCallback onTap) {
    return SizedBox(
      width: 95,
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Image.asset(iconPath, width: 50, height: 50),
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
