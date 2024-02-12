import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/client/components/access.dart';
import 'package:flutter_application/client/components/balans.dart';
import 'package:flutter_application/client/components/news.dart';
import 'package:flutter_application/client/components/offers.dart';
import 'package:flutter_application/client/components/requests.dart';
import 'package:flutter_application/client/ui/ModalBurger.dart';
import 'package:flutter_application/client/ui/select.dart';
import 'package:flutter_application/router/router.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void showMenuModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const ModalBurger();
      },
    );
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      showMenuModal(); // Показываем модальное окно при нажатии на кнопку меню
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF18232D),
              child: Column(children: <Widget>[
                Container(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 71, left: 15, right: 15),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Select(),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(
                                Icons.notifications,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              iconSize: 18,
                              onPressed: () {
                                // Код для другого действия
                              },
                            ),
                            IconButton(
                              onPressed: () {
                                AutoRouter.of(context).push(ProfileRoute());
                              },
                              icon: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      const Color.fromARGB(20, 255, 255, 255),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(22, 255, 255, 255),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/img/user.png',
                                        width: 22,
                                        height: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )),
                Container(
                  child: const Padding(
                      padding: EdgeInsets.only(
                          top: 29, left: 15, right: 15, bottom: 10),
                      child: Balans(
                        text: 'You have unpaid bills',
                        price: '3,696.13',
                        showPayButton: true,
                      )),
                ),
                Container(
                  child: const Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: Requests(),
                  ),
                ),
              ]),
            ),
            Container(
              child: const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Access(),
              ),
            ),
            Container(
              child: const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: News(),
              ),
            ),
            Container(
              child: const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Offers(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFF9F9F9),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
              color: Color(0xFFF9F9F9),
            ),
            label: 'Create a request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_phone),
            label: 'Contact',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF6873D1),
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(1), // Активация второй вкладки
        tooltip: 'Create a request',
        backgroundColor: Color(0xFF6873D1),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Установите желаемый радиус
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
