import 'package:flutter/material.dart';
import 'package:layoutr/common_layout.dart';

// Unlike `home_page`, this page structures the usage with a Hybrid structure: meaning that we have the same entry-point
// (in this case, the `build` function) to fit all of our use cases. Good in simpler scenarios where you won't have a
// ton of different layouts for a couple of breakpoints.
class DetailsPage extends StatelessWidget with SpacingMixin {
  @override
  Widget build(BuildContext context) {
    // Get the `CommonLayout` existing in any parent of this widget tree
    final layout = context.commonLayout;

    const showText = 'Show Snack';
    const showIcon = Icon(Icons.message);

    // Element that will be used in mobile or smaller devices
    final mobileFab = FloatingActionButton(
      onPressed: () => _displaySnackbar(context),
      tooltip: showText,
      child: showIcon,
    );

    // Element that will be used in desktop or bigger devices
    final desktopButton = OutlinedButton.icon(
      onPressed: () => _displaySnackbar(context),
      icon: showIcon,
      label: const Text(showText),
    );

    const pageTitle = 'Hybrid Page Structure';

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // This app bar will only exist in layouts that are equal to a tablet or smaller ...
      appBar: layout.isTabletOrSmaller
          ? AppBar(
              title: const Text(pageTitle),
            )
          : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ... and we will, instead, add a big title for desktop or larger breakpoints
            if (layout.isDesktop) ...[
              Text(pageTitle, style: textTheme.headline3),
              context.verticalBox(xxxLargeSpacing), // Creates a vertical spacing using a responsive spacing
            ],
            Text(
              'This is a responsive text!',
              style: layout.value(
                desktop: () => textTheme.headline4!.copyWith(color: Colors.indigo),
                tablet: () => textTheme.headline5!.copyWith(color: Colors.deepPurple),
                tinyHardware: () => textTheme.headline6!.copyWith(color: Colors.teal),
              ),
            ),
            if (layout.isTabletOrLarger) desktopButton,
          ],
        ),
      ),
      floatingActionButton: layout.isPhoneOrSmaller ? mobileFab : null,
    );
  }

  void _displaySnackbar(BuildContext context) {
    final layout = context.commonLayout;
    final textTheme = Theme.of(context).textTheme;

    final snackBarTextStyle = layout.isPhoneOrSmaller ? textTheme.bodyText2 : textTheme.subtitle1;
    final snackBarText = Text(
      'A responsive text inside the SnackBar!',
      style: snackBarTextStyle?.copyWith(color: Colors.white),
    );
    final snackBar = SnackBar(content: snackBarText);

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
