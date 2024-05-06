import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';

class LoginTab extends StatefulWidget {
  const LoginTab({Key? key}) : super(key: key);

  @override
  _LoginTabState createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  // final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null && mounted) {
        print('Успешный вход');
        final String? token = await userCredential.user!.getIdToken();
        await _sendTokenToServer(token!);

        if (!mounted) return; // Проверка перед переходом

        await _navigateBasedOnUserRole(userCredential.user!.uid);

        if (!mounted) return; // Проверка после асинхронной операции
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _handleLoginError(e);
    }
  }

  Future<void> _navigateBasedOnUserRole(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final role = snapshot.data()?['role'] as String?;
      if (role != null) {
        switch (role) {
          case 'client':
            AutoRouter.of(context).replace(const HomeRoute());
            break;
          case 'Company':
            AutoRouter.of(context).replace(const CompanyHomeMainRoute());
            break;
          case 'Employee':
            AutoRouter.of(context).replace(const EmployeHomeMainRoute());
            break;
        }
      } else {
        throw Exception('Role not found for user');
      }
    } catch (e) {
      print('Error navigating based on user role: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ошибка при перенаправлении на основе роли')));
    }
  }

  Future<void> _sendTokenToServer(String token) async {
    try {
      final response = await DioSingleton().dio.get(
            'login',
          );
      print('Token: ${token}');
      print('Ответ сервера: ${response.data}');
    } catch (e) {
      print('Ошибка при отправке токена на сервер: $e');
    }
  }

  void _handleLoginError(FirebaseAuthException e) {
    String errorMessage = 'Ошибка аутентификации';
    if (e.code == 'user-not-found') {
      errorMessage = 'Пользователь с таким email не найден.';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Неверный пароль.';
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(errorMessage)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF5F5F5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Email',
                      hintStyle: const TextStyle(fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(
                        Icons.email,
                        size: 18,
                      ),
                      contentPadding: const EdgeInsets.all(4),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(4),
                      hintText: 'Password',
                      hintStyle: const TextStyle(fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        size: 18,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          size: 18,
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_passwordVisible,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _login,
                        child: Text(
                          'Login',
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          // primary: const Color(0xFF6873D1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
