import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';

class SuccessModal extends StatefulWidget {
  final String message;
  final int durationInSeconds;

  const SuccessModal({
    super.key,
    required this.message,
    this.durationInSeconds = 5,
  });

  @override
  State<SuccessModal> createState() => _SuccessModalState();
}

class _SuccessModalState extends State<SuccessModal> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: widget.durationInSeconds), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Отменяем таймер при уничтожении виджета
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 40),
      decoration: const BoxDecoration(color: Colors.white),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 233, 233, 233),
                  width: 1.0,
                ),
              ),
            ),
            child: const ModalHeader(title: 'Information'),
          ),
          const SizedBox(height: 30),
          const Icon(
            Icons.check_circle,
            size: 50,
            color: Color(0xFF61BE75),
          ),
          const Center(
            child: Text(
              'Success',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF61BE75)),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              widget.message,
              style: const TextStyle(color: Color(0xFFA5A5A7)),
            ),
          ),
        ],
      ),
    );
  }
}
