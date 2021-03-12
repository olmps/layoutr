import 'package:layoutr/layoutr.dart';

import 'package:flutter/widgets.dart';

export 'layoutr.dart'
    show BuildContextUtilities, SpacingMixin, SpacingHelpers, SpacingPaddingHelpers, Spacing, RawSpacings;

enum CommonBreakpoint { desktop, tablet, phone, tinyHardware }

/// A set of wide-ranged breakpoints, frequently used in native, web and desktop cross-platform applications
///
/// See also:
///   - [LayoutResolver] - the base class used to create any type of layout, like a custom one.
class CommonLayout extends LayoutResolver<CommonBreakpoint> {
  /// Creates a [CommonLayout] with the specified [desktop], [tablet] and [phone] breakpoint sizes, each representing a
  /// [Breakpoint] instance of value type `CommonBreakpoint`.
  CommonLayout(double size, {int desktop = 769, int tablet = 481, int phone = 321})
      : assert(desktop > tablet),
        assert(tablet > phone),
        super(
          size: size,
          breakpoints: [
            Breakpoint(desktop, value: CommonBreakpoint.desktop),
            Breakpoint(tablet, value: CommonBreakpoint.tablet),
            Breakpoint(phone, value: CommonBreakpoint.phone),
            // Note that the last breakpoint is always created from a `null` value, representing the smallest possible
            // size, which in this case is [CommonBreakpoint.tinyHardware], and this occurs to be the [breakpointValue]
            // when the [size] argument is smaller than the [phone] breakpoint.
            const Breakpoint(null, value: CommonBreakpoint.tinyHardware),
          ],
        );

  // Helpers

  /// `true` if the current [breakpointValue] exactly matches [CommonBreakpoint.tinyHardware]
  bool get isTinyHardware => matchesValue(CommonBreakpoint.tinyHardware);

  /// `true` if the current [breakpointValue] matches [CommonBreakpoint.phone] or a smaller breakpoint
  bool get isPhoneOrSmaller => matchesValueOrSmaller(CommonBreakpoint.phone);

  /// `true` if the current [breakpointValue] exactly matches [CommonBreakpoint.phone]
  bool get isPhone => matchesValue(CommonBreakpoint.phone);

  /// `true` if the current [breakpointValue] matches [CommonBreakpoint.phone] or a larger breakpoint
  bool get isPhoneOrLarger => matchesValueOrLarger(CommonBreakpoint.phone);

  /// `true` if the current [breakpointValue] matches [CommonBreakpoint.tablet] or a smaller breakpoint
  bool get isTabletOrSmaller => matchesValueOrSmaller(CommonBreakpoint.tablet);

  /// `true` if the current [breakpointValue] exactly matches [CommonBreakpoint.tablet]
  bool get isTablet => matchesValue(CommonBreakpoint.tablet);

  /// `true` if the current [breakpointValue] matches [CommonBreakpoint.tablet] or a larger breakpoint
  bool get isTabletOrLarger => matchesValueOrLarger(CommonBreakpoint.tablet);

  /// `true` if the current [breakpointValue] exactly matches [CommonBreakpoint.desktop]
  bool get isDesktop => matchesValue(CommonBreakpoint.desktop);

  /// Builds the most suitable `T` depending on the current [breakpoint].
  ///
  /// Throws an [ArgumentError] if no argument is provided.
  ///
  /// Because all of the builders are optional, the current [breakpoint] may not be supplied, meaning that we will
  /// always default to the smallest builder available in such cases.
  ///
  /// ### Example:
  ///
  /// The current [breakpoint] value is `CommonBreakpoint.phone` and we make the following call:
  /// ```
  /// final commonLayout = context.commonLayout; // Get this context from somewhere
  /// final responsiveText = Text(value(desktop: () => 'Desktop text', tablet: () => 'Mobile text'));
  /// ```
  ///
  /// We will first check if there is a `phone`, then a `tinyHardware` provided. In this case, because both aren't
  /// available, we will have to get the smallest available from the remaining, in this case, returning the `tablet`s
  /// builder value.
  T value<T extends Object>({
    T Function()? desktop,
    T Function()? tablet,
    T Function()? phone,
    T Function()? tinyHardware,
  }) {
    if (desktop == null && tablet == null && phone == null && tinyHardware == null) {
      throw ArgumentError('At least one breakpoint (desktop, tablet, phone or tinyHardware) must be provided');
    }

    return closestValue({
      if (desktop != null) CommonBreakpoint.desktop: desktop(),
      if (tablet != null) CommonBreakpoint.tablet: tablet(),
      if (phone != null) CommonBreakpoint.phone: phone(),
      if (tinyHardware != null) CommonBreakpoint.tinyHardware: tinyHardware(),
    });
  }

