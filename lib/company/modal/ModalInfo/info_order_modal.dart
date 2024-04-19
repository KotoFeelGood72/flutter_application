import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/item_status.dart';
import 'package:flutter_application/company/components/uk_dropdown.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/service/dio_config.dart';

class InfoOrderModal extends StatefulWidget {
  final int id;
  final int appartmentId;
  const InfoOrderModal(
      {super.key, required this.id, required this.appartmentId});

  @override
  State<InfoOrderModal> createState() => _InfoOrderModalState();
}

class _InfoOrderModalState extends State<InfoOrderModal> {
  Map<String, dynamic> orderData = {};
  bool isLoading = true;
  Map<String, dynamic> selectedItem = {};

  @override
  void initState() {
    super.initState();
    _getSingleOrder();
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(""),
        duration: Duration(seconds: 4),
      ),
    );
  }

  Future<void> _putToWork(int executorId) async {
    try {
      final response = await DioSingleton().dio.post(
          'employee/apartments/apartment_info/${widget.appartmentId}/service_order/new/${widget.id}/to_work/$executorId');
      Navigator.pop(context);
      _showSuccessMessage();
    } catch (e) {
      print("Ошибка при отправке на работу: $e");
    }
  }

  Future<void> _getSingleOrder() async {
    try {
      final response = await DioSingleton().dio.get(
          'employee/apartments/apartment_info/${widget.appartmentId}/service_order/new/${widget.id}');
      if (response.data != null && response.data is Map) {
        var key = widget.id.toString(); // Если ключи в Map являются строками
        if (response.data.containsKey(key)) {
          setState(() {
            orderData = response.data[key];
            isLoading = false;
            if (orderData != null &&
                orderData.containsKey('executors') &&
                orderData['executors'].isNotEmpty) {
              selectedItem = orderData['executors'][0];
            }
          });
        } else {
          print("Данные по ключу $key не найдены");
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("Некорректный формат данных");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Ошибка при получении информации: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading ||
        orderData.isEmpty ||
        orderData['executors'] == null ||
        orderData['executors'].isEmpty) {
      return Container(
        height: 700,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 25),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 54,
                        height: 3,
                        color: const Color(0xFFDCDCDC),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
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
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 3),
            child: Text(
              orderData['created_at'].toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 6),
            child: const Text(
              'Other',
              style: TextStyle(color: Color(0xFFA5A5A7), fontSize: 12),
            ),
          ),
          Container(
            width: 88,
            height: 88,
            margin: const EdgeInsets.only(bottom: 10),
            child: orderData['icon_path'] != null &&
                    orderData['icon_path'].isNotEmpty
                ? Image.network(
                    orderData['icon_path'],
                    fit: BoxFit.contain,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset('assets/img/cleaning.png',
                          fit: BoxFit.contain);
                    },
                  )
                : Image.asset(
                    'assets/img/cleaning.png',
                    fit: BoxFit.contain,
                  ),
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  '№ ${orderData['order_id'].toString()}',
                  style: TextStyle(color: Color(0xFFA5A5A7), fontSize: 12),
                ),
                SizedBox(height: 5),
                Text(
                  orderData['apartment_name'].toString(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Wrap(
            children: [
              ItemStatus(status: orderData['status'].toString()),
            ],
          ),
          SizedBox(height: 10),
          Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: orderData['additional_info']
                        ['additional_service_list']
                    .map<Widget>((service) => Text(service))
                    .toList(),
              )),
          Container(
            margin: EdgeInsets.only(bottom: 12),
            child: const Text(
              'Execution time',
              style: TextStyle(
                  color: Color(0xFF5F6A73),
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const Row(
            children: [
              Expanded(
                child: UkTextField(
                  hint: '27.07.2023',
                  isDateField: true,
                  suffixIcon: Icon(Icons.date_range),
                ),
              ),
              SizedBox(width: 17),
              Expanded(
                child: UkTextField(
                  hint: '27.07.2023',
                  isTimeField: true,
                  suffixIcon: Icon(Icons.access_time),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomBtn(
            title: 'Go to the chat',
            onPressed: () {},
            color: const Color(0xFF878E92),
          ),
          SizedBox(height: 12),
          const Text(
            'Executor',
            style: TextStyle(
                color: Color(0xFF5F6A73),
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          UkDropdown(
            itemsList: List<Map<String, dynamic>>.from(orderData['executors']),
            selectedItemKey:
                selectedItem['firstname'], // используйте имя для отображения
            onSelected: (selectedName) {
              var executor = orderData['executors'].firstWhere(
                  (executor) => executor['firstname'] == selectedName,
                  orElse: () => null);
              if (executor != null) {
                setState(() {
                  selectedItem = executor;
                });
              }
            },
            displayValueKey: 'firstname',
            valueKey: 'firstname',
          ),
          const SizedBox(height: 5),
          CustomBtn(
            title: 'Put to work',
            onPressed: () => _putToWork(selectedItem['id']),
          ),
        ],
      ),
    );
  }
}
