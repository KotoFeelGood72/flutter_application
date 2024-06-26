import 'package:flutter/material.dart';
import 'package:flutter_application/company/modal/ModalInfo/info_order_modal.dart';
import 'package:flutter_application/company/modal/service/service_state_item.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/empty_state.dart';

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
      if (response.data is List) {
        final List<Map<String, dynamic>> castedData = (response.data as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
        setState(() {
          services = castedData;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print("Ошибка при получении информации о профиле: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return services.isEmpty
        ? const EmptyState(
            title: "No services available",
            text: '',
            url:
                'https://lottie.host/5268f534-057c-41e8-a452-caae0c1a1307/8G8EI88wA5.json',
          )
        : ListView.builder(
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
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
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
                                  appartmentId: widget.id,
                                  id: service['order_id']);
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
