import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/delete_employe_modal.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/default_list_card.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/empty_state.dart';

class EmployStaffModal extends StatefulWidget {
  final String apiUrl;
  const EmployStaffModal({super.key, required this.apiUrl});

  @override
  State<EmployStaffModal> createState() => _EmployStaffModalState();
}

class _EmployStaffModalState extends State<EmployStaffModal> {
  List<Map<String, dynamic>> staffList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getStaffList();
  }

  Future<void> _getStaffList() async {
    try {
      final response = await DioSingleton().dio.get(widget.apiUrl);
      if (response.data != null && response.data is List) {
        print(response.data);
        final List<dynamic> staff = response.data;
        setState(() {
          staffList =
              staff.map((item) => Map<String, dynamic>.from(item)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Ошибка при получении данных: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 600),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.only(
                  top: 20, left: 15, right: 15, bottom: 20),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const ModalHeader(title: 'Employee'),
                  const SizedBox(height: 20),
                  Container(
                    constraints: BoxConstraints(maxHeight: 400),
                    child: staffList.isEmpty
                        ? const EmptyState(
                            title: "No employee available",
                            text: '',
                          )
                        : ListView.builder(
                            itemCount: staffList.length,
                            itemBuilder: (context, index) {
                              final staff = staffList[index];
                              return DefaultListCard(
                                id: staff['id'],
                                name:
                                    "${staff['first_name'] ?? ''} ${staff['last_name'] ?? 'No name'}"
                                        .trim(),
                                address: staff['phone_number'] ?? 'No phone',
                                imageUrl: 'assets/img/users.png',
                                route: StaffProfileRoute(id: staff['id']),
                              );
                            },
                          ),
                  ),
                  if (!staffList.isEmpty)
                    CustomBtn(
                      title: 'Delete an employee',
                      onPressed: () {
                        Navigator.of(context).pop();
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          builder: (BuildContext context) {
                            return const DeleteEmployeModal();
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }
}
