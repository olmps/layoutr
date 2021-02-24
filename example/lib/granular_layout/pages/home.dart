import 'package:flutter/material.dart';
import 'package:layoutr/granular_layout.dart';

import 'package:layoutr_example/shared.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layout = context.granularLayout;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Splitted Page Structure'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: Column(
            children: [
              layout.value(
                xxLarge: () => Text('xxLarge and xLarge layout', style: textTheme.headline2),
                large: () => Text('large only layout', style: textTheme.headline3),
                medium: () => Text('medium only layout', style: textTheme.headline5),
                small: () => Text('small only layout', style: textTheme.headline5),
                xSmall: () => const Text('xSmall only layout'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: layout.value(
                    xxLarge: () => _LargeHomeContents(
                      leftChildren: generateRandomContainers(amount: 120),
                      rightChildren: generateRandomContainers(amount: 40),
                    ),
                    large: () => _LargeHomeContents(
                      leftChildren: generateRandomContainers(amount: 80),
                      rightChildren: generateRandomContainers(amount: 20),
                    ),
                    medium: () => _HomeContents(children: generateRandomContainers(amount: 40)),
                    small: () => _CompactHomeContents(children: generateRandomContainers(amount: 20)),
                    xSmall: () => _CompactHomeContents(children: generateRandomContainers(amount: 8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/details');
        },
        child: const Icon(Icons.arrow_drop_up),
      ),
    );
  }
}

class _LargeHomeContents extends StatelessWidget {
  const _LargeHomeContents({required this.leftChildren, required this.rightChildren, Key? key}) : super(key: key);
  final List<Widget> leftChildren;
  final List<Widget> rightChildren;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _HomeContents(children: leftChildren)),
        const SizedBox(width: 100),
        _CompactHomeContents(children: rightChildren),
      ],
    );
  }
}

class _HomeContents extends StatelessWidget {
  const _HomeContents({required this.children, Key? key}) : super(key: key);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 20,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}

class _CompactHomeContents extends StatelessWidget {
  const _CompactHomeContents({required this.children, Key? key}) : super(key: key);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.map((child) => Padding(padding: const EdgeInsets.only(bottom: 4), child: child)).toList(),
    );
  }
}
