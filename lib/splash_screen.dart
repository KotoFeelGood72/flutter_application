import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/router/router.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    if (mounted) {
      FirebaseAuth.instance.authStateChanges().listen((user) async {
        if (mounted) {
          if (user == null) {
            _navigateToAuthRoute();
          } else {
            await _getUserRole(user.uid);
          }
        }
      });
    }
  }

  Future<void> _getUserRole(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (mounted) {
        final role = snapshot.data()?['role'];
        if (role != null) {
          _navigateBasedOnRole(role);
        } else {
          _navigateToAuthRoute();
        }
      }
    } catch (e) {
      if (mounted) {
        _navigateToAuthRoute();
      }
    }
  }

  void _navigateToAuthRoute() {
    if (mounted) {
      context.router.replaceAll([AuthRoute()]);
    }
  }

  void _navigateBasedOnRole(String role) {
    if (mounted) {
      switch (role) {
        case 'client':
          context.router.replaceAll([HomeRoute()]);
          break;
        case 'Company':
          context.router.replaceAll([CompanyHomeMainRoute()]);
          break;
        case 'Employee':
          context.router.replaceAll([EmployeHomeMainRoute()]);
          break;
        default:
          _navigateToAuthRoute();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              constraints: BoxConstraints(maxWidth: 300),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset('assets/img/AppIcon.png'),
              ),
            ),
            Text(
              'Smart Apart',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
