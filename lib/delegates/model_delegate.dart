import 'base_delegate.dart';
import '../models/base_model.dart';

/// 列表代理解析
class ModelDelegate<T extends BaseModel> extends BaseDelegate<T> {
  T model;

  ModelDelegate({this.model}) : assert(model != null);

  T fromJson(dynamic json) {
    if (json is! Map) {
      return model;
    }
    return model.fromJson(json);
  }
}
