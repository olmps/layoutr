import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:layoutr/common_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        // We use value here because we must "update" the Provider whenever the context changes, as it may have updated
        // the device orientation/screen resizes.
        return Provider.value(
          // Used CommonLayout for the sake of the example, could use GranularLayout or even your custom layout
          // resolver, nothing would change here.
          value: CommonLayout(context.deviceWidth),
          child: child,
        );
      },
      home: const ProviderHomePage(),
    );
  }
}

class ProviderHomePage extends StatelessWidget {
  const ProviderHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layout = Provider.of<CommonLayout>(context);
    final textTheme = Theme.of(context).textTheme;

    final responsiveText = Text(
      'Responsive Text',
      style: layout.value(
        desktop: () => textTheme.headline3!.copyWith(color: Colors.red),
        tablet: () => textTheme.headline4!.copyWith(color: Colors.green),
        phone: () => textTheme.headline6!.copyWith(color: Colors.blue),
      ),
    );

    return Scaffold(
      body: Center(child: responsiveText),
    );
  }
}
