import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/other/puzzle.state.dart';
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
  void shuffle() async {
    ref.read(isActive.notifier).state = true;
    ref.notifyListeners();
  }

  setNewImage(String url) async {
    state.clear();
    ref.read(imageToSplit.notifier).state = url;
    ref.notifyListeners();
  }

  isMovable(int index) {
    List<PuzzleTile> images = state;
    return index - 1 >= 0 &&
            images[index - 1].whiteSpace &&
            index % size != 0 || // left
        index + 1 < state.length &&
            state[index + 1].whiteSpace &&
            (index + 1) % size != 0 || // right
        (index - size >= 0 && state[index - size].whiteSpace || // top
            index + size < state.length && state[index + size].whiteSpace);
  }

  moveGrid(int index) {
    final whiteSpace = state.singleWhere((tile) => tile.whiteSpace);
    state[state.indexOf(whiteSpace)] = state[index];
    state[index] = whiteSpace;
    ref.notifyListeners();
  }
}
