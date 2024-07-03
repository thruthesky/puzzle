import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/other/puzzle.model.state.dart';
import 'package:game/other/puzzle.service.dart';
import 'package:game/other/puzzle_tile.model.dart';

/// [isActive] is set to true when the game has started.
final isActive = StateProvider<bool>((ref) => false);

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

final timer = StateProvider<Timer>(
    (ref) => Timer.periodic(const Duration(seconds: 1), (t) => t));

final moveCounter = NotifierProvider<MoveCounter, int>(() => MoveCounter());

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

final puzzleImagesProvider =
    NotifierProvider<Puzzle, List<PuzzleTile>>(() => Puzzle());

final imageSplitter = FutureProvider(
  (ref) async => await PuzzleService.instance.splitImage(
    'assets/animals.jpg',
    ref.watch(gridSize),
  ),
);
