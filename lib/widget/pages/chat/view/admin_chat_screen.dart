import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application/widget/pages/chat/components/chat_header.dart';
import 'package:flutter_application/widget/pages/chat/components/chat_input.dart';
import 'package:flutter_application/widget/pages/chat/components/chat_message.dart';
import 'package:flutter_application/widget/pages/chat/components/upload_status.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

@RoutePage()
class AdminChatScreen extends StatefulWidget {
  final String id;

  const AdminChatScreen({super.key, required this.id});

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  UploadTask? _uploadTask;
  final ScrollController _scrollController = ScrollController();
  String apartmentName = '';
  Map<String, String> userNames = {}; // Store user names by their ID

  @override
  void initState() {
    super.initState();
    _fetchRoomDetails();
    _messageController.addListener(() {
      if (_messageController.text.isNotEmpty) {
        _scrollToBottom();
      }
    });
  }

  Future<void> _fetchRoomDetails() async {
    try {
      var roomDoc = await _firestore.collection('rooms').doc(widget.id).get();
      var roomData = roomDoc.data();
      if (roomData != null) {
        setState(() {
          apartmentName = roomData['apartmentName'] ?? 'Без названия';
        });

        List<String> userIds = List<String>.from(roomData['user_id'] ?? []);
        for (String userId in userIds) {
          if (userId != _auth.currentUser?.uid) {
            // Exclude current user
            var userDoc =
                await _firestore.collection('users').doc(userId).get();
            var userData = userDoc.data();
            if (userData != null) {
              setState(() {
                String fullName =
                    '${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}'
                        .trim();
                if (fullName.isEmpty) {
                  fullName = userData['name'] ?? 'Unknown';
                }
                userNames[userId] = fullName;
              });
            }
          }
        }
      }
    } catch (e) {
      print('Ошибка при получении данных о комнате: $e');
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage({String? imageUrl}) async {
    try {
      if (_messageController.text.isNotEmpty || imageUrl != null) {
        await _firestore
            .collection('rooms')
            .doc(widget.id)
            .collection('messages')
            .add({
          'text': _messageController.text,
          'from': _auth.currentUser?.uid,
          'sender_id': _auth.currentUser?.uid, // Добавлено поле sender_id
          'timestamp': FieldValue.serverTimestamp(),
          'imageUrl': imageUrl ?? '',
          'isRead': false,
        });
        _messageController.clear();
        FocusScope.of(context).unfocus();
        _scrollToBottom();
      }
    } catch (e) {
      print('Ошибка при отправке сообщения: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Неизвестно';
    }
    var date = timestamp.toDate();
    return DateFormat.Hm().format(date);
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef =
            FirebaseStorage.instance.ref().child('chat_images').child(fileName);

        setState(() {
          _uploadTask = storageRef.putFile(imageFile);
        });

        TaskSnapshot taskSnapshot = await _uploadTask!;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        _sendMessage(imageUrl: imageUrl);

        setState(() {
          _uploadTask = null;
        });
      }
    } catch (e) {
      print('Ошибка при выборе изображения: $e');
    }
  }

  void markMessageAsRead(DocumentSnapshot message) {
    final messageData = message.data() as Map<String, dynamic>?;
    if (message.exists &&
        messageData != null &&
        messageData.containsKey('isRead') &&
        !messageData['isRead'] &&
        messageData['from'] != _auth.currentUser?.uid) {
      _firestore
          .collection('rooms')
          .doc(widget.id)
          .collection('messages')
          .doc(message.id)
          .update({'isRead': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              ChatHeader(apartmentName: apartmentName, userNames: userNames),
              Expanded(
                child: Stack(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('rooms')
                          .doc(widget.id)
                          .collection('messages')
                          .orderBy('timestamp', descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        var messages = snapshot.data!.docs;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToBottom();
                        });
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          controller: _scrollController,
                          reverse: false,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            var message = messages[index];
                            var messageData =
                                message.data() as Map<String, dynamic>;
                            var isMe =
                                messageData['from'] == _auth.currentUser?.uid;
                            var isRead = messageData.containsKey('isRead') &&
                                messageData['isRead'];
                            var timestamp =
                                _formatTimestamp(messageData['timestamp']);
                            var text = messageData['text'] ?? '';

                            markMessageAsRead(message);

                            return ChatMessage(
                              isMe: isMe,
                              text: text,
                              timestamp: timestamp,
                              isRead: isRead,
                              imageUrl: messageData['imageUrl'],
                            );
                          },
                        );
                      },
                    ),
                    if (_uploadTask != null) UploadStatus(task: _uploadTask!),
                  ],
                ),
              ),
              ChatInput(
                messageController: _messageController,
                onSendMessage: _sendMessage,
                onPickImage: _pickImage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
