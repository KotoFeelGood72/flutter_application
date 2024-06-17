import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/client/bloc/client_bloc.dart';
import 'package:flutter_application/company/pages/staff/staff_profile.dart';
import 'package:flutter_application/components/modal/user_settings.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/user_profile_header.dart';
import 'package:flutter_application/employee/pages/home/employee_home.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/action_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _router = AppRouter();

Future<void> _signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    _router.push(const AuthRoute());
  } catch (e) {
    // print("Ошибка при выходе: $e");
  }
}

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ClientBloc>(context).add(ClientInfoUser());
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
        var response =
            await DioSingleton().dio.post('client/add_photo', data: formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          BlocProvider.of<ClientBloc>(context).add(ClientInfoUser());
        } else {}
      } catch (e) {
        print("Ошибка при отправке данных: $e");
      }
    } else {
      print("Выбор файла отменен");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ClientBloc, ClientState>(
        builder: (context, state) {
          if (state is ClientState && state.userInfo == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ClientState && state.userInfo != null) {
            var userProfile = state.userInfo;
            String userName =
                "${userProfile?.firstname ?? ''} ${userProfile?.lastname ?? ''}"
                    .trim();
            String? userImg = userProfile?.photoPath;

            return ListView(
              shrinkWrap: true,
              children: [
                UserProfileHeader(
                  imageNetwork: userImg ?? '',
                  imageAsset: 'assets/img/profile-big.png',
                  userName: userName,
                  onAddPhotoPressed: _uploadImg,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(
                      top: 10, left: 15, right: 15, bottom: 20),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(bottom: 13),
                        child: const Text(
                          'Personal information',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF73797C)),
                        ),
                      ),
                      ListInfoItem(
                          title:
                              '${userProfile?.firstname ?? ''} ${userProfile?.lastname ?? ''}',
                          icon: 'assets/img/mini-user.png'),
                      ListInfoItem(
                          title: userProfile?.phoneNumber ?? '',
                          icon: 'assets/img/mini-phone.png'),
                      ListInfoItem(
                          title: '${userProfile?.email ?? ''}',
                          icon: 'assets/img/mini-mail.png'),
                      const SizedBox(height: 15),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(bottom: 13),
                        child: const Text(
                          'Security and notifications',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF73797C)),
                        ),
                      ),
                      ListInfoItem(
                          onTap: () {
                            AutoRouter.of(context).push(NotificationsRoute());
                          },
                          title: 'Notifications',
                          icon: 'assets/img/mini-notice.png'),
                      ListInfoItem(
                          title: 'About the application',
                          onTap: () => AutoRouter.of(context)
                              .push(const DevelopmentRoute()),
                          icon: 'assets/img/mini-about.png'),
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
                                userRole: 'client',
                              );
                            },
                          );
                        },
                      ),
                      ActionButtons(),
                      // Action(),
                      // Row(children: [
                      //   CustomBtn(
                      //     title: 'Logout',
                      //     onPressed: _signOut,
                      //     height: 55,
                      //     color: Color(0xFFBE6161),
                      //   ),
                      //   CustomBtn(
                      //     title: 'Logout',
                      //     onPressed: _signOut,
                      //     height: 55,
                      //     color: Color(0xFFBE6161),
                      //   )
                      // ]),
                    ],
                  ),
                )
              ],
            );
          } else {
            return const Center(child: Text('Error loading profile'));
          }
        },
      ),
    );
  }
}
