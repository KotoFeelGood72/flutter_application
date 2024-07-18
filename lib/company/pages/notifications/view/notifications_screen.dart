import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/client/modal/client_modal_order.dart';
import 'package:flutter_application/company/modal/ModalInfo/info_order_modal.dart';
import 'package:flutter_application/components/bottom_admin_bar.dart';
import 'package:flutter_application/models/NotificationModel.dart';
import 'package:flutter_application/service/dio_config.dart';
import 'package:flutter_application/widget/empty_state.dart';
import 'package:flutter_application/router/router.dart';

@RoutePage()
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> notifications = [];
  String? userRole;

  Future<String?> fetchUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        return doc.data()?['role'];
      }
    }
    return null;
  }

  void _navigateBack(BuildContext context) async {
    String? role = await fetchUserRole();

    if (role != null) {
      switch (role) {
        case 'client':
          AutoRouter.of(context).push(HomeRoute());
          break;
        case 'Company':
          AutoRouter.of(context).push(CompanyHomeMainRoute());
          break;
        case 'Employee':
          AutoRouter.of(context).push(EmployeHomeMainRoute());
          break;
        default:
          Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _getNotifications() async {
    try {
      var response;
      switch (userRole) {
        case 'client':
          response = await DioSingleton().dio.get('client/notifications');
          break;
        case 'Employee':
          response = await DioSingleton().dio.get('employee/notifications');
          break;
        case 'Company':
          response = await DioSingleton().dio.get('/notifications');
          break;
        default:
          return;
      }
      setState(() {
        notifications = List<NotificationModel>.from(
            response.data.map((item) => NotificationModel.fromJson(item)));
      });
    } catch (e) {
      print('Ошибка при получении уведомлений: $e');
    }
  }

  Future<void> navigateNotification(
    String type,
    String apartmentId,
    String id,
  ) async {
    String? role = await fetchUserRole();
    if (role != null) {
      switch (role) {
        case 'Company':
        case 'Employee':
          if (type == 'order') {
            // Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return InfoOrderModal(
                    id: int.parse(id), appartmentId: int.parse(apartmentId));
              },
            );
          } else if (type == 'news' && role == 'Employee') {
            AutoRouter.of(context).push(NewsRoute(id: int.parse(id), type: ''));
          }
          break;
        case 'client':
          if (type == 'order') {
            // Navigator.pop(context);
            print('Appartament $apartmentId');
            // showModalBottomSheet(
            //   context: context,
            //   isScrollControlled: true,
            //   builder: (BuildContext context) {
            //     return ClientOrderModal(
            //         id: int.parse(id), appartmentId: int.parse(apartmentId));
            //   },
            // );
          } else if (type == 'news') {
            // Navigator.pop(context);
            AutoRouter.of(context)
                .push(NewsRoute(id: int.parse(id), type: 'client'));
          }
          break;
        default:
          print('Неизвестная роль пользователя');
      }
    } else {
      print('Роль пользователя не найдена');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserRole().then((role) {
      setState(() {
        userRole = role;
      });
      if (userRole != null) {
        _getNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(13.0),
            child: InkWell(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () => _navigateBack(context),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 14,
                  ),
                ),
              ),
            ),
          ),
          title: const Text('Notification',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          centerTitle: true,
          elevation: 0,
        ),
        body: notifications.isEmpty
            ? const EmptyState(title: 'No notification', text: '')
            : ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  final isView = notification.isView;
                  return Column(
                    children: [
                      InkWell(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () => navigateNotification(
                          notification.type,
                          notification.apartmentId.toString(),
                          notification.contentId.toString(),
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Image.asset(
                                        'assets/img/notification.png',
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                      if (!isView)
                                        const Positioned(
                                          top: -3,
                                          right: -3,
                                          child: Icon(
                                            Icons.circle,
                                            color: Color(0xFFBE6161),
                                            size: 10,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notification.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          notification.createdAt,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      notification.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      ),
                      if (index < notifications.length - 1)
                        const Divider(thickness: 0.4),
                    ],
                  );
                },
              ),
        bottomNavigationBar: userRole == null || userRole == 'client'
            ? null
            : const BottomAdminBar(),
      ),
    );
  }
}
