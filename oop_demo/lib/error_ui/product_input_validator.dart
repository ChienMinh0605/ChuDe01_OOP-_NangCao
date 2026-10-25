import 'dart:convert';

import 'validation_exception.dart';

// TV2: toàn bộ kiểm tra đầu vào và chủ động throw nằm trong phần này.
class ProductInputValidator {
  Map<String, Object?> parseAndValidate(
    String source, {
    required bool Function(String id) idExists,
  }) {
    if (source.trim().isEmpty) {
      throw const ValidationException(
        'Vui lòng nhập dữ liệu JSON trước khi thêm sản phẩm.',
      );
    }
    // JSON sai cú pháp phát sinh FormatException; wrapper sẽ bắt tập trung.
    final Object? decoded = jsonDecode(source);
    if (decoded is! Map<String, Object?>) {
      throw const ValidationException(
        'JSON cần là một đối tượng gồm mã, tên và giá sản phẩm.',
      );
    }
    final id = decoded['id'];
    final name = decoded['name'];
    final price = decoded['price'];
    if (id is! String || id.trim().isEmpty) {
      throw const ValidationException('Mã sản phẩm phải là chuỗi không trống.');
    }
    if (name is! String || name.trim().isEmpty) {
      throw const ValidationException('Vui lòng nhập tên sản phẩm hợp lệ.');
    }
    if (price is! num) {
      throw const ValidationException('Giá sản phẩm phải là số, ví dụ 250000.');
    }
    if (!price.isFinite || price <= 0) {
      throw const ValidationException('Giá sản phẩm phải lớn hơn 0.');
    }
    if (idExists(id.trim())) {
      throw ValidationException(
        'Mã sản phẩm "${id.trim()}" đã tồn tại. Vui lòng dùng mã khác.',
      );
    }
    return {'id': id.trim(), 'name': name.trim(), 'price': price};
  }
}
