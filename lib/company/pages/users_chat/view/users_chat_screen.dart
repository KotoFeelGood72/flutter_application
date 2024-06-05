import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/components/bottom_admin_bar.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/widget/empty_state.dart';
import 'package:intl/intl.dart';

@RoutePage()
class UsersChatScreen extends StatefulWidget {
  const UsersChatScreen({super.key});

  @override
  State<UsersChatScreen> createState() => _UsersChatScreenState();
}

class _UsersChatScreenState extends State<UsersChatScreen> {
  List<Map<String, dynamic>> _rooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('rooms').get();
      List<Map<String, dynamic>> rooms =
          await Future.wait(snapshot.docs.map((doc) async {
        var roomData = doc.data() as Map<String, dynamic>;
        var messagesSnapshot = await FirebaseFirestore.instance
            .collection('rooms')
            .doc(doc.id)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .get();
        int unreadCount = messagesSnapshot.docs
            .where((message) =>
                message['isRead'] == false &&
                message['from'] != FirebaseAuth.instance.currentUser?.uid)
            .length;
        var lastMessageDoc = messagesSnapshot.docs.isNotEmpty
            ? messagesSnapshot.docs.first
            : null;
        var lastMessage = lastMessageDoc != null
            ? lastMessageDoc['timestamp'] as Timestamp
            : null;
        var lastMessageText = 'No messages yet';

        if (lastMessageDoc != null) {
          if (lastMessageDoc['imageUrl'] != null) {
            lastMessageText = 'send is image';
          } else {
            lastMessageText = lastMessageDoc['text'] ?? 'Image message...';
          }
        }

        if (lastMessageText.length > 30) {
          lastMessageText = '${lastMessageText.substring(0, 30)}...';
        }

        return {
          'id': doc.id,
          ...roomData,
          'lastMessage': lastMessage,
          'lastMessageText': lastMessageText,
          'unreadCount': unreadCount
        };
      }).toList());

      setState(() {
        _rooms = rooms;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading rooms: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> getUserRole() async {
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
    String? userRole = await getUserRole();

    if (userRole != null) {
      switch (userRole) {
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
          context.router.pop();
      }
    } else {
      context.router.pop();
    }
  }

  Future<void> _handleChatTap(String roomId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final roomDoc =
          FirebaseFirestore.instance.collection('rooms').doc(roomId);
      final roomSnapshot = await roomDoc.get();

      if (roomSnapshot.exists) {
        final roomData = roomSnapshot.data() as Map<String, dynamic>;
        List<String> userIds = List<String>.from(roomData['user_id'] ?? []);

        if (!userIds.contains(user.uid)) {
          userIds.add(user.uid);
          await roomDoc.update({'user_id': userIds});
        }
      }

      AutoRouter.of(context).push(AdminChatRoute(id: roomId));
    } catch (e) {
      print("Error handling chat tap: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color(0xFF242E38),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            margin: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTap: () => _navigateBack(context),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[200]!.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Chats',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 36),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _rooms.isEmpty
                    ? const EmptyState(title: 'Empty chats', text: '')
                    : ListView.builder(
                        itemCount: _rooms.length,
                        itemBuilder: (context, index) {
                          final room = _rooms[index];
                          var lastMessageTime = room['lastMessage'] != null
                              ? DateFormat.Hm().format(
                                  (room['lastMessage'] as Timestamp).toDate())
                              : '';
                          int unreadCount = room['unreadCount'] ?? 0;

                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              border: index != _rooms.length - 1
                                  ? Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    )
                                  : null,
                            ),
                            child: InkWell(
                              onTap: () {
                                _handleChatTap(room['id']);
                              },
                              child: ListTile(
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                leading: Image.asset('assets/img/chat.png'),
                                title: Text(
                                  room['apartmentName'] ?? 'No Name',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(room['lastMessageText'] ??
                                    'No latest text message'),
                                trailing: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(lastMessageTime),
                                    if (unreadCount > 0)
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFBE6161),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          unreadCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomAdminBar(),
    );
  }
}
