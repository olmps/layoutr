import 'dart:collection';

class Breakpoint<T> implements Comparable<Breakpoint<T>> {
  Breakpoint(this.size, {required this.value}): assert(size == null || size > 0);

  final int? size;
  final T value;

  operator > (Breakpoint<T> other) => (size ?? 0) > (other.size ?? 0);
  operator >= (Breakpoint<T> other) => (size ?? 0) >= (other.size ?? 0);
  operator <= (Breakpoint<T> other) => (size ?? 0) <= (other.size ?? 0);
  operator < (Breakpoint<T> other) => (size ?? 0) < (other.size ?? 0);

  @override
  int compareTo(Breakpoint<T> other) {
    if (other > this) { return -1; }
    if (other < this) { return 1; }

    return 0;
  }
}

extension BreakpointListExtension<T> on List<Breakpoint<T>> {

  List<Breakpoint<T>> get descendingSorted {
    final descendingSorted = List<Breakpoint<T>>.from(this);

    descendingSorted..sort((a, b) {
      final comparison = b.compareTo(a);
      if (comparison == 0) {
        throw 'breakpoint of size `${b.size}` (value `${b.value}`) had the same size of other breakpoint (value `${a.value})';
      }

      return comparison;
    });

    return descendingSorted;
  }

    
  Breakpoint<T> firstCascadingBreakpoint(double size) {
    for (final breakpoint in this) {
      if (size >= (breakpoint.size ?? 0)) {
        return breakpoint;
      }
    }

    return last;
  }
}



abstract class LayoutResolver<T> {
  LayoutResolver({required double size, required List<Breakpoint<T>> breakpoints}): assert(size > 0), assert(breakpoints.length > 1), _descendingBreakpoints = breakpoints.descendingSorted, breakpoint = breakpoints.descendingSorted.firstCascadingBreakpoint(size);

  final List<Breakpoint<T>> _descendingBreakpoints;


  List<Breakpoint<T>> get breakpoints => _descendingBreakpoints;  
  final Breakpoint<T> breakpoint;
  T get breakpointValue => breakpoint.value;

  bool matchesValueOrSmaller(T match) {
    final valueBreakpoint = breakpoints.firstWhere((breakpoint) => breakpoint.value == match, orElse: () {
      throw 'TODO: throw or return false?';
    });

    return breakpoint <= valueBreakpoint; 
  }

  bool matchesValue(T match) {
    final valueBreakpoint = breakpoints.firstWhere((breakpoint) => breakpoint.value == match, orElse: () {
      throw 'TODO';
    });

    return breakpoint.size == valueBreakpoint.size; 
  }

  bool matchesValueOrLarger(T match) {
    final valueBreakpoint = breakpoints.firstWhere((breakpoint) => breakpoint.value == match, orElse: () {
      throw 'TODO';
    });

    return breakpoint >= valueBreakpoint; 
  }
}