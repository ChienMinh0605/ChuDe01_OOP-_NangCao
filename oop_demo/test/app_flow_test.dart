import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oop_demo/main.dart';

Future<void> press(WidgetTester tester, String key) async {
  final finder = find.byKey(ValueKey(key));
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> chooseExample(WidgetTester tester, String label) async {
  final finder = find.widgetWithText(ActionChip, label);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void configureSize(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

String count(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const ValueKey('product-count'))).data!;

void main() {
  testWidgets('sample and default JSON both add products to the same catalog', (
    tester,
  ) async {
    configureSize(tester, const Size(1280, 1000));
    await tester.pumpWidget(const ProductDemoApp());
    expect(count(tester), '0');
    await press(tester, 'add-sample-button');
    expect(count(tester), '1');
    expect(find.text('Bàn phím mẫu'), findsOneWidget);
    await press(tester, 'add-json-button');
    expect(count(tester), '2');
    expect(find.text('Chuột máy tính'), findsOneWidget);
    expect(find.text('150.000 đ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'all error presets keep catalog intact and valid input recovers',
    (tester) async {
      configureSize(tester, const Size(1280, 1000));
      await tester.pumpWidget(const ProductDemoApp());
      await press(tester, 'add-sample-button');
      for (final label in ['Tên trống', 'Giá âm', 'Sai cú pháp']) {
        await chooseExample(tester, label);
        await press(tester, 'add-json-button');
        expect(count(tester), '1', reason: label);
        expect(find.byKey(const ValueKey('feedback-banner')), findsOneWidget);
        expect(
          tester
              .widget<FilledButton>(
                find.byKey(const ValueKey('add-json-button')),
              )
              .onPressed,
          isNotNull,
        );
        expect(tester.takeException(), isNull);
      }
      await chooseExample(tester, 'Hợp lệ');
      await press(tester, 'add-json-button');
      expect(count(tester), '2');
      expect(find.textContaining('từ JSON.'), findsOneWidget);
    },
  );

  testWidgets('malformed JSON does not affect the independent sample action', (
    tester,
  ) async {
    configureSize(tester, const Size(1280, 1000));
    await tester.pumpWidget(const ProductDemoApp());
    await tester.enterText(find.byKey(const ValueKey('json-input')), '{bad');
    await press(tester, 'add-json-button');
    expect(count(tester), '0');
    await press(tester, 'add-sample-button');
    expect(count(tester), '1');
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile screen supports error and recovery without overflow', (
    tester,
  ) async {
    configureSize(tester, const Size(360, 800));
    await tester.pumpWidget(const ProductDemoApp());
    await chooseExample(tester, 'Giá âm');
    await press(tester, 'add-json-button');
    expect(count(tester), '0');
    expect(tester.takeException(), isNull);
    await chooseExample(tester, 'Hợp lệ');
    await press(tester, 'add-json-button');
    expect(count(tester), '1');
    expect(tester.takeException(), isNull);
  });
}
