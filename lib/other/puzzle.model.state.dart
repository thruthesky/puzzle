import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/other/puzzle.state.dart';
import 'package:game/other/puzzle_position.dart';
import 'package:game/other/puzzle_tile.model.dart';

class Puzzle extends Notifier<List<PuzzleTile>> {
  @override
  List<PuzzleTile> build() {
    List<PuzzleTile> result = [];
    final asyncValue = ref.watch(imageSplitter);
    if (!asyncValue.isLoading) {
      asyncValue.whenData((tile) => result.addAll(tile));
    }
    return result;
  }

  int get size => ref.watch(gridSize);
  bool get isNumber => ref.watch(isNumbered);

  /// manually shuffles the list until its solvable
  /// NOTE: isSolvable() is not finalized yet
  void shuffle(bool active) {
    do {
      state = _generatePuzzle(size);
      sort();
    } while (!isSolvable());
    ref.read(isActive.notifier).state = active;
    if (active) {
      ref.read(timer);
    }
    ref.notifyListeners();
  }

  /// Build a randomized, solvable puzzle of the given size.
  _generatePuzzle(int size) {
    Random? random;
    final currentPositions = <Position>[];

    // Create all possible board positions.
    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {
        final position = Position(x: x, y: y);
        currentPositions.add(position);
      }
    }

    currentPositions.shuffle(random);

    final tiles = [
      for (int i = 0; i < state.length; i++)
        state[i].copyWith(newPosition: currentPositions[i]),
    ];
    print(tiles.first.correctPosition);
    print(tiles.first.currentPosition);
    return tiles;
  }

  isMovable(int index) {
    List<PuzzleTile> images = state;
    int boardSize = size;
    return index - 1 >= 0 && images[index - 1].whiteSpace || // left
        index + 1 < state.length && state[index + 1].whiteSpace || // right
        (index - boardSize >= 0 && state[index - boardSize].whiteSpace || // top
            index + boardSize < state.length &&
                state[index + boardSize].whiteSpace);
  }

  moveGrid(int index) {
    final whiteSpace = state.singleWhere((tile) => tile.whiteSpace);

    // final currTile = state[index].copyWith(
    //   newPosition: whiteSpace.currentPosition,
    // );
    // final whSpace = whiteSpace.copyWith(
    //   newPosition: state[index].currentPosition,
    // );
    state[state.indexOf(whiteSpace)] = state[index];
    state[index] = whiteSpace;

    print('wh curr : --> ${whiteSpace.currentPosition}');
    print('wh corr : --> ${whiteSpace.correctPosition}');
    print('current : --> ${state[index].currentPosition}');
    print('correct : --> ${state[index].correctPosition}');
    ref.notifyListeners();
  }

  int get numberOfCorrectTiles {
    final whiteSpaceTile = state.singleWhere((tile) => tile.whiteSpace);
    int noOfCorrectTiles = 0;
    for (final tile in state) {
      if (tile != whiteSpaceTile) {
        if (tile.correctPosition == tile.currentPosition) {
          noOfCorrectTiles++;
        }
      }
    }
    return noOfCorrectTiles;
  }

  bool get isComplete {
    return state.length == numberOfCorrectTiles + 1;
  }

  /// Determines if the puzzle is solvable.
  bool isSolvable() {
    final height = state.length ~/ size;
    assert(
      size * height == state.length,
      'tiles must be equal to size * height',
    );
    final inversions = countInversions();
    final whitespace = state.singleWhere((tile) => tile.whiteSpace);
    final whitespaceRow = whitespace.currentPosition.y;

    if (((height - whitespaceRow) + 1).isOdd) {
      return inversions.isEven;
    } else {
      return inversions.isOdd;
    }
  }

  /// Sorts puzzle tiles so they are in order of their current position.
  sort() {
    final t = state.toList()
      ..sort((tileA, tileB) {
        return tileA.currentPosition.compareTo(tileB.currentPosition);
      });
    state = t;
  }

  int countInversions() {
    var count = 0;
    for (var a = 0; a < state.length; a++) {
      final tileA = state[a];
      if (tileA.whiteSpace) {
        continue;
      }

      for (var b = a + 1; b < state.length; b++) {
        final tileB = state[b];
        if (_isInversion(tileA, tileB)) {
          count++;
        }
      }
    }
    return count;
  }

  /// Determines if the two tiles are inverted.
  bool _isInversion(PuzzleTile a, PuzzleTile b) {
    if (!b.whiteSpace && a.value != b.value) {
      if (b.value < a.value) {
        return b.currentPosition.compareToForInversion(a.currentPosition) > 0;
      } else {
        return a.currentPosition.compareToForInversion(b.currentPosition) > 0;
      }
    }
    return false;
  }
}
