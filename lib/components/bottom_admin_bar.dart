import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application/router/router.dart';

class BottomAdminBar extends StatefulWidget {
  const BottomAdminBar({super.key});

  @override
  State<BottomAdminBar> createState() => _BottomAdminBarState();
}

class _BottomAdminBarState extends State<BottomAdminBar> {
  late final StackRouter _router;
  String _userRole = '';
  bool hasUnreadNotifications = false;
  bool hasUnreadChats = false;
  StreamSubscription<QuerySnapshot>? _notificationSubscription;
  StreamSubscription<QuerySnapshot>? _chatSubscription;
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _router = AutoRouter.of(context);
    _router.addListener(_onRouteChanged);
    _fetchUserRole();
    _checkUnreadNotifications();
    _checkUnreadChats();
    _subscribeToAuthChanges();
  }

  @override
  void dispose() {
    _router.removeListener(_onRouteChanged);
    _notificationSubscription?.cancel();
    _chatSubscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }

  void _onRouteChanged() {
    setState(() {});
  }

  Future<void> _fetchUserRole() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (mounted) {
        setState(() {
          _userRole = userDoc['role'];
        });
      }
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        _router.pushAndPopUntil(const NotificationsRoute(),
            predicate: (_) => false);
        break;
      case 1:
        if (_userRole == 'Company') {
          _router.pushAndPopUntil(const CompanyHomeMainRoute(),
              predicate: (_) => false);
        } else {
          _router.pushAndPopUntil(const EmployeHomeMainRoute(),
              predicate: (_) => false);
        }
        break;
      case 2:
        _router.pushAndPopUntil(const UsersChatRoute(),
            predicate: (_) => false);
        break;
    }
  }

  void _checkUnreadNotifications() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _notificationSubscription = FirebaseFirestore.instance
          .collection('notifications')
          .where('user_id', isEqualTo: user.uid)
          .where('is_view', isEqualTo: false)
          .snapshots()
          .listen((snapshot) {
        if (mounted) {
          setState(() {
            hasUnreadNotifications = snapshot.docs.isNotEmpty;
          });
        }
      }, onError: (error) {
        print('Error listening to notifications: $error');
      });
    } else {
      print('No user logged in. Cannot check for unread notifications.');
    }
  }

  void _checkUnreadChats() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _chatSubscription = FirebaseFirestore.instance
          .collection('rooms')
          .where('user_id', arrayContains: user.uid)
          .snapshots()
          .listen((snapshot) async {
        bool hasUnread = false;
        for (var doc in snapshot.docs) {
          var messagesSnapshot = await doc.reference
              .collection('messages')
              .where('isRead', isEqualTo: false)
              .get();

          for (var message in messagesSnapshot.docs) {
            if (message.data().containsKey('sender_id') &&
                message['sender_id'] != user.uid) {
              hasUnread = true;
              break;
            }
          }
          if (hasUnread) {
            break;
          }
        }
        if (mounted) {
          setState(() {
            hasUnreadChats = hasUnread;
          });
        }
      }, onError: (error) {
        print('Error listening to chats: $error');
      });
    } else {
      print('No user logged in. Cannot check for unread chats.');
    }
  }

  void _subscribeToAuthChanges() {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _notificationSubscription?.cancel();
        _chatSubscription?.cancel();
        print('User logged out. Cancelled subscriptions.');
      } else {
        print('User logged in. Checking for unread notifications and chats.');
        _checkUnreadNotifications();
        _checkUnreadChats();
      }
    });
  }

  bool _isRouteActive(String routeName) {
    return _router.current.name == routeName;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color.fromARGB(129, 221, 217, 217),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavItem(
            index: 0,
            icon: 'assets/img/note-menu.png',
            label: 'Notifications',
            hasNotificationDot: hasUnreadNotifications,
            isActive: _isRouteActive(NotificationsRoute.name),
          ),
          _buildNavItem(
            index: 1,
            icon: 'assets/img/home-menu.png',
            label: 'Main',
            isActive: _isRouteActive(CompanyHomeMainRoute.name) ||
                _isRouteActive(EmployeHomeMainRoute.name),
          ),
          _buildNavItem(
            index: 2,
            icon: 'assets/img/chat-menu.png',
            label: 'Chats',
            hasNotificationDot: hasUnreadChats,
            isActive: _isRouteActive(UsersChatRoute.name),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String icon,
    required String label,
    bool hasNotificationDot = false,
    bool isActive = false,
  }) {
    return Expanded(
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    width: 30,
                    height: 30,
                    child: Image.asset(icon),
                  ),
                ),
                if (hasNotificationDot)
                  Positioned(
                    top: 4,
                    right: 52,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
              ],
            ),
            Center(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? const Color(0xFF6873D1)
                      : const Color(0xFF878E92),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
