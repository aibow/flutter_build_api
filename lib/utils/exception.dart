class ApiException implements Exception {
  final int code;
  final String message;

  ApiException({this.message = '', this.code = 0});

  @override
  String toString() {
    return 'ApiException($code, $message)';
  }
}
