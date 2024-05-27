import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/service/service_state_item.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/empty_state.dart';

class InfoMetterModal extends StatefulWidget {
  final int id;
  const InfoMetterModal({super.key, required this.id});

  @override
  State<InfoMetterModal> createState() => _InfoMetterModalState();
}

class _InfoMetterModalState extends State<InfoMetterModal> {
  List<Map<String, dynamic>> metters = [];

  Future<void> _getMetters() async {
    try {
      final response = await DioSingleton().dio.get(
          'employee/apartments/apartment_info/${widget.id}/meter_readings');
      setState(() {
        // Прямое присвоение, так как структура JSON соответствует ожидаемой
        metters = List<Map<String, dynamic>>.from(response.data);
      });
    } catch (e) {
      // ignore: avoid_print
      print("Ошибка при получении информации о профиле: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getMetters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      child: ListView(
        shrinkWrap: true,
        children: [
          const ModalHeader(title: 'Meter readings'),
          metters.isEmpty
              ? const EmptyState(
                  title: "No meter available",
                  text: '',
                  url:
                      'https://lottie.host/5268f534-057c-41e8-a452-caae0c1a1307/8G8EI88wA5.json',
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: metters.length,
                  itemBuilder: (context, index) {
                    final day = metters[index];
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
                              id: service['id'].toString(),
                              time: service['created_at_time'],
                              times: service['created_at_date'],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
        ],
      ),
    );
  }
}
