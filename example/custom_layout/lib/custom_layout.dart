import 'package:flutter/widgets.dart';
import 'package:layoutr/layoutr.dart';

// We've opted to use an enum because of the ease of use, but you can use literally any value as the
// LayoutResolver type (just be careful of implementing the `==` and `hashCode` properly).
enum CustomBreakpoint { big, medium, small }

// Our custom implementation of the [LayoutResolver]
class CustomLayout extends LayoutResolver<CustomBreakpoint> {
  CustomLayout(double size)
      : super(
          size: size,
          breakpoints: const [
            Breakpoint(800, value: CustomBreakpoint.big),
            Breakpoint(400, value: CustomBreakpoint.medium),
            // Note that the last breakpoint is always created from a `null` value, representing the smallest size.
            Breakpoint(null, value: CustomBreakpoint.small),
          ],
        );

  // These are simply utilities that may be used (or not) by our app

  bool get isBig => matchesValue(CustomBreakpoint.big);

  bool get isMediumOrLarger => matchesValueOrLarger(CustomBreakpoint.medium);
  bool get isMedium => matchesValue(CustomBreakpoint.medium);
  bool get isMediumOrSmaller => matchesValueOrSmaller(CustomBreakpoint.medium);

  bool get isSmall => matchesValueOrSmaller(CustomBreakpoint.small);

  // This is the "core" method of our custom implementation, just like `CommonLayout` and `GranularLayout` have.
  // This is just a helper to make a more robust (or "typed") behavior to access our `closestValue` logic.
  T value<T>({
    T Function()? big,
    T Function()? medium,
    T Function()? small,
  }) {
    if (big == null && medium == null && small == null) {
      throw ArgumentError('At least one breakpoint (big, medium or small) must be provided');
    }

    return closestValue({
      if (big != null) CustomBreakpoint.big: big(),
      if (medium != null) CustomBreakpoint.medium: medium(),
      if (small != null) CustomBreakpoint.small: small(),
    });
  }
}

// This is the widget that will wrap our `MaterialApp`/`WidgetsApp`, to provide the `CustomLayout` down the tree
//
// In this example, we are assuming that we want only to customize the layout - meaning that we won't use anything
// related to the spacing properties.
class CustomLayoutResolverWidget extends StatelessWidget {
  const CustomLayoutResolverWidget({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return LayoutResolverInheritedWidget(
          resolver: CustomLayout(constraints.maxWidth),
          child: child,
        );
      },
    );
  }

  static CustomLayout of(BuildContext context) {
    final resolverAncestor = context.dependOnInheritedWidgetOfExactType<LayoutResolverInheritedWidget>();
    return resolverAncestor!.resolver as CustomLayout;
  }
}

extension CustomLayoutWidgetExt on BuildContext {
  CustomLayout get customLayout => CustomLayoutResolverWidget.of(this);
}

// And this implementation of custom layout assumes that we could possibly have spacings for each breakpoint (not
// mandatory though).
class CustomLayoutResolverWithSpacingsWidget extends StatelessWidget {
  const CustomLayoutResolverWithSpacingsWidget({
    required this.child,
    this.bigSpacings,
    this.mediumSpacings,
    this.smallSpacings,
  });

  final RawSpacings? bigSpacings;
  final RawSpacings? mediumSpacings;
  final RawSpacings? smallSpacings;

  bool get _hasCustomSpacings => bigSpacings != null || mediumSpacings != null || smallSpacings != null;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolver = CustomLayout(constraints.maxWidth);

        final spacings = _hasCustomSpacings
            ? resolver.value(
                big: () => bigSpacings,
                medium: () => mediumSpacings,
                small: () => smallSpacings,
              )
            : null;

        return LayoutResolverInheritedWidget(
          resolver: resolver,
          // We have to also pass the SpacingsInheritedWidget down the tree, otherwise the nested context won't know
          // about it.
          child: SpacingsInheritedWidget(spacings: spacings, child: child),
        );
      },
    );
  }

  static CustomLayout of(BuildContext context) {
    final resolverAncestor = context.dependOnInheritedWidgetOfExactType<LayoutResolverInheritedWidget>();
    return resolverAncestor!.resolver as CustomLayout;
  }
}
