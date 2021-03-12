import 'package:layoutr/src/spacing.dart';
import 'package:layoutr/src/spacings_widget.dart';

import 'package:flutter/widgets.dart';

extension BuildContextUtilities on BuildContext {
  /// Syntax-sugar for `MediaQuery.of(this).size`
  Size get deviceSize => MediaQuery.of(this).size;

  /// Syntax-sugar for `MediaQuery.of(this).size.height`
  double get deviceHeight => deviceSize.height;

  /// Syntax-sugar for `MediaQuery.of(this).size.width`
  double get deviceWidth => deviceSize.width;
}

extension SpacingHelpers on BuildContext {
  /// The current raw value associated with the [spacing]
  ///
  /// If this context don't have a [SpacingsInheritedWidget] ancestor, a default set of paddings will be used
  double rawSpacing(Spacing spacing) {
    final spacings = SpacingsInheritedWidget.of(this);

    switch (spacing) {
      case Spacing.xxxSmall:
        return spacings.xxxSmall;
      case Spacing.xxSmall:
        return spacings.xxSmall;
      case Spacing.xSmall:
        return spacings.xSmall;
      case Spacing.small:
        return spacings.small;
      case Spacing.medium:
        return spacings.medium;
      case Spacing.large:
        return spacings.large;
      case Spacing.xLarge:
        return spacings.xLarge;
      case Spacing.xxLarge:
        return spacings.xxLarge;
      case Spacing.xxxLarge:
        return spacings.xxxLarge;
    }
  }

  /// Creates a [SizedBox] with its `width` set to [spacing]
  ///
  /// See also:
  ///   - [Spacing] and [rawSpacing];
  ///   - [SpacingPaddingHelpers] - helpers for wrapping an Widget with a [Padding].
  SizedBox horizontalBox(Spacing spacing) => SizedBox(width: rawSpacing(spacing));

  /// Creates a [SizedBox] with its `height` set to [spacing]
  ///
  /// See also:
  ///   - [Spacing] and [rawSpacing];
  ///   - [SpacingPaddingHelpers] - helpers for wrapping an Widget with a [Padding].
  SizedBox verticalBox(Spacing spacing) => SizedBox(height: rawSpacing(spacing));

  /// Creates a [EdgeInsets] with its `EdgeInsets.all` set to [spacing]
  ///
  /// See also:
  ///   - [Spacing] and [rawSpacing];
  ///   - [SpacingPaddingHelpers] - helpers for wrapping an Widget with a [Padding].
  EdgeInsets allInsets(Spacing spacing) => EdgeInsets.all(rawSpacing(spacing));

  /// Creates a [EdgeInsets] with its `EdgeInsets.symmetric` by applying the respective [horizontal] and [vertical]
  /// spacings
  ///
  /// An optional [vertical] padding may be provided
  ///
  /// See also:
  ///   - [Spacing] and [rawSpacing];
  ///   - [SpacingPaddingHelpers] - helpers for wrapping an Widget with a [Padding].
  EdgeInsets symmetricInsets({Spacing? horizontal, Spacing? vertical}) => EdgeInsets.symmetric(
        horizontal: horizontal == null ? 0 : rawSpacing(horizontal),
        vertical: vertical == null ? 0 : rawSpacing(vertical),
      );

  /// Creates a [EdgeInsets] with its `EdgeInsets.only` by applying the [spacing] to the `true` arguments
  ///
  /// See also:
  ///   - [Spacing] and [rawSpacing];
  ///   - [SpacingPaddingHelpers] - helpers for wrapping an Widget with a [Padding].
  EdgeInsets onlyInsets(
    Spacing spacing, {
    bool left = false,
    bool top = false,
    bool right = false,
    bool bottom = false,
  }) =>
      EdgeInsets.only(
        left: left ? rawSpacing(spacing) : 0,
        top: top ? rawSpacing(spacing) : 0,
        right: right ? rawSpacing(spacing) : 0,
        bottom: bottom ? rawSpacing(spacing) : 0,
      );
}

extension SpacingPaddingHelpers on Widget {
  /// Uses the [RawSpacings] available in the [context] to wrap all insets of this widget in a [Padding] with the
  /// specific [spacing]
  ///
  /// See also:
  ///   - [Spacing];
  ///   - [SpacingHelpers] - helpers for [EdgeInsets] and [SizedBox].
  Padding withAllPadding(BuildContext context, Spacing spacing) => Padding(
        padding: context.allInsets(spacing),
        child: this,
      );

  /// Uses the [RawSpacings] available in the [context] to wrap this widget with the optional [horizontal] and
  /// [vertical] insets in [Padding]
  ///
  /// See also:
  ///   - [Spacing];
  ///   - [SpacingHelpers] - helpers for [EdgeInsets] and [SizedBox].
  Padding withSymmetricalPadding(BuildContext context, {Spacing? horizontal, Spacing? vertical}) {
    return Padding(
      padding: context.symmetricInsets(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  /// Uses the [RawSpacings] available in the [context] to wrap this widget in a [Padding] with the respective optional
  /// insets
  ///
  /// See also:
  ///   - [Spacing];
  ///   - [SpacingHelpers] - helpers for [EdgeInsets] and [SizedBox].
  Padding withOnlyPadding(BuildContext context, {Spacing? left, Spacing? top, Spacing? right, Spacing? bottom}) {
    return Padding(
      padding: EdgeInsets.only(
        left: left == null ? 0 : context.rawSpacing(left),
        top: top == null ? 0 : context.rawSpacing(top),
        right: right == null ? 0 : context.rawSpacing(right),
        bottom: bottom == null ? 0 : context.rawSpacing(bottom),
      ),
      child: this,
    );
  }
}
