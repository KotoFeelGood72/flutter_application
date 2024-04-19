import 'package:flutter/material.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/service/dio_config.dart';

class AddAppartamentsEmployeeModal extends StatefulWidget {
  const AddAppartamentsEmployeeModal({super.key});

  @override
  State<AddAppartamentsEmployeeModal> createState() =>
      _AddAppartamentsEmployeeModalState();
}

class _AddAppartamentsEmployeeModalState
    extends State<AddAppartamentsEmployeeModal> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _area = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _area.dispose();
    super.dispose();
  }

  Future<void> _createAppartaments() async {
    final Map<String, dynamic> appartaments = {
      "apartment_name": _name.text,
      "area": _area.text,
    };
    try {
      final response = await DioSingleton()
          .dio
          .post('employee/apartments/create_apartment', data: appartaments);
      print('Обьект: ${response}');
    } catch (e) {
      print("Appartament не создался $e");
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
                  'Add apartments',
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
                    controller: _name,
                  ),
                ),
                UkTextField(
                  hint: 'Square',
                  controller: _area,
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
                    'Add apartments',
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
