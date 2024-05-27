import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/ModalAdd/add_executors.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/empty_state.dart';

class EmployeModalExecutors extends StatefulWidget {
  const EmployeModalExecutors({super.key});

  @override
  State<EmployeModalExecutors> createState() => _EmployeModalExecutorsState();
}

class _EmployeModalExecutorsState extends State<EmployeModalExecutors> {
  List<Map<String, dynamic>> executors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getExecutorsList();
  }

  Future<void> _getExecutorsList() async {
    try {
      final response = await DioSingleton().dio.get('employee/executors');
      if (response.data != null && response.data is List) {
        final List executor = response.data;
        setState(() {
          executors = List<Map<String, dynamic>>.from(executor);
        });
      }
    } catch (e) {
      print("Ошибка при получении данных: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 600),
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 20),
            child: const ModalHeader(title: 'Executors'),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              constraints: BoxConstraints(maxHeight: 300),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : executors.isEmpty
                      ? const EmptyState(
                          title: 'No available executors',
                          text: '',
                        )
                      : ListView(
                          shrinkWrap: true,
                          children: executors.map((executor) {
                            return EmployCardStaff(
                              id: executor['id'],
                              name: executor['first_name'] ?? 'No Name',
                              lastname: executor['last_name'] ?? 'No Name',
                              specialization:
                                  executor['specialization'] ?? 'No Address',
                              img: executor['photo_path'] ?? '',
                            );
                          }).toList(),
                        ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            child: CustomBtn(
              title: 'Add an executors',
              onPressed: () {
                Navigator.of(context).pop();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  builder: (BuildContext context) {
                    return const AddExecutors();
                  },
                );
              },
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
  final String img;
  const EmployCardStaff({
    super.key,
    required this.name,
    required this.lastname,
    required this.specialization,
    required this.id,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        AutoRouter.of(context).push(ExecutorsProfileRoute(id: id));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 19),
                  width: 50,
                  height: 50,
                  child: img.isNotEmpty
                      ? Image.network(
                          img,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/img/users.png');
                          },
                          fit: BoxFit.cover,
                        )
                      : Image.asset('assets/img/users.png'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$name, $lastname',
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
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
