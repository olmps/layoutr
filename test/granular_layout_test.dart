import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:layoutr/granular_layout.dart';
import 'package:layoutr/src/layout_resolver_widget.dart';
import 'package:layoutr/src/spacings_widget.dart';

import 'utilities.dart';

void main() {
  group('GranularLayout', () {
    final testLayout = GranularLayout(100);

    test('value should throw when no argument is provided', () {
      expect(testLayout.value, throwsA(isA<ArgumentError>()));
    });

    test('maybeValue should return `null` when no argument is provided', () {
      expect(testLayout.maybeValue(), null);
    });
  });

  group('GranularLayoutWidget', () {
    group('Spacings', () {
      testWidgets('should have the same spacings for all breakpoints', (tester) async {
        tester.binding.window.devicePixelRatioTestValue = 1;

        tester.binding.window.physicalSizeTestValue = const Size.square(2000);

        const testSpacings = RawSpacings(2, 4, 6, 8, 10, 12, 14, 16, 18);
        await tester.pumpWidget(
          GranularLayoutWidget(
            spacings: testSpacings,
            child: Builder(
              builder: (context) {
                final spacingsWidget = SpacingsInheritedWidget.of(context);
                expect(spacingsWidget.xxxSmall, testSpacings.xxxSmall);

                return const Placeholder();
              },
            ),
          ),
        );

        await pumpTesterForSize(tester, const Size.square(1200));
        await pumpTesterForSize(tester, const Size.square(770));
        await pumpTesterForSize(tester, const Size.square(500));
        await pumpTesterForSize(tester, const Size.square(350));
        await pumpTesterForSize(tester, const Size.square(150));
      });

      testWidgets('should have the respective spacings for multiple breakpoints', (tester) async {
        tester.binding.window.devicePixelRatioTestValue = 1;

        tester.binding.window.physicalSizeTestValue = const Size.square(2000);

        const bigSpacings = RawSpacings(8, 12, 20, 32, 40, 60, 80, 100, 120);
        const mediumSpacings = RawSpacings(4, 8, 16, 20, 32, 48, 60, 80, 100);
        const smallSpacings = RawSpacings(2, 4, 6, 8, 10, 12, 14, 16, 18);
        await tester.pumpWidget(
          GranularLayoutWidget.withResponsiveSpacings(
            xLargeSpacings: bigSpacings,
            mediumSpacings: mediumSpacings,
            smallSpacings: smallSpacings,
            child: Builder(
              builder: (context) {
                final spacingsWidget = SpacingsInheritedWidget.of(context);
                switch (context.granularLayout.breakpointValue) {
                  case GranularBreakpoint.xxLarge:
                  case GranularBreakpoint.xLarge:
                    expect(spacingsWidget.xxxSmall, bigSpacings.xxxSmall);
                    break;
                  case GranularBreakpoint.large:
                  case GranularBreakpoint.medium:
                    expect(spacingsWidget.xxxSmall, mediumSpacings.xxxSmall);
                    break;
                  case GranularBreakpoint.small:
                  case GranularBreakpoint.xSmall:
                    expect(spacingsWidget.xxxSmall, smallSpacings.xxxSmall);
                    break;
                }

                return const Placeholder();
              },
            ),
          ),
        );

        await pumpTesterForSize(tester, const Size.square(1200));
        await pumpTesterForSize(tester, const Size.square(770));
        await pumpTesterForSize(tester, const Size.square(500));
        await pumpTesterForSize(tester, const Size.square(350));
        await pumpTesterForSize(tester, const Size.square(150));
      });
    });

    group('BuildContext', () {
      testWidgets(
        'Accessing granular layout in context without a LayoutResolverInheritedWidget should throw',
        (tester) async {
          await tester.pumpWidget(
            Builder(
              builder: (context) {
                expect(() => context.granularLayout, throwsA(isA<StateError>()));

                return const Placeholder();
              },
            ),
          );
        },
      );

      testWidgets(
        'Accessing granular layout in context with a LayoutResolverInheritedWidget of different type should throw',
        (tester) async {
          await tester.pumpWidget(
            LayoutResolverInheritedWidget(
              resolver: LayoutResolverMock(),
              child: Builder(
                builder: (context) {
                  expect(() => context.granularLayout, throwsA(isA<StateError>()));

                  return const Placeholder();
                },
              ),
            ),
          );
        },
      );
    });
  });
}
