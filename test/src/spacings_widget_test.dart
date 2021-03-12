import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:layoutr/src/spacing.dart';
import 'package:layoutr/src/spacings_widget.dart';

void main() {
  testWidgets(
    'SpacingsInheritedWidget should provide the overridden `spacings` to all nested children',
    (tester) async {
      const overriddenSpacings = RawSpacings(2, 4, 6, 8, 10, 12, 14, 16, 18);
      await tester.pumpWidget(
        SpacingsInheritedWidget(
          spacings: overriddenSpacings,
          child: Builder(
            builder: (context) {
              final spacings = SpacingsInheritedWidget.of(context);
              expect(spacings, overriddenSpacings);

              return Builder(
                builder: (context) {
                  final nestedSpacings = SpacingsInheritedWidget.of(context);
                  expect(nestedSpacings, overriddenSpacings);

                  return const Placeholder();
                },
              );
            },
          ),
        ),
      );
    },
  );

  testWidgets('SpacingsInheritedWidget should provide a default `spacings` to all nested children', (tester) async {
    await tester.pumpWidget(
      SpacingsInheritedWidget(
        child: Builder(
          builder: (context) {
            final spacings = SpacingsInheritedWidget.of(context);
            expect(spacings, SpacingsInheritedWidget.defaultSpacings);

            return Builder(
              builder: (context) {
                final nestedSpacings = SpacingsInheritedWidget.of(context);
                expect(nestedSpacings, SpacingsInheritedWidget.defaultSpacings);

                return const Placeholder();
              },
            );
          },
        ),
      ),
    );
  });
}
