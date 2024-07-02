import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/puzzle.piece.dart';
import 'package:game/puzzle.state.dart';

class PuzzleBoard extends ConsumerWidget {
  const PuzzleBoard({
    super.key,
    required this.crossAxisCount,
    required this.images,
  });

  final int crossAxisCount;
  final List<String> images;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) => PuzzlePiece(
        numbered: ref.watch(isNumbered), // state.isNumber,
        content: images[index],
        space: images[index] == "0",
        onTap: ref.watch(isActive)
            ? () {
                moveImage(context, ref, index);
              }
            : null,
      ),
    );
  }

  moveImage(BuildContext context, WidgetRef ref, int index) {
    if (ref.read(puzzleImagesProvider.notifier).isMovable(index)) {
      /// ref.watch(provider); 와 같이 하면 state 를 참조한다.
      /// ref.watch(provider.notifier) 와 같이 하면 provider 의 클래스 모델을 참조한다.
      /// ref.watch(isActive.notifier).state = true; 같이 하여, .state 를 통해서 state 를 바로 변경 할 수 있다.
      ref.read(puzzleImagesProvider.notifier).moveGrid(index);
      checkWin(context, ref);

      ref.read(moveCounter.notifier).increment();
    }
  }

  checkWin(BuildContext context, WidgetRef ref) {
    if (isSorted(ref)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Congrats! You Won!'),
        ),
      );
    }
  }

  isSorted(WidgetRef ref) {
    bool result = true;
    int index = 1;

    for (String item in ref.watch(puzzleImagesProvider)) {
      if (!item.startsWith("0") && index == 16) result = false;
      if (!item.startsWith("0") &&
          index != int.parse(item.split("/").last.substring(5, 8))) {
        result = false;
      }
      index++;
    }
    return result;
  }
}
