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
class TenantProfileScreen extends StatefulWidget {
  final int id;
  final int apartmentsId;
  const TenantProfileScreen(
      {super.key, required this.id, required this.apartmentsId});

  @override
  State<TenantProfileScreen> createState() => TenantProfileScreenState();
}

class TenantProfileScreenState extends State<TenantProfileScreen> {
  Map<String, dynamic> userProfile = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    try {
      final response = await DioSingleton().dio.get(
          'employee/apartments/apartment_info/${widget.apartmentsId}/list_tenant/${widget.id}');
      setState(() {
        userProfile = response.data ?? {};
        isLoading = false;
      });
    } catch (e) {
      print("Ошибка при получении информации о профиле: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteTenant() async {
    try {
      final response = await DioSingleton().dio.delete(
          'employee/apartments/apartment_info/${widget.apartmentsId}/list_tenant/${widget.id}/delete');
      if (response.statusCode == 204) {
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return const SuccessModal(message: "Tenant has been deleted");
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
          content: const Text('Are you sure you want to delete this tenant?'),
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
                        _deleteTenant();
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
                    imageNetwork: userProfile['photo_path'] ?? '',
                    objectName: userProfile['balance'].toString(),
                    userName:
                        '${userProfile['first_name'] ?? ''} ${userProfile['last_name'] ?? ''}',
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomBtn(
                      height: 55,
                      title: 'Delete tenant',
                      onPressed: () {
                        _showDeleteConfirmDialog(userProfile['id']);
                      },
                      color: const Color(0xFFBE6161),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
      bottomNavigationBar: BottomAdminBar(),
    );
  }
}
