import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class UserSupport {
  static Future<void> refreshUserDetails() async {
    final box = GetStorage();

    var uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get()
        .then(
          (value) => {
            value.docs.forEach((element) {
              box.write('docId', element.id);
              box.write('uid', element.data()['uid']);
              box.write('userAccessControl', element.get('userAccessControl'));
              box.write('disable', element.get('disable'));
              box.write('fName', element.get('firstName'));
              box.write('lName', element.get('lastName'));
              box.write('email', element.get('email'));
              box.write('mobile', element.get('mobile'));
              box.write('imageUrl', element.get('imageUrl'));
              box.write('nickname', element.get('nickname'));
              box.write('house', element.get('house'));
              box.write('verified', element.get('verified'));
              box.write('userAccessControl', element.get('userAccessControl'));
            }),
          },
        );
    print('User details refreshed!');
  }

  static Future<void> updateUserDetails(var usedDetails) async {
    var uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get()
        .then(
          (value) => {
            value.docs.forEach((element) async {
              CollectionReference users =
                  FirebaseFirestore.instance.collection('users');

              await users
                  .doc(element.id)
                  .update(usedDetails)
                  .then((value) => print('User details updated!'))
                  .catchError((error) => print("Failed to add user: $error"));
            }),
          },
        );

    refreshUserDetails();
  }

  static Future<void> updateUserData(var docId, var userDetails) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .update(userDetails)
        .then((value) => print('User details updated!'))
        .catchError((error) => print("Failed to add user: $error"));

    refreshUserDetails();
  }

  static void addUserGroup(bool status, var user) async {
    if (status) {
      await FirebaseFirestore.instance
          .collection('customRoomHead')
          .doc('ZuyBq82quuQhQgpQX6oj')
          .update({
        'audience': FieldValue.arrayUnion([user['uid']])
      });

      await FirebaseFirestore.instance
          .collection('commonRoomChatHeads')
          .doc(user['house'].toString().toLowerCase())
          .update({
        'users': FieldValue.arrayUnion([user['uid']])
      });
    } else {
      await FirebaseFirestore.instance
          .collection('customRoomHead')
          .doc('ZuyBq82quuQhQgpQX6oj')
          .update({
        'audience': FieldValue.arrayRemove([user['uid']])
      });

      await FirebaseFirestore.instance
          .collection('commonRoomChatHeads')
          .doc(user['house'].toString().toLowerCase())
          .update({
        'users': FieldValue.arrayRemove([user['uid']])
      });
    }
  }
}
