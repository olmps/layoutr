# layoutr_example

A list of implementation examples in common use-cases and built-in resolvers of `layoutr`.

## Examples

### Common Layout

Other than the specific usage of the class, you can see that:
- `HomePage` implementation exemplifies a "Split" Widget approach - meaning that we create private sub-widget for each layout, common in more complex scenarios, to improve the "core" widget readability;
- `DetailsPage` implementation exemplifies a "Hybrid" Widget approach - meaning that we have the same entry-point (in
this case, the `build` function) to fit all of our use cases.

#### Common Layout Inherited Widget

Example entry-point: `lib/common_layout/inherited_widget.dart`.

Shows the "default" usage of the `CommonLayout`, nothing else.

#### Common Layout Override Inherited Widget

Example entry-point: `lib/common_layout/override_inherited_widget.dart`.

Overrides the default behavior of the `CommonLayoutWidget` by adding our own custom `CommonLayout`, with the desired
changes to the breakpoints values.

### Granular Layout

Read the [Common Layout](#Common-Layout) approach that is also used in this example.

#### Granular Layout Inherited Widget

Example entry-point: `lib/granular_layout/inherited_widget.dart`.

Shows the "default" usage of the `GranularLayout`, nothing else.

#### Granular Layout Override Inherited Widget

Example entry-point: `lib/granular_layout/override_inherited_widget.dart`.

Overrides the default behavior of the `GranularLayoutWidget` by adding our own custom `GranularLayout`, with the desired
changes to the breakpoints values.

### Custom Layout

Extends the `LayoutResolver` to create a completely custom resolver and passes it down through the widget tree.

### `provider`

Example entry-point: `lib/provider.dart`.

Uses the `provider` package to _provide_ a layout resolver through the widget's tree.

### `river_pod`

Example entry-point: `lib/river_pod.dart`.

Uses the `river_pod` package to _provide_ a layout resolver through the widget's tree.