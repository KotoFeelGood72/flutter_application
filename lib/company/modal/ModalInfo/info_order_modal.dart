import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/company/bloc/company_bloc.dart';
import 'package:flutter_application/company/components/item_status.dart';
import 'package:flutter_application/company/components/uk_dropdown.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package

class InfoOrderModal extends StatefulWidget {
  final int id;
  final int appartmentId;

  const InfoOrderModal({
    Key? key,
    required this.id,
    required this.appartmentId,
  }) : super(key: key);

  @override
  State<InfoOrderModal> createState() => _InfoOrderModalState();
}

class _InfoOrderModalState extends State<InfoOrderModal> {
  late CompanyBloc _companyBloc;
  Map<String, dynamic> orderData = {};
  bool isLoading = true;
  Map<String, dynamic> selectedItem = {};
  String? dropdownValue;
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  String? chatRoomId; // New state variable to store chat room ID

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _companyBloc = context.read<CompanyBloc>();
    _getSingleOrder();
    _getChatRoomId(widget.appartmentId); // Call the method to get chat room ID
  }

  void _showSuccessMessage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const SuccessModal(
          message: "The order has been successfully added in progress",
        );
      },
    );
  }

  Future<void> _putToWork(int executorId) async {
    if (orderData['status'] == 'new') {
      try {
        final response = await DioSingleton().dio.post(
              'employee/apartments/apartment_info/${widget.appartmentId}/service_order/new/${widget.id}/to_work/$executorId',
            );
        Navigator.pop(context, true);
        _showSuccessMessage();
      } catch (e) {
        print("Ошибка при отправке на работу: $e");
      }
    } else {
      try {
        final response = await DioSingleton().dio.post(
              'employee/apartments/apartment_info/${widget.appartmentId}/service_order/progress/${widget.id}/to_work/$executorId',
            );
        Navigator.pop(context, true);
        _showSuccessMessage();
      } catch (e) {
        print("Ошибка при отправке на работу: $e");
      }
    }
  }

  Future<void> _completeToWork(int executorId) async {
    try {
      final response = await DioSingleton().dio.post(
            'employee/apartments/apartment_info/${widget.appartmentId}/service_order/progress/${widget.id}/completed',
          );
      Navigator.pop(context, true);
      _showSuccessMessage();
    } catch (e) {
      print("Ошибка при завершении работы: $e");
    }
  }

  Future<void> _getSingleOrder() async {
    try {
      final response = await DioSingleton().dio.get(
            'employee/apartments/apartment_info/${widget.appartmentId}/service_order/${widget.id}',
          );
      if (response.data != null) {
        _companyBloc.add(AppartamentsLoaded(widget.appartmentId));
        setState(() {
          orderData = response.data;
          isLoading = false;
          if (orderData['executor'].isNotEmpty) {
            selectedItem = orderData['executor'].firstWhere(
              (executor) => executor['active'] == true,
              orElse: () => orderData['executor'].first,
            );
            dropdownValue = selectedItem['id'].toString();
          }
        });
        setState(() {});
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getChatRoomId(int appartmentId) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('rooms').get();

      for (var doc in querySnapshot.docs) {
        if (doc['apartmentId'] == appartmentId) {
          if (mounted) {
            setState(() {
              chatRoomId = doc.id;
              print('Chat Room ID: $chatRoomId');
            });
          }
          return;
        }
      }
    } catch (e) {
      print('Error querying Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 700,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // bool isCompleted = true;
    bool isCompleted = orderData['status'] == 'completed';

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
              orderData['created_at']?.toString() ?? 'N/A',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 6),
            child: Text(
              orderData['service_name']?.toString() ?? 'N/A',
              style: const TextStyle(color: Color(0xFFA5A5A7), fontSize: 12),
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
                  '№ ${orderData['order_id']?.toString() ?? 'N/A'}',
                  style:
                      const TextStyle(color: Color(0xFFA5A5A7), fontSize: 12),
                ),
                const SizedBox(height: 5),
                Text(
                  orderData['apartment_name']?.toString() ?? 'N/A',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Wrap(
            children: [
              ItemStatus(status: orderData['status']?.toString() ?? 'N/A'),
            ],
          ),
          const SizedBox(height: 10),
          if (orderData['additional_info'] != null &&
              orderData['additional_info']['additional_service_list'] != null &&
              orderData['additional_info']['additional_service_list']
                  .isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.from(
                  orderData['additional_info']['additional_service_list']
                      .map<Widget>(
                    (service) => Text(service?.toString() ?? 'N/A'),
                  ),
                ),
              ),
            ),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: const Text(
              'Execution time',
              style: TextStyle(
                  color: Color(0xFF5F6A73),
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: UkTextField(
                  controller: dateController,
                  hint: orderData['completion_date']?.toString() ?? 'N/A',
                  isDateField: true,
                  suffixIcon: const Icon(Icons.date_range),
                  enabled: !isCompleted,
                ),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: UkTextField(
                  controller: timeController,
                  hint: orderData['completed_at']?.toString() ?? 'N/A',
                  isTimeField: true,
                  suffixIcon: const Icon(Icons.access_time),
                  enabled: !isCompleted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (chatRoomId != null)
            CustomBtn(
              title: 'Go to the chat',
              onPressed: () {
                AutoRouter.of(context).push(AdminChatRoute(id: chatRoomId!));
              },
              color: const Color(0xFF878E92),
            ),
          const SizedBox(height: 12),
          const Text(
            'Executor',
            style: TextStyle(
                color: Color(0xFF5F6A73),
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          UkDropdown(
            isEnabled: isCompleted ? false : true,
            itemsList:
                List<Map<String, dynamic>>.from(orderData['executor'] ?? []),
            selectedItemKey: dropdownValue,
            onSelected: (selectedId) {
              var executor = orderData['executor'].firstWhere(
                (staff) => staff['id'].toString() == selectedId,
                orElse: () => {},
              );
              setState(() {
                selectedItem = executor;
                dropdownValue = selectedId;
              });
            },
            displayValueKey: 'first_name',
            valueKey: 'id',
          ),
          const SizedBox(height: 5),
          if (orderData['status'] == 'new')
            CustomBtn(
              title: 'Put to work',
              onPressed: () => _putToWork(selectedItem['id']),
            ),
          if (orderData['status'] == 'in progress')
            CustomBtn(
              title: 'Completed',
              onPressed: () => _completeToWork(selectedItem['id']),
            ),
        ],
      ),
    );
  }
}
