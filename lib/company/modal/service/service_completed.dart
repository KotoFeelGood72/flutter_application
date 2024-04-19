import 'package:flutter/material.dart';
import 'package:flutter_application/company/modal/service/service_state_item.dart';
import 'package:flutter_application/service/dio_config.dart';

class ServiceCompleted extends StatefulWidget {
  final int id;
  const ServiceCompleted({super.key, required this.id});

  @override
  State<ServiceCompleted> createState() => _ServiceCompletedState();
}

class _ServiceCompletedState extends State<ServiceCompleted> {
  List<Map<String, dynamic>> services = [];
  @override
  void initState() {
    super.initState();
    _getServicesList();
  }

  Future<void> _getServicesList() async {
    try {
      final response = await DioSingleton().dio.get(
          'employee/apartments/apartment_info/${widget.id}/service_order/completed');
      setState(() {
        services = response.data;
      });
      print('serviceListNew: ${services}');
    } catch (e) {
      print("Ошибка при получении информации о профиле: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: services.length,
      itemBuilder: (context, index) {
        final day = services[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                day['name'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: day['services'].length,
              itemBuilder: (context, serviceIndex) {
                final service = day['services'][serviceIndex];
                return ServiceStateItem(
                  img: service['img'],
                  name: service['name'],
                  id: service['id'],
                  description: service['description'],
                  time: service['time'],
                  status: service['status'],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
