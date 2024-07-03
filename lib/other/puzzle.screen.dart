import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/other/puzzle.board.dart';
import 'package:game/other/puzzle.state.dart';

class OtherPuzzleScreen extends StatelessWidget {
  const OtherPuzzleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Consumer(builder: (context, ref, child) {
          int size = ref.watch(gridSize);
          List<Widget> items = List.generate(
            size,
            (index) => Expanded(
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          );
          return SizedBox(
            height: 550,
            child: Column(
              children: [
                Row(
                  children: items,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Column(
                        children: items,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PuzzleBoard(
                          crossAxisCount: ref.watch(gridSize),
                          puzzleTiles: ref.watch(puzzleImagesProvider),
                          numbered: ref.watch(isNumbered),
                          active: ref.watch(isActive),
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  children: [
                    _changeSize('2x2', ref, size: 2),
                    _changeSize('3x3', ref, size: 3),
                    _changeSize('4x4', ref, size: 4),
                    _changeSize('5x5', ref, size: 5),
                    _changeSize('6x6', ref, size: 6),
                    _changeSize('7x7', ref, size: 7),
                    _changeSize('8x8', ref, size: 8),
                    _changeSize('9x9', ref, size: 9),
                  ],
                ),
                _btn('Play', () {
                  ref.read(puzzleImagesProvider.notifier).shuffle(true);
                }),
              ],
            ),
          );
        }),
      ),
    );
  }

  ElevatedButton _changeSize(String label, WidgetRef ref, {required int size}) {
    return ElevatedButton(
      onPressed: () => ref.read(gridSize.notifier).state = size,
      child: Text(label),
    );
  }

  ElevatedButton _btn(
    String label,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
