import 'package:flutter/widgets.dart';
import 'package:responsive_layout/responsive_layout.dart';

import 'src/layout_resolver.dart';

export 'responsive_layout.dart';

enum CommonBreakpoint {
  desktop, tablet, phone, tinyHardware
}

@immutable
class CommonLayout extends LayoutResolver<CommonBreakpoint> {
  CommonLayout(double size, {
    int desktop = 769,
    int tablet = 481,
    int phone = 321
  }): super(size: size, breakpoints: [Breakpoint(desktop, value: CommonBreakpoint.desktop), Breakpoint(tablet, value: CommonBreakpoint.tablet), Breakpoint(phone, value: CommonBreakpoint.phone), Breakpoint(null, value: CommonBreakpoint.tinyHardware),]);

  // Helpers

  bool get isTinyHardware => matchesValue(CommonBreakpoint.tinyHardware);
  
  bool get isPhoneOrSmaller => matchesValueOrSmaller(CommonBreakpoint.phone);
  bool get isPhone => matchesValue(CommonBreakpoint.phone);
  bool get isPhoneOrLarger => matchesValueOrLarger(CommonBreakpoint.phone);

  bool get isTabletOrSmaller => matchesValueOrSmaller(CommonBreakpoint.tablet);
  bool get isTablet => matchesValue(CommonBreakpoint.tablet);
  bool get isTabletOrLarger => matchesValueOrLarger(CommonBreakpoint.tablet);

  bool get isDesktop => matchesValue(CommonBreakpoint.desktop);

  T value<T>({
    T? desktop,
    T? tablet,
    T? phone,
    T? tinyHardware
  }) {
    if (desktop == null && tablet == null && phone == null && tinyHardware == null) {
      throw 'At least one breakpoint must be provided';
    }

    // If it's in the exact range and has a layout supplied, try to use it...
    if (desktop != null && breakpointValue == CommonBreakpoint.desktop) {
      return desktop;
    } else if (tablet != null && breakpointValue == CommonBreakpoint.tablet) {
      return tablet;
    } else if (phone != null && breakpointValue == CommonBreakpoint.phone) {
      return phone;
    } else if (tinyHardware != null) {
      return tinyHardware;
    }
    // ... otherwise cascade down all the available values to get the largest
    // non-null layout supplied
    if (desktop != null) {
      return desktop;
    } else if (tablet != null) {
      return tablet;
    } else if (phone != null) {
      return phone;
    } else {
      return tinyHardware!;
    }
  }
}

// Widget Utility
extension CommonResolverWidget on BuildContext {
  CommonLayout get layout => LayoutResolverWidget.of(this).resolver as CommonLayout;
}