import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/client/pages/inquires/components/inq_services.dart';
import 'package:flutter_application/company/components/item_status.dart';
import 'package:flutter_application/company/components/uk_dropdown.dart';
import 'package:flutter_application/company/modal/message/success_modal.dart';
import 'package:flutter_application/components/ui/custom_btn.dart';
import 'package:flutter_application/components/ui/uk_text_field.dart';
import 'package:flutter_application/models/Orders.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientOrderModal extends StatefulWidget {
  final int id;
  final int appartmentId;
  const ClientOrderModal(
      {super.key, required this.id, required this.appartmentId});

  @override
  State<ClientOrderModal> createState() => _ClientOrderModalState();
}

class _ClientOrderModalState extends State<ClientOrderModal> {
  SingleOrder? orderData;
  bool isLoading = true;
  String? chatRoomId;

  @override
  void initState() {
    super.initState();
    _getOrderId();
  }

  void _showSuccessMessage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const SuccessModal(
            message: "The order has been successfully added in progress");
      },
    );
  }

  Future<void> _getOrderId() async {
    try {
      final response =
          await DioSingleton().dio.get('client/get_orders/${widget.id}');
      if (mounted) {
        setState(() {
          orderData = SingleOrder.fromJson(response.data);
          isLoading = false;
        });
      }

      print('Appartment ID from widget: ${widget.appartmentId}');
      // После получения данных о заказе, ищем комнату чата
      _getChatRoomId(widget.appartmentId);
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _getChatRoomId(int appartmentId) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('rooms').get();

      for (var doc in querySnapshot.docs) {
        print('${doc['apartmentId']} Good apparta');
        if (doc['apartmentId'] == appartmentId) {
          print('Found document with appartmentId: ${doc['apartmentId']}');
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
      // Обработка ошибок
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
          height: 300, child: const Center(child: CircularProgressIndicator()));
    }
    if (orderData == null) {
      return Container(
        height: 300,
        child: const Center(child: Text('No data available')),
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
              orderData!.createdAt ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 6),
            child: Text(
              orderData!.serviceName,
              style: const TextStyle(color: Color(0xFFA5A5A7), fontSize: 12),
            ),
          ),
          Container(
            width: 88,
            height: 88,
            margin: const EdgeInsets.only(bottom: 10),
            child: (orderData!.iconPath.isNotEmpty)
                ? Image.network(
                    orderData!.iconPath,
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
                  '№ ${orderData!.id}',
                  style:
                      const TextStyle(color: Color(0xFFA5A5A7), fontSize: 12),
                ),
                const SizedBox(height: 5),
                Text(
                  orderData!.appartamentName,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Wrap(
            children: [
              ItemStatus(status: orderData!.status),
            ],
          ),
          const SizedBox(height: 10),
          if (orderData!.additionalInfo.additionalServiceList.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: orderData!.additionalInfo.additionalServiceList
                    .map<Widget>((service) => Text(service.toString()))
                    .toList(),
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
                  hint: orderData!.completionDate,
                  isDateField: true,
                  enabled: false,
                  suffixIcon: const Icon(Icons.date_range),
                ),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: UkTextField(
                  hint: orderData!.completedAt,
                  isTimeField: true,
                  enabled: false,
                  suffixIcon: const Icon(Icons.access_time),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (chatRoomId != null)
            CustomBtn(
              title: 'Go to chat',
              onPressed: () {
                AutoRouter.of(context).push(AdminChatRoute(id: chatRoomId!));
              },
            )
          else
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Chat room not found',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
