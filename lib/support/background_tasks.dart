import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:the_three_broomsticks/screens/lock_screen.dart';
import 'package:the_three_broomsticks/support/support.dart';
import 'package:the_three_broomsticks/versions/app_versions.dart';

class BackgroundTasks {
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

  void backgroundTasks() {
    checkAllowedVersions();
    checkUpdates();
  }
}
