import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UkTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final int? maxLines;
  final bool isDateField;
  final bool isTimeField;
  final Widget? suffixIcon; // Параметр для пользовательской иконки

  const UkTextField({
    super.key,
    required this.hint,
    this.controller,
    this.maxLines = 1,
    this.isDateField = false,
    this.isTimeField = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDateTime(context),
      child: AbsorbPointer(
        absorbing: isDateField || isTimeField,
        child: TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 14),
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            hintStyle: const TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            suffixIcon: suffixIcon ??
                (isDateField || isTimeField ? Icon(Icons.chevron_right) : null),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    if (isDateField) {
      await _selectDate(context);
    } else if (isTimeField) {
      await _selectTime(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime oneYearLater = DateTime(now.year + 1, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: oneYearLater,
    );
    if (picked != null && controller != null) {
      controller!.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && controller != null) {
      final now = DateTime.now();
      final dateTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      controller!.text = DateFormat('HH:mm').format(dateTime);
    }
  }
}
