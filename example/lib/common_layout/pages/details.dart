import 'package:flutter/material.dart';
import 'package:layoutr/common_layout.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      appBar: layout.isTabletOrSmaller
          ? AppBar(
              title: const Text(pageTitle),
            )
          : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (layout.isDesktop)
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text(pageTitle, style: textTheme.headline3),
              ),
            Text(
              'This is a responsive text!',
              style: layout.value(
                desktop: () => textTheme.headline4?.copyWith(color: Colors.indigo),
                tablet: () => textTheme.headline5?.copyWith(color: Colors.deepPurple),
                tinyHardware: () => textTheme.headline6?.copyWith(color: Colors.teal),
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
