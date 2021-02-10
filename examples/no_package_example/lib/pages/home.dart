import 'dart:math';

import 'package:flutter/material.dart';
import 'package:responsive_layout/common_layout.dart';

class HomePage extends StatelessWidget {
    final _randomMockedChildren = List.generate(20, (index) => Container(
      width: (Random().nextInt(100) + 40).toDouble(),
      height: (Random().nextInt(100) + 40).toDouble(),
      color: Colors.primaries[index % Colors.primaries.length],
    ),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.isTabletOrSmaller ? AppBar(
        title: Text('Splitted Home'),
      ) : null,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            child: context.layoutValue(
              tablet: _HomeContents(children: _randomMockedChildren),
              phone: _CompactHomeContents(children: _randomMockedChildren),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/details');
          },
          child: Icon(Icons.arrow_drop_up),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children.map((child) => Padding(padding: EdgeInsets.only(bottom: 4), child: child)).toList(),
    );
  }
}