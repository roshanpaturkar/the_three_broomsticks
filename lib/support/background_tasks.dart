import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:the_three_broomsticks/screens/lock_screen.dart';
import 'package:the_three_broomsticks/screens/login_screen.dart';
import 'package:the_three_broomsticks/support/notification_support.dart';
import 'package:the_three_broomsticks/support/support.dart';
import 'package:the_three_broomsticks/versions/app_versions.dart';

class BackgroundTasks {
  final box = GetStorage();

  void checkSecuritySetting() {
    print('Checking security setting!');
  }

  void checkUserDataChanges() {
    print('Checking user data!');
    final docRef =
        FirebaseFirestore.instance.collection("users").doc(box.read('docId'));
    docRef.snapshots().listen(
      (event) {
        var user = event.data();
        box.write('uid', user!['uid']);
        box.write('userAccessControl', user['userAccessControl']);
        box.write('disable', user['disable']);
        box.write('fName', user['firstName']);
        box.write('lName', user['lastName']);
        box.write('email', user['email']);
        box.write('mobile', user['mobile']);
        box.write('imageUrl', user['imageUrl']);
        box.write('nickname', user['nickname']);
        box.write('house', user['house']);
        box.write('verified', user['verified']);
        box.write('userAccessControl', user['userAccessControl']);

        if (!user['verified']) {
          Support.toast('Please contact admin for account verification!');
          FirebaseAuth.instance.signOut();
          Get.offAll(const LoginScreen());
        }
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  void checkAllowedVersions() {
    print('Check all allowed version service started!');
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('versionControl/allowedVersions');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      var versions = data.toString().split(',');

      if (!versions.contains(AppVersion.version)) {
        FirebaseAuth.instance.signOut();
        Get.offAll(const LockScreen(), arguments: [
          'Current App version is expired, update your app or contact App Admin!'
        ]);
      }
    });
  }

  void checkUpdates() {
    print('Check updated service started!');
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('versionControl/currentVersion');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      var version = data.toString();

      if (version != AppVersion.version) {
        Support.toast('App update is available!');
      }
    });
  }

  void updateTokens() async {
    NotificationSupport notification = NotificationSupport();
    if (GetPlatform.isAndroid) {
      var data = {
        'uid': box.read('uid'),
        'email': box.read('email'),
        'token': await FirebaseMessaging.instance.getToken(),
        'deviceId': await PlatformDeviceId.getDeviceId
      };
      notification.tokenRefresher(data);
    } else if (GetPlatform.isWeb) {
      var data = {
        'uid': box.read('uid'),
        'email': box.read('email'),
        'token': await FirebaseMessaging.instance.getToken(
            vapidKey:
                'BBB3rHpaF1Ej0B-65GK-pess3IlMSD0COmgJyBNEMLvC41E4anQkQvq35JnXY7onE-XLKDkLrDt46oWwcDIc6Yw'),
        'deviceId': await PlatformDeviceId.getDeviceId,
        'isWeb': true
      };
      notification.tokenRefresher(data);
    }
  }

  void backgroundTasks() {
    checkUserDataChanges();
    checkAllowedVersions();
    checkUpdates();
    updateTokens();
  }
}
