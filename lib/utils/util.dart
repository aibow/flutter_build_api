/// 常用方法类
class ApiUtil {
  /// 转成字符串
  static String toStr(dynamic value, [String defValue = '', bool trim = true]) {
    if (value == null) {
      return defValue;
    }
    if (value is String) {
      return trim ? value.trim() : value;
    }
    try {
      value = value.toString();
      return trim ? value.trim() : value;
    } catch (e) {
      return defValue;
    }
  }

  /// 转成整数
  static int toInt(dynamic value, [int defValue = 0]) {
    if (value == null) {
      return defValue;
    }
    if (value is int) {
      return value;
    }
    if (value is num || value is double) {
      return value.toInt();
    }
    return int.tryParse(toStr(value)) ?? defValue;
  }

  /// 转成浮点
  static double toDouble(dynamic value, [double defValue = 0.0]) {
    if (value == null) {
      return defValue;
    }
    if (value is double) {
      return value;
    }
    if (value is num || value is int) {
      return value.toDouble();
    }
    return double.tryParse(toStr(value)) ?? defValue;
  }

  /// 转成布尔
  static bool toBool(dynamic value, [bool defValue = false]) {
    if (value == null) {
      return defValue;
    }
    if (value is bool) {
      return value;
    }
    return toStr(value, '') == 'on';
  }
}
