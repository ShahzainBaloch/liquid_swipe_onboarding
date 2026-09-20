import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_swipe_onboarding/liquid_swipe_onboarding.dart';

void main() {
  test('LiquidWaveClipper builds paths for varied progress values', () {
    const size = Size(375, 812);

    const clipperZero = LiquidWaveClipper(progress: 0.0, touchY: 400.0);
    expect(clipperZero.getClip(size).getBounds().isEmpty, isTrue);

    const clipperFull = LiquidWaveClipper(progress: 1.0, touchY: 400.0);
    expect(clipperFull.getClip(size).getBounds(),
        equals(const Rect.fromLTWH(0, 0, 375, 812)));

    const clipperHalf = LiquidWaveClipper(progress: 0.5, touchY: 400.0);
    expect(clipperHalf.getClip(size).getBounds().isEmpty, isFalse);
  });

  testWidgets('LiquidSwipeOnboarding renders and navigates with controller',
      (tester) async {
    final controller = LiquidSwipeController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LiquidSwipeOnboarding(
            controller: controller,
            pages: const [
              ColoredBox(
                color: Colors.blue,
                child: Center(child: Text('Page 1 Content')),
              ),
              ColoredBox(
                color: Colors.purple,
                child: Center(child: Text('Page 2 Content')),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Page 1 Content'), findsOneWidget);
    expect(controller.currentPage, equals(0));

    // Call nextPage without awaiting the inner un-pumped ticker future
    controller.nextPage();
    await tester.pumpAndSettle();

    expect(controller.currentPage, equals(1));
    expect(find.text('Page 2 Content'), findsOneWidget);
  });

  testWidgets('LiquidPageIndicator renders correct dot count', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LiquidPageIndicator(
            count: 4,
            currentPage: 2,
          ),
        ),
      ),
    );

    expect(find.byType(AnimatedContainer), findsNWidgets(4));
  });
}
