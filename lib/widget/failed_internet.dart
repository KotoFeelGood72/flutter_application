import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_application/router/router.dart';

class FailedInternet extends StatefulWidget {
  final String? url;
  final String title;
  final String text;
  final AppRouter appRouter;

  const FailedInternet({
    super.key,
    this.url,
    required this.title,
    required this.text,
    required this.appRouter,
  });

  @override
  State<FailedInternet> createState() => _FailedInternetState();
}

class _FailedInternetState extends State<FailedInternet> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            child: Lottie.asset('assets/lottie/internet.json'),
          ),
          const SizedBox(height: 20),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.blueGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            widget.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 40),
          _isLoading
              ? CircularProgressIndicator()
              : CustomBtn(
                  title: 'Reload app',
                  onPressed: () {
                    _reloadApp();
                  },
                ),
        ],
      ),
    );
  }

  void _reloadApp() async {
    setState(() {
      _isLoading = true;
    });

    bool success = await _tryReconnect();

    if (success) {
      widget.appRouter.replaceAll([const AuthRoute()]);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _tryReconnect() async {
    await Future.delayed(Duration(seconds: 2));

    try {
      final result = await InternetAddress.lookup('http://217.25.95.113:8000/');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
