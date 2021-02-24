import 'package:flutter/material.dart';

import 'package:layoutr_example/custom_layout/custom_layout.dart';

void main() {
  runApp(const MaterialApp(home: CustomLayoutApp()));
}

class CustomLayoutApp extends StatelessWidget {
  const CustomLayoutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layout = CustomLayoutWidget.of(context);
    final textTheme = Theme.of(context).textTheme;

    final responsiveText = Text(
      'Responsive Text',
      style: layout.value(
        big: () => textTheme.headline3!.copyWith(color: Colors.red),
        medium: () => textTheme.headline4!.copyWith(color: Colors.green),
        small: () => textTheme.headline6!.copyWith(color: Colors.blue),
      ),
    );

    return Scaffold(
      body: Center(child: responsiveText),
    );
  }
}
