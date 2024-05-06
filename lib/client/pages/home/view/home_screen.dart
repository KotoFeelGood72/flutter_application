import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/client/bloc/client_bloc.dart';
import 'package:flutter_application/client/components/access.dart';
import 'package:flutter_application/client/components/balans.dart';
import 'package:flutter_application/client/components/news.dart';
import 'package:flutter_application/client/components/offers.dart';
import 'package:flutter_application/client/components/requests.dart';
import 'package:flutter_application/client/modal/ModalOrder.dart';
import 'package:flutter_application/client/modal/components/select_objects.dart';
import 'package:flutter_application/client/pages/inquires/components/inq_services.dart';
import 'package:flutter_application/client/ui/ModalBurger.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ClientBloc _clientBloc;
  List<NewsItem> homeNews = [];
  int _selectedIndex = 0;
  int ordersLength = 0;
  double balans = 0.0;
  Map<String?, dynamic> user = {};
  Map<String?, dynamic> inqServiceLength = {};

  @override
  void initState() {
    super.initState();
    _getInqServiceItems();
    _getUserInfo();
    _getOrderList();
    _clientBloc = BlocProvider.of<ClientBloc>(context, listen: false);
    _clientBloc.add(ClientInfoLoad());
  }

  void showModal(String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          child: _getModalContent(type),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        showModal('burger');
        break;
      case 1:
        showModal('order');
        break;
      case 2:
        context.router.push(const ContactsRoute());
        break;
      default:
        setState(() {
          _selectedIndex = index;
        });
        break;
    }
  }

  Future<void> _getInqServiceItems() async {
    try {
      final response = await DioSingleton().dio.get('client/get_orders');
      setState(() {
        inqServiceLength = response.data;
        ordersLength = inqServiceLength['orders']?.length ?? 0;
      });
    } catch (e) {
      // print("Ошибка при получении информации о заказе: $e");
    }
  }

  Future<void> _getUserInfo() async {
    try {
      final response = await DioSingleton().dio.get('client/profile');
      setState(() {
        user = response.data;
        balans = response.data['balance'] ?? 0.0;
      });
    } catch (e) {}
  }

  Future<void> _getOrderList() async {
    try {
      final response = await DioSingleton().dio.get('client/get_order_list');
    } catch (e) {}
  }

  Widget _getModalContent(String type) {
    switch (type) {
      case 'burger':
        return const ModalBurger();
      case 'order':
        return ModalOrder(
          id: user['apartment_info'][0]['id'] ?? 1,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientBloc, ClientState>(
      bloc: _clientBloc,
      builder: (context, state) {
        int activeRequests = 0;
        if (state is ClientDataLoaded) {
          activeRequests = state.orders.length;
          print('Count orders: ${activeRequests} ${state.orders.length}');
        }
        return Scaffold(
          body: ListView(
            children: [
              Container(
                color: const Color(0xFF18232D),
                child: Column(children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 71, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SelectObjects();
                              },
                            );
                          },
                          child: Container(
                            width: 200,
                            height: 30,
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                if (user != null &&
                                    user['apartment_info'] != null &&
                                    user['apartment_info'].isNotEmpty &&
                                    user['apartment_info'][0]['name'] != null)
                                  Container(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Text(
                                      user['apartment_info'][0]['name'] ??
                                          'Non appartment',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                Positioned(
                                  top: 12,
                                  right: 0,
                                  child: SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: Image.asset(
                                        'assets/img/chevron-down.png',
                                        fit: BoxFit.contain),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(
                                Icons.notifications,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              iconSize: 18,
                              onPressed: () {
                                AutoRouter.of(context)
                                    .push(const ClientNoteRoute());
                              },
                            ),
                            IconButton(
                              onPressed: () {
                                AutoRouter.of(context)
                                    .push(const ProfileRoute());
                              },
                              icon: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      const Color.fromARGB(20, 255, 255, 255),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(22, 255, 255, 255),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/img/user.png',
                                        width: 22,
                                        height: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 29, left: 15, right: 15, bottom: 10),
                      child: Balans(
                        text: 'You have unpaid bills',
                        price: balans,
                        showPayButton: true,
                      )),
                  if (state is ClientDataLoaded)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      child: Requests(
                        activeRequest: activeRequests,
                      ),
                    ),
                ]),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Access(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: News(),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Offers(),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0xFFF9F9F9),
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: 'Menu',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFFF9F9F9),
                ),
                label: 'Create a request',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/img/support.png'),
                label: 'Contact',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFF6873D1),
            onTap: _onItemTapped,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _onItemTapped(1),
            tooltip: 'Create a request',
            backgroundColor: const Color(0xFF6873D1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
