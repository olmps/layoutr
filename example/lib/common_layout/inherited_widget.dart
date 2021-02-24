import 'package:flutter/material.dart';

import 'package:layoutr_example/common_layout/pages/home.dart';
import 'package:layoutr_example/common_layout/pages/details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Nothing out of the ordinary here, we are using the default value supplied by `CommonLayoutWidget` in our nested
    // pages
    return MaterialApp(
      initialRoute: '/',
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
