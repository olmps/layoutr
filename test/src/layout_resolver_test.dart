import 'package:flutter_test/flutter_test.dart';
import 'package:layoutr/src/layout_resolver.dart';

enum BreakpointTypeMock { first, second, third, fourth, fifth }

// Test class to enable testing the default implementation of `LayoutResolver`
class ResolverTest extends LayoutResolver<BreakpointTypeMock> {
  ResolverTest(double size, List<Breakpoint<BreakpointTypeMock>> breakpoints)
      : super(size: size, breakpoints: breakpoints);
}

void main() {
  group('LayoutResolver integrity', () {
    test('instance should sort its breakpoints in descending values', () {
      const unorderedBreakpoints = [
        Breakpoint(1000, value: BreakpointTypeMock.second),
        Breakpoint(250, value: BreakpointTypeMock.fourth),
        Breakpoint(2000, value: BreakpointTypeMock.first),
        Breakpoint(null, value: BreakpointTypeMock.fifth),
        Breakpoint(500, value: BreakpointTypeMock.third),
      ];

      final resolver = ResolverTest(1, unorderedBreakpoints);

      expect(resolver.breakpoints.first, unorderedBreakpoints[2]);
      expect(resolver.breakpoints[1], unorderedBreakpoints.first);
      expect(resolver.breakpoints[2], unorderedBreakpoints.last);
      expect(resolver.breakpoints[3], unorderedBreakpoints[1]);
      expect(resolver.breakpoints.last, unorderedBreakpoints[3]);
    });

    test('instance should throw when multiple breakpoints have the same size', () {
      const breakpoints = [
        Breakpoint(100, value: BreakpointTypeMock.second),
        Breakpoint(100, value: BreakpointTypeMock.first),
      ];

      expect(() => ResolverTest(1, breakpoints), throwsA(isA<ArgumentError>()));
    });
  });

  group('LayoutResolver matches', () {
    test('should match breakpoints accordingly', () {
      const breakpoints = [
        Breakpoint(100, value: BreakpointTypeMock.first),
        Breakpoint(200, value: BreakpointTypeMock.second),
        Breakpoint(300, value: BreakpointTypeMock.third),
      ];

      // matchesValue
      expect(ResolverTest(50, breakpoints).matchesValue(BreakpointTypeMock.first), true);

      expect(ResolverTest(100, breakpoints).matchesValue(BreakpointTypeMock.first), true);

      expect(ResolverTest(200, breakpoints).matchesValue(BreakpointTypeMock.second), true);
      expect(ResolverTest(200, breakpoints).matchesValue(BreakpointTypeMock.third), false);

      expect(ResolverTest(300, breakpoints).matchesValue(BreakpointTypeMock.third), true);
      expect(ResolverTest(300, breakpoints).matchesValue(BreakpointTypeMock.second), false);

      expect(ResolverTest(1000000000, breakpoints).matchesValue(BreakpointTypeMock.third), true);

      // matchesValueOrLarger
      expect(ResolverTest(50, breakpoints).matchesValueOrLarger(BreakpointTypeMock.first), true);
      expect(ResolverTest(50, breakpoints).matchesValueOrLarger(BreakpointTypeMock.second), false);

      expect(ResolverTest(200, breakpoints).matchesValueOrLarger(BreakpointTypeMock.first), true);
      expect(ResolverTest(200, breakpoints).matchesValueOrLarger(BreakpointTypeMock.second), true);
      expect(ResolverTest(200, breakpoints).matchesValueOrLarger(BreakpointTypeMock.third), false);

      expect(ResolverTest(300, breakpoints).matchesValueOrLarger(BreakpointTypeMock.third), true);
      expect(ResolverTest(300, breakpoints).matchesValueOrLarger(BreakpointTypeMock.second), true);

      // matchesValueOrSmaller
      expect(ResolverTest(50, breakpoints).matchesValueOrSmaller(BreakpointTypeMock.first), true);
      expect(ResolverTest(50, breakpoints).matchesValueOrSmaller(BreakpointTypeMock.third), true);

      expect(ResolverTest(200, breakpoints).matchesValueOrSmaller(BreakpointTypeMock.first), false);
      expect(ResolverTest(200, breakpoints).matchesValueOrSmaller(BreakpointTypeMock.second), true);
      expect(ResolverTest(200, breakpoints).matchesValueOrSmaller(BreakpointTypeMock.third), true);

      expect(ResolverTest(300, breakpoints).matchesValueOrSmaller(BreakpointTypeMock.first), false);
      expect(ResolverTest(300, breakpoints).matchesValueOrSmaller(BreakpointTypeMock.second), false);
      expect(ResolverTest(300, breakpoints).matchesValueOrSmaller(BreakpointTypeMock.third), true);
    });

    test('should match largest breakpoint if multiple breakpoints with the same value are provided', () {
      const breakpoints = [
        Breakpoint(100, value: BreakpointTypeMock.first),
        Breakpoint(200, value: BreakpointTypeMock.first),
        Breakpoint(300, value: BreakpointTypeMock.second),
        Breakpoint(400, value: BreakpointTypeMock.third),
      ];

      // With this size we will be in the first breakpoint, but with the same value as the next
      final firstBpResolver = ResolverTest(100, breakpoints);
      expect(firstBpResolver.matchesValue(BreakpointTypeMock.first), true);

      // With this size we will be in the second breakpoint, but with the same value as the previous
      final secondBpResolver = ResolverTest(250, breakpoints);
      expect(secondBpResolver.matchesValue(BreakpointTypeMock.first), true);

      // With this size we will be in the third breakpoint
      final thirdBpResolver = ResolverTest(300, breakpoints);
      expect(thirdBpResolver.matchesValue(BreakpointTypeMock.first), false);
    });

    test('should throw if no breakpoint with matching value exists', () {
      const breakpoints = [
        Breakpoint(100, value: BreakpointTypeMock.first),
        Breakpoint(200, value: BreakpointTypeMock.second),
      ];

      final resolver = ResolverTest(100, breakpoints);
      expect(() => resolver.matchesValueOrLarger(BreakpointTypeMock.third), throwsA(isA<ArgumentError>()));
      expect(() => resolver.matchesValueOrSmaller(BreakpointTypeMock.third), throwsA(isA<ArgumentError>()));
    });
  });

  group('LayoutResolver closestValue', () {
    test("should throw if the breakpointsMap keys (breakpoints) don't match with the instance", () {
      const breakpoints = [
        Breakpoint(100, value: BreakpointTypeMock.first),
        Breakpoint(200, value: BreakpointTypeMock.second),
      ];

      final resolver = ResolverTest(100, breakpoints);
      expect(
        () {
          resolver.closestValue({
            BreakpointTypeMock.third: 1,
          });
        },
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw if the breakpointsMap keys is empty', () {
      const breakpoints = [
        Breakpoint(100, value: BreakpointTypeMock.first),
        Breakpoint(200, value: BreakpointTypeMock.second),
      ];

      final resolver = ResolverTest(100, breakpoints);
      expect(
        () {
          resolver.closestValue(<BreakpointTypeMock, Object>{});
        },
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should match the closest values accordingly', () {
      const breakpoints = [
        Breakpoint(100, value: BreakpointTypeMock.first),
        Breakpoint(200, value: BreakpointTypeMock.second),
        Breakpoint(300, value: BreakpointTypeMock.third),
        Breakpoint(400, value: BreakpointTypeMock.fourth),
        Breakpoint(500, value: BreakpointTypeMock.fifth),
      ];

      final firstBpResolver = ResolverTest(100, breakpoints);
      final secondBpResolver = ResolverTest(200, breakpoints);
      final thirdBpResolver = ResolverTest(300, breakpoints);
      final fourthBpResolver = ResolverTest(400, breakpoints);
      final fifthBpResolver = ResolverTest(500, breakpoints);

      final testMap = {
        BreakpointTypeMock.second: 'small',
        BreakpointTypeMock.third: 'medium',
        BreakpointTypeMock.fourth: 'big',
      };

      expect(firstBpResolver.closestValue(testMap), 'small');
      expect(secondBpResolver.closestValue(testMap), 'small');
      expect(thirdBpResolver.closestValue(testMap), 'medium');
      expect(fourthBpResolver.closestValue(testMap), 'big');
      expect(fifthBpResolver.closestValue(testMap), 'big');

      final testMap2 = {
        BreakpointTypeMock.second: 'small',
        BreakpointTypeMock.fourth: 'big',
      };

      expect(firstBpResolver.closestValue(testMap2), 'small');
      expect(secondBpResolver.closestValue(testMap2), 'small');
      expect(thirdBpResolver.closestValue(testMap2), 'small');
      expect(fourthBpResolver.closestValue(testMap2), 'big');
      expect(fifthBpResolver.closestValue(testMap2), 'big');

      final testMap3 = {
        BreakpointTypeMock.fourth: 'big',
      };

      expect(firstBpResolver.closestValue(testMap3), 'big');
      expect(secondBpResolver.closestValue(testMap3), 'big');
      expect(thirdBpResolver.closestValue(testMap3), 'big');
      expect(fourthBpResolver.closestValue(testMap3), 'big');
      expect(fifthBpResolver.closestValue(testMap3), 'big');

      final testMap4 = {
        BreakpointTypeMock.first: 'tiny',
        BreakpointTypeMock.fifth: 'colossal',
      };

      expect(firstBpResolver.closestValue(testMap4), 'tiny');
      expect(secondBpResolver.closestValue(testMap4), 'tiny');
      expect(thirdBpResolver.closestValue(testMap4), 'tiny');
      expect(fourthBpResolver.closestValue(testMap4), 'tiny');
      expect(fifthBpResolver.closestValue(testMap4), 'colossal');
    });
  });
}
