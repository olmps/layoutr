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

The `CommonLayout` is split in 4 breakpoints: `desktop`, `tablet`, `phone` and `tinyHardware`. A simple usage of returning a responsive `Text` widget that has both its value and style customized based on the current device's constraints may be done like the below:
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

> You can see that there is no `tablet` supplied to the `layout.value`, and that is intended to exemplify a common scenario, where we may want to just provide two or three arguments - and that means not all possible scenarios are "covered" - and that's where the resolver comes in handy: if the **current breakpoint** value is not passed to `layout.value`, it will fallback to the "nearest" available one, fitting the most suitable layout for your particular value. This "nearest logic" can be confusing, but you can find out more how it works in `LayoutResolver.closestValue`

Also, if you want to keep the structure but want to override the sizes of each breakpoint, you can provide your `CommonLayout` instance through the InheritedWidget called `CommonLayoutWidget`:

```dart
import 'package:layoutr/common_layout.dart';

// ...

CommonLayoutWidget(
  resolver: CommonLayout(context.deviceWidth, desktop: 800),
  child: /* My child */,
);
// ...
```

> You will probably want to add these above the top-most widget of your tree, usually the `MaterialApp`, but be careful that `MediaQuery` may not be available if you don't have any other widget above `CommonLayoutWidget`, which is required when we use the `context.deviceWidth`. You can check out an [`example/`](https://pub.dev/packages/layoutr/example#Common-Layout-Inherited-Widget) that overrides the custom values. 

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
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(pageTitle, style: Theme.of(context).textTheme.headline3),
            ),
          // ... the rest of the widget
        ],
      ),
    ),
  );
}
// ...
```

Tip: we can easily use this package with common libraries like `provider` (see in [`example/`](https://pub.dev/packages/layoutr/example#`provider`)) and `river_pod` (see in [`example/`](https://pub.dev/packages/layoutr/example#`river_pod`)).

#### Available Built-in `LayoutResolver`
- `CommonLayout`: a resolver split in 4 breakpoints: `desktop`, `tablet`, `phone` and `tinyHardware`. Import this resolver through `package:layoutr/common_layout.dart` - (see in [`example/`](https://pub.dev/packages/layoutr/example#Common-Layout));
- `GranularLayout`: a resolver split in 6 breakpoints: `xxLarge`, `xLarge`, `large`, `medium`, `small` and `xSmall`. Import this resolver through `package:layoutr/granular_layout.dart` - (see in [`example/`](https://pub.dev/packages/layoutr/example#Granular-Layout)).

### Custom `LayoutResolver`

If the above built-in resolvers don't match the requirements, `LayoutResolver` can be customized by extending it, taking advantage of the utilities built-in in the abstract class itself. To extend the and implement your custom `LayoutResolver`, import `package:layoutr/layoutr.dart`. Check out a custom implementation example in the [`example/`](https://pub.dev/packages/layoutr/example#Custom-Layout).

### Utilities

- Syntax-sugar for common use-cases, like: `deviceWidth` and `deviceHeight` (plus a couple more that are WIP);
- Other helper Widgets are WIP.

## Reference OS Projects

List of open source projects that use this package and can be used as a reference to implement your own use-cases:

WIP

## Contributing

There is no rocket science to contributing to this project. Just open your issue or pull request if needed - but please be descriptive!

To submit a PR, follow [these useful guidelines](https://gist.github.com/MarcDiethelm/7303312), respect the dartfmt lint (modifications/exceptions may be discussed), and create an awesome description so we can understand it.

Even though there is no "rules" to how you should contribute, there goes my quick tips on it:

- If you're experiencing a bug that can be demonstrated visually, please take screenshots and post them alongside the issue;
- For a quicker/seamless understanding of the issue, please post a sample project, so the evaluation will be bulletproof;
- This is a git overall tip - do atomic commits with a descriptive message (no more than 50 characters is ideal).