import 'package:flutter/material.dart';
import 'package:layoutr/common_layout.dart';

void main() {
  runApp(SplitViewExample());
}

class SplitViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Used `CommonLayoutWidget` for the sake of the example, could use `GranularLayoutWidget` or even
    // your custom layout resolver, nothing would change here.
    return CommonLayoutWidget.withResponsiveSpacings(
      // In this particular case, we are changing the responsive spacings as well, so we can exemplify the responsivity
      // of such cases as well.
      desktopSpacings: const RawSpacings(12, 16, 20, 24, 28, 32, 40, 48, 60),
      tabletSpacings: const RawSpacings(8, 12, 16, 20, 24, 28, 32, 36, 40),
      phoneSpacings: const RawSpacings(4, 8, 12, 16, 20, 24, 28, 32, 36),
      child: MaterialApp(home: HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// Root page that sticks together both list contents and the details of each list item
class _HomePageState extends State<HomePage> {
  int? _selectedDetailsIndex;

  String? get _selectedDetailsTitle => _selectedDetailsIndex != null ? 'Element number $_selectedDetailsIndex' : null;

  @override
  Widget build(BuildContext context) {
    final layout = context.commonLayout;

    final listContents = ListContents(
      onTap: (itemIndex) {
        // If we are on tablet or larger, we will update the selected item with setState, so it can rebuild the
        // structure, showing which item is selected, all on the same "page"
        if (layout.isTabletOrLarger) {
          setState(() {
            // Toggle between selected and unselected, if the item is the current selected
            _selectedDetailsIndex = _selectedDetailsIndex == itemIndex ? null : itemIndex;
          });
        } else {
          // Otherwise we default to a navigation
          _navigateToDetails(context, itemIndex: itemIndex);
        }
      },
      // We want to allow the highligh only if we are on a tablet or larger
      highlightedItemIndex: layout.isTabletOrLarger ? _selectedDetailsIndex : null,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Split View')),
      body: Row(
        children: [
          // list contents will always appear, but with a ratio depending on the current breakpoint
          Flexible(flex: layout.value(desktop: () => 3, tablet: () => 7), child: listContents),
          // The split view will only appear when the size is tablet or larger
          if (layout.isTabletOrLarger) ...[
            // Divider to visually distinguish both elements containers
            Container(
              width: 4,
              color: Colors.grey,
            ),
            Flexible(
              // The list details ratio is proportional to the list contents, adjusting to the most suitable size, just
              // like the list contents
              flex: layout.value(desktop: () => 7, tablet: () => 3),
              child: DetailsContents(title: _selectedDetailsTitle),
            ),
          ],
        ],
      ),
    );
  }

  void _navigateToDetails(BuildContext context, {required int itemIndex}) {
    Navigator.of(context).push<dynamic>(
      MaterialPageRoute<dynamic>(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Details')),
            body: DetailsContents(title: 'Element number $itemIndex'),
          );
        },
      ),
    );
  }
}

// Displays a fake list of elements that can have one selected at moment
class ListContents extends StatelessWidget with SpacingMixin {
  ListContents({required this.onTap, this.highlightedItemIndex});

  static const _fakeDataSourceSize = 20;

  final void Function(int itemIndex) onTap;
  final int? highlightedItemIndex;

  @override
  Widget build(BuildContext context) {
    final layout = context.commonLayout;

    return ListView(
      shrinkWrap: true,
      children: List.generate(_fakeDataSourceSize, (index) {
        final isSelected = highlightedItemIndex == index;
        final selectionIcon = isSelected ? Icons.check_circle : Icons.circle;

        // Always keep in mind to also change the experience of your application to not simply visually re-order things,
        // like changing structural clues to the user.
        final trailingIcon = Icon(layout.isPhoneOrSmaller ? Icons.arrow_forward_ios : selectionIcon);

        return ListTile(
          title: Text('Element number $index'),
          trailing: trailingIcon,
          selected: isSelected,
          onTap: () => onTap(index),
          contentPadding: context.allInsets(xxSmallSpacing),
        );
      }),
    );
  }
}

// Displays the contents of a item with an optional title
class DetailsContents extends StatelessWidget with SpacingMixin {
  DetailsContents({this.title, Key? key}) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    final layout = context.commonLayout;

    // Simulates an "empty state" for split-view screens that will show this even when there isn't a highlighted item
    if (title == null) {
      return const Center(child: Icon(Icons.help_center, size: 40));
    }

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You are currently viewing',
            // Adjusts the text style based on the current breakpoint
            style:
                layout.isPhoneOrSmaller ? Theme.of(context).textTheme.caption : Theme.of(context).textTheme.subtitle1,
          ),
          // Adds a relative mediumSpacing that will be responsive depending on the current breakpoint
          context.verticalBox(mediumSpacing),
          Container(
            // Adjusts the container color based on the current breakpoint
            color: layout.value(
              desktop: () => Colors.amber,
              tablet: () => Colors.purple,
              phone: () => Colors.indigo,
            ),
            child: Text(
              title!,
              // Adjusts the text style based on the current breakpoint
              style: layout.isTabletOrSmaller
                  ? Theme.of(context).textTheme.headline6
                  : Theme.of(context).textTheme.headline4,
            ),
          ),
        ],
      ),
      // Uses the helper to add a responsive padding to this container
    ).withAllPadding(context, largeSpacing);
  }
}
