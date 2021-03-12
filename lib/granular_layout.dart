import 'package:flutter/widgets.dart';
import 'package:layoutr/layoutr.dart';

export 'layoutr.dart'
    show BuildContextUtilities, SpacingMixin, SpacingHelpers, SpacingPaddingHelpers, Spacing, RawSpacings;

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
  T value<T extends Object>({
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

  /// Proxies the call to [value] but allows all arguments to be `null`
  ///
  /// When not a single argument is non-nullable, instead of throwing, returns a `null` instead.
  T? maybeValue<T extends Object>({
    T Function()? xxLarge,
    T Function()? xLarge,
    T Function()? large,
    T Function()? medium,
    T Function()? small,
    T Function()? xSmall,
  }) {
    if (xxLarge == null && xLarge == null && large == null && medium == null && small == null && xSmall == null) {
      return null;
    }

    return value(xxLarge: xxLarge, xLarge: xLarge, large: large, medium: medium, small: small, xSmall: xSmall);
  }
}

/// Provides its [child] with both [GranularLayout] and the breakpoint-specific [RawSpacings]
///
/// All [RawSpacings] are optional and if none is provided, it uses the default values found in
/// [SpacingsInheritedWidget.defaultSpacings].
/// These spacings act like an auxiliar set of fields that:
/// - help the related code to be less prone to hardcoded values (provides type-safety with the usage of [Spacing]);
/// - alongside the provided utilities, makes handling spacings less verbose by handling the proxying the logic to this
/// instance's resolver.
///
/// Because [GranularLayoutWidget] uses a `LayoutBuilder` to get its device constraints, no `MaterialApp` (or
/// `MediaQueryData`) is required above/below this widget.
class GranularLayoutWidget extends StatelessWidget {
  /// Creates a `GranularLayoutWidget` with a single default [spacings] for all breakpoints
  ///
  /// If [spacings] argument is provided, all the respective breakpoint's spacings should be the same. If you want to
  /// specify each breakpoint spacing, use the [GranularLayoutWidget.withResponsiveSpacings] constructor.
  ///
  /// To override with your own [GranularLayout], use the [resolverBuilder] argument.
  const GranularLayoutWidget({required this.child, this.resolverBuilder, RawSpacings? spacings})
      : xxLargeSpacings = spacings,
        xLargeSpacings = spacings,
        largeSpacings = spacings,
        mediumSpacings = spacings,
        smallSpacings = spacings,
        xSmallSpacings = spacings;

  /// Creates a `GranularLayoutWidget` with specified breakpoints spacings
  ///
  /// If not all spacings are provided, it uses the same [GranularLayout.value] logic to pick the closest and most
  /// suitable. If you want to a single spacing for all breakpoints, use the default constructor.
  ///
  /// To override with your own [GranularLayout], use the [resolverBuilder] argument.
  const GranularLayoutWidget.withResponsiveSpacings({
    required this.child,
    this.resolverBuilder,
    this.xxLargeSpacings,
    this.xLargeSpacings,
    this.largeSpacings,
    this.mediumSpacings,
    this.smallSpacings,
    this.xSmallSpacings,
  });

  /// Provides a `BoxConstraints` to build this widget's resolver
  final GranularLayout Function(BoxConstraints deviceConstraints)? resolverBuilder;

  /// Spacings corresponding to the [GranularBreakpoint.xxLarge]
  final RawSpacings? xxLargeSpacings;

  /// Spacings corresponding to the [GranularBreakpoint.xLarge]
  final RawSpacings? xLargeSpacings;

  /// Spacings corresponding to the [GranularBreakpoint.large]
  final RawSpacings? largeSpacings;

  /// Spacings corresponding to the [GranularBreakpoint.medium]
  final RawSpacings? mediumSpacings;

  /// Spacings corresponding to the [GranularBreakpoint.small]
  final RawSpacings? smallSpacings;

  /// Spacings corresponding to the [GranularBreakpoint.xSmall]
  final RawSpacings? xSmallSpacings;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolver = resolverBuilder?.call(constraints) ?? GranularLayout(constraints.maxWidth);

        // Applies the same logic of `closestValue` to the spacings, because not all may be provided
        final spacings = resolver.value(
          xxLarge: xxLargeSpacings != null ? () => xxLargeSpacings! : null,
          xLarge: xLargeSpacings != null ? () => xLargeSpacings! : null,
          large: largeSpacings != null ? () => largeSpacings! : null,
          medium: mediumSpacings != null ? () => mediumSpacings! : null,
          small: smallSpacings != null ? () => smallSpacings! : null,
          xSmall: xSmallSpacings != null ? () => xSmallSpacings! : null,
        );

        return LayoutResolverInheritedWidget(
          resolver: resolver,
          child: SpacingsInheritedWidget(spacings: spacings, child: child),
        );
      },
    );
  }

  /// The resolver (`GranularLayout`) from the closest [GranularLayoutWidget] instance that encloses the given
  /// [context].
  static GranularLayout of(BuildContext context) {
    final resolverAncestor = context.dependOnInheritedWidgetOfExactType<LayoutResolverInheritedWidget>();

    if (resolverAncestor == null) {
      throw StateError('No ancestor with `LayoutResolverInheritedWidget` (of type GranularLayout)');
    }

    final resolver = resolverAncestor.resolver;
    if (resolver is! GranularLayout) {
      throw StateError(
        'Found `LayoutResolverInheritedWidget` ancestor of type ${resolver.runtimeType}. Expected a `GranularLayout`.',
      );
    }

    return resolver;
  }
}

extension GranularLayoutWidgetExt on BuildContext {
  GranularLayout get granularLayout => GranularLayoutWidget.of(this);
}
