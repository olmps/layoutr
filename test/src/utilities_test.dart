import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:layoutr/src/spacing.dart';
import 'package:layoutr/src/spacings_widget.dart';
import 'package:layoutr/src/utilities.dart';

void main() {
  testWidgets(
    'rawSpacing should correctly match spacing with the respective `RawSpacings`',
    (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            const defaultSpacings = SpacingsInheritedWidget.defaultSpacings;
            final xxxLarge = context.rawSpacing(Spacing.xxxLarge);
            final xxLarge = context.rawSpacing(Spacing.xxLarge);
            final xLarge = context.rawSpacing(Spacing.xLarge);
            final large = context.rawSpacing(Spacing.large);
            final medium = context.rawSpacing(Spacing.medium);
            final small = context.rawSpacing(Spacing.small);
            final xSmall = context.rawSpacing(Spacing.xSmall);
            final xxSmall = context.rawSpacing(Spacing.xxSmall);
            final xxxSmall = context.rawSpacing(Spacing.xxxSmall);

            expect(xxxLarge, defaultSpacings.xxxLarge);
            expect(xxLarge, defaultSpacings.xxLarge);
            expect(xLarge, defaultSpacings.xLarge);
            expect(large, defaultSpacings.large);
            expect(medium, defaultSpacings.medium);
            expect(small, defaultSpacings.small);
            expect(xSmall, defaultSpacings.xSmall);
            expect(xxSmall, defaultSpacings.xxSmall);
            expect(xxxSmall, defaultSpacings.xxxSmall);

            return const Placeholder();
          },
        ),
      );
    },
  );

  testWidgets(
    'horizontalBox should create a SizedBox only with its matching width',
    (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final rawWidth = SpacingsInheritedWidget.defaultSpacings.medium;
            final sizedBox = context.horizontalBox(Spacing.medium);

            expect(sizedBox.width, rawWidth);
            expect(sizedBox.height, null);

            return const Placeholder();
          },
        ),
      );
    },
  );

  testWidgets(
    'verticalBox should create a SizedBox only with its matching height',
    (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final rawHeight = SpacingsInheritedWidget.defaultSpacings.medium;
            final sizedBox = context.verticalBox(Spacing.medium);

            expect(sizedBox.height, rawHeight);
            expect(sizedBox.width, null);

            return const Placeholder();
          },
        ),
      );
    },
  );
}
