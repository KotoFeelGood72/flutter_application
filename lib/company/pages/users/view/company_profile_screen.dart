import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application/company/bloc/company_bloc.dart';
import 'package:flutter_application/components/bottom_admin_bar.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/user_profile_header.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';

final _router = AppRouter();

Future<void> _signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    _router.push(const AuthRoute());
  } catch (e) {
    print("Error on exit: $e");
  }
}

@RoutePage()
class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  bool isLoading = true;
  bool isUploading = false;

  Future<void> _uploadImg() async {
    setState(() {
      isUploading = true;
    });

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
        var response = await DioSingleton()
            .dio
            .post('get_profile_uk/add_photo', data: formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          print("The image has been uploaded successfully");
          if (mounted) {
            setState(() {
              // Update the state after uploading the image
              context.read<CompanyBloc>().add(CompanyLoaded());
            });
          }
        } else {
          print("Error loading the image: ${response.statusCode}");
        }
      } catch (e) {
        print("Error loading the image: $e");
      } finally {
        setState(() {
          isUploading = false; // Set uploading state to false
        });
      }
    } else {
      print("The file selection has been canceled");
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<CompanyBloc>().add(CompanyLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<CompanyBloc, CompanyState>(
              builder: (context, state) {
                if (state is CompanyStateData) {
                  final company = state.company;
                  final userImg = company!.photoPath;
                  final contacts = company.contacts ?? [];

                  List<Widget> contactWidgets = contacts.map<Widget>((contact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 13),
                            child: Text(contact.name ?? 'No name',
                                style: const TextStyle(
                                    color: Color(0xFF73797C),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        if (contact.phone != null)
                          ListInfoItem(
                              title: contact.phone.toString(),
                              icon: 'assets/img/mini-phone.png'),
                        if (contact.email != null)
                          ListInfoItem(
                              title: contact.email,
                              icon: 'assets/img/mini-mail.png'),
                      ],
                    );
                  }).toList();

                  return ListView(
                    shrinkWrap: true,
                    children: [
                      UserProfileHeader(
                        imageNetwork: userImg ?? '',
                        imageAsset: 'assets/img/profile-big.png',
                        userName: company.ukName,
                        onAddPhotoPressed: _uploadImg,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            ...contactWidgets,
                            CustomBtn(
                              title: 'Logout',
                              onPressed: _signOut,
                              color: Color(0xFFBE6161),
                            ),
                            const SizedBox(height: 30)
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (state is CompanyInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Center(
                      child: Text('Failed to load company data'));
                }
              },
            ),
            if (isUploading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
        bottomNavigationBar: BottomAdminBar(),
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
