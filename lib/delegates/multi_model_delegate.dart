import '../models/base_model.dart';
import 'base_delegate.dart';

/// 列表代理解析
class MultiModelDelegate<T extends BaseModel> extends BaseDelegate<List<T>> {
  T model;

  MultiModelDelegate({this.model}) : assert(model != null);

  List<T> fromJson(dynamic json) {
    if (json is! List) {
      return [];
    }
    return json.map<T>((item) {
      return model.fromJson(item) as T;
    }).toList();
  }
}
