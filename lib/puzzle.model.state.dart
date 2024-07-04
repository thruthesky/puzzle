import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/puzzle.state.dart';
import 'package:game/puzzle_tile.model.dart';

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

  /// Shuffles the list to a new solvable puzzle
  void shuffle() async {
    state.shuffle();
    // final oldState = state;
    // List<int> movableTiles = [];
    // PuzzleTile lastMove = state.last;
    // PuzzleTile whiteSpace = state.singleWhere((tile) => tile.whiteSpace);
    ref.notifyListeners();
  }

  /// Use this to generate a board with a custom or uploaded file
  /// This accepts [url] from assets or Firebase Storage URL
  setNewImage(String url) async {
    state.clear();
    ref.read(imageToSplit.notifier).state = url;
    ref.notifyListeners();
  }

  /// Check if the Puzzle Tile is movable or not
  isMovable(int index) {
    return index - 1 >= 0 && state[index - 1].whiteSpace && index % size != 0 ||
        index + 1 < state.length &&
            state[index + 1].whiteSpace &&
            (index + 1) % size != 0 ||
        (index - size >= 0 && state[index - size].whiteSpace ||
            index + size < state.length && state[index + size].whiteSpace);
  }

  /// This will swap the value of the index of whiteSpace and [index] from params
  moveGrid(int index) {
    PuzzleTile whiteSpace = state.singleWhere((tile) => tile.whiteSpace);

    // final col = whiteSpace.currentPosition.y;
    // final row = whiteSpace.currentPosition.x;

    // List<PuzzleTile> tileX =
    //     state.where((tile) => tile.currentPosition.x == row).toList();
    // List<PuzzleTile> tileY =
    //     state.where((tile) => tile.currentPosition.y == col).toList();

    // final moveRow = state[index].currentPosition.x == row;
    // final moveCol = state[index].currentPosition.y == col;

    // print(moveRow);
    // print(moveCol);

    state[state.indexOf(whiteSpace)] = state[index].copyWith(
        position: whiteSpace.currentPosition, index: whiteSpace.value);
    state[index] = whiteSpace.copyWith(
        position: state[index].currentPosition, index: state[index].value);

    ref.notifyListeners();
  }
}
