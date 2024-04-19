import 'package:flutter/material.dart';
import 'package:flutter_application/company/modal/service/service_state_item.dart';
import 'package:flutter_application/service/dio_config.dart';

class PaidPaymentScreen extends StatefulWidget {
  final int id;
  const PaidPaymentScreen({super.key, required this.id});

  @override
  State<PaidPaymentScreen> createState() => _PaidPaymentScreenState();
}

class _PaidPaymentScreenState extends State<PaidPaymentScreen> {
  List<Map<String, dynamic>> services = [];
  Future<void> _getMetters() async {
    try {
      final response = await DioSingleton().dio.get(
          'employee/apartments/apartment_info/${widget.id}/meter_readings');
      setState(() {
        services = response.data;
      });
    } catch (e) {
      print("Ошибка при получении информации о профиле: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getMetters();
  }

  // final List<Map<String, dynamic>> services = [
  //   {
  //     'name': 'Today',
  //     'services': [
  //       {
  //         'img': 'assets/img/electrity.png',
  //         'name': '12-2 Floor-2nd, Smart, 17',
  //         'id': '№ 929809',
  //         'time': '12:15',
  //         'statusOther': 'paid',
  //         'price': 'The amount'
  //       },
  //       {
  //         'img': 'assets/img/electrity.png',
  //         'name': '12-2 Floor-2nd, Smart, 17',
  //         'id': '№ 929809',
  //         'time': '12:15',
  //         'statusOther': 'paid',
  //         'price': 'The amount'
  //       },
  //     ],
  //   },
  //   {
  //     'name': 'Yesterday',
  //     'services': [
  //       {
  //         'img': 'assets/img/electrity.png',
  //         'name': '12-2 Floor-2nd, Smart, 17',
  //         'id': '№ 929809',
  //         'time': '12:15',
  //         'statusOther': 'paid',
  //         'price': 'The amount'
  //       },
  //       {
  //         'img': 'assets/img/electrity.png',
  //         'name': '12-2 Floor-2nd, Smart, 17',
  //         'id': '№ 929809',
  //         'time': '12:15',
  //         'statusOther': 'paid',
  //         'price': 'The amount'
  //       },
  //     ],
  //   },
  //   {
  //     'name': 'Yesterday',
  //     'services': [
  //       {
  //         'img': 'assets/img/electrity.png',
  //         'name': '12-2 Floor-2nd, Smart, 17',
  //         'id': '№ 929809',
  //         'time': '12:15',
  //         'statusOther': 'paid',
  //         'price': 'The amount'
  //       },
  //       {
  //         'img': 'assets/img/electrity.png',
  //         'name': '12-2 Floor-2nd, Smart, 17',
  //         'id': '№ 929809',
  //         'time': '12:15',
  //         'statusOther': 'paid',
  //         'price': 'The amount'
  //       },
  //     ],
  //   },
  // ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
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
                    time: service['time'],
                    price: service['price'],
                    statusOther: service['statusOther'],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
