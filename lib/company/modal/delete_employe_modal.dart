import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/components/uk_dropdown.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/toggle_switch.dart';
import 'package:flutter_application/service/dio_config.dart';

class DeleteEmployeModal extends StatefulWidget {
  const DeleteEmployeModal({Key? key}) : super(key: key);

  @override
  State<DeleteEmployeModal> createState() => _DeleteEmployeModalState();
}

class _DeleteEmployeModalState extends State<DeleteEmployeModal> {
  String? dropdownValue;
  bool isArchive = false;
  List<Map<String, dynamic>> staffLists = [];
  Map<String, dynamic> selectedItem = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getStaffList();
  }

  Future<void> _getStaffList() async {
    try {
      final response = await DioSingleton().dio.get('get_staff_uk');
      if (response.data != null) {
        setState(() {
          staffLists = List<Map<String, dynamic>>.from(response.data);
          if (staffLists.isNotEmpty) {
            selectedItem = staffLists.first;
            dropdownValue = selectedItem['id'].toString();
          }
          isLoading = false;
        });
      }
    } catch (e) {
      print("Ошибка при получении данных: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteEmployee() async {
    try {
      if (selectedItem.isNotEmpty) {
        String endpoint = isArchive ? 'archive' : 'delete';
        if (isArchive) {
          await DioSingleton()
              .dio
              .put('get_staff_uk/delete/${selectedItem['id']}/archive');
        } else {
          await DioSingleton()
              .dio
              .delete('get_staff_uk/delete/${selectedItem['id']}');
        }
        Navigator.of(context).pop();
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SuccessModal(
              message:
                  "The employee has been successfully ${isArchive ? 'archived' : 'deleted'}",
            );
          },
        );
      }
    } catch (e) {
      print("Ошибка при удалении сотрудника: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            constraints: BoxConstraints(maxHeight: 300),
            child: const Center(child: CircularProgressIndicator()))
        : Container(
            padding:
                const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 24),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ModalHeader(title: 'Delete an employee '),
                const SizedBox(
                  height: 20,
                ),
                if (staffLists.isNotEmpty)
                  Container(
                    width: double.infinity,
                    child: UkDropdown(
                      itemsList: staffLists,
                      selectedItemKey: dropdownValue,
                      onSelected: (selectedId) {
                        var staff = staffLists.firstWhere(
                          (staff) => staff['id'].toString() == selectedId,
                          orElse: () => {},
                        );
                        setState(() {
                          selectedItem = staff;
                          dropdownValue = selectedId;
                        });
                      },
                      displayValueKey:
                          'first_name', // Передайте ключ отображаемого значения
                      valueKey: 'id', // Используйте идентификатор для valueKey
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.only(bottom: 26),
                  child: ToggleSwitch(
                    leftTabName: "Delete an employee",
                    rightTabName: "Archive an employee",
                    initialValue: isArchive,
                    onToggle: (value) {
                      setState(() {
                        isArchive = value;
                      });
                    },
                  ),
                ),
                CustomBtn(
                    title: 'Delete an employee', onPressed: _deleteEmployee),
              ],
            ),
          );
  }
}
