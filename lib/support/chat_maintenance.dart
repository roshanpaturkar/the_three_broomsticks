import 'package:firebase_database/firebase_database.dart';

class ChatMaintenance {
  final dbRef = FirebaseDatabase.instance.ref();
  void clearOldChat(String roomPath, List messages) {
    print('Expired message count: ${messages.length}');
    Map<String, Object> oldChats = {};
    messages.forEach((element) {
      oldChats['/rooms/$roomPath/$element'] = {};
    });
    dbRef.update(oldChats);
  }
}
