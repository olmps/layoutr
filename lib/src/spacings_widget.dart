import 'package:layoutr/src/spacing.dart';

import 'package:flutter/widgets.dart';

/// Provides a [RawSpacings] instance to all nested widgets
class SpacingsInheritedWidget extends InheritedWidget {
  const SpacingsInheritedWidget({required Widget child, this.spacings, Key? key}) : super(key: key, child: child);

  static const defaultSpacings = RawSpacings(4, 8, 12, 16, 20, 24, 28, 32, 36);
  final RawSpacings? spacings;

  @override
  bool updateShouldNotify(covariant SpacingsInheritedWidget oldWidget) => oldWidget.spacings == spacings;

  /// The closest [RawSpacings] instance that encloses the given [context].
  ///
  /// If no ancestor is found, defaults to the [defaultSpacings] instance
  static RawSpacings of(BuildContext context) {
    final resolverAncestor = context.dependOnInheritedWidgetOfExactType<SpacingsInheritedWidget>();
    return resolverAncestor?.spacings ?? defaultSpacings;
  }
}
