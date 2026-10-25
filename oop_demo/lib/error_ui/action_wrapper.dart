import 'dart:developer' as developer;

import 'validation_exception.dart';

// Kết quả cụ thể; wrapper không triển khai thêm generic <T>.
class ActionResult {
  const ActionResult(this.succeeded, this.message);
  final bool succeeded;
  final String message;
}

// TV2: điểm duy nhất chứa try-catch-finally trong mã ứng dụng.
class ActionWrapper {
  ActionResult run({
    required String Function() action,
    required void Function() onFinally,
  }) {
    try {
      return ActionResult(true, action());
    } on ValidationException catch (error) {
      return ActionResult(false, error.message);
    } on FormatException {
      return const ActionResult(
        false,
        'Dữ liệu JSON chưa đúng định dạng. Vui lòng kiểm tra dấu ngoặc, '
        'dấu phẩy và dấu nháy kép.',
      );
    } catch (error, stackTrace) {
      // Chi tiết chẩn đoán đi vào log; giao diện nhận thông báo dễ hiểu.
      developer.log(
        'Không thể hoàn tất thao tác thêm sản phẩm.',
        name: 'OOP.ActionWrapper',
        error: error,
        stackTrace: stackTrace,
      );
      return const ActionResult(
        false,
        'Chưa thể hoàn tất thao tác. Vui lòng kiểm tra dữ liệu và thử lại.',
      );
    } finally {
      // Thực hiện sau action hoặc catch, trước khi caller nhận kết quả.
      onFinally();
    }
  }
}
