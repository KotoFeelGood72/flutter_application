import 'package:flutter/material.dart';
import 'package:flutter_application/company/modal/ModalInfo/info_order_modal.dart';
import 'package:flutter_application/company/modal/service/service_state_item.dart';
import 'package:flutter_application/service/dio_config.dart';

class ServiceNew extends StatefulWidget {
  final int id;
  const ServiceNew({super.key, required this.id});

  @override
  State<ServiceNew> createState() => _ServiceNewState();
}

class _ServiceNewState extends State<ServiceNew> {
  List<Map<String, dynamic>> services = [];
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
      });
      print('serviceListNew: $services');
    } catch (e) {
      print("Ошибка при получении информации: $e");
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
