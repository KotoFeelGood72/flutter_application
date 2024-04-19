import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';

final _router = AppRouter();
Future<void> _signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    _router.push(const AuthRoute());
  } catch (e) {
    print("Ошибка при выходе: $e");
  }
}

@RoutePage()
class ExecutorsProfileScreen extends StatefulWidget {
  final int id;
  const ExecutorsProfileScreen({super.key, required this.id});

  @override
  State<ExecutorsProfileScreen> createState() => _ExecutorsProfileScreenState();
}

class _ExecutorsProfileScreenState extends State<ExecutorsProfileScreen> {
  Map<String?, dynamic> userProfile = {};

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    try {
      final response =
          await DioSingleton().dio.get('employee/executors/${widget.id}');
      setState(() {
        userProfile = response.data;
      });
    } catch (e) {
      print("Ошибка при получении информации о профиле: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(310.0),
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
                  backgroundColor: const Color(0xFF18232D),
                  centerTitle: true,
                  leading: Container(
                    margin: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
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
                  width: 103,
                  height: 103,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(103 / 2),
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color.fromRGBO(255, 255, 255, 0.2),
                      ),
                      child: Image.asset('assets/img/profile-big.png'),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 5),
                      child: Text(
                        '${userProfile['firstname']} ${userProfile['lastname']}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      'Attached object',
                      style: TextStyle(color: Color(0xFFA5A5A7)),
                    )
                  ],
                ),
                const SizedBox(height: 10)
              ]),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListInfoItem(
                  title:
                      '${userProfile['firstname']} ${userProfile['lastname']}',
                  icon: 'assets/img/mini-user.png'),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(bottom: 13),
                child: const Text(
                  'Contacts',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xFF73797C)),
                ),
              ),
              ListInfoItem(
                  title: '${userProfile['phone_number']}',
                  icon: 'assets/img/mini-phone.png'),
              ListInfoItem(
                  title: '${userProfile['email']}',
                  icon: 'assets/img/mini-mail.png'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signOut,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF878E92)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF5F5F5)),
      child: ListTile(
        leading: Image.asset(icon),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
