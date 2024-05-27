import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application/client/bloc/client_bloc.dart';
import 'package:flutter_application/company/bloc/company_bloc.dart';
import 'package:flutter_application/employee/bloc/employee_bloc.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/notification_service.dart';
import 'package:flutter_application/service/setup.dart';
import 'package:flutter_application/widget/empty_state.dart';
import 'package:flutter_application/widget/failed_internet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final NotificationService notificationService = NotificationService();
  await notificationService.init();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = getIt<AppRouter>();
  String? userRole;
  late StreamSubscription _internetSubscription;
  bool _hasInternetConnection = true;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
    setupFirebaseMessaging(context);
    _internetSubscription = _checkInternetPeriodically();
  }

  @override
  void dispose() {
    _internetSubscription.cancel();
    super.dispose();
  }

  StreamSubscription<void> _checkInternetPeriodically() {
    const duration = Duration(seconds: 5);
    return Stream.periodic(duration).asyncMap((_) async {
      return await _checkInternetConnection();
    }).listen((hasConnection) {
      if (mounted) {
        setState(() {
          _hasInternetConnection = hasConnection;
        });
      }
    });
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
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
      routerDelegate: AutoRouterDelegate(
        _appRouter,
        navigatorObservers: () => [AutoRouteObserver()],
      ),
      routeInformationParser: _appRouter.defaultRouteParser(),
      builder: (context, router) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<ClientBloc>(create: (context) => ClientBloc()),
            BlocProvider<CompanyBloc>(create: (context) => CompanyBloc()),
            BlocProvider<EmployeeBloc>(create: (context) => EmployeeBloc()),
          ],
          child: SafeArea(
            child: _hasInternetConnection
                ? (router ?? const CircularProgressIndicator())
                : FailedInternet(
                    appRouter: _appRouter,
                    title: 'No Internet Connection',
                    text:
                        'Please check your internet connection and try again.',
                  ),
          ),
        );
      },
    );
  }
}
