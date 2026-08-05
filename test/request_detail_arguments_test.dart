import 'package:flutter_test/flutter_test.dart';
import 'package:storysign/features/author/request/controller/request_detail_controller.dart';

void main() {
  group('normalizeRequestDetailArgs', () {
    test('returns from and id from a map argument', () {
      final args = normalizeRequestDetailArgs({
        'from': 'all_delivered',
        'autographRequestId': 'req-123',
      });

      expect(args['from'], 'all_delivered');
      expect(args['autographRequestId'], 'req-123');
    });

    test('coerces non-string values to strings', () {
      final args = normalizeRequestDetailArgs({
        'from': 'home',
        'autographRequestId': 42,
      });

      expect(args['autographRequestId'], '42');
    });

    test('returns empty values when arguments are missing', () {
      final args = normalizeRequestDetailArgs(null);

      expect(args['from'], isEmpty);
      expect(args['autographRequestId'], isEmpty);
    });
  });
}
