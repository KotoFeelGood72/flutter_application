import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';

class GuestPass extends StatefulWidget {
  const GuestPass({super.key});

  @override
  State<GuestPass> createState() => _GuestPassState();
}

class _GuestPassState extends State<GuestPass> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedRoom = 'Smart, 17 12-2 floor 23';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}.${picked.month}.${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ModalHeader(title: 'Gues Pass'),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: const Text(
                'Visit date',
                style: TextStyle(
                    color: Color(0xFF5F6A73),
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: UkTextField(
                    controller: _dateController,
                    hint: '',
                    isDateField: true,
                    suffixIcon: const Icon(Icons.date_range),
                  ),
                ),
                const SizedBox(width: 17),
                Expanded(
                  child: UkTextField(
                    controller: _timeController,
                    hint: '',
                    isTimeField: true,
                    suffixIcon: const Icon(Icons.access_time),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _timeController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Time',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () => _selectTime(context),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Guest full name',
                suffixIcon: TextButton(
                  onPressed: () {
                    // Add guest logic
                  },
                  child: const Text('Add guest'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRoom,
              decoration: const InputDecoration(
                labelText: 'Room',
              ),
              items: <String>[
                'Smart, 17 12-2 floor 23',
                'Room 2',
                'Room 3',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRoom = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLength: 500,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Note',
                hintText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                // Attach document logic
              },
              icon: const Icon(Icons.attach_file),
              label: const Text('Attach document'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Send logic
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
