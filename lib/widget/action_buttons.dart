import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      context.router.push(const AuthRoute());
    } catch (e) {
      print("Error on exit: $e");
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      await DioSingleton().dio.delete('delete-profile');
      context.router.push(const AuthRoute());
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomBtn(
            borderRadius: 8,
            title: 'Logout',
            onPressed: () => _signOut(context),
            height: 50,
            color: Color(0xFFBE6161),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: CustomBtn(
            borderRadius: 8,
            height: 50,
            color: Color(0xFFBE6161),
            title: "Delete account",
            icon: Icon(Icons.delete_sharp, color: Colors.white),
            onPressed: () => _deleteAccount(context),
          ),
        )
      ],
    );
  }
}
