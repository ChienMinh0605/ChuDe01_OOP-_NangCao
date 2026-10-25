import 'package:flutter/material.dart';

import '../product/product_module.dart';
import 'action_wrapper.dart';

// TV2: đọc dữ liệu để hiển thị; không trực tiếp tạo Product.
class ProductDemoView extends StatelessWidget {
  const ProductDemoView({
    super.key,
    required this.products,
    required this.jsonController,
    required this.busy,
    required this.feedback,
    required this.onAddSample,
    required this.onAddFromJson,
    required this.onFillExample,
  });

  // Kiểu dữ liệu ở điểm kết nối; cách quản lý danh sách nằm trong TV1.
  final List<Product> products;
  final TextEditingController jsonController;
  final bool busy;
  final ActionResult? feedback;
  final VoidCallback onAddSample;
  final VoidCallback onAddFromJson;
  final ValueChanged<String> onFillExample;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'CHỦ ĐỀ 01 · DART & FLUTTER',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Quản lý sản phẩm',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tạo nhanh từ dữ liệu mẫu hoặc thêm sản phẩm của bạn bằng JSON.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _SampleCard(onPressed: busy ? null : onAddSample),
                  if (feedback case final result?) ...[
                    const SizedBox(height: 18),
                    _FeedbackBanner(result: result),
                  ],
                  const SizedBox(height: 22),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final input = _JsonInputCard(
                        controller: jsonController,
                        busy: busy,
                        onSubmit: onAddFromJson,
                        onFillExample: onFillExample,
                      );
                      final catalog = _ProductListCard(products: products);
                      if (constraints.maxWidth < 850) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            input,
                            const SizedBox(height: 22),
                            catalog,
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 10, child: input),
                          const SizedBox(width: 22),
                          Expanded(flex: 12, child: catalog),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sản phẩm được lưu trong phiên chạy hiện tại. '
                    'Dữ liệu sẽ được làm mới khi mở lại ứng dụng.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    child: child,
  );
}

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final description = Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.add_box_outlined,
            color: theme.colorScheme.onSecondaryContainer,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bắt đầu với sản phẩm mẫu',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Một lần bấm để tạo sản phẩm có sẵn dữ liệu.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
    final button = OutlinedButton.icon(
      key: const ValueKey('add-sample-button'),
      onPressed: onPressed,
      icon: const Icon(Icons.add_rounded),
      label: const Text('Thêm sản phẩm mẫu'),
    );
    return _Panel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 650) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [description, const SizedBox(height: 18), button],
            );
          }
          return Row(
            children: [
              Expanded(child: description),
              const SizedBox(width: 24),
              button,
            ],
          );
        },
      ),
    );
  }
}

class _JsonInputCard extends StatelessWidget {
  const _JsonInputCard({
    required this.controller,
    required this.busy,
    required this.onSubmit,
    required this.onFillExample,
  });
  final TextEditingController controller;
  final bool busy;
  final VoidCallback onSubmit;
  final ValueChanged<String> onFillExample;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'THÊM DỮ LIỆU CỦA BẠN',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Thêm từ JSON',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhập mã, tên và giá sản phẩm. Giá phải là số lớn hơn 0.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            key: const ValueKey('json-input'),
            controller: controller,
            enabled: !busy,
            minLines: 7,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            autocorrect: false,
            enableSuggestions: false,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              height: 1.7,
            ),
            decoration: const InputDecoration(
              labelText: 'Dữ liệu JSON',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          Text('Điền nhanh một ví dụ', style: theme.textTheme.labelMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final example in [
                'Hợp lệ',
                'Tên trống',
                'Giá âm',
                'Sai cú pháp',
              ])
                ActionChip(
                  label: Text(example),
                  onPressed: busy ? null : () => onFillExample(example),
                  backgroundColor: const Color(0xFFF7F7F5),
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
            ],
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            key: const ValueKey('add-json-button'),
            onPressed: busy ? null : onSubmit,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Thêm từ JSON'),
          ),
        ],
      ),
    );
  }
}

class _ProductListCard extends StatelessWidget {
  const _ProductListCard({required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Danh sách sản phẩm',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${products.length}',
                  key: const ValueKey('product-count'),
                  style: TextStyle(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Các sản phẩm đã được thêm thành công.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          if (products.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 86, horizontal: 12),
              child: Column(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 54,
                    color: theme.colorScheme.secondary.withValues(alpha: 0.55),
                  ),
                  const SizedBox(height: 18),
                  Text('Chưa có sản phẩm', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Thêm sản phẩm mẫu hoặc nhập JSON để bắt đầu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 440),
              child: ListView.separated(
                key: const ValueKey('product-list'),
                shrinkWrap: true,
                itemCount: products.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) =>
                    _ProductRow(product: products[index]),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decimals = product.price == product.price.truncateToDouble() ? 0 : 2;
    final parts = product.price.toStringAsFixed(decimals).split('.');
    final whole = parts.first.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    final fraction = parts.length == 1 ? '' : ',${parts.last}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  '$whole$fraction đ',
                  textAlign: TextAlign.right,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            product.id,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({required this.result});
  final ActionResult result;

  @override
  Widget build(BuildContext context) {
    final ink = result.succeeded
        ? const Color(0xFF276449)
        : const Color(0xFF9A3542);
    final background = result.succeeded
        ? const Color(0xFFEBF6EF)
        : const Color(0xFFFCEDEF);
    return Semantics(
      liveRegion: true,
      child: Container(
        key: const ValueKey('feedback-banner'),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              result.succeeded
                  ? Icons.check_circle_outline
                  : Icons.info_outline,
              color: ink,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                result.message,
                style: TextStyle(
                  color: ink,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
