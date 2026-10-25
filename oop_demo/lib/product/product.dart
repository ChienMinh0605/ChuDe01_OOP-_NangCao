// TV1: Named constructor và Factory constructor chỉ được triển khai ở đây.
class Product {
  const Product._({required this.id, required this.name, required this.price});

  // Named constructor: tên và giá có sẵn; số thứ tự giúp mã mẫu không trùng.
  Product.sample(int sequence)
    : id = 'MAU-${sequence.toString().padLeft(3, '0')}',
      name = 'Bàn phím mẫu',
      price = 250000;

  // Tiền điều kiện: TV2 đã kiểm tra các trường, kiểu dữ liệu và giá trị.
  // Factory tập trung chuyển Map thành Product, chuẩn hóa giá về double.
  factory Product.fromMap(Map<String, Object?> map) {
    return Product._(
      id: map['id'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
    );
  }

  final String id;
  final String name;
  final double price;
}
