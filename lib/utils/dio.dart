import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import 'option.dart';

/// 网络实例
class DioManager {
  /// DIO静态变量
  static Dio _dio;

  /// 获取DIO实例
  static Dio get dio {
    if (_dio == null) {
      _();
    }
    return _dio;
  }

  /// 初始化DIO
  static void _() {
    _dio?.close();
    _dio = Dio();
    dio.options.connectTimeout =
        ApiOptionManager.option.connectTimeout.inMilliseconds;
    dio.options.receiveTimeout =
        ApiOptionManager.option.receiveTimeout.inMilliseconds;
    dio.options.sendTimeout =
        ApiOptionManager.option.sendTimeout.inMilliseconds;
    dio.options.contentType = ApiOptionManager.option.contentType;
    // 网络代理
    String host = ApiOptionManager.option.proxyHost;
    String port = ApiOptionManager.option.proxyPort;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      if (ApiOptionManager.option.isProxy &&
          host.isNotEmpty &&
          port.isNotEmpty) {
        client.findProxy = (uri) {
          return "PROXY $host:$port";
        };
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      }
    };
    // 日志
    if (ApiOptionManager.option.logCallback != null) {
      dio.interceptors.add(LogInterceptor(
          requestHeader: ApiOptionManager.option.logRequestHeader,
          requestBody: ApiOptionManager.option.logRequestBody,
          responseHeader: ApiOptionManager.option.logResponseHeader,
          responseBody: ApiOptionManager.option.logResponseBody,
          error: true,
          logPrint: ApiOptionManager.option.logCallback));
    }
  }

  /// 重新初始化
  static void reInit() {
    _();
  }
}
