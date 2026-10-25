import 'logging_mixin.dart';
import 'product.dart';

// TV1: OOP và quản lý dữ liệu. Không import UI hoặc xử lý lỗi của TV2.
class ProductManager with LoggingMixin {
  // Generics cơ bản: danh sách chỉ nhận Product.
  final List<Product> _products = [];
  int _sampleSequence = 0;

  // Bản chụp chỉ đọc: bên ngoài không tự sửa kho sản phẩm.
  List<Product> get products => List<Product>.unmodifiable(_products);

  bool containsId(String id) => _products.any((product) => product.id == id);

  Product addSample() {
    // Tránh trùng với cả mã MAU-xxx người dùng đã thêm từ JSON.
    Product product;
    do {
      product = Product.sample(++_sampleSequence);
    } while (containsId(product.id));
    _products.add(product);
    logAction('Thêm mẫu: ${product.id} | ${product.name} | ${product.price}');
    return product;
  }

  // Chỉ nhận Map hợp lệ. Quy tắc kiểm tra và Custom Exception thuộc TV2.
  Product addFromMap(Map<String, Object?> validatedMap) {
    final product = Product.fromMap(validatedMap);
    _products.add(product);
    logAction(
      'Thêm từ Map: ${product.id} | ${product.name} | ${product.price}',
    );
    return product;
  }
}
