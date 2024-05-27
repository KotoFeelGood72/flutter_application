import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/password_generator.dart';

class AddExecutors extends StatefulWidget {
  const AddExecutors({
    super.key,
  });

  @override
  State<AddExecutors> createState() => _AddExecutorsState();
}

class _AddExecutorsState extends State<AddExecutors> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _specialization = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _recipientName = TextEditingController();
  final TextEditingController _account = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();
  final TextEditingController _purposeOfPayment = TextEditingController();
  final TextEditingController _bic = TextEditingController();
  final TextEditingController _correspondentAccount = TextEditingController();
  final TextEditingController _bankName = TextEditingController();
  final TextEditingController _inn = TextEditingController();
  final TextEditingController _kpp = TextEditingController();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _specialization.dispose();
    _phoneNumber.dispose();
    _email.dispose();
    _recipientName.dispose();
    _account.dispose();
    _contactNumber.dispose();
    _purposeOfPayment.dispose();
    _bic.dispose();
    _correspondentAccount.dispose();
    _bankName.dispose();
    _inn.dispose();
    _kpp.dispose();
    super.dispose();
  }

  Future<void> _createExecutor() async {
    final Map<String, dynamic> executor = {
      "first_name": _firstName.text,
      "last_name": _lastName.text,
      "specialization": _specialization.text,
      "phone_number": _phoneNumber.text,
      "email": _email.text,
      "recipient_name": _recipientName.text,
      "account": _account.text,
      "contact_number": _contactNumber.text,
      "purpose_of_payment": _purposeOfPayment.text,
      "bic": _bic.text,
      "correspondent_account": _correspondentAccount.text,
      "bank_name": _bankName.text,
      "inn": _inn.text,
      "kpp": _kpp.text,
    };

    try {
      final response = await DioSingleton()
          .dio
          .post('employee/executors/add_executor', data: executor);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          Navigator.pop(context);
          await showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return const SuccessModal(
                  message: "Executor has been successfully issued.");
            },
          );
        }
      } else {
        // Обработка некорректного ответа
        print("Ошибка при добавлении исполнителя: ${response.statusMessage}");
      }
    } catch (e) {
      print("Ошибка при добавлении исполнителя: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ModalHeader(title: 'Add an executor'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                          'Basic information',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xFF73797C)),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: UkTextField(
                                hint: 'First name', controller: _firstName),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: UkTextField(
                                hint: 'Last name', controller: _lastName),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      UkTextField(
                        hint: '8 (999) 999-99-99',
                        controller: _phoneNumber,
                      ),
                      const SizedBox(height: 16),
                      UkTextField(
                        hint: 'Press email',
                        controller: _email,
                      ),
                      const SizedBox(height: 16),
                      UkTextField(
                        hint: 'Press specialization',
                        controller: _specialization,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                          'Requisites information',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xFF73797C)),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: UkTextField(
                              hint: 'Press recipient name',
                              controller: _recipientName,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: UkTextField(
                              hint: 'Press account',
                              controller: _account,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: UkTextField(
                              hint: 'Press contact number',
                              controller: _contactNumber,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: UkTextField(
                              hint: 'Press purpose of payment',
                              controller: _purposeOfPayment,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      UkTextField(
                        hint: 'Press bic',
                        controller: _bic,
                      ),
                      const SizedBox(height: 16),
                      UkTextField(
                        hint: 'Press correspondent account',
                        controller: _correspondentAccount,
                      ),
                      const SizedBox(height: 16),
                      UkTextField(
                        hint: 'Press bank name',
                        controller: _bankName,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: UkTextField(
                              hint: 'Press inn',
                              controller: _inn,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: UkTextField(
                              hint: 'Press kpp',
                              controller: _kpp,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                  CustomBtn(title: 'Add a executor', onPressed: _createExecutor)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
