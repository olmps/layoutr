# layoutr

[![pub package](https://img.shields.io/pub/v/layoutr?style=flat-square)](https://pub.dev/packages/layoutr)

A set of succinct Dart/Flutter utilities to help doing responsive layouts with less verbosity.

## Why

There are already a ton of layout/UI libraries out there and this is just another one to solve the same problem: responsive layouts.

This package aims to be a single dependecy to handle responsive use-cases in Flutter applications while keeping the verbosity to a minimum, because we know how quickly verbose (reads harder-to-read) we can get with those Widgets.

## Usage

Before finding out the package's API, make sure to [install this package](https://pub.dev/packages/layoutr/install). With this out of the way, let's get an overview what this package does:

### Layout Resolvers

These are the core layout classes that should make the process of handling multiple-layout widgets much less verbose. We can use these resolvers whenever you have a `BuildContext` (usually in the Widgets `build` function) available.

Even though the magic should happen inside the abstract `LayoutResolver`, we need to extend this class to provide our desired `Breakpoint`s. This is intended due to the fact that there is an incredible amount of use-cases available when building any kind of UI - meaning that these breakpoints are completely subjective, based on each project "constraints".

But that's not any reason to not have built-in Layout Resolvers, and these will probably fit the most generic use-cases. To exemplify the resolvers, we can see how the `CommonLayout` works.

#### Exemplifying with CommonLayout
---

Before diving into the concepts, you have to make sure to provide a `CommonLayout` for your widgets. This can be done
in multiple different ways, although the easiest is to just wrap your top-most widget in the `CommonLayoutWidget`:

```dart
import 'package:layoutr/common_layout.dart';

// ...
CommonLayoutWidget(
  child: /* My child, possibly a MaterialApp/WidgetsApp */,
);
// ...
```

Now, `CommonLayout` is split in 4 breakpoints: `desktop`, `tablet`, `phone` and `tinyHardware`. A simple usage of returning a responsive `Text` widget that has both its value and style customized based on the current device's constraints may be done like the below:

```dart
import 'package:layoutr/common_layout.dart';

// ...

Widget build(BuildContext context) {
  final layout = context.commonLayout;
  final textTheme = Theme.of(context).textTheme;

  return layout.value(
    desktop: () => Text('Desktop layout', style: textTheme.headline1),
    phone: () => Text('Phone layout', style: textTheme.headline4),
    tinyHardware: () => Text('Tiny Hardware layout', style: textTheme.headline6),
  );
}
// ...
```

> **TLDR: all breakpoints don't need to be provided, the layout will automatically find the nearest suitable value for your current breakpoint.**
> 
> Long version: you can see that there is no `tablet` supplied to the `layout.value`, and that is intended to exemplify a common scenario, where we may want to just provide two or three arguments - and that means not all possible scenarios are "covered" - and that's where the resolver comes in handy: if the **current breakpoint** value is not passed to `layout.value`, it will fallback to the "nearest" available one, fitting the most suitable layout for your particular value. This "nearest logic" can be confusing, but you can find out more how it works in `LayoutResolver.closestValue`

Other than `layout.value`, the `CommonLayout` provide utilities for simple boolean comparisons:

```dart
import 'package:layoutr/common_layout.dart';

// ...

Widget build(BuildContext context) {
  final layout = context.commonLayout;
  const pageTitle = 'Title';

  final myAppBar = layout.isTabletOrSmaller ? AppBar(title: const Text(pageTitle)) : null;

  return Scaffold(
    // We wan't to have an `AppBar` if the current layout is a tablet or smaller
    appBar: myAppBar,
    body: Center(
      child: Column(
        children: [
          // And we wan't to have a custom title `AppBar` if the current layout is a tablet or smaller
          if (layout.isDesktop)
            Text(pageTitle, style: Theme.of(context).textTheme.headline3),
          // ... the rest of the widget
        ],
      ),
    ),
  );
}
// ...
```

##### Overriding `CommonLayout` resolver
---

To override the sizes for each breakpoint, you can provide your own `CommonLayout` instance:

```dart
import 'package:layoutr/common_layout.dart';
// ...
CommonLayoutWidget(
  resolverBuilder: (constraints) => CommonLayout(constraints.maxWidth, desktop: 800, tablet: 520),
  child: /* My child */,
);
// ...
```

> **TLDR: your app don't need to necessarily use `MaterialApp` (or `WidgetsApp`), just add it above your top-most widget.**
> 
> Long version: it's probably the best to add the resolver widget above the top-most widget of your tree, because the all built-in widgets use a `LayoutBuilder` to provide such responsive features, and this may create inconsistencies if they are created in nested widgets, which will only use the parent's `BoxConstraints`. This could also be useful if you wanted to created a resolver that is not necessarily related to the device's sizes, but I fail to see a useful scenario like this at the moment.

##### Overriding `CommonLayout` spacings
---
To override the spacings for each breakpoint, you can provide your own `RawSpacings` instance:

```dart
import 'package:layoutr/common_layout.dart';
// ...
CommonLayoutWidget(
  spacings: const RawSpacings(4, 12, 20, 24, 32, 40, 48, 56, 60),
  child: /* My child */,
);
// ...
```

While the above will customize all spacings for all breakpoints, it's still not responsive, and that's fine. You may
want to use the spacings for the sole benefit of type-safety utilities. Now if you also want them to be responsive,
there is a constructor for that:

```dart
import 'package:layoutr/common_layout.dart';

// ...
CommonLayoutWidget.withResponsiveSpacings(
  desktopSpacings: RawSpacings(8, 16, 24, 32, 40, 52, 60, 68, 80),
  phoneSpacings: RawSpacings(4, 8, 12, 20, 28, 36, 40, 48, 60),
  child: /* My child */,
);
// ...
```

Not sure what spacings mean? Check out [spacings](#spacings).

----
Tips:
- we can easily use this package with common libraries like `provider` (see in [`example/`](example/provider_usage/)) and `river_pod` (see in [`example/`](example/river_pod_usage/`));
- everything explained here is same for all built-in resolvers (like `GranularLayout`), they just differ in the
breakpoints amount/types.

#### Available Built-in `LayoutResolver`
---

- `CommonLayout`: a resolver split in 4 breakpoints: `desktop`, `tablet`, `phone` and `tinyHardware`. Import this resolver through `package:layoutr/common_layout.dart` - (see in [`example/`](example/common_layout/));
- `GranularLayout`: a resolver split in 6 breakpoints: `xxLarge`, `xLarge`, `large`, `medium`, `small` and `xSmall`. Import this resolver through `package:layoutr/granular_layout.dart` - (see in [`example/`](example/granular_layout/)).

#### Custom `LayoutResolver`
---

If the above built-in resolvers don't match the requirements, `LayoutResolver` can be customized by extending it, taking advantage of the utilities built-in in the abstract class itself. To extend the and implement your custom `LayoutResolver`, import `package:layoutr/layoutr.dart`. Check out a custom implementation example in the [`example/`](example/custom_layout/).

### Spacings

All spacing features revolve around `Spacing` enumerator. These are named ranges that should usually fit most use-cases
out there in the wild. They are pretty intuitive: `xxxSmall`, `xxSmall`, `xSmall`, `small`, `medium`, ... and so on.

Spacings are an additional help for situations where we need type-safety, responsivity, or both. Being more specific:
- type-safety: even if you don't want to use it as a responsive value, you will still benefit from having a type-safe
system that will prevent inconsistent spacings, margins and paddings in your application;
- responsivity: the spacings can be customized to one, some or all breakpoints, meaning that you won't have to change
anything if you use the `Spacing` type system.

All built-in `LayoutResolver` will provide the spacings out-of-the-box, so no need to add anything extra other than your root widget. But this might not be the best for most. If wanted, one could use only this package's feature alone (with `SpacingsInheritedWidget`), like so:

```dart
import 'package:layoutr/layoutr.dart';

// ...
LayoutBuilder(
  builder: (context, constraints) {
    // If we wanted, we could use this spacings type-safety/responsivity without the resolver themselves
    final myCustomSpacings = constraints.maxWidth > 800
        ? RawSpacings(16, 24, 32, 40, 52, 60, 68, 76, 80)
        : RawSpacings(8, 12, 24, 32, 40, 48, 56, 64, 72);

    return SpacingsInheritedWidget(
      spacings: myCustomSpacings,
      child: // ... ,
    );
  },
);
// ...
```

Alone this can be somewhat useful, but its potential is enhanced with the built-in utilities and resolvers
widgets - you can even build your own by extending any `BuildContext`, `Widget` or any layout-related element.

An example usage with some of the utilities:

```dart
import 'package:layoutr/layoutr.dart';

// SpacingMixin just helps you to call spacings like `smallSpacing`, instead of `Spacing.smallSpacing`, making it
// overall less verbose.
class MyPage extends StatelessWidget with SpacingMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('My page'),
          // Creates a vertical responsive/type-safe spacing
          context.verticalBox(xxxLargeSpacing), 
          Container(
            // Creates a vertical symmetrical insets responsive/type-safe spacing
            margin: context.symmetricInsets(vertical: smallSpacing),
            color: Colors.amber,
            // Wraps this widget in a Padding with all insets to this responsive/type-safe spacing
            child: Placeholder().withAllPadding(context, mediumSpacing),
          ),
        ],
      ),
    );
  }
}
```

### Utilities

- Syntax-sugar for common use-cases, like: `deviceWidth` and `deviceHeight`;
- [Helpers] for commonly used elements like `EdgeInsets` and `Padding`, using `Spacing`.

Check out all [spacing utilities](lib/src/utilities.dart).

## Reference OS Projects

List of open source projects that use this package and can be used as a reference to implement your own use-cases:

WIP

## Contributing

Want to contribute? Check it out [here](CONTRIBUTING.md).