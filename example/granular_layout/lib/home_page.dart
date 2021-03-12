import 'package:flutter/material.dart';
import 'package:layoutr/granular_layout.dart';

import 'package:shared/shared.dart';

// This first page exemplifies the usage of the `granular_layout` with a Split-page structure: meaning that we create
// private sub-widgets for each layout (breakpoint), granular in more complex scenarios, to improve the "core" widget
// readability.
//
// Note: You can focus only on the usage of the `granular_layout` if you want to, the split-page structure is just an
// "architectural" suggestion to split widgets in a decent way, although there are a ton of other good approaches, just
// like the hybrid one in `details_page`.
//
// Also, the `SpacingMixin` makes the spacing-related operations less verbose
class HomePage extends StatelessWidget with SpacingMixin {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the `GranularLayout` existing in any parent of this widget tree
    final layout = context.granularLayout;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Splitted Page Structure'),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Column(
          children: [
            // Specifies a title that changes not only its style but also its text, based on the breakpoint
            layout.value(
              xxLarge: () => Text('xxLarge and xLarge layout', style: textTheme.headline2),
              large: () => Text('large only layout', style: textTheme.headline3),
              medium: () => Text('medium only layout', style: textTheme.headline5),
              small: () => Text('small only layout', style: textTheme.headline5),
              xSmall: () => const Text('xSmall only layout'),
            ),
            // This spacing will be responsive if multiple spacings have been specified for the respective breakpoints
            context.verticalBox(mediumSpacing),
            Expanded(
              child: SingleChildScrollView(
                // Creates a new widget for each layout. In this case, because xLarge is null, it will use the closest
                // value available: the `large`.
                child: layout.value(
                  xxLarge: () => _LargeHomeContents(
                    leftChildren: generateRandomContainers(amount: 120),
                    rightChildren: generateRandomContainers(amount: 40),
                  ),
                  large: () => _LargeHomeContents(
                    leftChildren: generateRandomContainers(amount: 80),
                    rightChildren: generateRandomContainers(amount: 20),
                  ),
                  medium: () => _HomeContents(children: generateRandomContainers(amount: 40)),
                  small: () => _CompactHomeContents(children: generateRandomContainers(amount: 20)),
                  xSmall: () => _CompactHomeContents(children: generateRandomContainers(amount: 8)),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/details');
        },
        child: const Icon(Icons.arrow_drop_up),
      ),
    ).withAllPadding(context, smallSpacing); // Helper to add padding, using a responsive Spacing
  }
}

class _LargeHomeContents extends StatelessWidget with SpacingMixin {
  const _LargeHomeContents({required this.leftChildren, required this.rightChildren, Key? key}) : super(key: key);
  final List<Widget> leftChildren;
  final List<Widget> rightChildren;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _HomeContents(children: leftChildren)),
        context.verticalBox(xxxLargeSpacing), // Creates a vertical spacing using a responsive spacing
        _CompactHomeContents(children: rightChildren),
      ],
    );
  }
}

class _HomeContents extends StatelessWidget with SpacingMixin {
  const _HomeContents({required this.children, Key? key}) : super(key: key);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      // Uses the raw value of the respective responsive spacings
      spacing: context.rawSpacing(xSmallSpacing),
      runSpacing: context.rawSpacing(mediumSpacing),
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}

class _CompactHomeContents extends StatelessWidget with SpacingMixin {
  const _CompactHomeContents({required this.children, Key? key}) : super(key: key);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      // Helper to add padding, using a responsive Spacing
      children: children.map((child) => child.withOnlyPadding(context, bottom: xxxSmallSpacing)).toList(),
    );
  }
}
