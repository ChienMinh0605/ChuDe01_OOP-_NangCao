import 'package:flutter_test/flutter_test.dart';
import 'package:oop_demo/product/product_module.dart';
import 'package:oop_demo/error_ui/action_wrapper.dart';
import 'package:oop_demo/error_ui/product_input_validator.dart';
import 'package:oop_demo/error_ui/validation_exception.dart';

void main() {
  final validator = ProductInputValidator();
  final wrapper = ActionWrapper();

  test('valid input is normalized before entering product module', () {
    final map = validator.parseAndValidate(
      '{"id":" SP01 ","name":" Chuột ","price":150000}',
      idExists: (_) => false,
    );
    expect(map, {'id': 'SP01', 'name': 'Chuột', 'price': 150000});
  });

  final invalidInputs = <String, String>{
    '': 'Vui lòng nhập dữ liệu JSON',
    '[]': 'JSON cần là một đối tượng',
    'null': 'JSON cần là một đối tượng',
    '{"name":"A","price":1}': 'Mã sản phẩm',
    '{"id":7,"name":"A","price":1}': 'Mã sản phẩm',
    '{"id":"A","name":"  ","price":1}': 'tên sản phẩm',
    '{"id":"A","name":null,"price":1}': 'tên sản phẩm',
    '{"id":"A","name":"A","price":"150000"}': 'phải là số',
    '{"id":"A","name":"A","price":true}': 'phải là số',
    '{"id":"A","name":"A"}': 'phải là số',
    '{"id":"A","name":"A","price":0}': 'lớn hơn 0',
    '{"id":"A","name":"A","price":-50000}': 'lớn hơn 0',
    '{"id":"A","name":"A","price":1e400}': 'lớn hơn 0',
  };
  for (final entry in invalidInputs.entries) {
    test(
      'invalid input is rejected without mutating catalog: ${entry.key}',
      () {
        final manager = ProductManager()..addSample();
        var finalized = 0;
        final result = wrapper.run(
          action: () {
            final map = validator.parseAndValidate(
              entry.key,
              idExists: manager.containsId,
            );
            manager.addFromMap(map);
            return 'Thành công';
          },
          onFinally: () => finalized++,
        );
        expect(result.succeeded, isFalse);
        expect(result.message, contains(entry.value));
        expect(finalized, 1);
        expect(manager.products.length, 1);
      },
    );
  }

  test('duplicate ID with surrounding spaces is rejected', () {
    final manager = ProductManager();
    manager.addFromMap({'id': 'SP01', 'name': 'Đã có', 'price': 100});
    expect(
      () => validator.parseAndValidate(
        '{"id":" SP01 ","name":"Mới","price":200}',
        idExists: manager.containsId,
      ),
      throwsA(
        isA<ValidationException>().having(
          (e) => e.message,
          'message',
          contains('đã tồn tại'),
        ),
      ),
    );
    expect(manager.products.length, 1);
  });

  test(
    'format error and unexpected error return friendly messages and finalize',
    () {
      for (final action in <String Function()>[
        () {
          validator.parseAndValidate('{', idExists: (_) => false);
          return 'Không tới đây';
        },
        () => throw StateError('technical-detail-should-not-reach-user'),
      ]) {
        var finalized = false;
        final result = wrapper.run(
          action: action,
          onFinally: () => finalized = true,
        );
        expect(result.succeeded, isFalse);
        expect(result.message, isNot(contains('technical-detail')));
        expect(finalized, isTrue);
      }
    },
  );

  test('success returns only after finally has completed', () {
    final events = <String>[];
    final result = wrapper.run(
      action: () {
        events.add('action');
        return 'Đã thêm';
      },
      onFinally: () => events.add('finally'),
    );
    events.add('caller');
    expect(result.succeeded, isTrue);
    expect(result.message, 'Đã thêm');
    expect(events, ['action', 'finally', 'caller']);
  });
}
