import 'package:flutter/material.dart';
import 'package:flutter_application/router/router.dart';
// import 'package:flutter_application/routes/client_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6873D1),
          surfaceVariant: Colors.transparent,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Цвет иконки назад
            size: 21, // Размер иконки назад
          ),
          // Другие глобальные настройки для AppBar, если необходимо
        ),
      ),
      routerConfig: _router.config(),
    );
  }
}
