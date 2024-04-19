import 'package:flutter/material.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/password_generator.dart';

class AddEmployeModal extends StatefulWidget {
  const AddEmployeModal({super.key});

  @override
  State<AddEmployeModal> createState() => _AddEmployeModalState();
}

class _AddEmployeModalState extends State<AddEmployeModal> {
  List<Map<String, dynamic>> objectList = [];
  String _generatedPassword = '';
  String selectedObjectId = '';
  final TextEditingController _firstNameLastNameController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _firstNameLastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getObjectList();
  }

  Future<void> _getObjectList() async {
    try {
      final response = await DioSingleton().dio.get('get_objects_uk');
      if (response.data != null && response.data['objects'] is List) {
        final List objects = response.data['objects'];
        setState(() {
          objectList = List<Map<String, dynamic>>.from(objects);
          // Предполагаем, что у объектов есть поле 'id'
          if (objectList.isNotEmpty) {
            selectedObjectId = objectList.first['id'].toString();
          }
        });
      }
    } catch (e) {
      print("Ошибка при получении данных: $e");
    }
  }

  void _onObjectSelected(String id) {
    setState(() {
      selectedObjectId = id;
    });
  }

  // void _showSuccessMessage() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text("Employee added"),
  //       duration: Duration(seconds: 4),
  //     ),
  //   );
  // }

  Future<void> _createEmployee() async {
    final Map<String, dynamic> employee = {
      "object_id": selectedObjectId,
      "first_last_name": _firstNameLastNameController.text,
      "phone_number": _phoneNumberController.text,
      "email": _emailController.text,
      "password": _generatedPassword
      // "apartment_name": _nameController.text,
      // "area": _areaController.text,
    };

    try {
      final response = await DioSingleton()
          .dio
          .post('add_employee_uk/${selectedObjectId}', data: employee);
      Navigator.pop(context);
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SuccessModal(message: "Employee added");
        },
      );
    } catch (e) {
      print("Объект не создался: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add an employee',
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
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                ObjectDropDown(
                  objectList: objectList,
                  selectedObjectId: selectedObjectId,
                  onSelected: _onObjectSelected,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Basic information',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xFF73797C)),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _firstNameLastNameController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'First name Last name',
                        filled: true,
                        hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      style: const TextStyle(fontSize: 14),
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        hintText: '8 (999) 999-99-99',
                        filled: true,
                        hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      style: const TextStyle(fontSize: 14),
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Press email',
                        filled: true,
                        hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
                PasswordGenerator(
                  onPasswordGenerated: (String generatedPassword) {
                    setState(() {
                      _generatedPassword = generatedPassword;
                    });
                  },
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
                          _createEmployee();
                        },
                        child: const Text(
                          'Add an employee',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ObjectDropDown extends StatefulWidget {
  final List<Map<String, dynamic>> objectList;
  final String? selectedObjectId;
  final Function(String) onSelected;

  const ObjectDropDown({
    super.key,
    required this.objectList,
    required this.selectedObjectId,
    required this.onSelected,
  });

  @override
  _ObjectDropDownState createState() => _ObjectDropDownState();
}

class _ObjectDropDownState extends State<ObjectDropDown> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? selectedObject;
    try {
      // Пытаемся найти выбранный объект без использования orElse
      selectedObject = widget.objectList.firstWhere(
        (obj) => obj['id'].toString() == widget.selectedObjectId,
      );
    } catch (e) {
      // Если объект не найден, selectedObject останется null
    }
    String? dropdownValue = selectedObject?['object_name'];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          icon: const Icon(Icons.expand_more_rounded),
          iconSize: 20,
          elevation: 16,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),
          value: dropdownValue,
          onChanged: (String? newValue) {
            Map<String, dynamic>? newSelectedObject;
            try {
              newSelectedObject = widget.objectList.firstWhere(
                (obj) => obj['object_name'] == newValue,
              );
            } catch (e) {}

            if (newSelectedObject != null) {
              widget.onSelected(newSelectedObject['id'].toString());
            }
          },
          items: widget.objectList
              .map<DropdownMenuItem<String>>((Map<String, dynamic> object) {
            return DropdownMenuItem<String>(
              value: object['object_name'],
              child: Text(object['object_name']),
            );
          }).toList(),
        ),
      ),
    );
  }
}
