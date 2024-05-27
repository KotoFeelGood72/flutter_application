import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/client/bloc/client_bloc.dart';
import 'package:flutter_application/client/components/balans.dart';
import 'package:flutter_application/client/pages/finances/screens/history_screen.dart';
import 'package:flutter_application/client/pages/finances/screens/receipts_screen.dart';
import 'package:flutter_application/models/ClientUser.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class FinancesScreen extends StatefulWidget {
  const FinancesScreen({Key? key}) : super(key: key);

  @override
  State<FinancesScreen> createState() => _FinancesScreenState();
}

class _FinancesScreenState extends State<FinancesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ClientBloc _clientBloc;
  double balans = 0.0;
  ClientUser? user;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _tabController = TabController(length: 2, vsync: this);
    _clientBloc = BlocProvider.of<ClientBloc>(context);
    _clientBloc.add(ClientInfoUser());
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
      // ignore: avoid_print
      print("Ошибка при получении информации : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientBloc, ClientState>(
      builder: (context, state) {
        String apartmentName = '';
        if (state is ClientState &&
            state.userInfo != null &&
            state.activeApartment != null) {
          user = state.userInfo;
          apartmentName = state.activeApartment!.name;
        }
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
                      title: const Text('Finances',
                          style: TextStyle(color: Colors.white)),
                      elevation: 0,
                      backgroundColor: const Color(0xFF18232D),
                      centerTitle: true,
                      leading: Container(
                        margin: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
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
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 15, right: 15),
                      child: Row(
                        children: [
                          Text(
                            apartmentName,
                            style: const TextStyle(
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
                        price: user?.balance ?? 0.0, // Use null-aware operator
                        showPayButton: false,
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              left: 18,
              right: 18,
            ),
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
      },
    );
  }
}
