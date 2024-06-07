import 'package:flutter/material.dart';
import 'package:flutter_application/client/bloc/client_bloc.dart';
import 'package:flutter_application/company/bloc/company_bloc.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/text_divider.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/employee/bloc/employee_bloc.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserSettings extends StatefulWidget {
  final String userRole;
  const UserSettings({super.key, required this.userRole});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  late final TextEditingController _firstnameController;
  late final TextEditingController _lastnameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _companyNameController;
  late final TextEditingController _unifiedContactPhoneController;
  late final TextEditingController _unifiedContactEmailController;
  late final TextEditingController _offersEmailController;
  late final TextEditingController _mobileAppPhoneController;
  late final TextEditingController _mobileAppEmailController;
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
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _companyNameController = TextEditingController();
    _unifiedContactPhoneController = TextEditingController();
    _unifiedContactEmailController = TextEditingController();
    _offersEmailController = TextEditingController();
    _mobileAppPhoneController = TextEditingController();
    _mobileAppEmailController = TextEditingController();
    _recipientNameController = TextEditingController();
    _innController = TextEditingController();
    _kppController = TextEditingController();
    _accountController = TextEditingController();
    _bicController = TextEditingController();
    _correspondentController = TextEditingController();
    _okpoController = TextEditingController();
    _bankNameController = TextEditingController();

    switch (widget.userRole) {
      case 'client':
        BlocProvider.of<ClientBloc>(context).add(ClientInfoUser());
        break;
      case 'Company':
        BlocProvider.of<CompanyBloc>(context).add(CompanyLoaded());
        break;
      case 'Employee':
        BlocProvider.of<EmployeeBloc>(context).add(EmployeeLoaded());
        break;
      default:
        throw Exception('Unknown user role: ${widget.userRole}');
    }
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyNameController.dispose();
    _unifiedContactPhoneController.dispose();
    _unifiedContactEmailController.dispose();
    _offersEmailController.dispose();
    _mobileAppPhoneController.dispose();
    _mobileAppEmailController.dispose();
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

  Future<void> updateUser() async {
    try {
      final data = {
        'first_last_name':
            '${_firstnameController.text} ${_lastnameController.text}',
        'phone_number': _phoneController.text,
        'email': _emailController.text,
      };

      if (widget.userRole == 'Company') {
        data.addAll({
          'name_of_company': _companyNameController.text,
          'unified_contact_phone_number': _unifiedContactPhoneController.text,
          'unified_contact_email': _unifiedContactEmailController.text,
          'offers_email': _offersEmailController.text,
          'mobile_application_phone_number': _mobileAppPhoneController.text,
          'mobile_application_email': _mobileAppEmailController.text,
          'recipient_name': _recipientNameController.text,
          'account': _accountController.text,
          'okpo': _okpoController.text,
          'bic': _bicController.text,
          'correspondent_account': _correspondentController.text,
          'bank_name': _bankNameController.text,
          'inn': _innController.text,
          'kpp': _kppController.text,
        });
      }

      final url = 'update-profiles';
      await DioSingleton().dio.put(url, data: data);

      switch (widget.userRole) {
        case 'client':
          BlocProvider.of<ClientBloc>(context).add(ClientInfoUser());
          break;
        case 'Company':
          BlocProvider.of<CompanyBloc>(context).add(CompanyLoaded());
          break;
        case 'Employee':
          BlocProvider.of<EmployeeBloc>(context).add(EmployeeLoaded());
          break;
      }
      Navigator.pop(context);
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return const SuccessModal(message: "Profile updated successfully");
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  Widget _buildClientSettings(ClientState state) {
    if (state is ClientState && state.userInfo != null) {
      _firstnameController.text = state.userInfo!.firstname;
      _lastnameController.text = state.userInfo!.lastname;
      _phoneController.text = state.userInfo!.phoneNumber;
      _emailController.text = state.userInfo!.email;
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: UkTextField(
                hint: 'First name',
                controller: _firstnameController,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: UkTextField(
                hint: 'Last name',
                controller: _lastnameController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        UkTextField(
          hint: 'Phone',
          controller: _phoneController,
        ),
        const SizedBox(height: 10),
        UkTextField(
          hint: 'Email',
          controller: _emailController,
        ),
        const SizedBox(height: 15),
        CustomBtn(
          title: 'Edit profile',
          height: 55,
          onPressed: updateUser,
        ),
      ],
    );
  }

  Widget _buildCompanySettings(CompanyState state) {
    if (state is CompanyStateData) {
      final company = state.company!;
      final requisites = company.requisites;

      _firstnameController.text = company.ukName ?? '';
      _phoneController.text = company.contacts?.first.phone ?? '';
      _emailController.text = company.contacts?.first.email ?? '';
      _companyNameController.text = company.ukName ?? '';
      _unifiedContactPhoneController.text = company.contacts?.first.phone ?? '';
      _unifiedContactEmailController.text = company.contacts?.first.email ?? '';
      _offersEmailController.text = company.contacts?.first.email ?? '';
      _mobileAppPhoneController.text = company.contacts?.first.phone ?? '';
      _mobileAppEmailController.text = company.contacts?.first.email ?? '';
      if (requisites != null) {
        _recipientNameController.text = requisites.recipient ?? '';
        _innController.text = requisites.inn ?? '';
        _kppController.text = requisites.kpp ?? '';
        _accountController.text = requisites.account ?? '';
        _bicController.text = requisites.bic ?? '';
        _correspondentController.text = requisites.correspondentAccount ?? '';
        _okpoController.text = requisites.okpo ?? '';
        _bankNameController.text = requisites.bankName ?? '';
      }
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: UkTextField(
                hint: 'Company Name',
                controller: _companyNameController,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: UkTextField(
                hint: 'Phone',
                controller: _phoneController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        UkTextField(
          hint: 'Email',
          controller: _emailController,
        ),
        const SizedBox(height: 20),
        UkTextField(
          hint: 'Unified Contact Phone',
          controller: _unifiedContactPhoneController,
        ),
        const SizedBox(height: 10),
        UkTextField(
          hint: 'Unified Contact Email',
          controller: _unifiedContactEmailController,
        ),
        const SizedBox(height: 10),
        UkTextField(
          hint: 'Offers Email',
          controller: _offersEmailController,
        ),
        const SizedBox(height: 10),
        UkTextField(
          hint: 'Mobile App Phone',
          controller: _mobileAppPhoneController,
        ),
        const SizedBox(height: 10),
        UkTextField(
          hint: 'Mobile App Email',
          controller: _mobileAppEmailController,
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.centerLeft,
          child: const TextDivider(text: 'Recipient'),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: UkTextField(
                hint: 'Recipient Name',
                controller: _recipientNameController,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: UkTextField(
                hint: 'INN',
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
                hint: 'KPP',
                controller: _kppController,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: UkTextField(
                hint: 'Account',
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
                hint: 'BIC',
                controller: _bicController,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: UkTextField(
                hint: 'Correspondent Account',
                controller: _correspondentController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        UkTextField(
          hint: 'OKPO',
          controller: _okpoController,
        ),
        const SizedBox(height: 10),
        UkTextField(
          hint: 'Bank Name',
          controller: _bankNameController,
        ),
        const SizedBox(height: 15),
        CustomBtn(
          title: 'Edit profile',
          height: 55,
          onPressed: updateUser,
        ),
      ],
    );
  }

  Widget _buildEmployeeSettings(EmployeeState state) {
    if (state is EmployeeDataLoaded) {
      _firstnameController.text = state.employeeInfo!.firstname;
      _lastnameController.text = state.employeeInfo!.lastname;
      _phoneController.text = state.employeeInfo!.phoneNumber;
      _emailController.text = state.employeeInfo!.email;
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: UkTextField(
                hint: 'First name',
                controller: _firstnameController,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: UkTextField(
                hint: 'Last name',
                controller: _lastnameController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        UkTextField(
          hint: 'Phone',
          controller: _phoneController,
        ),
        const SizedBox(height: 10),
        UkTextField(
          hint: 'Email',
          controller: _emailController,
        ),
        const SizedBox(height: 15),
        CustomBtn(
          title: 'Edit profile',
          height: 55,
          onPressed: updateUser,
        ),
      ],
    );
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
          if (widget.userRole == 'client')
            BlocBuilder<ClientBloc, ClientState>(
              builder: (context, state) {
                return _buildClientSettings(state);
              },
            )
          else if (widget.userRole == 'Company')
            BlocBuilder<CompanyBloc, CompanyState>(
              builder: (context, state) {
                return _buildCompanySettings(state);
              },
            )
          else if (widget.userRole == 'Employee')
            BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, state) {
                return _buildEmployeeSettings(state);
              },
            ),
        ],
      ),
    );
  }
}
