import 'package:flutter/material.dart';
import 'package:layoutr/granular_layout.dart';

import 'package:granular_layout/home_page.dart';

void main() {
  runApp(GranularLayoutExample());
}

class GranularLayoutExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ideally you should put this above your `MaterialApp`, because then, new routes will always have this inherited
    // widget available. Then, be careful: you can add this anywhere into your widget tree, although it will calculate
    // the breakpoints based on the space available up to that point in the tree.
    //
    // This is the default implementation for GranularLayout - it has both `resolverBuilder` and `spacings` default
    // values.
    // Uncomment both `resolverBuilder` and `spacings` to override the default values with your custom.
    //
    // For custom spacings, you can use the `withResponsiveSpacings` constructor and add specific spacings for
    // each breakpoint, although this is a completely optional utility to the "core" resolver.
    // If a breakpoint is not supplied, it follows the same logic as the layout resolver: it finds the closest matching
    // (and suitable) value available.
    //
    // Example using custom spacings:
    //
    // return GranularLayoutWidget.withResponsiveSpacings(
    //   xLargeSpacings: RawSpacings(8, 16, 24, 32, 40, 52, 60, 68, 80),
    //   smallSpacings: RawSpacings(4, 8, 12, 20, 28, 36, 40, 48, 60),
    //   xSmallSpacings: RawSpacings(2, 4, 8, 12, 16, 20, 28, 32, 40),
    //   child: MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()),
    // );
    return const GranularLayoutWidget(
      // resolverBuilder: (constraints) => GranularLayout(constraints.maxWidth, xLarge: 993, large: 681),
      // If you pass the `spacings` argument, it will override the default spacing for all breakpoints.
      // spacings: const RawSpacings(4, 12, 20, 24, 32, 40, 48, 56, 60),
      child: MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()),
    );
  }
}
