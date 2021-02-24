import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:layoutr/granular_layout.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// Used GranularLayout for the sake of the example, could use CommonLayout or even your custom layout resolver, nothing
// would change here.
final layoutProvider = Provider.family<GranularLayout, double>((ref, size) => GranularLayout(size));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: RiverpodHomePage());
  }
}

class RiverpodHomePage extends ConsumerWidget {
  const RiverpodHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final layout = watch(layoutProvider(context.deviceWidth));
    final textTheme = Theme.of(context).textTheme;

    final responsiveText = Text(
      'Responsive Text',
      style: layout.value(
        xxLarge: () => textTheme.headline2!.copyWith(color: Colors.red),
        large: () => textTheme.headline4!.copyWith(color: Colors.green),
        medium: () => textTheme.headline5!.copyWith(color: Colors.blue),
        small: () => textTheme.headline6!.copyWith(color: Colors.orange),
      ),
    );

    return Scaffold(
      body: Center(child: responsiveText),
    );
  }
}
