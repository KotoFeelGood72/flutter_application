import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/modal/delete_employe_modal.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';

class EmployeModalExecutors extends StatefulWidget {
  const EmployeModalExecutors({super.key});

  @override
  State<EmployeModalExecutors> createState() => _EmployeModalExecutorsState();
}

class _EmployeModalExecutorsState extends State<EmployeModalExecutors> {
  List<Map<String, dynamic>> executors = [];
  @override
  void initState() {
    super.initState();
    _getExecutorsList();
  }

  Future<void> _getExecutorsList() async {
    try {
      final response = await DioSingleton().dio.get('employee/executors');
      if (response.data != null && response.data['executors'] is List) {
        final List executor = response.data['executors'];
        setState(() {
          executors = List<Map<String, dynamic>>.from(executor);
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
                  'Executors',
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
              children: executors.map((executor) {
                return EmployCardStaff(
                  id: executor['id'],
                  name: executor['firstname'] ?? 'No Name',
                  lastname: executor['lastname'] ?? 'No Name',
                  specialization: executor['specialization'] ?? 'No Address',
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class EmployCardStaff extends StatelessWidget {
  final String name;
  final String lastname;
  final String specialization;
  final int id;
  const EmployCardStaff(
      {super.key,
      required this.name,
      required this.lastname,
      required this.specialization,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AutoRouter.of(context).push(ExecutorsProfileRoute(id: id)),
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
                      '${name}, ${lastname}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      specialization,
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
