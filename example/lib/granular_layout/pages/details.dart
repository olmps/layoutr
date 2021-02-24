import 'package:flutter/material.dart';
import 'package:layoutr/granular_layout.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      appBar: layout.isMediumOrSmaller
          ? AppBar(
              title: const Text(pageTitle),
            )
          : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (layout.isLargeOrLarger)
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text(pageTitle, style: textTheme.headline3),
              ),
            Text(
              'This is a granular responsive text!',
              style: layout.value(
                xxLarge: () => textTheme.headline2?.copyWith(color: Colors.deepOrange),
                xLarge: () => textTheme.headline3?.copyWith(color: Colors.indigo),
                large: () => textTheme.headline4?.copyWith(color: Colors.lime),
                medium: () => textTheme.headline5?.copyWith(color: Colors.deepPurple),
                small: () => textTheme.headline6?.copyWith(color: Colors.teal),
                xSmall: () => textTheme.subtitle2?.copyWith(color: Colors.yellow),
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
