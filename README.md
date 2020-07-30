# build_api

一个简单易用的API框架

## Getting Started

修改`pubspec.ymal`添加库引用

```yaml
build_api: @latest version
```

定义model类，用于存放接口返回内容

```dart
import 'package:build_api/build_api.dart';

class HeaderModel extends BaseModel {
  final String customKey;

  HeaderModel({this.customKey = ''});

  @override
  fromJson(json) {
    if (json is! Map) {
      return this;
    }
    return HeaderModel(customKey: ApiUtil.toStr(json['Custom-Key']));
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'customKey': customKey,
    };
  }
}
```

定义request类，用于发起网络请求

```dart
import 'package:build_api/build_api.dart';

class CustomHeaderRequest extends BaseRequest {
  @override
  Future<String> buildUrl() async {
    return 'https://httpbin.org/get';
  }

  @override
  MethodType buildMethodType() {
    return MethodType.get;
  }

  @override
  BaseDelegate buildDelegate() {
    return ModelDelegate<HeaderModel>(model: HeaderModel());
  }

  @override
  Future<Map<String, dynamic>> buildHeaders(_, __) async {
    return {
      'Custom-Key': 'CustomValue',
    };
  }

  @override
  parseResponse(
      int statusCode, dynamic data, Map<String, List<String>> headers) {
    if (statusCode != 200 && statusCode != 201) {
      throw ApiException(
          message: 'invalid status code($statusCode)', code: 1000);
    }
    if (data is! Map) {
      throw ApiException(message: 'data invalid', code: 1000);
    }
    return data['headers'];
  }
}
```

在业务逻辑中发起API请求

```dart
HeaderModel headerData = await CustomHeaderRequest().get<HeaderModel>();
print(headerData);
```

更多使用方法请参考`example/lib/main.dart`文件
