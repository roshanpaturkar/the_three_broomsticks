import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificationSupport {
  var baseUrl = GetPlatform.isWeb
      ? 'https://d3broomsticks-web-ns.deta.dev'
      : 'https://d3broomsticks-android-ns-270422.deta.dev';
  void tokenRefresher(var data) async {
    var url = '$baseUrl/v1/api/user/token';

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
    var url = '$baseUrl/v1/api/notification/tokens';

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
