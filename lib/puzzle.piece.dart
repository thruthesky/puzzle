import 'package:flutter/material.dart';

/// PuzzlePiece is a widget that represents a piece of the puzzle.
///
/// It has a [content] that can be an image or a number, a [space] that is a
/// boolean that represents if the piece is empty or not, and a [numbered] that
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
  final String content;
  final bool space;
  final bool numbered;

  @override
  State<PuzzlePiece> createState() => _PuzzlePieceState();
}

class _PuzzlePieceState extends State<PuzzlePiece> {
  // int index;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.space ? null : widget.onTap,

      /// TODO make hero work
      child: Hero(
        tag: 'dash',
        child: widget.space
            ? const SizedBox.shrink()
            : widget.numbered
                ? Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryFixed,
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        widget.content,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  )
                : Image.asset(
                    widget.content,
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
      ),
    );
  }
}
