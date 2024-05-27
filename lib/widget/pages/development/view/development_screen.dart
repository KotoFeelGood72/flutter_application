import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:lottie/lottie.dart';

@RoutePage() // Убедитесь, что вы используете правильную аннотацию для auto_route
class DevelopmentScreen extends StatefulWidget {
  const DevelopmentScreen({super.key});

  @override
  State<DevelopmentScreen> createState() => _DevelopmentScreenState();
}

class _DevelopmentScreenState extends State<DevelopmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Lottie.network(
                  'https://lottie.host/ad57922a-24af-4476-9bb0-d844271e3659/qOnVibAAyF.json'),
            ),
            const SizedBox(height: 20),
            const Text(
              'This page is under development. Please check later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            CustomBtn(
                title: 'Go back',
                onPressed: () {
                  context.router.pop();
                })
          ],
        ),
      ),
    );
  }
}
