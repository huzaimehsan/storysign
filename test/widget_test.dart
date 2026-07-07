import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:storysign/features/author/request/controller/request_detail_controller.dart';
import 'package:storysign/features/author/request/view/request_detail.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('request detail back button pops the current screen', (tester) async {
    Get.put(RequestDetailController());

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(Get.context!).push(
                  MaterialPageRoute(builder: (_) => const RequestDetailAuthor()),
                );
              },
              child: const Text('Open request detail'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open request detail'));
    await tester.pumpAndSettle();

    expect(find.text('Request Detail'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    expect(find.text('Open request detail'), findsOneWidget);
  });
}
