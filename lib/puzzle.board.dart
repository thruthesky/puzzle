import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/puzzle.piece.dart';
import 'package:game/puzzle_tile.model.dart';
import 'package:game/puzzle.state.dart';

class PuzzleBoard extends StatelessWidget {
  const PuzzleBoard({
    super.key,
    required this.crossAxisCount,
    required this.puzzleTiles,
    this.numbered = false,
    this.active = false,
  });

  final int crossAxisCount;
  final List<PuzzleTile> puzzleTiles;
  final bool numbered;
  final bool active;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: puzzleTiles.length,
      itemBuilder: (context, index) => Consumer(
        builder: (context, ref, child) => PuzzlePiece(
          key: ValueKey(puzzleTiles[index].value.toString()),
          numbered: numbered, // state.isNumber,
          content: puzzleTiles[index].image,
          space: puzzleTiles[index].whiteSpace,
          onTap: () {
            moveImage(context, ref, index);
          },
        ),
      ),
    );
  }

  moveImage(BuildContext context, WidgetRef ref, int index) {
    final imageProvider = ref.read(puzzleImagesProvider.notifier);
    if (imageProvider.isMovable(index)) {
      /// ref.watch(provider); 와 같이 하면 state 를 참조한다.
      /// ref.watch(provider.notifier) 와 같이 하면 provider 의 클래스 모델을 참조한다.
      /// ref.watch(isActive.notifier).state = true; 같이 하여, .state 를 통해서 state 를 바로 변경 할 수 있다.
      imageProvider.moveGrid(index);
      (context, ref);

      ref.read(moveCounter.notifier).increment();
    }
  }
}
