import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:layoutr/common_layout.dart';
import 'package:layoutr/src/layout_resolver_widget.dart';
import 'package:layoutr/src/spacings_widget.dart';

import 'utilities.dart';

void main() {
  group('CommonLayout', () {
    final testLayout = CommonLayout(100);

    test('value should throw when no argument is provided', () {
      expect(testLayout.value, throwsA(isA<ArgumentError>()));
    });

    test('maybeValue should return `null` when no argument is provided', () {
      expect(testLayout.maybeValue(), null);
    });
  });

  group('CommonLayoutWidget', () {
    group('Spacings', () {
      testWidgets('should have the same spacings for all breakpoints', (tester) async {
        tester.binding.window.devicePixelRatioTestValue = 1;

        tester.binding.window.physicalSizeTestValue = const Size.square(1000);

        const testSpacings = RawSpacings(2, 4, 6, 8, 10, 12, 14, 16, 18);
        await tester.pumpWidget(
          CommonLayoutWidget(
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

        await pumpTesterForSize(tester, const Size.square(600));
        await pumpTesterForSize(tester, const Size.square(400));
        await pumpTesterForSize(tester, const Size.square(200));
      });

      testWidgets('should have the respective spacings for multiple breakpoints', (tester) async {
        tester.binding.window.devicePixelRatioTestValue = 1;

        tester.binding.window.physicalSizeTestValue = const Size.square(1000);

        const bigSpacings = RawSpacings(4, 8, 16, 20, 32, 48, 60, 80, 100);
        const smallSpacings = RawSpacings(2, 4, 6, 8, 10, 12, 14, 16, 18);
        await tester.pumpWidget(
          CommonLayoutWidget.withResponsiveSpacings(
            tabletSpacings: bigSpacings,
            phoneSpacings: smallSpacings,
            child: Builder(
              builder: (context) {
                final spacingsWidget = SpacingsInheritedWidget.of(context);
                switch (context.commonLayout.breakpointValue) {
                  case CommonBreakpoint.desktop:
                  case CommonBreakpoint.tablet:
                    expect(spacingsWidget.xxxSmall, bigSpacings.xxxSmall);
                    break;
                  case CommonBreakpoint.phone:
                  case CommonBreakpoint.tinyHardware:
                    expect(spacingsWidget.xxxSmall, smallSpacings.xxxSmall);
                    break;
                }

                return const Placeholder();
              },
            ),
          ),
        );

        await pumpTesterForSize(tester, const Size.square(600));
        await pumpTesterForSize(tester, const Size.square(400));
        await pumpTesterForSize(tester, const Size.square(200));
      });
    });

    group('BuildContext', () {
      testWidgets(
        'Accessing common layout in context without a LayoutResolverInheritedWidget should throw',
        (tester) async {
          await tester.pumpWidget(
            Builder(
              builder: (context) {
                expect(() => context.commonLayout, throwsA(isA<StateError>()));

                return const Placeholder();
              },
            ),
          );
        },
      );

      testWidgets(
        'Accessing common layout in context with a LayoutResolverInheritedWidget of different type should throw',
        (tester) async {
          await tester.pumpWidget(
            LayoutResolverInheritedWidget(
              resolver: LayoutResolverMock(),
              child: Builder(
                builder: (context) {
                  expect(() => context.commonLayout, throwsA(isA<StateError>()));

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
