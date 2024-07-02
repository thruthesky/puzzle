import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/puzzle.board.dart';
import 'package:game/puzzle.state.dart';

class PuzzleScreen extends ConsumerWidget {
  const PuzzleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('rebuild');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('Moves: ${ref.watch(moveCounter)}'),
            Expanded(
              child: PuzzleBoard(
                crossAxisCount: ref.watch(gridSize),
                images: ref.watch(puzzleImagesProvider),
              ),
            ),
            ElevatedButton(
                onPressed: () => ref.read(moveCounter.notifier).increment(),
                child: const Text('+ move')),
            ElevatedButton(
              onPressed: () {
                // ref.read(puzzleImagesProvider.notifier).shuffle();
                ref.read(isActive.notifier).state = true;
              },
              child: const Text('Play'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(gridSize.notifier).state =
                    ref.read(gridSize) == 3 ? 4 : 3;
                ref.read(isActive.notifier).state = false;
              },
              child:
                  Text('Change to ${ref.watch(gridSize) == 3 ? '4x4' : '3x3'}'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(gridSize.notifier).state =
                    ref.read(gridSize) == 3 ? 4 : 3;
                ref.read(isActive.notifier).state = false;
              },
              child: Text(
                  'Change to Numbered ${ref.watch(gridSize) == 3 ? '4x4' : '3x3'}'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
