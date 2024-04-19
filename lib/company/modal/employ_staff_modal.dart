import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/modal/delete_employe_modal.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';

class EmployStaffModal extends StatefulWidget {
  final String apiUrl;
  const EmployStaffModal({super.key, required this.apiUrl});

  @override
  State<EmployStaffModal> createState() => _EmployStaffModalState();
}

class _EmployStaffModalState extends State<EmployStaffModal> {
  List<Map<String, dynamic>> staffList = [];
  @override
  void initState() {
    super.initState();
    _getStaffList();
  }

  Future<void> _getStaffList() async {
    try {
      final response = await DioSingleton().dio.get(widget.apiUrl);
      if (response.data != null && response.data['staff_uk'] is List) {
        final List objects = response.data['staff_uk'];
        setState(() {
          staffList = List<Map<String, dynamic>>.from(objects);
        });
      }
      print(response);
    } catch (e) {
      print("Ошибка при получении данных: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Staff',
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
              shrinkWrap: true,
              children: staffList.map((object) {
                return EmployCardStaff(
                  id: object['id'],
                  name: object['object_name'] ??
                      'No Name', // Используйте '??' для обработки null значений
                  address: object['object_address'] ?? 'No Address',
                );
              }).toList(),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 27, left: 15, right: 15),
              child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(20)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF878E92)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () => {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          builder: (BuildContext context) {
                            return DeleteEmployeModal();
                          },
                        )
                      },
                  child: const Text(
                    'Delete an employee',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  )),
            ),
          )
        ],
      ),
    );
  }
}

class EmployCardStaff extends StatelessWidget {
  final int id;
  final String name;
  final String address;
  const EmployCardStaff(
      {super.key, required this.name, required this.address, required this.id});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AutoRouter.of(context).push(StaffProfileRoute(id: id)),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 19),
                  child: Image.asset('assets/img/users.png'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      address,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFFA5A5A7)),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
