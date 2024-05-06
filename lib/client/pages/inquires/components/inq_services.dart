import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/client/bloc/client_bloc.dart';
import 'package:flutter_application/client/modal/ModalOrder.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Order {
  final int id;
  final String name;
  final String createdAt;
  final String status;
  final String selectedServices;
  final List<Map<String, dynamic>> additionalServices;

  Order({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.status,
    required this.selectedServices,
    required this.additionalServices,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['order_id'] as int,
      name: json['name'] as String,
      createdAt: json['created_at'] as String,
      status: json['status'] as String,
      selectedServices: json['selected_services'] as String,
      additionalServices: (json['additional_services'] as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
    );
  }
}

class InqServices extends StatefulWidget {
  final int id;
  const InqServices({super.key, required this.id});

  @override
  State<InqServices> createState() => _InqServicesState();
}

class _InqServicesState extends State<InqServices> {
  Map<String?, dynamic> inqServiceItems = {};
  void initState() {
    super.initState();
    _getInqServiceItems();
  }

  void printFormattedJson(dynamic json) {
    var prettyString = JsonEncoder.withIndent('  ').convert(json);
    print(prettyString);
  }

  Future<void> _getInqServiceItems() async {
    try {
      final response = await DioSingleton().dio.get('client/get_orders');
      setState(() {
        inqServiceItems = response.data;
      });
      printFormattedJson(inqServiceItems['orders']);
    } catch (e) {
      print("Ошибка при получении информации : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ClientBloc, ClientState>(
        builder: (context, state) {
          if (state is ClientDataLoaded) {
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (BuildContext context, int index) {
                Order order = state.orders[index];
                bool isLastItem = index == state.orders.length - 1;
                return Container(
                  decoration: BoxDecoration(
                    border: isLastItem
                        ? null
                        : Border(
                            bottom: BorderSide(
                                color: Colors.grey[300]!, width: 1.0)),
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: InqServiceItem(
                    title: order.name,
                    date: order.createdAt,
                    status: order.status,
                    id: order.id.toString(),
                    selected_services: order.selectedServices,
                    additionalServices: order.additionalServices,
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TextButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return ModalOrder(
                id: widget.id,
              );
            },
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: Color(0xFF6873D1),
          padding:
              const EdgeInsets.only(top: 15, left: 35, right: 35, bottom: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Text(
          'Create a request',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class InqServiceItem extends StatelessWidget {
  const InqServiceItem(
      {super.key,
      required this.title,
      required this.date,
      required this.additionalServices,
      required this.id,
      required this.status,
      required this.selected_services});

  final String title;
  final String date;
  final String status;
  final List<Map<String, dynamic>> additionalServices;

  final String selected_services;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 22),
            width: 42,
            height: 42,
            child: Image.asset('assets/img/wrench.png'),
          ),
          Expanded(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 220,
                          child: Text(
                            "$title",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )),
                      InqServiceChip(
                        status: status,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '№ $id',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFA5A5A7),
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        date,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFA5A5A7),
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
                Text(
                  selected_services,
                  style: const TextStyle(
                      color: Color(0xFF5F6A73), fontWeight: FontWeight.w500),
                ),
                ...additionalServices
                    .map((service) => Text("${service['name']}",
                        style: const TextStyle(
                            color: Color(0xFF5F6A73),
                            fontWeight: FontWeight.w500)))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InqServiceChip extends StatelessWidget {
  const InqServiceChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color textColor;

    switch (status) {
      case 'pending':
        textColor = Colors.orange;
        break;
      case 'completed':
        textColor = Colors.white;
        break;
      case 'processing':
        textColor = const Color(0xFF6873D1);
        break;
      case 'default':
      default:
        textColor = Colors.black;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toString().split('.').last,
        style: TextStyle(
            color: textColor, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}
