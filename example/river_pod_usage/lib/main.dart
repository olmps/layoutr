import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:layoutr/granular_layout.dart';

void main() {
  runApp(const RiverpodUsageExample());
}

// Using `GranularLayout` for the sake of the example, could use `CommonLayout` or even your custom layout resolver,
// nothing would change here.
//
// You could also:
// 1. Implement/override as a `Provider`, but it would only work in the root `ProviderScope`:
// final layoutProvider = Provider<GranularLayout>((ref) => throw StateError('Provider not overridden in root ProviderScope'));
//
// 2. Implement/override as a `Provider.family`, but you would need to pass the device dimension everytime you wanted
// to use it.
// final layoutProvider = Provider.family<GranularLayout, double>((ref, size) => GranularLayout(size));
//
// and to call it in `build`:
// final layout = watch(layoutProvider(context.deviceWidth))
final layoutProvider = ScopedProvider<GranularLayout>(null);

class RiverpodUsageExample extends StatelessWidget {
  const RiverpodUsageExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap in a LayoutBuilder to use the constraints of the device, because we don't have `MediaQuery` available before
    // a `MaterialApp`
    return LayoutBuilder(
      builder: (context, constraints) {
        final granularLayout = GranularLayout(constraints.maxWidth);

        return ProviderScope(
          overrides: [layoutProvider.overrideWithValue(granularLayout)],
          child: MaterialApp(
            home: RiverpodHomePage(),
          ),
        );
      },
    );
  }
}

class RiverpodHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final layout = watch(layoutProvider);
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
