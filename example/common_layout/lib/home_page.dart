import 'package:flutter/material.dart';
import 'package:layoutr/common_layout.dart';

import 'package:shared/shared.dart';
import 'package:common_layout/details_page.dart';

// This first page exemplifies the usage of the `common_layout` with a Split-page structure: meaning that we create
// private sub-widgets for each layout (breakpoint), common in more complex scenarios, to improve the "core" widget
// readability.
//
// Note: You can focus only on the usage of the `common_layout` if you want to, the split-page structure is just an
// "architectural" suggestion to split widgets in a decent way, although there are a ton of other good approaches, just
// like the hybrid one in `details_page`.
//
// Also, the `SpacingMixin` makes the spacing-related operations less verbose
class HomePage extends StatelessWidget with SpacingMixin {
  @override
  Widget build(BuildContext context) {
    // Get the `CommonLayout` existing in any parent of this widget tree
    final layout = context.commonLayout;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Splitted Page Structure'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                  builder: (context) => DetailsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Column(
          children: [
            // Specifies a title that changes not only its style but also its text, based on the breakpoint
            layout.value(
              desktop: () => Text('Desktop layout', style: textTheme.headline1),
              tablet: () => Text('Tablet layout', style: textTheme.headline3),
              phone: () => Text('Phone layout', style: textTheme.headline4),
              tinyHardware: () => Text('Tiny Hardware layout', style: textTheme.headline6),
            ),
            // This spacing will be responsive if multiple spacings have been specified for the respective breakpoints
            context.verticalBox(mediumSpacing),
            Expanded(
              child: SingleChildScrollView(
                // Creates a new widget for each layout. In this case, because tinyHardware is null, it will use the
                // closest value available: the `phone`.
                child: layout.value(
                  desktop: () => _HomeContents(children: generateRandomContainers(amount: 100)),
                  tablet: () => _HomeContents(children: generateRandomContainers(amount: 40)),
                  phone: () => _CompactHomeContents(children: generateRandomContainers(amount: 20)),
                ),
              ),
            ),
          ],
        ),
      ).withAllPadding(context, smallSpacing), // Helper to add padding, using a responsive Spacing
    );
  }
}

// The widget that will be displayed when we have more space to do so.
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

// The widget that will be displayed for smaller screens, where we don't much space horizontally.
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
