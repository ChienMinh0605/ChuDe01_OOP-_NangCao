import 'package:flutter_test/flutter_test.dart';
import 'package:oop_demo/product/product_module.dart';

void main() {
  test('sample IDs stay distinct, including collisions with imported IDs', () {
    final manager = ProductManager();
    manager.addFromMap({
      'id': 'MAU-001',
      'name': 'Sản phẩm nhập',
      'price': 100,
    });
    final first = manager.addSample();
    final second = manager.addSample();
    expect(first.id, 'MAU-002');
    expect(second.id, 'MAU-003');
    expect(first.name, 'Bàn phím mẫu');
    expect(first.price, 250000);
    expect(manager.products.length, 3);
  });

  test(
    'factory accepts valid integer and decimal prices without losing fields',
    () {
      final integer = Product.fromMap({
        'id': 'A',
        'name': 'Chuột',
        'price': 150000,
      });
      final decimal = Product.fromMap({
        'id': 'B',
        'name': 'Tai nghe',
        'price': 999.5,
      });
      expect(integer.id, 'A');
      expect(integer.name, 'Chuột');
      expect(integer.price, 150000.0);
      expect(decimal.price, 999.5);
    },
  );

  test(
    'catalog snapshots cannot change manager state or change retroactively',
    () {
      final manager = ProductManager();
      final sample = manager.addSample();
      final snapshot = manager.products;
      expect(() => snapshot.add(sample), throwsUnsupportedError);
      manager.addSample();
      expect(snapshot.length, 1);
      expect(manager.products.length, 2);
    },
  );
}
