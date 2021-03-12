import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:layoutr/src/layout_resolver.dart';

// ignore: must_be_immutable
class LayoutResolverMock extends Mock implements LayoutResolver<dynamic> {}

Future<void> pumpTesterForSize(WidgetTester tester, Size size) {
  tester.binding.window.physicalSizeTestValue = size;
  return tester.pump();
}
