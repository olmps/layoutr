import 'package:flutter/widgets.dart';
import 'package:responsive_layout/responsive_layout.dart';

import 'src/layout_resolver.dart';
import 'src/utilities.dart';


export 'responsive_layout.dart';

// extension LayoutMetadataCtx on BuildContext {
//   LayoutMetadata get layoutMetadata => watch<LayoutMetadata>();
// }

// typedef LayoutValue<T> = T Function(BuildContext context);



enum CommonBreakpoint {
  desktop, tablet, phone, tinyHardware
}


class CommonLayout extends LayoutResolver<CommonBreakpoint> {
  CommonLayout({
    this.desktop = 769,
    this.tablet = 481,
    this.phone = 321
  }) {
    if (desktop <= tablet || desktop <= phone) {
      throw 'tablet (tablet) and/or phone (phone) size was greater than desktop size (desktop)';
    }

    if (tablet <= phone) {
      throw 'phone size (phone) was greater than tablet size (tablet)';
    }
  }

  final int desktop;
  final int tablet;
  final int phone;

  @override
  CommonBreakpoint resolveBreakpoint(double size) {
    if (size < phone) {
      return CommonBreakpoint.tinyHardware;
    } else if (size < tablet) {
      return CommonBreakpoint.phone;
    } else if (size < desktop) {
      return CommonBreakpoint.tablet;
    }

    return CommonBreakpoint.desktop;
  }
}

extension CommonLayoutValue on BuildContext {
  CommonLayout get commonLayout => LayoutResolverWidget.of(this).resolver as CommonLayout;
  CommonBreakpoint get breakpoint => commonLayout.resolveBreakpoint(deviceWidth);

  bool get isTinyHardware => breakpoint == CommonBreakpoint.tinyHardware;
  
  bool get isPhoneOrSmaller => breakpoint == CommonBreakpoint.phone || breakpoint == CommonBreakpoint.tinyHardware;
  bool get isPhone => breakpoint == CommonBreakpoint.phone;
  bool get isPhoneOrLarger => breakpoint != CommonBreakpoint.tinyHardware;

  bool get isTabletOrSmaller => breakpoint != CommonBreakpoint.desktop;
  bool get isTablet => breakpoint == CommonBreakpoint.tablet;
  bool get isTabletOrLarger => breakpoint != CommonBreakpoint.phone && breakpoint != CommonBreakpoint.tinyHardware;

  bool get isDesktop => breakpoint == CommonBreakpoint.desktop;

  T layoutValue<T>({
    T? desktop,
    T? tablet,
    T? phone,
    T? tinyHardware
  }) {
    if (desktop == null && tablet == null && phone == null && tinyHardware == null) {
      throw 'At least one breakpoint must be provided';
    }

    // If it's in the exact range and has a layout supplied, try to use it,
    // otherwise cascade down all the available values
    if (desktop != null && breakpoint == CommonBreakpoint.desktop) {
      return desktop;
    } else if (tablet != null && breakpoint == CommonBreakpoint.tablet) {
      return tablet;
    } else if (phone != null && breakpoint == CommonBreakpoint.phone) {
      return phone;
    } else if (tinyHardware != null) {
      return tinyHardware;
    }

     // Get the largest non-null layout supplied
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
