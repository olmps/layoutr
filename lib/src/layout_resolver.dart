import 'package:meta/meta.dart';

/// Resolves a list of [Breakpoint] for a specific [size], providing responsive layout utilities.
///
/// For commonly used implementations, see:
///   - `CommonLayout` - a wide-ranged breakpoints that are frequently used in native, web and desktop cross-platform
///   applications;
///   - `GranularLayout` - a more granular set of breakpoints, recommended when there are many different layout
///   "behaviors".
///
/// Note: even though you can pass a list of [breakpoints] that have the same [Breakpoint.value], it's not recommended
/// because the logic might get really confusing, given what the [LayoutResolver] API proposes to do.
@immutable
abstract class LayoutResolver<T> {
  LayoutResolver({required this.size, required List<Breakpoint<T>> breakpoints})
      : assert(size > 0),
        assert(breakpoints.length > 1),
        _descendingBreakpoints = breakpoints.descendingSorted,
        breakpoint = breakpoints.descendingSorted.firstDescendingBreakpoint(size);

  /// The reference value to build the current [breakpoint]
  final double size;

  /// The list of the current available breakpoints, descending ordered
  List<Breakpoint<T>> get breakpoints => _descendingBreakpoints;
  final List<Breakpoint<T>> _descendingBreakpoints;

  /// Current breakpoint created from [size]
  final Breakpoint<T> breakpoint;

  /// The [Breakpoint.value] associated with the current [breakpoint]
  T get breakpointValue => breakpoint.value;

  /// `true` if [match] is associated with a corresponding [Breakpoint] that is exactly or smaller than the current
  /// [breakpointValue]
  ///
  /// If distinct [Breakpoint]s have the same value, only the largest (first) match will be used for comparison.
  ///
  /// Throws an `ArgumentError` if [match] doesn't exist in the [breakpoints]
  bool matchesValueOrSmaller(T match) => breakpoint <= _firstBreakpointWithValue(match);

  /// `true` if [match] is associated with a corresponding [Breakpoint] that is exactly or larger than the current
  /// [breakpointValue]
  ///
  /// If distinct [Breakpoint]s have the same value, only the largest (first) match will be used for comparison.
  ///
  /// Throws an `ArgumentError` if [match] doesn't exist in the [breakpoints]
  bool matchesValueOrLarger(T match) => breakpoint >= _firstBreakpointWithValue(match);

  /// `true` if [match] is equals to [breakpointValue]
  bool matchesValue(T match) => breakpointValue == match;

  Breakpoint<T> _firstBreakpointWithValue(T value) => breakpoints.firstWhere(
        (breakpoint) => breakpoint.value == value,
        orElse: () {
          throw ArgumentError.value(value, null, 'No existing breakpoint with the compared value');
        },
      );

