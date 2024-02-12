import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(376.0),
        child: Column(
          children: [
            Container(
              color: const Color(0xFF18232D),
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: AppBar(
                  title: const Text('Profile',
                      style: TextStyle(color: Colors.white)),
                  elevation: 0,
                  // backgroundColor: const Color(0xFF18232D),
                  backgroundColor: Color(0xFF18232D),
                  centerTitle: true,
                  leading: Container(
                    margin: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.2), // Прозрачный белый фон контейнера
                      borderRadius:
                          BorderRadius.circular(100), // Закругление углов
                    ),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/img/back.png',
                        width: 22,
                        height: 22,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: const Color(0xFF18232D),
              width: double.infinity,
              child: Column(children: <Widget>[
                Container(
                  width: 103, // Размер внешнего контейнера
                  height: 103,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        103 / 2), // Радиус скругления для круглой обводки
                    color: Colors.transparent, // Прозрачный фон, если требуется
                    border: Border.all(
                      color: Colors.white, // Цвет обводки
                      width: 1, // Толщина обводки
                    ),
                  ),
                  child: Center(
                    // Центрирование внутреннего контейнера
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            100), // Радиус скругления внутреннего контейнера
                        color: Color.fromRGBO(255, 255, 255, 0.2),
                      ),
                      child: Image.asset(
                          'assets/img/profile-big.png'), // Ваше изображение
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16, top: 20),
                  child: const Text(
                    'First name Last name',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 0.32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15), // Установите нужное значение радиуса здесь
                    ),
                  ),
                  onPressed: () {},
                  child: const Padding(
                    padding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                    child: Text(
                      'Add photo',
                      style: TextStyle(
                        color:
                            Colors.white, // Пример использования цвета текста
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 37)
              ]),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(bottom: 13),
                child: const Text(
                  'Personal information',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xFF73797C)),
                ),
              ),
              ListInfoItem(
                  title: 'First name Last name',
                  icon: 'assets/img/mini-user.png'),
              ListInfoItem(
                  title: '8(999)-999-99-99', icon: 'assets/img/mini-phone.png'),
              ListInfoItem(
                  title: 'mail004@gmail.com', icon: 'assets/img/mini-mail.png'),
              // ],
              // ListView(
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   children: const [
              // ),
              SizedBox(height: 37),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(bottom: 13),
                child: const Text(
                  'Security and notifications',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xFF73797C)),
                ),
              ),
              // ListView(
              //   physics: NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   children: const [
              ListInfoItem(
                  title: 'Login settings', icon: 'assets/img/mini-login.png'),
              ListInfoItem(
                  title: 'Notifications', icon: 'assets/img/mini-notice.png'),
              ListInfoItem(
                  title: 'About the application',
                  icon: 'assets/img/mini-about.png'),
            ],
          ),
          // ],
        ),
      ),
      // ),
    );
  }
}

class ListInfoItem extends StatelessWidget {
  final String title;
  final String icon;

  const ListInfoItem({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xFFF5F5F5)),
      child: ListTile(
        leading: Image.asset(icon),
        title: Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
