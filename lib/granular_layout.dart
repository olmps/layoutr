import 'package:flutter/widgets.dart';
import 'package:layoutr/layoutr.dart';

export 'layoutr.dart' show BuildContextUtilities;

enum GranularBreakpoint { xxLarge, xLarge, large, medium, small, xSmall }

/// A granular set of breakpoints, commonly used in applications that requires a more fine-grained layout.
///
/// See also:
///   - [LayoutResolver] - the base class used to create any type of layout, like a custom one.
class GranularLayout extends LayoutResolver<GranularBreakpoint> {
  /// Creates a [GranularLayout] with the respective breakpoint sizes, each representing a [Breakpoint] instance of
  /// value type `GranularBreakpoint`.
  GranularLayout(
    double size, {
    int xxLarge = 1600,
    int xLarge = 1200,
    int large = 769,
    int medium = 481,
    int small = 321,
  })  : assert(xxLarge > xLarge),
        assert(xLarge > large),
        assert(large > medium),
        assert(medium > small),
        super(
          size: size,
          breakpoints: [
            Breakpoint(xxLarge, value: GranularBreakpoint.xxLarge),
            Breakpoint(xLarge, value: GranularBreakpoint.xLarge),
            Breakpoint(large, value: GranularBreakpoint.large),
            Breakpoint(medium, value: GranularBreakpoint.medium),
            Breakpoint(small, value: GranularBreakpoint.small),
            // Note that the last breakpoint is always created from a `null` value, representing the smallest possible
            // size, which in this case is [GranularBreakpoint.xSmall], and this occurs to be the [breakpointValue]
            // when the [size] argument is smaller than the [small] breakpoint.
            const Breakpoint(null, value: GranularBreakpoint.xSmall),
          ],
        );

  // Helpers

  /// `true` if the current [breakpointValue] exactly matches [GranularBreakpoint.xxLarge]
  bool get isXXLarge => matchesValue(GranularBreakpoint.xxLarge);

  /// `true` if the current [breakpointValue] matches [GranularBreakpoint.xLarge] or a larger breakpoint
  bool get isXLargeOrLarger => matchesValueOrLarger(GranularBreakpoint.xLarge);

  /// `true` if the current [breakpointValue] exactly matches [GranularBreakpoint.xLarge]
  bool get isXLarge => matchesValue(GranularBreakpoint.xLarge);

  /// `true` if the current [breakpointValue] matches [GranularBreakpoint.xLarge] or a smaller breakpoint
  bool get isXLargeOrSmaller => matchesValueOrSmaller(GranularBreakpoint.xLarge);

  /// `true` if the current [breakpointValue] matches [GranularBreakpoint.large] or a larger breakpoint
  bool get isLargeOrLarger => matchesValueOrLarger(GranularBreakpoint.large);

  /// `true` if the current [breakpointValue] exactly matches [GranularBreakpoint.large]
  bool get isLarge => matchesValue(GranularBreakpoint.large);

  /// `true` if the current [breakpointValue] matches [GranularBreakpoint.large] or a smaller breakpoint
  bool get isLargeOrSmaller => matchesValueOrSmaller(GranularBreakpoint.large);

  /// `true` if the current [breakpointValue] matches [GranularBreakpoint.medium] or a larger breakpoint
  bool get isMediumOrLarger => matchesValueOrLarger(GranularBreakpoint.medium);

  /// `true` if the current [breakpointValue] exactly matches [GranularBreakpoint.medium]
  bool get isMedium => matchesValue(GranularBreakpoint.medium);

  /// `true` if the current [breakpointValue] matches [GranularBreakpoint.medium] or a smaller breakpoint
  bool get isMediumOrSmaller => matchesValueOrSmaller(GranularBreakpoint.medium);

  /// `true` if the current [breakpointValue] matches [GranularBreakpoint.small] or a larger breakpoint
  bool get isSmallOrLarger => matchesValueOrLarger(GranularBreakpoint.small);

  /// `true` if the current [breakpointValue] exactly matches [GranularBreakpoint.small]
  bool get isSmall => matchesValue(GranularBreakpoint.small);

  /// `true` if the current [breakpointValue] matches [GranularBreakpoint.small] or a smaller breakpoint
  bool get isSmallOrSmaller => matchesValueOrSmaller(GranularBreakpoint.small);

  /// `true` if the current [breakpointValue] exactly matches [GranularBreakpoint.xSmall]
  bool get isXSmall => matchesValue(GranularBreakpoint.xSmall);

  /// Builds the most suitable `T` depending on the current [breakpoint].
  ///
  /// Throws an [ArgumentError] if no argument is provided.
  ///
  /// Because all of the builders are optional, the current [breakpoint] may not be supplied, meaning that we will
  /// always default to the smallest builder available in such cases.
  ///
  /// ### Example:
  ///
  /// The current [breakpoint] value is `GranularBreakpoint.medium` and we make the following call:
  /// ```
  /// final granularLayout = context.granularLayout; // Get this context from somewhere
  /// final text = value(
  ///   xxLarge: () => 'Text for xxlarge!',
  ///   xLarge: () => 'Text for xLarge!',
  ///   large: () => 'Text for large or smaller',
  /// );
  /// final responsiveText = Text();
  /// ```
  ///
  /// We will first check, respectively, if there is a `medium`, `small`, then a `xSmall` provided. In this case,
  /// because none is available, we will have to get the smallest available from the remaining, in this case, returning
  /// the `large`s builder value, the smallest of the available supplied builders.
  T value<T>({
    T Function()? xxLarge,
    T Function()? xLarge,
    T Function()? large,
    T Function()? medium,
    T Function()? small,
    T Function()? xSmall,
  }) {
    if (xxLarge == null && xLarge == null && large == null && medium == null && small == null && xSmall == null) {
      throw ArgumentError('At least one breakpoint (xxLarge, xLarge, large, medium, small or xSmall) must be provided');
    }

    return closestValue({
      if (xxLarge != null) GranularBreakpoint.xxLarge: xxLarge(),
      if (xLarge != null) GranularBreakpoint.xLarge: xLarge(),
      if (large != null) GranularBreakpoint.large: large(),
      if (medium != null) GranularBreakpoint.medium: medium(),
      if (small != null) GranularBreakpoint.small: small(),
      if (xSmall != null) GranularBreakpoint.xSmall: xSmall(),
    });
  }
}

class GranularLayoutWidget extends InheritedWidget {
  const GranularLayoutWidget({
    required this.resolver,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  final GranularLayout resolver;

  @override
  bool updateShouldNotify(GranularLayoutWidget oldWidget) => oldWidget.resolver != resolver;

  /// The resolver (`GranularLayout`) from the closest [GranularLayoutWidget] instance that encloses the given [context].
  ///
  /// If no ancestor is found, defaults to a new [GranularLayout] instance using the `context.deviceWidth`.
  static GranularLayout of(BuildContext context) {
    final resolverAncestor = context.dependOnInheritedWidgetOfExactType<GranularLayoutWidget>();

    // TODO(matuella): Is it returning an optional because it's not available in the ancestors, or for some other
    // reason?
    // Commented in https://github.com/flutter/flutter/issues/73423, let's see how it turns out.
    return resolverAncestor?.resolver ?? GranularLayout(context.deviceWidth);
  }
}

extension GranularLayoutWidgetExt on BuildContext {
  GranularLayout get granularLayout => GranularLayoutWidget.of(this);
}
