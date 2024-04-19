import 'package:flutter/material.dart';
import 'package:flutter_application/company/modal/service/service_state_item.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/company/modal/ModalInfo/info_order_modal.dart';

class ServiceProgress extends StatefulWidget {
  final int id;
  const ServiceProgress({super.key, required this.id});

  @override
  State<ServiceProgress> createState() => _ServiceProgressState();
}

class _ServiceProgressState extends State<ServiceProgress> {
  List<Map<String, dynamic>> services = [];
  @override
  void initState() {
    super.initState();
    _getServicesList();
  }

  Future<void> _getServicesList() async {
    try {
      final response = await DioSingleton().dio.get(
          'employee/apartments/apartment_info/${widget.id}/service_order/progress');
      if (response.data is List) {
        // Явное приведение элементов списка к типу Map<String, dynamic>
        final List<Map<String, dynamic>> castedData = (response.data as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
        setState(() {
          services = castedData;
        });
      } else {
        print("Некорректный формат данных");
      }
    } catch (e) {
      print("Ошибка при получении информации о профиле: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: services.length,
      itemBuilder: (context, index) {
        final day = services[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
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
                  img: service['icon_path'],
                  name: service['apartment_name'],
                  id: service['order_id'].toString(),
                  time: service['created_at'],
                  status: service['status'],
                  description: service['additional_info']
                      ['additional_service_list'],
                  onTap: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      builder: (BuildContext context) {
                        return InfoOrderModal(
                            appartmentId: widget.id, id: service['order_id']);
                      },
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
