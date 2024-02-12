import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/client/components/balans.dart';
import 'package:flutter_application/client/pages/finances/screens/history_screen.dart';
import 'package:flutter_application/client/pages/finances/screens/receipts_screen.dart';

@RoutePage()
class FinancesScreen extends StatefulWidget {
  const FinancesScreen({Key? key}) : super(key: key);

  @override
  State<FinancesScreen> createState() => _FinancesScreenState();
}

class _FinancesScreenState extends State<FinancesScreen>
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(320.0),
        child: Column(
          children: [
            Container(
              color: Color(0xFF18232D),
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: AppBar(
                  title:
                      Text('Finances', style: TextStyle(color: Colors.white)),
                  elevation: 0,
                  backgroundColor: Color(0xFF18232D),
                  centerTitle: true,
                  leading: Container(
                    margin: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.2), // Прозрачный белый фон контейнера
                      borderRadius:
                          BorderRadius.circular(100), // Закругление углов
                    ),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/img/back.png',
                        width: 22,
                        height: 22,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: const Color(0xFF18232D),
              child: Column(children: <Widget>[
                Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 15, right: 15),
                    child: Row(
                      children: [
                        Text(
                          'SMART 17',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: const Padding(
                      padding: EdgeInsets.only(
                          top: 17, left: 15, right: 15, bottom: 20),
                      child: Balans(
                        text: 'Utility bills and additional services',
                        price: '3,696.13',
                        showPayButton: false,
                      )),
                ),
              ]),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: Column(
          children: [
            SizedBox(
              height: 46,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(7)),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000), // Цвет тени в формате ARGB
                          offset: Offset(1, 1), // Смещение тени
                          blurRadius: 10.0, // Радиус размытия
                        ),
                      ],
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor: Color(0xFF6C6770),
                    labelColor: Colors.black,
                    tabs: const [
                      Tab(text: 'Receipts'),
                      Tab(text: 'History'),
                    ],
                    labelPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  // Ваши компоненты для каждой вкладки
                  Center(child: ReceiptsScreen()),
                  Center(child: HistoryScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
