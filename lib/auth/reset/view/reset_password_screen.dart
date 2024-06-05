import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/page_header.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';

@RoutePage()
class SendResetEmailScreen extends StatefulWidget {
  const SendResetEmailScreen({Key? key}) : super(key: key);

  @override
  _SendResetEmailScreenState createState() => _SendResetEmailScreenState();
}

class _SendResetEmailScreenState extends State<SendResetEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendResetEmail() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await DioSingleton().dio.post('forgot-password',
          data: {'email': _emailController.text.trim()});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password reset email sent successfully.')),
      );
      AutoRouter.of(context)
          .push(EnterResetCodeRoute(email: _emailController.text.trim()));
    } on DioError catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.response?.statusCode == 400) {
        errorMessage = 'Invalid email address.';
      } else if (e.response?.statusCode == 404) {
        errorMessage = 'Email address not found.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $errorMessage')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(
        title: 'Reset password from email',
      ),
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
                        _isLoading
                            ? const CircularProgressIndicator()
                            : CustomBtn(
                                title: 'Send Reset Email',
                                height: 50,
                                borderRadius: 5,
                                onPressed: _sendResetEmail,
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
