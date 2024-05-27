import 'package:flutter/material.dart';
import 'package:flutter_application/client/bloc/client_bloc.dart';
import 'dart:math' as math;

import 'package:flutter_application/client/components/invoice_card.dart';
import 'package:flutter_application/models/ClientInvoices.dart';
import 'package:flutter_application/models/ClientUser.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/empty_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  late ClientBloc _clientBloc;
  bool _isListVisible = true;
  ClientUser? user;
  List<ClientInvoices> invoices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _clientBloc = BlocProvider.of<ClientBloc>(context);
    _clientBloc.add(ClientInfoUser());
    _getInvoices();
  }

  Future<void> _getInvoices() async {
    try {
      final response = await DioSingleton().dio.get('client/pay');
      setState(() {
        if (response.data != null) {
          invoices = (response.data['invoice_history'] as List)
              .map((e) => ClientInvoices.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        isLoading = false;
      });
    } catch (e) {
      print('Ошибка при получении информации о счетах: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientBloc, ClientState>(
      builder: (context, state) {
        if (state is ClientState && state.userInfo != null) {
          user = state.userInfo;
        }

        if (isLoading) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (invoices.isEmpty) {
          return Scaffold(
            body:
                EmptyState(title: 'No receipts', text: 'You have no receipts.'),
          );
        }

        return Scaffold(
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${user?.firstname ?? ""} ${user?.lastname ?? ""}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          _isListVisible = !_isListVisible;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xFFF5F5F5)),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 4, left: 15, right: 15),
                              child: Text(
                                "${user?.balance ?? 0} \$",
                                style: const TextStyle(
                                    color: Color(0xFF5D5D67),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Transform.rotate(
                            angle:
                                _isListVisible ? math.pi / 2 * 3 : math.pi / 2,
                            child: const Icon(Icons.chevron_left),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_isListVisible)
                Expanded(
                  child: ListView.builder(
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      return InvoiceComponent(
                        title: '${invoices[index].name} #${invoices[index].id}',
                        price: '${invoices[index].amount} \$',
                        icon: '${invoices[index].iconPath}',
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