  /// Proxies the call to [value] but allows all arguments to be `null`
  ///
  /// When not a single argument is non-nullable, instead of throwing, returns a `null` instead.
  T? maybeValue<T extends Object>({
    T Function()? desktop,
    T Function()? tablet,
    T Function()? phone,
    T Function()? tinyHardware,
  }) {
    if (desktop == null && tablet == null && phone == null && tinyHardware == null) {
      return null;
    }

    return value(desktop: desktop, tablet: tablet, phone: phone, tinyHardware: tinyHardware);
  }
}

/// Provides its [child] with both [CommonLayout] and the breakpoint-specific [RawSpacings]
///
/// All [RawSpacings] are optional and if none is provided, it uses the default values found in
/// [SpacingsInheritedWidget.defaultSpacings].
/// These spacings act like an auxiliar set of fields that:
/// - help the related code to be less prone to hardcoded values (provides type-safety with the usage of [Spacing]);
/// - alongside the provided utilities, makes handling spacings less verbose by handling the proxying the logic to this
/// instance's resolver.
///
/// Because [CommonLayoutWidget] uses a `LayoutBuilder` to get its device constraints, no `MaterialApp` (or
/// `MediaQueryData`) is required above/below this widget.
class CommonLayoutWidget extends StatelessWidget {
  /// Creates a `CommonLayoutWidget` with a single default [spacings] for all breakpoints
  ///
  /// If [spacings] argument is provided, all the respective breakpoint's spacings should be the same. If you want to
  /// specify each breakpoint spacing, use the [CommonLayoutWidget.withResponsiveSpacings] constructor.
  ///
  /// To override with your own [CommonLayout], use the [resolverBuilder] argument.
  const CommonLayoutWidget({required this.child, this.resolverBuilder, RawSpacings? spacings})
      : desktopSpacings = spacings,
        tabletSpacings = spacings,
        phoneSpacings = spacings,
        tinyHardwareSpacings = spacings;

  /// Creates a `CommonLayoutWidget` with specified breakpoints spacings
  ///
  /// If not all spacings are provided, it uses the same [CommonLayout.value] logic to pick the closest and most
  /// suitable. If you want to a single spacing for all breakpoints, use the default constructor.
  ///
  /// To override with your own [CommonLayout], use the [resolverBuilder] argument.
  const CommonLayoutWidget.withResponsiveSpacings({
    required this.child,
    this.resolverBuilder,
    this.desktopSpacings,
    this.tabletSpacings,
    this.phoneSpacings,
    this.tinyHardwareSpacings,
  });

  /// Provides a `BoxConstraints` to build this widget's resolver
  final CommonLayout Function(BoxConstraints deviceConstraints)? resolverBuilder;

  /// Spacings corresponding to the [CommonBreakpoint.desktop]
  final RawSpacings? desktopSpacings;

  /// Spacings corresponding to the [CommonBreakpoint.tablet]
  final RawSpacings? tabletSpacings;

  /// Spacings corresponding to the [CommonBreakpoint.phone]
  final RawSpacings? phoneSpacings;

  /// Spacings corresponding to the [CommonBreakpoint.tinyHardware]
  final RawSpacings? tinyHardwareSpacings;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolver = resolverBuilder?.call(constraints) ?? CommonLayout(constraints.maxWidth);

        // Applies the same logic of `closestValue` to the spacings, because not all may be provided
        final spacings = resolver.maybeValue(
          desktop: desktopSpacings != null ? () => desktopSpacings! : null,
          tablet: tabletSpacings != null ? () => tabletSpacings! : null,
          phone: phoneSpacings != null ? () => phoneSpacings! : null,
          tinyHardware: tinyHardwareSpacings != null ? () => tinyHardwareSpacings! : null,
        );

        return LayoutResolverInheritedWidget(
          resolver: resolver,
          child: SpacingsInheritedWidget(spacings: spacings, child: child),
        );
      },
    );
  }

  /// The resolver (`CommonLayout`) from the closest [CommonLayoutWidget] instance that encloses the given
  /// [context].
  static CommonLayout of(BuildContext context) {
    final resolverAncestor = context.dependOnInheritedWidgetOfExactType<LayoutResolverInheritedWidget>();

    if (resolverAncestor == null) {
      throw StateError('No ancestor with `LayoutResolverInheritedWidget` (of type CommonLayout)');
    }

    final resolver = resolverAncestor.resolver;
    if (resolver is! CommonLayout) {
      throw StateError(
        'Found `LayoutResolverInheritedWidget` ancestor of type ${resolver.runtimeType}. Expected a `CommonLayout`.',
      );
    }

    return resolver;
  }
}

extension CommonLayoutWidgetExt on BuildContext {
  CommonLayout get commonLayout => CommonLayoutWidget.of(this);
}
