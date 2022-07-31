import 'package:flutter/material.dart';
import 'package:optimize/models/greeting.dart';
import 'package:optimize/network/greeting_service.dart';

class GreetingProvider with ChangeNotifier {
  List<Greeting> items = [];

  Future<void> getAll() async {
    items.clear();
    var response = await GreetingService.getAll();
    for (int i = 0; i < response["data"].length; i++) {
      items.add(Greeting(
        id: response["data"][i]["id"],
        title: response["data"][i]["title"] ?? "",
        body: response["data"][i]["body"] ?? "",
      ));
    }
    notifyListeners();
  }
}
