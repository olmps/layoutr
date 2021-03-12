import 'package:layoutr/src/layout_resolver.dart';

import 'package:flutter/widgets.dart';

/// Provides a [LayoutResolver] instance to all nested widgets
///
/// This should be usually used alongside a LayoutResolver implementation, to better define the related types to the
/// associated [LayoutResolver].
class LayoutResolverInheritedWidget extends InheritedWidget {
  const LayoutResolverInheritedWidget({
    required this.resolver,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  final LayoutResolver resolver;

  @override
  bool updateShouldNotify(LayoutResolverInheritedWidget oldWidget) => oldWidget.resolver != resolver;
}
