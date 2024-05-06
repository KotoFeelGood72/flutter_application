import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/router/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application/service/dio_config.dart';

class RegistrationTab extends StatefulWidget {
  const RegistrationTab({Key? key}) : super(key: key);

  @override
  _RegistrationTabState createState() => _RegistrationTabState();
}

class _RegistrationTabState extends State<RegistrationTab> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Dio _dio = Dio(); // Создание экземпляра Dio
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String? _selectedRole; // Для хранения выбранной роли
  final List<String> _roles = [
    'Administrator',
    'Employee',
    'Client',
    'Company'
  ];

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _confirmPasswordVisible = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (userCredential.user != null) {
          final String uid = userCredential.user!.uid;
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'email': _emailController.text.trim(),
            'role': _selectedRole,
          });
          final String? token = await userCredential.user!.getIdToken();

          print('Новый токен: ${token}');
          if (token != null) {
            await _sendTokenToServer(token);
          }

          if (!mounted) return;
          AutoRouter.of(context).replace(const HomeRoute());
        }
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
      }
    } else {
      if (!mounted) return;
    }
  }

  Future<void> _sendTokenToServer(String token) async {
    try {
      final response = await DioSingleton().dio.post(
            'register',
            data: jsonEncode({'uuid': token}),
          );
      print('Ответ сервера: ${response.data}');
    } catch (e) {
      print('Ошибка при отправке токена на сервер: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF5F5F5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(4),
                        hintStyle: const TextStyle(fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.email,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(4),
                        hintStyle: const TextStyle(fontSize: 14),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          size: 18,
                        ),
                        suffixIcon: IconButton(
                          iconSize: 18,
                          icon: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
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
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(4),
                        hintStyle: const TextStyle(fontSize: 14),
                        hintText: 'Confirm password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          size: 18,
                        ),
                        suffixIcon: IconButton(
                          iconSize: 18,
                          icon: Icon(_confirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_confirmPasswordVisible,
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(4),
                        hintStyle: const TextStyle(fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(
                          Icons.supervised_user_circle,
                          size: 18,
                        ),
                      ),
                      value: _selectedRole,
                      items:
                          _roles.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRole = newValue;
                        });
                      },
                      hint: const Text('Role'),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            // primary: const Color(0xFF6873D1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
