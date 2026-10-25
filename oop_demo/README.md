# Chủ đề 01 - Quản lý sản phẩm

Demo **Nền tảng OOP nâng cao & Xử lý lỗi trong Dart**, theo nội dung giảng viên gửi lại. App có hai cách thêm sản phẩm vào cùng một danh sách: tạo từ dữ liệu mẫu và đọc dữ liệu người dùng nhập bằng JSON. Dữ liệu được lưu trong bộ nhớ của phiên chạy.

## Cài đặt và chạy

Cần Flutter có Dart >= 3.13.5 và bộ công cụ cho nền tảng muốn chạy. Mở Terminal tại thư mục `oop_demo`, nơi có `pubspec.yaml`:

```bash
flutter pub get
flutter run -d linux
```

Trên Windows, cài Visual Studio với workload **Desktop development with C++**, rồi chạy:

```powershell
flutter pub get
flutter run -d windows
```

Trên Android, chuẩn bị Android SDK và thiết bị/máy ảo; dùng `flutter devices` lấy ID rồi chạy `flutter run -d DEVICE_ID`. Có thể chạy bản Web bằng `flutter run -d chrome`. Source có scaffold Android, Linux, Windows và Web; kết quả kiểm tra trên máy hiện tại được ghi trong `docs/05_Ket_qua_kiem_tra.md`.

Trong workspace này, Flutter SDK nằm tại `../../../Flutter SDK/flutter` tính từ `oop_demo`. Nếu Flutter chưa có trong PATH, trên Linux dùng:

```bash
"../../../Flutter SDK/flutter/bin/flutter" --suppress-analytics --no-version-check run -d linux --no-pub
```

App không cần API, database, tài khoản dịch vụ hoặc biến môi trường. Sau khi dependency và công cụ build đã có, app hoạt động offline. Khi dùng cache có sẵn có thể chạy `flutter pub get --offline`.

## Thao tác

1. **Thêm sản phẩm mẫu:** tạo bàn phím mẫu giá 250.000 đ, mã tự tăng `MAU-001`, `MAU-002`... Nút hoạt động độc lập với ô JSON.
2. **Thêm từ JSON:** nhập một đối tượng có `id`, `name`, `price`, rồi bấm nút. Mã và tên phải là chuỗi không trống; giá phải là số hữu hạn lớn hơn 0; mã không được trùng sản phẩm đã có.
3. Các nút **Hợp lệ**, **Tên trống**, **Giá âm**, **Sai cú pháp** chỉ điền ví dụ vào ô. Bấm **Thêm từ JSON** để thực hiện xử lý. Các ví dụ tự chọn mã chưa có để trình diễn nhiều lượt.
4. Lỗi hiển thị ngay trên giao diện, dữ liệu sai không được thêm; sửa lại rồi thử tiếp. Khởi động lại app sẽ làm mới danh sách.

```json
{
  "id": "SP01",
  "name": "Chuột máy tính",
  "price": 150000
}
```

## Hai phần mã nguồn

```text
lib/
  main.dart                           # TV2: khởi động app
  product/                            # TV1: OOP và dữ liệu
    product.dart                      # Named + Factory constructor
    logging_mixin.dart                # Mixin in log
    product_manager.dart              # List<Product> và các thao tác dữ liệu
    product_module.dart               # Điểm import công khai cho TV2
  error_ui/                           # TV2: kiểm tra, lỗi và giao diện
    validation_exception.dart         # Custom Exception
    product_input_validator.dart      # Đọc JSON, kiểm tra, throw
    action_wrapper.dart               # try-catch-finally tập trung
    product_demo_page.dart            # Kết nối thao tác và quản lý trạng thái
    product_demo_view.dart             # Bố cục và hiển thị
    app_theme.dart                    # Màu sắc
```

**Ranh giới đã chốt:** TV1 nhận Map hợp lệ để khởi tạo đối tượng và quản lý sản phẩm; TV2 kiểm tra trước, phát sinh ngoại lệ, bắt và chuyển lỗi thành thông báo. Hai nút cùng đi qua một wrapper. TV1 không import TV2 hoặc Flutter; TV2 không trực tiếp gọi `Product.sample`, `Product.fromMap`, không khai báo mixin.

`List<Product>` và `Map<String, Object?>` có thể xuất hiện ở chữ ký kết nối/hiển thị vì hai phần cần trao đổi dữ liệu có kiểu. Phần triển khai và giải thích Generics là danh sách trong module TV1; wrapper của TV2 dùng kết quả cụ thể, không có generic `<T>` riêng.

Log của Mixin xuất hiện ở Terminal với tiền tố `[ProductManager]` khi thêm thành công. Mixin cung cấp hàm; chính các phương thức trong `ProductManager` gọi hàm đó.

## Học và trình diễn

- [Phần TV1: OOP và quản lý dữ liệu](docs/01_TV1_OOP_va_du_lieu.md)
- [Phần TV2: xử lý lỗi và giao diện](docs/02_TV2_Xu_ly_loi_va_UI.md)
- [Bảng phân công và điểm kết nối](docs/03_Phan_cong_va_diem_ket_noi.md)
- [Kịch bản demo 5 phút](docs/04_Kich_ban_demo_5_phut.md)
- Hai sơ đồ draw.io nằm ở thư mục cha `Chu_de_01_OOP`.

## Kiểm tra mã

```bash
flutter analyze
flutter test
flutter build linux --release
```

Các bài test tập trung vào dữ liệu không hợp lệ, trùng mã, bảo toàn danh sách sau lỗi, `finally`, phục hồi sau lỗi và giao diện hẹp.

Nguồn tham khảo: [Dart constructors](https://dart.dev/language/constructors), [Mixins](https://dart.dev/language/mixins), [Generics](https://dart.dev/language/generics), [Error handling](https://dart.dev/language/error-handling).
