import 'package:dio/dio.dart';

import 'dio.dart';

typedef LogCallback = void Function(String);

/// Api Options
class ApiOptionManager {
  /// 配置类变量
  static ApiOption _option;

  /// 获取配置类，如果初始化则初始化
  static ApiOption get option {
    if (_option == null) {
      _();
    }
    return _option;
  }

  /// 初始化配置类
  static void _() {
    _option = ApiOption(
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 5),
        sendTimeout: Duration(seconds: 5),
        contentType: ApiOption.formUrlEncodedContentType,
        isProxy: false,
        proxyHost: '',
        proxyPort: '',
        logCallback: null,
        logRequestHeader: false,
        logRequestBody: true,
        logResponseHeader: true,
        logResponseBody: true,
        retry: 2);
  }

  /// 更新配置类
  static void updateOption(
      {Duration connectTimeout,
      Duration receiveTimeout,
      Duration sendTimeout,
      String contentType,
      bool isProxy,
      String proxyHost,
      String proxyPort,
      LogCallback logCallback,
      bool logRequestHeader,
      bool logRequestBody,
      bool logResponseHeader,
      bool logResponseBody,
      int retry}) {
    _option = ApiOption(
        connectTimeout: connectTimeout ?? option.connectTimeout,
        receiveTimeout: receiveTimeout ?? option.receiveTimeout,
        sendTimeout: sendTimeout ?? option.sendTimeout,
        contentType: contentType ?? option.contentType,
        isProxy: isProxy ?? option.isProxy,
        proxyHost: proxyHost ?? option.proxyHost,
        proxyPort: proxyPort ?? option.proxyPort,
        logCallback: logCallback ?? option.logCallback,
        logRequestHeader: logRequestHeader ?? option.logRequestHeader,
        logRequestBody: logRequestBody ?? option.logRequestBody,
        logResponseHeader: logResponseHeader ?? option.logResponseHeader,
        logResponseBody: logResponseBody ?? option.logResponseBody,
        retry: retry ?? option.retry);
    // 通知DioManager更新配置
    DioManager.reInit();
  }
}

/// 配置参数类
class ApiOption {
  /// JSON编码
  static const jsonContentType = Headers.jsonContentType;

  /// FORM编码
  static const formUrlEncodedContentType = Headers.formUrlEncodedContentType;

  /// 连接超时时间
  final Duration connectTimeout;

  /// 接收数据超时时间
  final Duration receiveTimeout;

  /// 发送数据超时时间
  final Duration sendTimeout;

  /// 网络请求参数编码类型
  final String contentType;

  /// 是否使用网络代理
  final bool isProxy;

  /// 网络代理地址
  final String proxyHost;

  /// 网络代理端口
  final String proxyPort;

  /// 日志打印函数
  final LogCallback logCallback;

  /// 是否打印请求头
  final bool logRequestHeader;

  /// 是否打印请求参数
  final bool logRequestBody;

  /// 是否打印返回头
  final bool logResponseHeader;

  /// 是否打印返回参数
  final bool logResponseBody;

  /// 请求失败重试次数（不包括第一次请求）
  final int retry;

  const ApiOption(
      {this.connectTimeout,
      this.receiveTimeout,
      this.sendTimeout,
      this.contentType,
      this.isProxy,
      this.proxyHost,
      this.proxyPort,
      this.logCallback,
      this.logRequestHeader,
      this.logResponseBody,
      this.logResponseHeader,
      this.logRequestBody,
      this.retry});
}

/// 请求方法自定义参数
class RequestOption {
  final Duration timeout;
  final int retry;

  RequestOption({this.timeout, this.retry});
}
