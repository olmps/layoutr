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

class CustomLayoutWidget extends InheritedWidget {
  const CustomLayoutWidget({
    required this.resolver,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  final CustomLayout resolver;

  @override
  bool updateShouldNotify(CustomLayoutWidget oldWidget) => oldWidget.resolver != resolver;

  static CustomLayout of(BuildContext context) {
    final resolverAncestor = context.dependOnInheritedWidgetOfExactType<CustomLayoutWidget>();
    return resolverAncestor?.resolver ?? CustomLayout(context.deviceWidth);
  }
}

extension CustomLayoutWidgetExt on BuildContext {
  CustomLayout get customLayout => CustomLayoutWidget.of(this);
}
