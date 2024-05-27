import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/client/bloc/client_bloc.dart';
import 'package:flutter_application/client/pages/inquires/components/app_services.dart';
import 'package:flutter_application/client/pages/inquires/components/com_services.dart';
import 'package:flutter_application/client/pages/inquires/components/inq_services.dart';
import 'package:flutter_application/service/dio_config.dart';

@RoutePage()
class InquiresScreen extends StatefulWidget {
  const InquiresScreen({Key? key}) : super(key: key);

  @override
  State<InquiresScreen> createState() => _InquiresScreenState();
}

class _InquiresScreenState extends State<InquiresScreen>
    with SingleTickerProviderStateMixin {
  Map<String?, dynamic> inq = {};
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _getUserInfo() async {
    try {
      final response = await DioSingleton().dio.get('client/profile');
      setState(() {
        inq = response.data;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Inquires',
          )),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 30),
        child: Column(
          children: [
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
                      Tab(text: 'Services'),
                      Tab(text: 'Complaints'),
                      Tab(text: 'Appreciations')
                    ],
                    labelPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: TabBarView(controller: _tabController, children: [
                  InqServices(),
                  const ComServices(),
                  const AppServices(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
