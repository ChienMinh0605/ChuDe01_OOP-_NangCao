import 'package:flutter/material.dart';

import 'error_ui/app_theme.dart';
import 'error_ui/product_demo_page.dart';

void main() => runApp(const ProductDemoApp());

// TV2: chỉ khởi động ứng dụng và gắn giao diện.
class ProductDemoApp extends StatelessWidget {
  const ProductDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý sản phẩm',
      debugShowCheckedModeBanner: false,
      theme: createAppTheme(),
      home: const ProductDemoPage(),
    );
  }
}
