import 'package:equatable/equatable.dart';

/// The 2-Dimensional position model
/// (1, 1) is the top left corner of the board.
class Position extends Equatable implements Comparable<Position> {
  const Position({required this.x, required this.y});

  final int x;
  final int y;

  @override
  List<Object?> get props => [x, y];

  @override
  int compareTo(Position other) {
    return (y - x) - (other.y - other.x);
  }
}

extension PositionExtension on Position {
  int compareToForInversion(Position other) {
    if (y < other.y) {
      return -1;
    } else if (y > other.y) {
      return 1;
    } else {
      if (x < other.x) {
        return -1;
      } else if (x > other.x) {
        return 1;
      } else {
        return 0;
      }
    }
  }
}
