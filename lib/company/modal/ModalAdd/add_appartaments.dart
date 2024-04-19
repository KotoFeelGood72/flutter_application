import 'package:flutter/material.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/service/dio_config.dart';

class AddAppartamentsModal extends StatefulWidget {
  final int id;
  const AddAppartamentsModal({super.key, required this.id});

  @override
  State<AddAppartamentsModal> createState() => _AddAppartamentsModalState();
}

class _AddAppartamentsModalState extends State<AddAppartamentsModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Аппартамент успешно создан!"),
        duration: Duration(seconds: 4),
      ),
    );
  }

  Future<void> _createAppartaments() async {
    final Map<String, dynamic> appartamentData = {
      "apartment_name": _nameController.text,
      "area": _areaController.text,
    };

    try {
      final response = await DioSingleton().dio.post(
          'get_objects_uk/${widget.id}/create_apartment',
          data: appartamentData);
      print('Объект: ${response}');
      Navigator.pop(context);
      _showSuccessMessage();
    } catch (e) {
      print("Объект не создался: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 445,
      padding: const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 24),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add an object',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color.fromARGB(255, 235, 234, 234),
                  ),
                  child: IconButton(
                      color: const Color(0xFFB4B7B8),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.zero,
                      iconSize: 12,
                      icon: const Icon(
                        Icons.close,
                      )),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: UkTextField(
                    hint: 'Apartment number',
                    controller: _nameController,
                  ),
                ),
                UkTextField(
                  hint: 'Square',
                  controller: _areaController,
                ),
              ],
            ),
          ),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF6873D1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () {
                    _createAppartaments();
                  },
                  child: const Text(
                    'Add an object',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
