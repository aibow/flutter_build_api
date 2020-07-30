import 'package:build_api/build_api.dart';

class HeadModel extends BaseModel {
  final bool isExists;

  HeadModel({this.isExists = false});

  @override
  fromJson(json) {
    if (json is! Map) {
      return this;
    }
    return HeadModel(isExists: json['isExists'] ?? false);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'isExists': isExists};
  }
}

class HeadRequest extends BaseRequest {
  @override
  Future<String> buildUrl() async {
    return 'https://jsonplaceholder.typicode.com/posts';
  }

  @override
  Future<Map<String, dynamic>> buildQueryParameter() async {
    return {
      '_start': 0,
      '_limit': 10,
    };
  }

  @override
  BaseDelegate buildDelegate() {
    return ModelDelegate<HeadModel>(model: HeadModel());
  }

  @override
  parseResponse(int statusCode, _, __) {
    return {'isExists': statusCode == 200};
  }
}

class DataModel extends BaseModel {
  final int userId;
  final int id;
  final String title;
  final String body;

  DataModel({this.userId = 0, this.id = 0, this.title = '', this.body = ''});

  @override
  fromJson(json) {
    if (json is! Map) {
      return this;
    }
    return DataModel(
        userId: ApiUtil.toInt(json['userId']),
        id: ApiUtil.toInt(json['id']),
        title: ApiUtil.toStr(json['title']),
        body: ApiUtil.toStr(json['body']));
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }
}

class SingleDataRequest extends BaseRequest {
  final int id;
  SingleDataRequest({this.id}) : assert(id != null);

  @override
  Future<String> buildUrl() async =>
      'https://jsonplaceholder.typicode.com/posts/$id';

  @override
  BaseDelegate buildDelegate() {
    return ModelDelegate<DataModel>(model: DataModel());
  }

  @override
  dynamic parseResponse(int statusCode, dynamic data, _) {
    if (statusCode != 200 && statusCode != 201) {
      throw ApiException(
          message: 'invalid status code($statusCode)', code: 1000);
    }
    return data;
  }
}

class MultiDataRequest extends BaseRequest {
  final int start;
  final int size;

  MultiDataRequest({this.start, this.size})
      : assert(start != null),
        assert(size != null);

  @override
  Future<String> buildUrl() async =>
      'https://jsonplaceholder.typicode.com/posts';

  @override
  Future<Map<String, dynamic>> buildQueryParameter() async {
    return {
      '_start': start ?? 0,
      '_limit': size ?? 10,
    };
  }

  @override
  BaseDelegate buildDelegate() {
    return MultiModelDelegate<DataModel>(model: DataModel());
  }

  @override
  dynamic parseResponse(int statusCode, dynamic data, _) {
    if (statusCode != 200 && statusCode != 201) {
      throw ApiException(
          message: 'invalid status code($statusCode)', code: 1000);
    }
    return data;
  }
}

class PostRequest extends BaseRequest {
  @override
  Future<String> buildUrl() async {
    return 'https://jsonplaceholder.typicode.com/posts';
  }

  @override
  String buildContentType() {
    return ApiOption.jsonContentType;
  }

  @override
  MethodType buildMethodType() {
    return MethodType.post;
  }

  @override
  Future<Map<String, dynamic>> buildData() async {
    return {
      'title': 'title',
      'body': 'body',
      'userId': 1000,
    };
  }

  @override
  BaseDelegate buildDelegate() {
    return ModelDelegate<DataModel>(model: DataModel());
  }

  @override
  parseResponse(int statusCode, dynamic data, _) {
    if (statusCode != 200 && statusCode != 201) {
      throw ApiException(
          message: 'invalid status code($statusCode)', code: 1000);
    }
    return data;
  }
}

class PutRequest extends BaseRequest {
  final int id;

  PutRequest({this.id}) : assert(id != null);

  @override
  Future<String> buildUrl() async {
    return 'https://jsonplaceholder.typicode.com/posts/$id';
  }

  @override
  String buildContentType() {
    return ApiOption.jsonContentType;
  }

  @override
  MethodType buildMethodType() {
    return MethodType.put;
  }

  @override
  Future<Map<String, dynamic>> buildData() async {
    return {
      'title': 'title',
      'body': 'body',
      'userId': 1000,
    };
  }

  @override
  BaseDelegate buildDelegate() {
    return ModelDelegate<DataModel>(model: DataModel());
  }

  @override
  parseResponse(int statusCode, dynamic data, _) {
    if (statusCode != 200 && statusCode != 201) {
      throw ApiException(
          message: 'invalid status code($statusCode)', code: 1000);
    }
    return data;
  }
}

class DeleteRequest extends BaseRequest {
  final int id;

  DeleteRequest({this.id}) : assert(id != null);

  @override
  Future<String> buildUrl() async {
    return 'https://jsonplaceholder.typicode.com/posts/$id';
  }

  @override
  String buildContentType() {
    return ApiOption.jsonContentType;
  }

  @override
  MethodType buildMethodType() {
    return MethodType.delete;
  }

  @override
  BaseDelegate buildDelegate() {
    return ValueDelegate<int>(defaultValue: 0);
  }

  @override
  parseResponse(int statusCode, _, __) {
    if (statusCode != 200 && statusCode != 201) {
      return 0;
    }
    return 1;
  }
}

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
