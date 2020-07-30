import 'base_delegate.dart';
import 'value_delegate.dart';

/// 基础数据列表代理解析
class MultiValueDelegate<T> extends BaseDelegate<List<T>> {
  List<T> fromJson(dynamic json) {
    if (json is! List) {
      return [];
    }
    return json
        .map<T>((item) {
          return ValueDelegate<T>().fromJson(item);
        })
        .removeWhere((item) => item == null)
        .toList();
  }
}
