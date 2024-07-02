import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/puzzle.defines.dart';

/// [isActive] is set to true when the game has started.
final isActive = StateProvider<bool>((ref) => false);

/// [PuzzleImages] is a list of images that are shuffled and moved by users in the board.
///
/// [ref] is provided by default?
///
/// [state] is the state of the provider?
///
/// [build] returns the state?
///
/// Notifier 에는 state 의 Generic Type 을 지정한다.
///
class PuzzleImages extends Notifier<List<String>> {
  /// The default state. The images are the bird images.
  @override
  List<String> build() {
    int size = ref.watch(gridSize);

    /// used a spread operator to return the value as a new list
    /// and the original list are constant

    return [...size == 3 ? bird : whale];
  }

  /// Shuffles the images.
  void shuffle() {
    /// [shuffle] reorder the items of the list but not changing its state
    /// to work around this we need to reassign it to our state as a new value

    state.shuffle(); // new list state
    state = [...state]; // reassign to state
  }

  moveGrid(int index) {
    state[state.indexOf("0")] = state[index];
    state[index] = "0";
    state = [...state]; // reassign to state
  }

  reset() {
    state = [...ref.watch(gridSize) == 3 ? bird : whale];
  }

  isMovable(int index) {
    List<String> images = state;
    int boardSize = ref.read(gridSize);
    return index - 1 >= 0 && images[index - 1] == "0" || // left
        index + 1 < state.length && state[index + 1] == "0" || // right
        (index - boardSize >= 0 && state[index - boardSize] == "0" || // top
            index + boardSize < state.length &&
                state[index + boardSize] == "0");
  }
}

final puzzleImagesProvider =
    NotifierProvider<PuzzleImages, List<String>>(() => PuzzleImages());

/// [MoveCounter] is a counter that counts the number of moves the user has made.
class MoveCounter extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void reset() {
    state = 0;
  }
}

final moveCounter = NotifierProvider<MoveCounter, int>(() => MoveCounter());

/// [timeElapsed] is the time elapsed since the game started.
final timeElapsed = StateProvider<int>((ref) => 0);

/// [gridSize] is the size of the grid. It is a square grid, so it is the
/// number of rows and columns. If it's 2 then it will be 2 by 2, if it's 3
/// then it will be 3 by 3, and so on. The default is 4. and the maximum is 9.
final gridSize = StateProvider<int>((ref) => 4);

/// [gridChanged] if the user changes the size of the grid, this will be set to true.
/// This will trigger the [PuzzleBoard] to rebuild with the new grid size.
final gridChanged = StateProvider<bool>((ref) => false);

/// [isNumbered] is set to true when the user wants to play with numbers instead of images.
final isNumbered = StateProvider<bool>((ref) => false);

/// [numberedArray] is the list of numbers that will be displayed in the board.
final numberedArray = Provider<List<String>>((ref) {
  int size = ref.watch(gridSize);
  final List<String> numbers = [];
  for (int i = 1; i < size * size; i++) {
    numbers.add(i.toString());
  }
  numbers.add("0");
  return numbers;
});

class ElapsedTimer extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  int value = 0;
  late Timer timer;

  reset() {
    state = 0;
    timer.cancel();
  }

  startTime() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) => state++);
  }
}

final countTime = NotifierProvider<ElapsedTimer, int>(ElapsedTimer.new);
