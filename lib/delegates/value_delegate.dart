import '../utils/util.dart';
import 'base_delegate.dart';

/// 基础数据类型代理解析
class ValueDelegate<T> extends BaseDelegate<T> {
  final T defaultValue;

  ValueDelegate({this.defaultValue});

  T fromJson(dynamic json) {
    T result;
    if (T == int) {
      result = ApiUtil.toInt(json, null) as T;
    } else if (T == double) {
      result = ApiUtil.toDouble(json, null) as T;
    } else if (T == String) {
      result = ApiUtil.toStr(json) as T;
    }
    if (result == null) {
      return defaultValue;
    }
    return result;
  }
}
