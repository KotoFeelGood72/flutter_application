import 'package:dio/dio.dart'; // Добавьте этот импорт
import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/models/Appartments.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/password_generator.dart';

class AddTenantModal extends StatefulWidget {
  final int id;
  const AddTenantModal({super.key, required this.id});

  @override
  State<AddTenantModal> createState() => _AddTenantModalState();
}

class _AddTenantModalState extends State<AddTenantModal> {
  Appartaments? appartament;
  String selectedAppartamentId = '';
  String _generatedPassword = '';
  final TextEditingController _firstNameLastNameController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;
  String? _errorMessage;

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
    _getAppartaments();
  }

  Future<void> _getAppartaments() async {
    try {
      final response = await DioSingleton()
          .dio
          .get('employee/apartments/apartment_info/${widget.id}');
      if (response.data != null && response.data.isNotEmpty) {
        setState(() {
          appartament = Appartaments.fromJson(response.data);
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print("Ошибка при получении данных: $e");
    }
  }

  Future<void> _createTenant() async {
    final Map<String, dynamic> tenant = {
      "first_last_name": _firstNameLastNameController.text,
      "phone_number": _phoneNumberController.text,
      "email": _emailController.text,
      "password": _generatedPassword
    };

    try {
      final response = await DioSingleton().dio.post(
          'employee/apartments/apartment_info/${appartament!.id}/add_tenant',
          data: tenant);

      if (response.statusCode == 201) {
        Navigator.pop(context);
        await showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return const SuccessModal(
                message: "Tenant has been successfully issued.");
          },
        );
      } else {
        setState(() {
          _isEmailValid = true;
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ModalHeader(title: 'Add a tenant'),
                if (appartament != null)
                  Container(
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 13),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(14)),
                    child: Text(appartament!.name),
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
                    UkTextField(
                        hint: 'First name Last name',
                        controller: _firstNameLastNameController),
                    const SizedBox(height: 16),
                    UkTextField(
                      hint: '8 (999) 999-99-99',
                      controller: _phoneNumberController,
                    ),
                    const SizedBox(height: 16),
                    UkTextField(
                      hint: 'Press email',
                      controller: _emailController,
                    ),
                    if (_isEmailValid)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Invalid email address',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
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
                          'Add a tenant',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
