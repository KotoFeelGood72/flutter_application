import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application/components/bottom_admin_bar.dart';
import 'package:flutter_application/components/ui/user_profile_header.dart';
import 'package:flutter_application/employee/pages/home/employee_home.dart';
// import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';

// final _router = AppRouter();

// ignore: unused_element
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

    // print(formData.fields);
    // print(formData.files);

    try {
      // ignore: unused_local_variable
      final response =
          await DioSingleton().dio.post('add_photo', data: formData);
      // print('Ответ сервера: $response');
    } catch (e) {
      // ignore: avoid_print
      print("Ошибка при загрузке изображения: $e");
    }
  } else {
    // Пользователь отменил выбор файла
    // ignore: avoid_print
    print("Выбор файла отменен");
  }
}

@RoutePage()
class StaffProfileScreen extends StatefulWidget {
  final int id;
  const StaffProfileScreen({Key? key, @PathParam('id') required this.id})
      : super(key: key);

  @override
  State<StaffProfileScreen> createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen> {
  // String? userImg;
  Map<String?, dynamic> userProfile = {};

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    // _getUserImg();
  }

  Future<void> _getUserInfo() async {
    try {
      final response =
          await DioSingleton().dio.get('get_staff_uk/staff_info/${widget.id}');
      setState(() {
        userProfile = response.data;
      });
    } catch (e) {
      // ignore: avoid_print
      print("Ошибка при получении информации о профиле: $e");
    }
  }

  // Future<void> _getUserImg() async {
  //   try {
  //     final response = await DioSingleton().dio.get('get_profile_uk');
  //     setState(() {
  //       userImg = response.data;
  //     });
  //     print('Image: ${userImg}');
  //   } catch (e) {
  //     print("Ошибка при получении информации о профиле: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            UserProfileHeader(
                imageAsset: 'assets/img/profile-big.png',
                userName:
                    "${userProfile['first_name'] ?? ''} ${userProfile['last_name'] ?? 'No name'}"
                        .trim(),
                objectName: userProfile['object_name']),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListInfoItem(
                      title:
                          "${userProfile['first_name'] ?? ''} ${userProfile['last_name'] ?? 'No name'}"
                              .trim(),
                      icon: 'assets/img/mini-user.png'),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(bottom: 13),
                    child: const Text(
                      'Contacts',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF73797C)),
                    ),
                  ),
                  ListInfoItem(
                      title: '${userProfile['phone_number']}',
                      icon: 'assets/img/mini-phone.png'),
                  ListInfoItem(
                      title: '${userProfile['email']}',
                      icon: 'assets/img/mini-mail.png'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAdminBar(),
    );
  }
}
