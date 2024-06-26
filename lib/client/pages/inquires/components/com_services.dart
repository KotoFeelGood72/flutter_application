import 'package:flutter/material.dart';

class ComServices extends StatelessWidget {
  const ComServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 130),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 170,
                  height: 170,
                  child: Image.asset('assets/img/complaints.png')),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'No history of inquiries',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TextButton(
        onPressed: () {
          // print("Create a request button pressed");
        },
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFF6873D1),
          padding:
              const EdgeInsets.only(top: 15, left: 35, right: 35, bottom: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Text(
          'Create',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
