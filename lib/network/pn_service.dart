import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class PnService {
  static bool auth = true;

  static getAll() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response =
        await ApiService.getApiHandler(storedData['token']).get('pns');
    return response.data;
  }

  static getEach(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response =
        await ApiService.getApiHandler(storedData['token']).get('pns/$id');
    return response.data;
  }

  static getAllF() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response =
        await ApiService.getApiHandler(storedData['token']).get('pns-featured');
    return response.data;
  }

  static markData(String type, int id, int value) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .post('mark-pns/$id', data: {type: value});

    return response.data;
  }

  static getAllLikes() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response =
        await ApiService.getApiHandler(storedData['token']).get('pn-likes');
    return response.data;
  }

  static getAllTips() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response =
        await ApiService.getApiHandler(storedData['token']).get('pn-tips');
    return response.data;
  }

  static getAllBooks() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response =
        await ApiService.getApiHandler(storedData['token']).get('pn-bookmarks');
    return response.data;
  }

  static subscribeCourse(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .get('pn-subscription/' + id.toString());
    return response.data;
  }
}
