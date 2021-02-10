import 'package:flutter/widgets.dart';
import 'package:responsive_layout/src/layout_resolver.dart';

class LayoutResolverWidget extends InheritedWidget {
  const LayoutResolverWidget({required this.resolver, required Widget child}): super(child: child);

  final LayoutResolver resolver;

  @override
  bool updateShouldNotify(LayoutResolverWidget oldWidget) => oldWidget.resolver != resolver;

  // TODO: Can I use the bang operator here? Why is it returning an optional?
  static LayoutResolverWidget of(BuildContext context) {
    final resolverAncestor = context.dependOnInheritedWidgetOfExactType<LayoutResolverWidget>();
    if (resolverAncestor != null) {
      return resolverAncestor;
    }


    throw 'No `LayoutResolverWidget` found in the ancestors of this widget of type `${context.widget.runtimeType}`';
  }
}