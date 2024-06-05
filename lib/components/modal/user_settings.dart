import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/text_divider.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _recipientNameController;
  late final TextEditingController _innController;
  late final TextEditingController _kppController;
  late final TextEditingController _accountController;
  late final TextEditingController _bicController;
  late final TextEditingController _correspondentController;
  late final TextEditingController _okpoController;
  late final TextEditingController _bankNameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _recipientNameController = TextEditingController();
    _innController = TextEditingController();
    _kppController = TextEditingController();
    _accountController = TextEditingController();
    _bicController = TextEditingController();
    _correspondentController = TextEditingController();
    _okpoController = TextEditingController();
    _bankNameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _recipientNameController.dispose();
    _innController.dispose();
    _kppController.dispose();
    _accountController.dispose();
    _bicController.dispose();
    _correspondentController.dispose();
    _okpoController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 15,
        right: 15,
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          const ModalHeader(title: 'Edit profile'),
          const SizedBox(height: 20),
          const TextDivider(text: 'User info'),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: UkTextField(
                  hint: 'name',
                  controller: _nameController,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: UkTextField(
                  hint: 'phone',
                  controller: _phoneController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          UkTextField(
            hint: 'email',
            controller: _emailController,
          ),
          const SizedBox(height: 20),
          const TextDivider(text: 'Recipient'),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: UkTextField(
                  hint: 'name',
                  controller: _recipientNameController,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: UkTextField(
                  hint: 'inn',
                  controller: _innController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: UkTextField(
                  hint: 'kpp',
                  controller: _kppController,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: UkTextField(
                  hint: 'account',
                  controller: _accountController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: UkTextField(
                  hint: 'bic',
                  controller: _bicController,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: UkTextField(
                  hint: 'Correspondent',
                  controller: _correspondentController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          UkTextField(
            hint: 'okpo',
            controller: _okpoController,
          ),
          const SizedBox(height: 10),
          UkTextField(
            hint: 'Bank name',
            controller: _bankNameController,
          ),
          const SizedBox(height: 15),
          CustomBtn(
            title: 'Edit profile',
            height: 55,
            onPressed: () {
              // Implement save functionality here
            },
          ),
        ],
      ),
    );
  }
}
