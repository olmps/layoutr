import 'dart:math';

import 'package:flutter/material.dart';

/// Creates a list of [Container] with random colors and sizes
List<Container> generateRandomContainers({required int amount}) {
  final randomGenerator = Random();
  const baseSize = 100;
  const randomIncrement = 40;

  return List.generate(
    amount,
    (index) => Container(
      width: (randomGenerator.nextInt(baseSize) + randomIncrement).toDouble(),
      height: (randomGenerator.nextInt(baseSize) + randomIncrement).toDouble(),
      color: Colors.primaries[index % Colors.primaries.length],
    ),
  );
}
