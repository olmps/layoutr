import 'package:flutter/material.dart';
import 'package:responsive_layout/common_layout.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final showText = 'Show Snack';
    final showIcon = Icon(Icons.message);

    final mobileFab = FloatingActionButton(
          onPressed: () => _displaySnackbar(context),
          tooltip: showText,
          child: showIcon,
    );

    final desktopButton = OutlinedButton.icon(onPressed: () => _displaySnackbar(context), icon: showIcon, label: Text(showText),);
    
    final pageTitle = 'Hybrid Details';

    return Scaffold(
      appBar: context.isTabletOrSmaller ? AppBar(
        title: Text(pageTitle),
      ) : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (context.isDesktop) Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(pageTitle, style: Theme.of(context).textTheme.headline3,),
            ),
            Text(
              'This is a responsive text!',
              style: context.isPhoneOrSmaller ? Theme.of(context).textTheme.headline6 : Theme.of(context).textTheme.headline5,
            ),
            if (context.isTabletOrLarger) desktopButton,
          ],
        ),
      ),
      floatingActionButton: context.isPhoneOrSmaller ? mobileFab : null,
    );
  }

  void _displaySnackbar(BuildContext context) {
    final snackBarTextStyle = context.isPhoneOrSmaller ? Theme.of(context).textTheme.bodyText2 : Theme.of(context).textTheme.subtitle1;

    final snackBarText = Text('A responsive text inside the SnackBar!', style: snackBarTextStyle?.copyWith(color: Colors.white));
    final snackBar = SnackBar(content: snackBarText);

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
