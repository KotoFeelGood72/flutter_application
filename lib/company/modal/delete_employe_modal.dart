import 'package:flutter/material.dart';
import 'package:flutter_application/components/ui/toggle_switch.dart';
import 'package:flutter_application/service/dio_config.dart';

class DeleteEmployeModal extends StatelessWidget {
  const DeleteEmployeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 24),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Delete an employee',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                )),
            const SizedBox(
              width: double.infinity,
              child: ObjectDropDown(),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 26),
                child: ToggleSwitch(
                  leftTabName: "Delete an employee",
                  rightTabName: "Archive an employee",
                  initialValue: false,
                  onToggle: (value) {
                    print("Текущее значение: $value");
                  },
                )),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: const Color(0xFF878E92),
                  borderRadius: BorderRadius.circular(15)),
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  'Delete an employee',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ));
  }
}

class ObjectDropDown extends StatefulWidget {
  const ObjectDropDown({super.key});

  @override
  _ObjectDropDownState createState() => _ObjectDropDownState();
}

class _ObjectDropDownState extends State<ObjectDropDown> {
  List<Map<String, dynamic>> staffList = [];
  @override
  void initState() {
    super.initState();
    _getStaffList();
  }

  Future<void> _getStaffList() async {
    try {
      final response = await DioSingleton().dio.get('get_staff_uk');
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

  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropdownValue,
          hint: Text('Select employee'),
          icon: const Icon(Icons.expand_more_rounded),
          iconSize: 20,
          elevation: 16,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: staffList
              .map<DropdownMenuItem<String>>((Map<String, dynamic> staff) {
            String displayValue = '${staff['firstname']} ${staff['lastname']}';
            return DropdownMenuItem<String>(
              value: displayValue,
              child: Text(displayValue),
            );
          }).toList(),
        ),
      ),
    );
  }
}
