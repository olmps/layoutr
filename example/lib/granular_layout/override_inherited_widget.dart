import 'package:flutter/material.dart';
import 'package:layoutr/granular_layout.dart';

import 'package:layoutr_example/granular_layout/pages/home.dart';
import 'package:layoutr_example/granular_layout/pages/details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      // We decided to use the width of the device, but there are some cases where using the smallest dimension is
      // required, so simply change the:
      // `GranularLayout(context.deviceWidth)`
      //  for
      // `GranularLayout(context.deviceWidth > context.deviceHeight ? context.deviceHeight : context.deviceWidth)`
      //
      // Override a `GranularLayout` with a custom breakpoint
      builder: (context, child) => GranularLayoutWidget(
        resolver: GranularLayout(context.deviceWidth, xLarge: 993, large: 681),
        child: child!,
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute<dynamic>(builder: (context) => const HomePage());
          case '/details':
            return MaterialPageRoute<dynamic>(builder: (context) => const DetailsPage(), fullscreenDialog: true);
          default:
            throw ArgumentError.value(settings.name, 'No route for such name');
        }
      },
    );
  }
}
