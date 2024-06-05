import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/requisites_card.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/components/bottom_admin_bar.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/user_profile_header.dart';
import 'package:flutter_application/employee/pages/home/employee_home.dart';

import 'package:flutter_application/service/dio_config.dart';

@RoutePage()
class ExecutorsProfileScreen extends StatefulWidget {
  final int id;
  const ExecutorsProfileScreen({super.key, required this.id});

  @override
  State<ExecutorsProfileScreen> createState() => _ExecutorsProfileScreenState();
}

class _ExecutorsProfileScreenState extends State<ExecutorsProfileScreen> {
  Map<String, dynamic> userProfile = {};
  String userImg = '';
  bool isLoading = true;

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
        userProfile = response.data ?? {};
        userImg = response.data['photo_path'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      print("Ошибка при получении информации о профиле: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _uploadImg() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      File imageFile = File(result.files.single.path!);
      String? originalFileName = result.files.single.name;

      FormData formData = FormData.fromMap({
        "photo": await MultipartFile.fromFile(imageFile.path,
            filename: originalFileName),
      });

      try {
        var response = await DioSingleton().dio.post(
            'employee/executors/${widget.id}/add_photo',
            data: formData); // Corrected endpoint
        if (response.statusCode == 200 || response.statusCode == 201) {
          _getUserInfo(); // Refresh user info to get the new image URL
        } else {
          print("Ошибка при отправке данных");
        }
      } catch (e) {
        print("Ошибка при отправке данных: $e");
      }
    } else {
      print("Выбор файла отменен");
    }
  }

  Future<void> _deleteExecutor() async {
    try {
      final response = await DioSingleton()
          .dio
          .delete('employee/executors/${userProfile['id']}/delete');
      if (response.statusCode == 204) {
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return const SuccessModal(message: "Executor has been deleted");
            },
          );
        }
      } else {
        print("Ошибка при удалении исполнителя");
      }
    } catch (e) {
      print("Ошибка при удалении исполнителя: $e");
    }
  }

  Future<void> _showDeleteConfirmDialog(int? id) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete this executor?'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: CustomBtn(
                      title: 'Cancel',
                      height: 45,
                      color: Colors.green,
                      borderRadius: 5,
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      }),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomBtn(
                      title: 'Delete',
                      height: 45,
                      borderRadius: 5,
                      color: Colors.red,
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        _deleteExecutor();
                      }),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  UserProfileHeader(
                    imageAsset: 'assets/img/profile-big.png',
                    imageNetwork: userImg ?? '',
                    objectName: userProfile['specialization'] ?? '',
                    onAddPhotoPressed: _uploadImg,
                    userName:
                        '${userProfile['first_name'] ?? ''} ${userProfile['last_name'] ?? ''}',
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ListInfoItem(
                          title:
                              '${userProfile['first_name'] ?? ''} ${userProfile['last_name'] ?? ''}',
                          icon: 'assets/img/mini-user.png',
                        ),
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
                          title: userProfile['phone_number'] ?? 'No phone',
                          icon: 'assets/img/mini-phone.png',
                        ),
                        ListInfoItem(
                          title: userProfile['email'] ?? 'No email',
                          icon: 'assets/img/mini-mail.png',
                        ),
                        ListInfoItem(
                          title: userProfile['specialization'] ??
                              'No specialization',
                          icon: 'assets/img/mini-user.png',
                        ),
                      ],
                    ),
                  ),
                  const RequisitesCard(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
                    cardHeight: 50.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: CustomBtn(
                      height: 55,
                      title: 'Delete executor',
                      onPressed: () {
                        _showDeleteConfirmDialog(userProfile['id']);
                      },
                      color: const Color(0xFFBE6161),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomAdminBar(),
    );
  }
}
