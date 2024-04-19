import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
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

Future<void> _uploadImg() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );

  if (result != null) {
    File imageFile = File(result.files.single.path!);

    FormData formData = FormData.fromMap({
      "photo":
          await MultipartFile.fromFile(imageFile.path, filename: "upload.jpg"),
    });

    print(formData.fields);
    print(formData.files);

    try {
      final response =
          await DioSingleton().dio.post('add_photo', data: formData);
      print('Ответ сервера: $response');
    } catch (e) {
      print("Ошибка при загрузке изображения: $e");
    }
  } else {
    // Пользователь отменил выбор файла
    print("Выбор файла отменен");
  }
}

@RoutePage()
class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  Map<String?, dynamic> userProfile = {};
  List<dynamic> contacts = [];
  String? userImg;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    try {
      final response = await DioSingleton().dio.get('get_profile_uk');
      setState(() {
        userProfile = response.data;
        contacts = response.data['contacts'] ?? [];
      });
    } catch (e) {
      print("Ошибка при получении информации о профиле: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> contactWidgets = contacts.map<Widget>((contact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              margin: const EdgeInsets.only(bottom: 13),
              child: Text(contact['name'] ?? 'No name',
                  style: const TextStyle(
                      color: Color(0xFF73797C), fontWeight: FontWeight.bold)),
            ),
          ),
          if (contact['phone'] != null)
            ListInfoItem(
                title: contact['phone'], icon: 'assets/img/mini-phone.png'),
          if (contact['email'] != null)
            ListInfoItem(
                title: contact['email'], icon: 'assets/img/mini-mail.png'),
          if (contact['email'] != null)
            ListInfoItem(
                title: contact['email'], icon: 'assets/img/mini-mail.png'),
        ],
      );
    }).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(356.0),
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
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          const Color.fromRGBO(255, 255, 255, 0.32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: _uploadImg,
                    child: const Padding(
                      padding: EdgeInsets.only(
                          top: 5, bottom: 5, left: 20, right: 20),
                      child: Text(
                        'Add photo',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 5),
                      child: Text(
                        '${userProfile['UK name']}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20)
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
              ...contactWidgets,
              Container(
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
              SizedBox(height: 30)
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
