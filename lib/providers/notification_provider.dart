import 'package:flutter/material.dart';
import 'package:optimize/models/Noti.dart';
import 'package:optimize/network/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  List<Noti> items = [];

  Future<void> getAll() async {
    items.clear();
    var response = await NotiService.getAll();
    for (int i = 0; i < response["data"].length; i++) {
      items.add(Noti(
        id: response["data"][i]["id"],
        title: response["data"][i]["title"] ?? "",
        body: response["data"][i]["body"] ?? "",
        image: response["data"][i]["image"] ?? "",
      ));
    }
    notifyListeners();
  }
}
