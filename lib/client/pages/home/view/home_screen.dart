import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/client/bloc/client_bloc.dart';
import 'package:flutter_application/client/components/access.dart';
import 'package:flutter_application/client/components/balans.dart';
import 'package:flutter_application/client/components/news.dart';
import 'package:flutter_application/client/components/requests.dart';
import 'package:flutter_application/client/modal/modal_order.dart';
import 'package:flutter_application/client/modal/components/select_objects.dart';
import 'package:flutter_application/client/ui/modal_burger.dart';
import 'package:flutter_application/components/ui/profile_avatar.dart';
import 'package:flutter_application/models/ClientUser.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool isLoading = true;
  bool hasUnreadNotifications = false;
  ClientUser? users;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _clientBloc = BlocProvider.of<ClientBloc>(context, listen: false);
    _clientBloc.add(ClientInfoLoad());
    _clientBloc.add(ClientInfoUser());
    _checkForUnreadNotifications();
  }

  Future<void> _checkForUnreadNotifications() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('user_id', isEqualTo: user!.uid)
          .where('is_view.client', isEqualTo: false)
          .get();

      setState(() {
        hasUnreadNotifications = querySnapshot.docs.isNotEmpty;
        print('hasUnreadNotifications: $hasUnreadNotifications');
        print('Number of unread notifications: ${querySnapshot.docs.length}');
        querySnapshot.docs.forEach((doc) {
          print(
              'Notification ID: ${doc.id}, is_view.client: ${doc['is_view']['client']}');
        });
      });
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }

  Future<void> _getUserInfo() async {
    try {
      final response = await DioSingleton().dio.get('client/profile');
      setState(() {
        balans = response.data['balance'] ?? 0.0;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
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

  Widget _getModalContent(String type) {
    final ClientState state = _clientBloc.state;
    final int apartmentId =
        state.activeApartment?.id ?? (users?.apartmentInfo[0]!.id ?? 1);

    switch (type) {
      case 'burger':
        return const ModalBurger();
      case 'order':
        return ModalOrder(
          id: apartmentId,
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
        String apartmentName = '';
        if (state is ClientState &&
            state.orders != null &&
            state.activeApartment != null &&
            state.userInfo != null) {
          apartmentName = state.activeApartment!.name;
          activeRequests = state.orders!.length;
          users = state.userInfo;
        }

        return SafeArea(
          child: Scaffold(
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      Container(
                        color: const Color(0xFF18232D),
                        child: Column(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const SelectObjects();
                                      },
                                    );
                                  },
                                  child: Container(
                                    child: Stack(
                                      alignment: Alignment.centerLeft,
                                      children: [
                                        Container(
                                          constraints: const BoxConstraints(
                                            maxWidth: 240,
                                          ),
                                          padding:
                                              const EdgeInsets.only(right: 30),
                                          child: Text(
                                            apartmentName,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                            maxLines: 2,
                                          ),
                                        ),
                                        Positioned(
                                          top: 9,
                                          right: 0,
                                          child: SizedBox(
                                            width: 11,
                                            height: 11,
                                            child: Image.asset(
                                              'assets/img/chevron-down.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Stack(
                                      children: [
                                        Text(hasUnreadNotifications.toString()),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.notifications,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                          iconSize: 30,
                                          onPressed: () {
                                            AutoRouter.of(context)
                                                .push(NotificationsRoute());
                                          },
                                        ),
                                        if (hasUnreadNotifications)
                                          Positioned(
                                            right: 11,
                                            top: 11,
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 8,
                                                minHeight: 8,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    ProfileAvatar(
                                      photoUrl: users?.photoPath ?? '',
                                      route: ProfileRoute(),
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
                                price: users?.balance ?? 0.0,
                                showPayButton: true,
                              )),
                          if (state is ClientState)
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
                      const Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: News(type: 'client'),
                      ),
                    ],
                  ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: const Color(0xFFF9F9F9),
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  backgroundColor: Colors.transparent,
                  icon: Icon(Icons.menu),
                  label: 'Menu',
                ),
                const BottomNavigationBarItem(
                  backgroundColor: Colors.transparent,
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Color(0xFFF9F9F9),
                  ),
                  label: 'Create a request',
                ),
                BottomNavigationBarItem(
                  backgroundColor: Colors.transparent,
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
          ),
        );
      },
    );
  }
}
