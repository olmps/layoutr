import 'package:flutter/widgets.dart';

extension BuildContextUtilities on BuildContext {
  /// Syntax-sugar for `MediaQuery.of(this).size`
  Size get deviceSize => MediaQuery.of(this).size;

  /// Syntax-sugar for `MediaQuery.of(this).size.height`
  double get deviceHeight => deviceSize.height;

  /// Syntax-sugar for `MediaQuery.of(this).size.width`
  double get deviceWidth => deviceSize.width;
}
