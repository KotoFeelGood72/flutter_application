import 'package:flutter/material.dart';
import 'package:flutter_application/company/components/modal_header.dart';
import 'package:flutter_application/company/modal/service/service_completed.dart';
import 'package:flutter_application/company/modal/service/service_new.dart';
import 'package:flutter_application/company/modal/service/service_progress.dart';

class ServiceOrdersModal extends StatefulWidget {
  final int id;
  const ServiceOrdersModal({Key? key, required this.id}) : super(key: key);

  @override
  State<ServiceOrdersModal> createState() => _ServiceOrdersModalState();
}

class _ServiceOrdersModalState extends State<ServiceOrdersModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isNewServiceViewed = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void updateNewServiceViewStatus(bool isViewed) {
    setState(() {
      isNewServiceViewed = isViewed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 34),
      child: Column(
        children: [
          const ModalHeader(title: 'Service orders'),
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
                  dividerColor: Colors.transparent,
                  controller: _tabController,
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
                  tabs: [
                    Tab(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Text('New'),
                          if (!isNewServiceViewed)
                            Positioned(
                              left: -25,
                              top: 7.7,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFBE6161),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Tab(text: 'In progress'),
                    const Tab(text: 'Completed'),
                  ],
                  labelPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ServiceNew(
                    id: widget.id, updateIsView: updateNewServiceViewStatus),
                ServiceProgress(id: widget.id),
                ServiceCompleted(id: widget.id)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
