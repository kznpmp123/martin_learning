
import 'package:dio/dio.dart';

import 'api_service.dart';

class GreetingService {
  static getAll() async {
    Response response = await ApiService.getApiHandler("token")
        .get('greetings');
    return response.data;
  }
}
