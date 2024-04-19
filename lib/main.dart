import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application/router/router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();
  String? userRole;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  void _checkAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        _navigateToAuthRoute();
      } else {
        await _getUserRole(user.uid);
      }
    });
  }

  Future<void> _getUserRole(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final role = snapshot.data()?['role'];
      if (role != null) {
        setState(() => userRole = role);
        _navigateBasedOnRole(role);
      } else {
        _navigateToAuthRoute();
      }
    } catch (e) {
      print("Error getting user role: $e");
      _navigateToAuthRoute();
    }
  }

  void _navigateToAuthRoute() {
    _appRouter.replaceAll([const AuthRoute()]);
  }

  void _navigateBasedOnRole(String role) {
    switch (role) {
      case 'client':
        _appRouter.replaceAll([const HomeRoute()]);
        break;
      case 'Company':
        _appRouter.replaceAll([const CompanyHomeMainRoute()]);
        break;
      case 'Employee':
        _appRouter.replaceAll([const EmployeHomeMainRoute()]);
        break;
      default:
        _navigateToAuthRoute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: AutoRouterDelegate(_appRouter,
          navigatorObservers: () => [AutoRouteObserver()]),
      routeInformationParser: _appRouter.defaultRouteParser(),
      builder: (context, router) => router ?? const CircularProgressIndicator(),
    );
  }
}
