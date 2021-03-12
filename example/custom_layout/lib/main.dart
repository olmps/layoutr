import 'package:custom_layout/custom_layout.dart';
import 'package:flutter/material.dart';

void main() {
  // Creates a custom layout implementation and pass it down as a "root" inherited widget. You can check out the
  // implementation in `custom_layout.dart`
  //
  // We could also use the `CustomLayoutResolverWithSpacingsWidget` example if we wanted to use custom spacings.
  runApp(
    CustomLayoutResolverWidget(
      child: MaterialApp(
        home: CustomLayoutExample(),
      ),
    ),
  );
}

class CustomLayoutExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final layout = context.customLayout;
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
