import 'package:flutter/widgets.dart';
import 'package:game/puzzle_position.dart';

class PuzzleTile {
  const PuzzleTile({
    required this.value,
    required this.image,
    required this.correctPosition,
    required this.currentPosition,
    this.whiteSpace = false,
  });

  /// The image of the tile that can be display
  final Image image;

  final int value;

  final bool whiteSpace;

  ///
  final Position correctPosition;
  final Position currentPosition;

  /// Create a copy of a tile with a new property value
  PuzzleTile copyWith({required Position position, required int index}) {
    return PuzzleTile(
      value: index,
      image: image,
      correctPosition: correctPosition,
      currentPosition: position,
      whiteSpace: whiteSpace,
    );
  }
}
