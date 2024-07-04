import 'package:flutter/widgets.dart';

class PuzzleTile {
  const PuzzleTile({
    required this.value,
    required this.image,
    this.whiteSpace = false,
  });

  /// The image of the tile that can be display
  final Image image;

  final int value;

  final bool whiteSpace;
}
