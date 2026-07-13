// import 'package:flutter_test/flutter_test.dart';
// import 'package:storysign/features/reader/auth/controller/auth_controller.dart';
//
// void main() {
//   group('AuthController validation', () {
//     late AuthController controller;
//
//     setUp(() {
//       controller = AuthController();
//     });
//
//     test('returns email validation error for invalid sign-in email', () {
//       final error = controller.validateLoginInput('abc', 'Strong@123');
//
//       expect(error, 'Invalid email');
//     });
//
//     test('returns password validation error for weak sign-in password', () {
//       final error = controller.validateLoginInput('lisa@example.com', 'password');
//
//       expect(error, 'must contains at least 1 upper case letter');
//     });
//
//     test('returns null for valid sign-in input', () {
//       final error = controller.validateLoginInput('lisa@example.com', 'Strong@123');
//
//       expect(error, isNull);
//     });
//   });
// }
