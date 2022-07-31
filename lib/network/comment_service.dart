import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class CommentService {
  static bool auth = true;

  static getAll(String path, int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);

    Response response = await ApiService.getApiHandler(storedData['token'])
        .get('$path/comments/$id');
    return response.data;
  }

  static postComment(String path, Map<String, String> data, int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);
    try {
      Response response = await ApiService.getApiHandler(storedData['token'])
          .post("$path/comments/$id", data: data);
      return response.data;
    } on DioError catch (e) {
      throw e.response!.data.toString();
    }
  }

  static deleteComment(String path, int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    final storedData = json.decode(token!);
    try {
      Response response = await ApiService.getApiHandler(storedData['token'])
          .delete("$path/comments/$id");
      return response.statusCode;
    } on DioError catch (e) {
      throw e.response!.data.toString();
    }
  }
}
