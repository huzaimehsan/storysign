import 'package:flutter_test/flutter_test.dart';
import 'package:storysign/features/reader/library/model/library_detail_model.dart';

void main() {
  test('parses a book detail payload with paid metadata', () {
    final detail = ReaderLibraryBookDetailModel.fromJson({
      'id': 'book-1',
      'title': 'My Book',
      'coverImage': 'https://example.com/cover.png',
      'status': 'Signed',
      'uploadDate': '2024-01-15',
      'feeAmount': 25,
      'isPaid': true,
      'author': {'fullName': 'Jane Doe'}
    });

    expect(detail.id, 'book-1');
    expect(detail.title, 'My Book');
    expect(detail.isPaid, isTrue);
    expect(detail.feeAmount, 25);
    expect(detail.authorName, 'Jane Doe');
  });
}
