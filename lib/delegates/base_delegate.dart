/// 解析接口返回数据代理类
abstract class BaseDelegate<T> {
  /// 解析接口数据
  T fromJson(dynamic json);
}
