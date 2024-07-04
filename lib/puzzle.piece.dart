import 'package:flutter/material.dart';

/// PuzzlePiece is a widget that represents a piece of the puzzle.
///
/// It has a [content] that can be an image or a number, a [space] that is a
/// boolean that represents if thesxax piece is empty or not, and a [numbered] that
/// is a boolean that represents if the piece is numbered or not.
///
/// It also has a [onTap] function that is called when the piece is tapped.
class PuzzlePiece extends StatefulWidget {
  const PuzzlePiece({
    super.key,
    this.onTap,
    required this.content,
    this.space = false,
    this.numbered = false,
  });
  final VoidCallback? onTap;
  final Image content;
  final bool space;
  final bool numbered;

  @override
  State<PuzzlePiece> createState() => _PuzzlePieceState();
}

class _PuzzlePieceState extends State<PuzzlePiece>
    with TickerProviderStateMixin {
  // int index;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.space ? null : widget.onTap,

      /// TODO make hero work
      child: Hero(
        tag: widget.content,
        child: widget.space
            ? const SizedBox.shrink()
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                clipBehavior: Clip.antiAlias,
                child: widget.content,
              ),
      ),
    );
  }
}
