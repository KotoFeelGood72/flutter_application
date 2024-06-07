import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/components/bottom_admin_bar.dart';
import 'package:flutter_application/components/modal/user_settings.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/user_profile_header.dart';
import 'package:flutter_application/employee/bloc/employee_bloc.dart';
import 'package:flutter_application/employee/pages/home/employee_home.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _router = AppRouter();

Future<void> _signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    _router.push(const AuthRoute());
  } catch (e) {
    print("Ошибка при выходе: $e");
  }
}

@RoutePage()
class EmployProfileScreen extends StatefulWidget {
  const EmployProfileScreen({super.key});

  @override
  State<EmployProfileScreen> createState() => _EmployProfileScreenState();
}

class _EmployProfileScreenState extends State<EmployProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(EmployeeLoaded());
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

      context.read<EmployeeBloc>().add(UploadEmployeePhoto(formData));
    } else {
      print("Выбор файла отменен");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading || state is EmployeeInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is EmployeeDataLoaded) {
            final userProfile = state.employeeInfo;
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      UserProfileHeader(
                        imageAsset: 'assets/img/profile-big.png',
                        userName:
                            '${userProfile.firstname} ${userProfile.lastname}',
                        imageNetwork: userProfile.photoPath ?? '',
                        onAddPhotoPressed: _uploadImg,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            ListInfoItem(
                              title:
                                  '${userProfile.firstname} ${userProfile.lastname}',
                              icon: 'assets/img/mini-user.png',
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(bottom: 13),
                              child: const Text(
                                'Contacts',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF73797C),
                                ),
                              ),
                            ),
                            ListInfoItem(
                              title: '${userProfile.phoneNumber}',
                              icon: 'assets/img/mini-phone.png',
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(bottom: 13),
                              child: const Text(
                                'Object',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF73797C),
                                ),
                              ),
                            ),
                            ListInfoItem(
                              title: userProfile.objectName,
                              icon: 'assets/img/mini-user.png',
                            ),
                            ListInfoItem(
                              title: 'Edit profile',
                              icon: 'assets/img/mini-user.png',
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  builder: (BuildContext context) {
                                    return UserSettings(
                                      userRole: 'Employee',
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: CustomBtn(
                          title: 'Logout',
                          onPressed: () => _signOut(context),
                          color: const Color(0xFFBE6161),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          } else if (state is EmployeeError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text('Неизвестное состояние'),
            );
          }
        },
      ),
      bottomNavigationBar: const BottomAdminBar(),
    );
  }
}