  /// Finds the closest value to the current [breakpoint] by applying a custom cascading search in the current list of
  /// available [breakpointsMap].
  ///
  /// This `closestValue` logic ensures that we will always return the *most suitable layout size*, given the
  /// [breakpointsMap] argument.
  ///
  /// The cascade search might be confusing, but it works as following:
  /// 1. Iterates "down" (starting from the current [breakpoint]) the descending ordered list of [breakpoints], while
  /// checking if there is a corresponding key in the [breakpointsMap]. If this predicate matches, returns the
  /// associated value with that key;
  /// 2. If no predicate is met, we start to iterate "upwards" (going from the first element *before* the current
  /// [breakpoint]), and go from there up until the first - or largest - breakpoint available.
  ///
  /// This method should only be overridden if you're customizing the logic of finding the closest value for a
  /// particular breakpoint value.
  ///
  /// Example:
  ///
  /// Let's say this resolver has current [breakpoint] of `Breakpoint<String>(200, 'BP200')` and the following list of
  /// [breakpoints]:
  /// ```
  /// [
  ///   Breakpoint<String>(400, 'BP400'),
  ///   Breakpoint<String>(300, 'BP300'),
  ///   Breakpoint<String>(200, 'BP200'),
  ///   Breakpoint<String>(100, 'BP100'),
  /// ]
  /// ```
  ///
  /// When calling this [closestValue], we will assume that we've passed the value of [breakpointsMap] like so:
  /// ```
  /// {
  ///   'BP400': Text('My widget when BP is 400', maxLines: 2, overflow: TextOverflow.ellipsis),
  ///   'BP100': Text('My widget when BP is 100'),
  /// }
  /// ```
  ///
  /// To get the closest value (of our current [breakpoint]) for the keys available in [breakpointsMap], we will
  /// cascade all available breakpoints to find the smallest possible value, in this case that we are in `'BP200'`:
  /// - Is there a value `'BP200'` available? No;
  /// - Is there a value `'BP100'` available? Yes.
  ///
  /// So, in this example, returns `Text('My widget when BP is 100')`.
  ///
  /// Now, if [breakpointsMap] argument was passed as the following:
  /// ```
  /// {
  ///   'BP400': Text('My widget when BP is 400', maxLines: 2, overflow: TextOverflow.ellipsis),
  /// }
  /// ```
  ///
  /// The cascade logic would be:
  /// - Is there a value `'BP200'` available? No;
  /// - Is there a value `'BP100'` available? No;
  /// - Is there a value `'BP300'` available? No;
  /// - Is there a value `'BP400'` available? Yes.
  @protected
  @visibleForTesting
  U closestValue<U extends Object>(Map<T, U> breakpointsMap) {
    if (breakpointsMap.isEmpty) {
      throw ArgumentError('The provided map cannot be empty');
    }

    final breakpointsValues = breakpoints.map((breakpoint) => breakpoint.value).toSet();
    // TODO(matuella): Why this isn't the `Set.containsAll` working?
    // if (breakpointsValues.containsAll(breakpointsMap.keys.toSet())) {
    //
    // Even though, we can workaround by doing an intersection and getting the length:
    if (breakpointsValues.intersection(breakpointsMap.keys.toSet()).length != breakpointsMap.keys.length) {
      throw ArgumentError(
        'The provided map of breakpoint values should be the same available in the `LayoutResolver.breakpoints`.',
      );
    }

    // Find the index of our current breakpoint in the descending ordered list
    final breakpointIndex = _descendingBreakpoints.indexOf(breakpoint);

    final nextElementsSubset = _descendingBreakpoints.sublist(breakpointIndex);
    final reversedPreviousElementsSubset = _descendingBreakpoints.sublist(0, breakpointIndex).reversed;

    // Creates a new list with the new order that we want to cascade from:
    // - First the elements that are the exact same or directly "below" our current breakpoint;
    // - Then the remaining elements - but reversed -, starting from the first element up until our first element in
    // the list.
    final cascadedOrderedBreakpoints = List<Breakpoint<T>>.from(<Breakpoint<T>>[
      ...nextElementsSubset,
      ...reversedPreviousElementsSubset,
    ]);

    // Then simply return the first breakpoint available in `breakpointsMap`
    final firstMatch =
        cascadedOrderedBreakpoints.firstWhere((breakpoint) => breakpointsMap.containsKey(breakpoint.value));
    return breakpointsMap[firstMatch.value]!;
  }
}

/// Associates a [size] with a [value] to represent a "visual" breakpoint
class Breakpoint<T> implements Comparable<Breakpoint<T>> {
  const Breakpoint(this.size, {required this.value}) : assert(size == null || size > 0);

  /// Raw representation of this breakpoint
  ///
  /// Should be `null` only if this instance represents the smallest breakpoint possible
  final int? size;

  /// Associated value with this breakpoint
  final T value;

  bool operator >(Breakpoint<T> other) => (size ?? 0) > (other.size ?? 0);
  bool operator >=(Breakpoint<T> other) => (size ?? 0) >= (other.size ?? 0);
  bool operator <=(Breakpoint<T> other) => (size ?? 0) <= (other.size ?? 0);
  bool operator <(Breakpoint<T> other) => (size ?? 0) < (other.size ?? 0);

  @override
  int compareTo(Breakpoint<T> other) {
    if (other > this) {
      return -1;
    }
    if (other < this) {
      return 1;
    }

    return 0;
  }
}

// Sort helpers for List + Breakpoint
extension _BreakpointListExtension<T> on List<Breakpoint<T>> {
  List<Breakpoint<T>> get descendingSorted {
    final descendingSorted = List<Breakpoint<T>>.from(this)
      ..sort((a, b) {
        final comparison = b.compareTo(a);
        if (comparison == 0) {
          throw ArgumentError(
            'breakpoint of size `${b.size}` (value `${b.value}`) had '
            'the same size of other breakpoint (value `${a.value})',
          );
        }

        return comparison;
      });

    return descendingSorted;
  }

  Breakpoint<T> firstDescendingBreakpoint(double size) {
    for (final breakpoint in this) {
      if (size >= (breakpoint.size ?? 0)) {
        return breakpoint;
      }
    }

    return last;
  }
}
