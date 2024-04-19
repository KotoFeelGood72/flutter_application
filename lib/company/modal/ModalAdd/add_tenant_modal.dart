import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/uk_dropdown.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/password_generator.dart';

class AddTenantModal extends StatefulWidget {
  final int id;
  const AddTenantModal({super.key, required this.id});

  @override
  State<AddTenantModal> createState() => _AddTenantModalState();
}

class _AddTenantModalState extends State<AddTenantModal> {
  List<Map<String, dynamic>> apartmentsList = [];
  String selectedAppartamentId = '';
  String _generatedPassword = '';
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
    _getAppartamentsList().then((_) {
      if (apartmentsList.isNotEmpty) {
        setState(() {
          selectedAppartamentId = apartmentsList[0]['id'].toString();
        });
      }
    });
  }

  void _onAppartamentSelected(String id) {
    setState(() {
      selectedAppartamentId = id;
    });
  }

  Future<void> _getAppartamentsList() async {
    try {
      final response = await DioSingleton()
          .dio
          .get('get_objects_uk/${widget.id}/apartment_list');
      if (response.data != null && response.data['apartments'] is List) {
        final List appartaments = response.data['apartments'];
        setState(() {
          apartmentsList = List<Map<String, dynamic>>.from(appartaments);
        });
      }
      print(response);
    } catch (e) {
      print("Ошибка при получении данных: $e");
    }
  }

  Future<void> _createTenant() async {
    final Map<String, dynamic> employee = {
      // "apartament_id": selectedAppartamentId,
      "first_last_name": _firstNameLastNameController.text,
      "phone_number": _phoneNumberController.text,
      "email": _emailController.text,
      "password": _generatedPassword
      // "apartment_name": _nameController.text,
      // "area": _areaController.text,
    };

    try {
      final response = await DioSingleton().dio.post(
          'employee/apartments/apartment_info/${selectedAppartamentId}/add_tenant',
          data: employee);
      Navigator.pop(context);
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SuccessModal(message: "Tenant has been successfully issued.");
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
                  'Add an tenant',
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
                UkDropdown(
                  itemsList: apartmentsList,
                  selectedItemKey: "1",
                  onSelected: (selectedId) {},
                  displayValueKey: "apartment_name",
                  valueKey: "id",
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
                          _createTenant();
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
