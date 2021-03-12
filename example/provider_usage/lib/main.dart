import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:layoutr/common_layout.dart';

void main() {
  runApp(const ProviderUsageExample());
}

class ProviderUsageExample extends StatelessWidget {
  const ProviderUsageExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap in a LayoutBuilder to use the constraints of the device, because we don't have `MediaQuery` available before
    // a `MaterialApp`
    return LayoutBuilder(
      builder: (context, constraints) {
        // Used `CommonLayout` for the sake of the example, could use `GranularLayout` or even your custom layout
        // resolver, nothing would change here.
        final resolver = CommonLayout(constraints.maxWidth);
        return Provider.value(
          value: resolver,
          child: const MaterialApp(
            home: ProviderHomePage(),
          ),
        );
      },
    );
  }
}

class ProviderHomePage extends StatelessWidget {
  const ProviderHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<CommonLayout>();
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
