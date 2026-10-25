import 'package:flutter/material.dart';

import '../product/product_module.dart';
import 'action_wrapper.dart';
import 'product_demo_view.dart';
import 'product_input_validator.dart';

// TV2 chỉ gọi API của module, không trực tiếp gọi constructor hoặc mixin.
class ProductDemoPage extends StatefulWidget {
  const ProductDemoPage({super.key});

  @override
  State<ProductDemoPage> createState() => _ProductDemoPageState();
}

class _ProductDemoPageState extends State<ProductDemoPage> {
  final _manager = ProductManager();
  final _validator = ProductInputValidator();
  final _wrapper = ActionWrapper();
  final _jsonController = TextEditingController(
    text:
        '{\n  "id": "SP01",\n  "name": "Chuột máy tính",\n  "price": 150000\n}',
  );
  bool _busy = false;
  ActionResult? _feedback;

  void _runAction(String Function() action) {
    if (_busy) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _busy = true);
    final result = _wrapper.run(
      action: action,
      onFinally: () {
        if (mounted) setState(() => _busy = false);
      },
    );
    if (mounted) setState(() => _feedback = result);
  }

  void _addSample() {
    _runAction(() {
      final product = _manager.addSample();
      return 'Đã thêm sản phẩm mẫu "${product.name}" (${product.id}).';
    });
  }

  void _addFromJson() {
    _runAction(() {
      final map = _validator.parseAndValidate(
        _jsonController.text,
        idExists: _manager.containsId,
      );
      final product = _manager.addFromMap(map);
      return 'Đã thêm "${product.name}" (${product.id}) từ JSON.';
    });
  }

  void _fillExample(String example) {
    if (_busy) return;
    var index = 1;
    while (_manager.containsId('SP${index.toString().padLeft(2, '0')}')) {
      index++;
    }
    final id = 'SP${index.toString().padLeft(2, '0')}';
    final name = example == 'Tên trống' ? '' : 'Chuột máy tính';
    final price = example == 'Giá âm' ? '-50000' : '150000';
    final closingBrace = example == 'Sai cú pháp' ? '' : '\n}';
    _jsonController.text =
        '{\n  "id": "$id",\n  "name": "$name",\n  "price": $price$closingBrace';
    setState(() => _feedback = null);
  }

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProductDemoView(
      products: _manager.products,
      jsonController: _jsonController,
      busy: _busy,
      feedback: _feedback,
      onAddSample: _addSample,
      onAddFromJson: _addFromJson,
      onFillExample: _fillExample,
    );
  }
}
