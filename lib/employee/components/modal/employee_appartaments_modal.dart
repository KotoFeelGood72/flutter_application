import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/employee/components/modal/add_appartaments_employee.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';

class EmployeeAppartamentsModal extends StatefulWidget {
  const EmployeeAppartamentsModal({super.key});

  State<EmployeeAppartamentsModal> createState() =>
      _EmployeeAppartamentsModalState();
}

class _EmployeeAppartamentsModalState extends State<EmployeeAppartamentsModal> {
  List<Map<String, dynamic>> apartmentsList = [];

  @override
  void initState() {
    super.initState();
    _getAppartamentsList();
  }

  Future<void> _getAppartamentsList() async {
    try {
      final response = await DioSingleton().dio.get('employee/apartments');
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

  void openModal(BuildContext context) {
    Navigator.of(context).pop();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      builder: (BuildContext context) {
        return AddAppartamentsEmployeeModal();
      },
    );
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
                  'Apartments',
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
              children: apartmentsList.map((appartament) {
                return EmployCardObjects(
                  id: appartament['id'],
                  name: appartament['apartment_name'] ?? 'No Name',
                  area: appartament['area'] ?? 'No Address',
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: const Color(0xFF878E92),
                  borderRadius: BorderRadius.circular(15)),
              child: GestureDetector(
                onTap: () {
                  openModal(context);
                },
                child: const Text(
                  'Add apartments',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class EmployCardObjects extends StatelessWidget {
  final String name;
  final double area;
  final int id;
  const EmployCardObjects(
      {super.key, required this.name, required this.area, required this.id});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AutoRouter.of(context).push(ObjectSingleRoute(id: id));
      },
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
                  child: Image.asset('assets/img/appartaments_icon.png'),
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
                      area.toString(),
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFFA5A5A7)),
                    )
                  ],
                ),
              ],
            ),
            const Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }
}
