import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:game/other/puzzle_position.dart';

class PuzzleTile extends Equatable {
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

  ///
  final Position correctPosition;
  final Position currentPosition;

  final bool whiteSpace;

  bool get isInCorrectPosition =>
      correctPosition.compareTo(currentPosition) == 0;

  PuzzleTile copyWith({required Position newPosition}) {
    return PuzzleTile(
      value: value,
      image: image,
      correctPosition: correctPosition,
      currentPosition: newPosition,
      whiteSpace: whiteSpace,
    );
  }

  @override
  List<Object?> get props => [
        image,
        correctPosition,
        currentPosition,
        whiteSpace,
      ];
}
