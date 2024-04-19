import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/client/components/balans.dart';
import 'package:flutter_application/client/pages/finances/screens/history_screen.dart';
import 'package:flutter_application/client/pages/finances/screens/receipts_screen.dart';
import 'package:flutter_application/service/dio_config.dart';

@RoutePage()
class FinancesScreen extends StatefulWidget {
  const FinancesScreen({Key? key}) : super(key: key);

  @override
  State<FinancesScreen> createState() => _FinancesScreenState();
}

class _FinancesScreenState extends State<FinancesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double balans = 0.0;

  @override
  void initState() {
    _getUserInfo();
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        balans = response.data['balance'] ?? 0.0;
      });
    } catch (e) {
      print("Ошибка при получении информации : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(320.0),
        child: Column(
          children: [
            Container(
              color: const Color(0xFF18232D),
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
                const Padding(
                  padding: EdgeInsets.only(top: 30, left: 15, right: 15),
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
                Padding(
                    padding: const EdgeInsets.only(
                        top: 17, left: 15, right: 15, bottom: 20),
                    child: Balans(
                      text: 'Utility bills and additional services',
                      price: balans,
                      showPayButton: false,
                    )),
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
