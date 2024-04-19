import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';

class SuccessModal extends StatelessWidget {
  final String message;
  const SuccessModal({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 40),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
            child: ModalHeader(title: 'Information'),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 233, 233, 233), // Цвет границы
                  width: 1.0, // Толщина границы
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Icon(
            Icons.check_circle,
            size: 50,
            color: Color(0xFF61BE75),
          ),
          Center(
            child: Text(
              'Success',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF61BE75)),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              message,
              style: TextStyle(color: Color(0xFFA5A5A7)),
            ),
          ),
        ],
      ),
    );
  }
}
