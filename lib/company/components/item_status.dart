import 'package:flutter/material.dart';

class ItemStatus extends StatelessWidget {
  final String status;
  const ItemStatus({super.key, required this.status});
  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    switch (status) {
      case 'new':
        statusColor = Color(0xFF4FC0FF);
        statusText = 'New';
        break;
      case 'in progress':
        statusColor = Color(0xFFBCBE61);
        statusText = 'in progress';
        break;
      case 'Completed':
        statusColor = Color(0xFF61BE75);
        statusText = 'Completed';
        break;
      case 'paid':
        statusColor = Color(0xFF61BE75);
        statusText = 'Paid';
        break;
      case 'unpaid':
        statusColor = Color(0xFFBE6161);
        statusText = 'Unpaid';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
    }
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 7),
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(25)),
      child: Text(statusText,
          style: TextStyle(
              color: statusColor, fontSize: 10, fontWeight: FontWeight.w500)),
    );
  }
}
