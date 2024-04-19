import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/ModalInfo/payment/paid_payment_screen.dart';
import 'package:flutter_application/company/modal/ModalInfo/payment/unpaid_payment_screen.dart';

class InfoPaymentModal extends StatefulWidget {
  final int id;
  const InfoPaymentModal({super.key, required this.id});

  @override
  State<InfoPaymentModal> createState() => _InfoPaymentModalState();
}

// Вот здесь правильное использование `with SingleTickerProviderStateMixin`
class _InfoPaymentModalState extends State<InfoPaymentModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      color: Colors.white,
      child: ListView(shrinkWrap: true, children: [
        ModalHeader(title: 'Payment history'),
        SizedBox(height: 20),
        SizedBox(
          height: 46,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(7)),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      offset: Offset(1, 1),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: const Color(0xFF6C6770),
                labelColor: Colors.black,
                tabs: const [
                  Tab(text: 'Paid'),
                  Tab(text: 'Unpaid'),
                ],
                labelPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        Container(
          height: 500,
          child: TabBarView(
            controller: _tabController,
            children: [
              Center(child: PaidPaymentScreen(id: widget.id)),
              Center(child: UnpaidPaymentScreen(id: widget.id)),
            ],
          ),
        ),
      ]),
    );
  }
}
