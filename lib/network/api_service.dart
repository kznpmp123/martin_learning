import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  static Dio getApiHandler(String token) {
    BaseOptions options = BaseOptions(
      // baseUrl: "http://54.255.18.148/marthin/public/api/v1/",
      // baseUrl: "http://52.47.68.101/marthin/public/api/v1/",
      baseUrl: "http://10.0.2.2:8000/api/v1/",
      // baseUrl: "http://192.168.98.174/learning-app-backend/public/api/v1/",
      //baseUrl: "http://yourlink.mar-thin.com/api/v1/",
      // http://192.168.98.174/
    );


 options.headers["Authorization"] = "Bearer $token";


    options.headers["Accept"] = "application/json";

    Dio dio = Dio(options);
    dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      )
    ]);

    return dio;
  }
}
