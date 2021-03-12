import 'package:equatable/equatable.dart';

/// Literal representation for all the constant spacing values available
enum Spacing {
  xxxSmall,
  xxSmall,
  xSmall,
  small,
  medium,
  large,
  xLarge,
  xxLarge,
  xxxLarge,
}

/// A set of raw values for each [Spacing.values]
class RawSpacings extends Equatable {
  const RawSpacings(
    this.xxxSmall,
    this.xxSmall,
    this.xSmall,
    this.small,
    this.medium,
    this.large,
    this.xLarge,
    this.xxLarge,
    this.xxxLarge,
  );

  final double xxxSmall;
  final double xxSmall;
  final double xSmall;
  final double small;
  final double medium;
  final double large;
  final double xLarge;
  final double xxLarge;
  final double xxxLarge;

  @override
  List<Object?> get props => [
        xxxSmall,
        xxSmall,
        xSmall,
        small,
        medium,
        large,
        xLarge,
        xxLarge,
        xxxLarge,
      ];
}

/// Provides all [Spacing] values as instance properties
///
/// This mixin exists solely to make things less verbose in widgets that heavily uses [Spacing] and its utilities
mixin SpacingMixin {
  Spacing get xxxSmallSpacing => Spacing.xxxSmall;
  Spacing get xxSmallSpacing => Spacing.xxSmall;
  Spacing get xSmallSpacing => Spacing.xSmall;
  Spacing get smallSpacing => Spacing.small;
  Spacing get mediumSpacing => Spacing.medium;
  Spacing get largeSpacing => Spacing.large;
  Spacing get xLargeSpacing => Spacing.xLarge;
  Spacing get xxLargeSpacing => Spacing.xxLarge;
  Spacing get xxxLargeSpacing => Spacing.xxxLarge;
}
