import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class ChatRoomSupport {
  final firestore = FirebaseFirestore.instance;
  final box = GetStorage();

  void updateLastSeen(String headId, bool isCommonRoom) async {
    await firestore
        .collection(isCommonRoom ? 'commonRoomChatHeads' : 'customRoomHead')
        .doc(headId)
        .update({
      'lastSeen': FieldValue.arrayUnion([box.read('uid')])
    }).catchError((error) => print(error));
  }
}
