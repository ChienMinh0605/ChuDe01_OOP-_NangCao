// TV2: Custom Exception cho lỗi đầu vào mà người dùng có thể sửa.
class ValidationException implements Exception {
  const ValidationException(this.message);
  final String message;

  @override
  String toString() => 'ValidationException: $message';
}
