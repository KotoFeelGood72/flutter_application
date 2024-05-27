import 'package:flutter/material.dart';
import 'package:flutter_application/company/modal/ModalInfo/info_order_modal.dart';
import 'package:flutter_application/company/modal/service/service_state_item.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/empty_state.dart';

class ServiceNew extends StatefulWidget {
  final int id;
  final Function(bool) updateIsView; // Add callback parameter
  const ServiceNew({super.key, required this.id, required this.updateIsView});

  @override
  State<ServiceNew> createState() => _ServiceNewState();
}

class _ServiceNewState extends State<ServiceNew> {
  List<Map<String, dynamic>> services = [];
  bool isView = true; // Initialize boolean value for parent

  @override
  void initState() {
    super.initState();
    _getServicesList();
  }

  Future<void> _getServicesList() async {
    try {
      final response = await DioSingleton().dio.get(
          'employee/apartments/apartment_info/${widget.id}/service_order/new');
      final List<dynamic> rawData = response.data;
      setState(() {
        services = rawData.cast<Map<String, dynamic>>();

        services.sort((a, b) {
          final aIsViewed = a['services'].every((s) => s['is_view'] == true);
          final bIsViewed = b['services'].every((s) => s['is_view'] == true);
          return aIsViewed ? 1 : -1;
        });

        for (var day in services) {
          day['services'].sort((a, b) => a['is_view'] ? 1 : -1);
        }

        checkIfAnyServiceIsNotViewed();
      });
    } catch (e) {
      // ignore: avoid_print
      print("Ошибка при получении информации: $e");
    }
  }

  void checkIfAnyServiceIsNotViewed() {
    for (var day in services) {
      for (var service in day['services']) {
        if (service['is_view'] == false) {
          setState(() {
            isView = false;
          });
          widget.updateIsView(false);
          return;
        }
      }
    }
    setState(() {
      isView = true;
    });
    widget.updateIsView(true); // Call the callback with the new value
  }

  @override
  Widget build(BuildContext context) {
    return services.isEmpty
        ? const EmptyState(
            title: "No services available",
            text: '',
          )
        : ListView.builder(
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
                        isView: service['is_view'],
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
