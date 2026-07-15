import 'package:flutter_test/flutter_test.dart';
import 'package:storysign/features/reader/Home/model/home_model.dart';

void main() {
  test('BookItem.fromResponse parses nested request payload with book and author objects', () {
    final response = {
      'data': {
        'request': {
          'id': 'req_123',
          'book': {
            'title': 'Things Fall Apart',
            'coverImage': '/covers/things.jpg',
          },
          'personalMessage': 'Please sign this for me',
          'status': 'In Process',
          'feeAmount': '250',
          'isPaid': 'true',
          'author': {
            'fullName': 'Chinua Achebe',
            'profilePicture': '/authors/chinua.jpg',
            'dateJoined': '2024-01-01',
          },
        },
      },
    };

    final request = BookItem.fromResponse(response);

    expect(request, isNotNull);
    expect(request!.title, 'Things Fall Apart');
    expect(request.coverImage, '/covers/things.jpg');
    expect(request.personalMessage, 'Please sign this for me');
    expect(request.status, 'In Process');
    expect(request.feeAmount, 250);
    expect(request.isPaid, isTrue);
    expect(request.author.fullName, 'Chinua Achebe');
  });
}
