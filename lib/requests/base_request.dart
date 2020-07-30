import 'package:build_api/build_api.dart';
import 'package:dio/dio.dart';

import '../delegates/base_delegate.dart';
import '../utils/dio.dart';
import '../utils/exception.dart';

enum MethodType { head, get, post, put, delete, patch }

/// Request基础类
abstract class BaseRequest {
  /// API地址
  Future<String> buildUrl();

  /// URL请求参数
  Future<Map<String, dynamic>> buildQueryParameter() async {
    return null;
  }

  /// 请求内容体
  Future<Map<String, dynamic>> buildData() async {
    return null;
  }

  /// 上传文件字段
  Future<Map<String, String>> buildUploadFile() async {
    return null;
  }

  /// 请求头
  Future<Map<String, dynamic>> buildHeaders(
      Map<String, dynamic> queryParameter, Map<String, dynamic> data) async {
    return null;
  }

  /// 返回内容解析代理类
  BaseDelegate buildDelegate();

  /// 解析接口基本字段
  dynamic parseResponse(int statusCode, dynamic responseBody,
      Map<String, List<String>> responseHeaders);

  /// 失败重试条件
  bool retryIf(dynamic error) {
    if (error is ApiException) {
      return false;
    }
    if (error is DioError && error.type == DioErrorType.CANCEL) {
      return false;
    }
    return true;
  }

  /// 设置fetch方法请求类型
  MethodType buildMethodType() => MethodType.get;

  /// 自定义请求编码类型，为null采用公共配置类型
  String buildContentType() => null;

  /// 失败重试
  Future<T> _retry<T>(MethodType methodType, {RequestOption option}) async {
    int retry = option?.retry ?? ApiOptionManager.option.retry;
    if (retry <= 0) {
      return _load<T>(methodType, option: option);
    }
    for (int i = 0; i <= retry; i += 1) {
      try {
        return await _load<T>(methodType, option: option);
      } catch (e) {
        if (!retryIf(e) || i == retry) {
          rethrow;
        }
        continue;
      }
    }
    throw ApiException(message: 'retry error', code: -999);
  }

  /// 统一请求类
  Future<T> _load<T>(MethodType methodType, {RequestOption option}) async {
    // URL地址
    String url = await buildUrl();
    // URL请求参数
    Map<String, dynamic> queryParameter = await buildQueryParameter();
    // 请求内容体
    Map<String, dynamic> data = await buildData();
    // 请求头
    Map<String, dynamic> headers = await buildHeaders(queryParameter, data);
    // 文件上传
    if (methodType == MethodType.put || methodType == MethodType.post) {
      Map<String, String> uploadFile = await buildUploadFile();
      if (uploadFile != null) {
        data ??= {};
        data.addAll(uploadFile.map((name, path) {
          return MapEntry(name, MultipartFile.fromFileSync(path));
        }));
      }
    }
    // 请求配置
    Options options = Options(
        receiveTimeout: option?.timeout?.inMilliseconds,
        sendTimeout: option?.timeout?.inMilliseconds,
        headers: headers);
    // 发送请求
    Response response;
    switch (methodType) {
      case MethodType.get:
        response = await DioManager.dio
            .get(url, queryParameters: queryParameter, options: options);
        break;
      case MethodType.post:
        response = await DioManager.dio.post(url,
            queryParameters: queryParameter, data: data, options: options);
        break;
      case MethodType.put:
        response = await DioManager.dio.put(url,
            queryParameters: queryParameter, data: data, options: options);
        break;
      case MethodType.delete:
        response = await DioManager.dio.delete(url,
            queryParameters: queryParameter, data: data, options: options);
        break;
      case MethodType.head:
        response = await DioManager.dio.head(url,
            queryParameters: queryParameter, data: data, options: options);
        break;
      case MethodType.patch:
        response = await DioManager.dio.patch(url,
            queryParameters: queryParameter, data: data, options: options);
        break;
    }
    if (response == null) {
      throw ApiException(message: 'response invalid', code: -999);
    }
    dynamic jsonData = parseResponse(
        response?.statusCode, response?.data, response?.headers?.map);
    BaseDelegate delegate = buildDelegate();
    if (delegate == null) {
      return jsonData;
    }
    try {
      return delegate.fromJson(jsonData);
    } on ApiException catch (_) {
      rethrow;
    } catch (e) {
      throw ApiException(
          message: 'delegate parse error: ${e.toString()}', code: -999);
    }
  }

  /// GET请求
  Future<T> get<T>({RequestOption option}) async {
    return await _retry<T>(MethodType.get, option: option);
  }

  /// PUT请求
  Future<T> post<T>({RequestOption option}) async {
    return await _retry<T>(MethodType.post, option: option);
  }

  /// PUT请求
  Future<T> put<T>({RequestOption option}) async {
    return await _retry<T>(MethodType.put, option: option);
  }

  /// DELETE请求
  Future<T> delete<T>({RequestOption option}) async {
    return await _retry<T>(MethodType.delete, option: option);
  }

  /// HEAD请求
  Future<T> head<T>({RequestOption option}) async {
    return await _retry<T>(MethodType.head, option: option);
  }

  /// PATCH请求
  Future<T> patch<T>({RequestOption option}) async {
    return await _retry<T>(MethodType.patch, option: option);
  }

  /// 继承类指定请求
  Future<T> fetch<T>({RequestOption option}) async {
    return await _retry(buildMethodType(), option: option);
  }
}
