import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class PasswordGenerator extends StatefulWidget {
  final Function(String) onPasswordGenerated;

  const PasswordGenerator({super.key, required this.onPasswordGenerated});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordGeneratorState createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends State<PasswordGenerator> {
  String _generatedPassword = '';
  bool _isTextCopied = false;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _generatePassword() {
    const length = 12;
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random.secure();
    final password =
        List.generate(length, (_) => chars[rnd.nextInt(chars.length)]).join();

    setState(() {
      _generatedPassword = password;
      _passwordController.text = _generatedPassword;
    });
    widget.onPasswordGenerated(_generatedPassword);
  }

  void _copyToClipboard() {
    if (_generatedPassword.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _generatedPassword));
      setState(() {
        _passwordController.text = 'Copied to clipboard';
        _isTextCopied = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _passwordController.text = _generatedPassword;
            _isTextCopied = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF878E92),
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: _generatePassword,
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text(
                  'Generate a password',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _passwordController,
          readOnly: true,
          style: TextStyle(
              color: _isTextCopied ? Colors.green : Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Password',
            suffixIcon: IconButton(
              icon: const Icon(Icons.copy),
              color: const Color(0xFFD9D9D9),
              iconSize: 20,
              onPressed: () => _copyToClipboard(),
            ),
            hintStyle: const TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
