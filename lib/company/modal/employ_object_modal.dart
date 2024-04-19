import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';

class EmployObjectModal extends StatefulWidget {
  const EmployObjectModal({super.key});

  @override
  State<EmployObjectModal> createState() => _EmployObjectModalState();
}

class _EmployObjectModalState extends State<EmployObjectModal> {
  List<Map<String, dynamic>> objectList = [];

  @override
  void initState() {
    super.initState();
    _getObjectList();
  }

  Future<void> _getObjectList() async {
    try {
      final response = await DioSingleton().dio.get('get_objects_uk');
      // Предполагая, что response.data - это Map<String, dynamic>, где есть ключ "objects"
      if (response.data != null && response.data['objects'] is List) {
        final List objects = response.data['objects'];
        setState(() {
          objectList = List<Map<String, dynamic>>.from(objects);
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
                  'Objects',
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
              children: objectList.map((object) {
                return EmployCardObjects(
                  id: object['id'],
                  name: object['object_name'] ?? 'No Name',
                  address: object['object_address'] ?? 'No Address',
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class EmployCardObjects extends StatelessWidget {
  final String name;
  final String address;
  final int id;
  const EmployCardObjects(
      {super.key, required this.name, required this.address, required this.id});

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
                  child: Image.asset('assets/img/house.png'),
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
            const Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }
}
