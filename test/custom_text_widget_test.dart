import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';
import 'package:storysign/widgets/customText_widget.dart';

void main() {
  testWidgets('customText normalizes TextDecoration.none to avoid empty decoration styles', (tester) async {
    await tester.pumpWidget(
      Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            home: Scaffold(
              body: customText(text: 'Hello', txtDecoration: TextDecoration.none),
            ),
          );
        },
      ),
    );

    final text = tester.widget<Text>(find.text('Hello'));
    expect(text.style?.decoration, isNull);
  });
}
