import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
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
  bool _isLoading = false;

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
          if (objectList.isNotEmpty) {
            selectedObjectId = objectList.first['id'].toString();
          }
        });
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  void _onObjectSelected(String id) {
    setState(() {
      selectedObjectId = id;
    });
  }

  Future<void> _createEmployee() async {
    setState(() {
      _isLoading = true;
    });

    final Map<String, dynamic> employee = {
      "object_id": selectedObjectId,
      "first_last_name": _firstNameLastNameController.text,
      "phone_number": _phoneNumberController.text,
      "email": _emailController.text,
      "password": _generatedPassword
    };

    try {
      await DioSingleton()
          .dio
          .post('add_employee_uk/$selectedObjectId', data: employee);
      Navigator.of(context).pop();
      if (!mounted) return;
      await Future.delayed(Duration.zero);
      // ignore: use_build_context_synchronously
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const SuccessModal(
              message: "The employee has been successfully added");
        },
      );
    } catch (e) {
      // Handle error appropriately
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding:
              const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 24),
          color: Colors.white,
          child: Column(
            children: [
              const ModalHeader(title: 'Add an employee'),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ObjectDropDown(
                  objectList: objectList,
                  selectedObjectId: selectedObjectId,
                  onSelected: _onObjectSelected,
                ),
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
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: UkTextField(
                      hint: 'First name Last name',
                      controller: _firstNameLastNameController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: UkTextField(
                      hint: '8 (999) 999-99-99',
                      controller: _phoneNumberController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: UkTextField(
                      hint: 'Press email',
                      controller: _emailController,
                    ),
                  ),
                ],
              ),
              PasswordGenerator(
                onPasswordGenerated: (String generatedPassword) {
                  setState(() {
                    _generatedPassword = generatedPassword;
                  });
                },
              ),
              CustomBtn(
                title: 'Add an employee',
                height: 55,
                onPressed: _createEmployee,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
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
  // ignore: library_private_types_in_public_api
  _ObjectDropDownState createState() => _ObjectDropDownState();
}

class _ObjectDropDownState extends State<ObjectDropDown> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? selectedObject;
    try {
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
              // ignore: empty_catches
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
