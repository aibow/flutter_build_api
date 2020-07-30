import 'base_delegate.dart';

/// 返回内容为空代理解析
class EmptyDelegate extends BaseDelegate<dynamic> {
  dynamic fromJson(dynamic json) {
    return null;
  }
}
