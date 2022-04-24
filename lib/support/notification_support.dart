import 'dart:convert';

import 'package:http/http.dart' as http;

class NotificationSupport {
  void tokenRefresher(var data) async {
    var url = 'https://d3broomsticks-android-ns.deta.dev/v1/api/user/token';

    String body = json.encode(data);
    try {
      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: body);
      print('Token refresher response code: ${response.statusCode}');
    } on Exception catch (error) {
      print(error);
    }
  }

  void sendNotification(var data) async {
    var url =
        'https://d3broomsticks-android-ns.deta.dev/v1/api/notification/tokens';

    String body = json.encode(data);
    try {
      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: body);
      print('Notification status code: ${response.statusCode}');
    } on Exception catch (error) {
      print(error);
    }
  }
}
