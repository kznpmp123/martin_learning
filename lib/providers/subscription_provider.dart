import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:optimize/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionProvider with ChangeNotifier {
  late String description;

  Future<void> getAll(String type, int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);
    Response response;
    if (type == "pn") {
      response = await ApiService.getApiHandler(storedData['token'])
          .get('pn-descriptions/$id');
      if (response.data["data"].length > 0) {
        description = response.data["data"][0]["description"];
      } else {
        description = "<p>You need to subscribe premium account</p>";
      }
    } else if (type == "101") {
      response = await ApiService.getApiHandler(storedData['token'])
          .get('one-zero-one-descriptions/$id');
      if (response.data["data"].length > 0) {
        description = response.data["data"][0]["description"];
      } else {
        description = "<p>You need to subscribe premium account</p";
      }
    }
  }
}
