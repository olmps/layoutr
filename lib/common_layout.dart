import 'package:flutter/widgets.dart';
import 'package:layoutr/layoutr.dart';

export 'layoutr.dart' show BuildContextUtilities;

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
  T value<T>({
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
}

class CommonLayoutWidget extends InheritedWidget {
  const CommonLayoutWidget({
    required this.resolver,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  final CommonLayout resolver;

  @override
  bool updateShouldNotify(CommonLayoutWidget oldWidget) => oldWidget.resolver != resolver;

  /// The resolver (`CommonLayout`) from the closest [CommonLayoutWidget] instance that encloses the given [context].
  ///
  /// If no ancestor is found, defaults to a new [CommonLayout] instance using the `context.deviceWidth`.
  static CommonLayout of(BuildContext context) {
    final resolverAncestor = context.dependOnInheritedWidgetOfExactType<CommonLayoutWidget>();

    // TODO(matuella): Is it returning an optional because it's not available in the ancestors, or for some other
    // reason?
    // Commented in https://github.com/flutter/flutter/issues/73423, let's see how it turns out.
    return resolverAncestor?.resolver ?? CommonLayout(context.deviceWidth);
  }
}

extension CommonLayoutWidgetExt on BuildContext {
  CommonLayout get commonLayout => CommonLayoutWidget.of(this);
}
