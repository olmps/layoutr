import 'package:flutter/material.dart';
import 'package:layoutr/granular_layout.dart';

// Unlike `home_page`, this page structures the usage with a Hybrid structure: meaning that we have the same entry-point
// (in this case, the `build` function) to fit all of our use cases. Good in simpler scenarios where you won't have a
// ton of different layouts for a couple of breakpoints.
class DetailsPage extends StatelessWidget with SpacingMixin {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the `GranularLayout` existing in any parent of this widget tree
    final layout = context.granularLayout;

    const showText = 'Show Snack';
    const showIcon = Icon(Icons.message);

    // Element that will be used in smaller devices
    final mobileFab = FloatingActionButton(
      onPressed: () => _displaySnackbar(context),
      tooltip: showText,
      child: showIcon,
    );

    // Element that will be used in larger devices
    final largeButton = OutlinedButton.icon(
      onPressed: () => _displaySnackbar(context),
      icon: showIcon,
      label: const Text(showText),
    );

    const pageTitle = 'Hybrid Page Structure';

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // This app bar will only exist in layouts that are equal to a medium breakpoint or smaller ...
      appBar: layout.isMediumOrSmaller
          ? AppBar(
              title: const Text(pageTitle),
            )
          : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ... and we will, instead, add a big title for large breakpoints (or larger)
            if (layout.isLargeOrLarger) ...[
              Text(pageTitle, style: textTheme.headline3),
              context.verticalBox(xxxLargeSpacing), // Creates a vertical spacing using a responsive spacing
            ],
            Text(
              'This is a granular responsive text!',
              style: layout.value(
                xxLarge: () => textTheme.headline2!.copyWith(color: Colors.deepOrange),
                xLarge: () => textTheme.headline3!.copyWith(color: Colors.indigo),
                large: () => textTheme.headline4!.copyWith(color: Colors.lime),
                medium: () => textTheme.headline5!.copyWith(color: Colors.deepPurple),
                small: () => textTheme.headline6!.copyWith(color: Colors.teal),
                xSmall: () => textTheme.subtitle2!.copyWith(color: Colors.yellow),
              ),
            ),
            if (layout.isMediumOrLarger) largeButton,
          ],
        ),
      ),
      floatingActionButton: layout.isSmallOrSmaller ? mobileFab : null,
    );
  }

  void _displaySnackbar(BuildContext context) {
    final layout = context.granularLayout;
    final textTheme = Theme.of(context).textTheme;

    final snackBarTextStyle = layout.isSmallOrSmaller ? textTheme.bodyText2 : textTheme.subtitle1;
    final snackBarText = Text(
      'A responsive text inside the SnackBar!',
      style: snackBarTextStyle?.copyWith(color: Colors.white),
    );
    final snackBar = SnackBar(content: snackBarText);

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
