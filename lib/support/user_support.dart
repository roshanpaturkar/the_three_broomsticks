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
            }),
          },
        );
  }
}
