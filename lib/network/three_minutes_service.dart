import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class ThreeMinutesService {

  static getAll() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .get('three-minutes');
    return response.data;
  }

  static getEach(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .get('three-minutes/$id');
    return response.data;
  }

  static getAllF() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .get('three-minutes-featured');
    return response.data;
  }

  static markData(String type, int id, int value) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .post('mark-three-minutes/$id', data: {type: value});
    return response.data;
  }

  static getAllLikes() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .get('three-minutes-likes');
    return response.data;
  }

  static getAllTips() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .get('three-minutes-tips');
    return response.data;
  }

  static getAllBooks() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .get('three-minutes-bookmarks');
    return response.data;
  }
}
