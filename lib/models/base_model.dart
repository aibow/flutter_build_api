import 'dart:convert' show jsonEncode;

/// 抽象接口结构模型
abstract class BaseModel {
  /// 解析并填充数据
  fromJson(dynamic json);

  /// json method
  Map<String, dynamic> toJson();

  /// string method
  String toString() {
    return '${runtimeType.toString()}${jsonEncode(this)}';
  }
}
