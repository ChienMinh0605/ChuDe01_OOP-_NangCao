// TV1: cung cấp hành vi dùng chung; module gọi hàm này khi thao tác.
mixin LoggingMixin {
  void logAction(String message) {
    // Demo cần nhìn thấy log ngay trong Terminal, cả khi chạy bản release.
    // ignore: avoid_print
    print('[ProductManager] $message');
  }
}
