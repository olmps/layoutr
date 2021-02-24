import 'package:flutter/material.dart';
import 'package:layoutr/common_layout.dart';

import 'package:layoutr_example/shared.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layout = context.commonLayout;
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
                desktop: () => Text('Desktop layout', style: textTheme.headline1),
                tablet: () => Text('Tablet layout', style: textTheme.headline3),
                phone: () => Text('Phone layout', style: textTheme.headline4),
                tinyHardware: () => Text('Tiny Hardware layout', style: textTheme.headline6),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: layout.value(
                    desktop: () => _HomeContents(children: generateRandomContainers(amount: 100)),
                    tablet: () => _HomeContents(children: generateRandomContainers(amount: 40)),
                    phone: () => _CompactHomeContents(children: generateRandomContainers(amount: 20)),
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
