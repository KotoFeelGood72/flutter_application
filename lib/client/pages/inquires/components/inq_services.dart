import 'package:flutter/material.dart';
import 'package:flutter_application/client/bloc/client_bloc.dart';
import 'package:flutter_application/client/modal/client_modal_order.dart';
import 'package:flutter_application/client/modal/modal_order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Order {
  final int id;
  final String name;
  final String iconPath;
  final String createdAt;
  final String status;
  final String selectedServices;
  final List<Map<String, dynamic>> additionalServices;

  Order({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.createdAt,
    required this.status,
    required this.selectedServices,
    required this.additionalServices,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['order_id'] as int,
      name: json['name'] as String,
      iconPath: json['icon_path'] as String? ?? '',
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
  const InqServices({super.key});

  @override
  State<InqServices> createState() => _InqServicesState();
}

class _InqServicesState extends State<InqServices> {
  late ClientBloc _clientBloc;
  int apartmentId = 0;

  @override
  void initState() {
    super.initState();
    _clientBloc = context.read<ClientBloc>();
    _clientBloc
        .add(ClientInfoUser()); // Ensure this event is added to get user info.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ClientBloc, ClientState>(
        builder: (context, state) {
          if (state is ClientState &&
              state.orders != null &&
              state.orders!.isNotEmpty) {
            apartmentId = state.activeApartment?.id ?? 0;
            return ListView.builder(
              itemCount: state.orders!.length,
              itemBuilder: (BuildContext context, int index) {
                Order order = state.orders![index];
                bool isLastItem = index == state.orders!.length - 1;
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
                    icons: order.iconPath,
                    id: order.id.toString(),
                    selected_services: order.selectedServices,
                    additionalServices: order.additionalServices,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        builder: (BuildContext context) {
                          return ClientOrderModal(
                              appartmentId: apartmentId, id: order.id);
                        },
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<ClientBloc, ClientState>(
        builder: (context, state) {
          int currentApartmentId = state.activeApartment?.id ?? 0;
          return TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return ModalOrder(
                    id: currentApartmentId,
                  );
                },
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF6873D1),
              padding: const EdgeInsets.only(
                  top: 15, left: 35, right: 35, bottom: 15),
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
          );
        },
      ),
    );
  }
}

class InqServiceItem extends StatelessWidget {
  const InqServiceItem({
    super.key,
    required this.title,
    required this.icons,
    required this.date,
    required this.additionalServices,
    required this.id,
    required this.status,
    required this.selected_services,
    this.onTap,
  });

  final VoidCallback? onTap;
  final String title;
  final String icons;
  final String date;
  final String status;
  final List<Map<String, dynamic>> additionalServices;
  final String selected_services;
  final String id;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 22),
              width: 42,
              height: 42,
              child: icons.isNotEmpty
                  ? Image.network(
                      icons,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/img/wrench.png');
                      },
                    )
                  : Image.asset('assets/img/wrench.png'),
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
                            title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
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
      case 'in progress':
        textColor = Colors.orange;
        break;
      case 'completed':
        textColor = Colors.white;
        break;
      case 'new':
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
        status,
        style: TextStyle(
            color: textColor, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}
