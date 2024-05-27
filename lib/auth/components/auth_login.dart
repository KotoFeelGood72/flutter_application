import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
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
  bool isLoading = false;

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
    setState(() {
      isLoading = true;
    });
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null && mounted) {
        final String? token = await userCredential.user!.getIdToken();
        await _sendTokenToServer(token!);

        if (!mounted) return;

        await _navigateBasedOnUserRole(userCredential.user!.uid);

        if (!mounted) return;
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _handleLoginError(e);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _navigateBasedOnUserRole(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final role = snapshot.data()?['role'] as String?;
      if (role != null && mounted) {
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ошибка при перенаправлении на основе роли')));
    }
  }

  Future<void> _sendTokenToServer(String token) async {
    try {
      await DioSingleton().dio.get(
            'login',
          );
    } catch (e) {}
  }

  void _handleLoginError(FirebaseAuthException e) {
    String errorMessage = 'Authentication error';
    if (e.code == 'user-not-found') {
      errorMessage = 'The user with this email address was not found.';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'The password is incorrect.';
    }
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
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
                        isLoading
                            ? const CircularProgressIndicator()
                            : CustomBtn(
                                title: 'Sign in',
                                height: 50,
                                borderRadius: 5,
                                onPressed: _login,
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
