import 'package:flutter/material.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/service/dio_config.dart';

class AddObjectModal extends StatefulWidget {
  const AddObjectModal({super.key});

  @override
  State<AddObjectModal> createState() => _AddObjectModalState();
}

class _AddObjectModalState extends State<AddObjectModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Объект успешно создан!"),
        duration: Duration(seconds: 4),
      ),
    );
  }

  Future<void> _createObject() async {
    final Map<String, dynamic> objectData = {
      "object_name": _nameController.text,
      "object_address": _addressController.text,
    };

    try {
      final response =
          await DioSingleton().dio.post('create_object', data: objectData);
      print('Объект: ${response}');

      // Закрытие модального окна
      Navigator.pop(context);

      // Отображение уведомления о успешном создании
      SuccessModal(message: 'Employee added');
    } catch (e) {
      print("Объект не создался: $e");
      // Здесь также можно отобразить сообщение об ошибке, если нужно
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
                    hint: 'Name of the object',
                    controller: _nameController,
                  ),
                ),
                UkTextField(
                  hint: 'Address',
                  controller: _addressController,
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
                    _createObject();
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
