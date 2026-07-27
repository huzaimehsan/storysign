import 'package:flutter_test/flutter_test.dart';
import 'package:storysign/features/reader/notification/model/notification_model.dart';

void main() {
  group('NotificationModel', () {
    test('parses createdAt when backend sends camelCase field', () {
      final model = NotificationModel.fromJson({
        'id': '1',
        'title': 'Hello',
        'body': 'Body',
        'type': 'general',
        'is_read': false,
        'createdAt': '2024-01-02T03:04:05.000Z',
      });

      expect(model.createdAt, isA<DateTime>());
      expect(model.createdAt.toIso8601String(), '2024-01-02T03:04:05.000Z');
    });
  });
}
