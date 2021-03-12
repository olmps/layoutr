## 1.0.0

First stable release containing the `Spacing` utilities and a couple of minor improvements.

## Breaking Changes

- `CommonLayout` and `GranularLayout` `value` function now requires the type `T` to extend from `Object`, not allowing
the return of `null` values (which threw a `null` access in specific scenarios). This was intended but the
type-inference allowed nullable types when not enforced by `Object`;
- `CommonLayoutWidget`/`GranularLayoutWidget` constructors requires a `resolverBuilder` instead of a `resolver`.

#### Added
- Unit and Widget tests for all the features provided in `layoutr`;
- `maybeValue` in both `CommonLayout` and `GranularLayout`;
- `Spacing`, `RawSpacings` and `SpacingsInheritedWidget` with utilities (`SpacingMixin`, `SpacingHelpers` and 
`SpacingPaddingHelpers`);
- `LayoutResolverInheritedWidget`, base `InheritedWidget` for all `LayoutResolver` implementations;
- Both `CommonLayoutWidget`/`GranularLayoutWidget`:
  - accept a new optional `spacings` argument that allows responsive and type-safe spacing alongside the usual resolver;
  - `withResponsiveSpacings` for a fine-grained constructor of breakpoint-specific `spacings`.
- `split_view` example.

#### Updated
- Both `CommonLayoutWidget`/`GranularLayoutWidget` can live independent from a `MediaQuery` parent widget (by using a
`LayoutBuilder`);
- Restructured the example folder to a more realistic usage (also added a ton of comments to the respective examples);
- `README.md` to reflect the new `Spacing` features.

### Fixed

- `LayoutResolver.closestValue` now throws a descriptive `ArgumentError` for empty dictionaries;


## 1.0.0-nullsafety.0

First library release, everything already documented in `README.md`.

For a stable release, just the tests and a little improvement on examples remains.
