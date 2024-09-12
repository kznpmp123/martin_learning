import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class PlusOneService {
  static bool auth = true;

  static getAll(int isPlusOne) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .get('plus-ones?is_plus_one=' + isPlusOne.toString());
    return response.data;
  }

  static getEach(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .get('plus-ones/$id');
    return response.data;
  }

  static getAllF() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .get('plus-ones-featured');
    return response.data;
  }

  static markData(String type, int id, int value) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .post('mark-plus-ones/$id', data: {type: value});
    return response.data;
  }

  static getAllLikes() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .get('plus-one-likes');
    return response.data;
  }

  static getAllTips() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .get('plus-one-tips');
    return response.data;
  }

  static getAllBooks() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .get('plus-one-bookmarks');
    return response.data;
  }
}
