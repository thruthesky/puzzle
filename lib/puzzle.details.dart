import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/puzzle.state.dart';

class PuzzleMenuBar extends StatelessWidget {
  const PuzzleMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) => Container(
        decoration: const BoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Move: ${ref.watch(moveCounter)}"),
          ],
        ),
      ),
    );
  }
}
