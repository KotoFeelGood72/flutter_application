import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getClients() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'client')
          .get();
      List<Map<String, dynamic>> users = snapshot.docs
          .map((doc) => {
                'uid': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
      return users;
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getRooms() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('rooms').get();
      List<Map<String, dynamic>> rooms = snapshot.docs
          .map((doc) => {
                'uid': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
      return rooms;
    } catch (e) {
      print('Error getting rooms: $e');
      return [];
    }
  }

  Future<void> createRoomsForClients() async {
    try {
      List<Map<String, dynamic>> clients = await getClients();
      for (var client in clients) {
        String clientId = client['uid'];

        // Check if room already exists
        QuerySnapshot existingRoom = await _firestore
            .collection('rooms')
            .where('clientId', isEqualTo: clientId)
            .get();

        if (existingRoom.docs.isEmpty) {
          // Create a new room
          await _firestore.collection('rooms').add({
            'clientId': clientId,
            'clientName': client['name'],
            'clientEmail': client['email'],
            'date': FieldValue.serverTimestamp(),
            // add other necessary fields
          });
        }
      }
    } catch (e) {
      print('Error creating rooms: $e');
    }
  }
}
