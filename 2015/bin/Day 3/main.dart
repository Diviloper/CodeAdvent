import 'dart:io';

import 'package:equatable/equatable.dart';

void main() {
  final input = File('input.txt').readAsStringSync().split('');
  final visitedHouses = <Coords>{Coords(0, 0)};
  Coords santa = Coords(0, 0);
  Coords roboSanta = Coords(0, 0);
  bool santaTurn = true;
  for (final direction in input) {
    if (santaTurn) {
      santa = santa.move(direction);
      visitedHouses.add(santa);
    } else {
      roboSanta = roboSanta.move(direction);
      visitedHouses.add(roboSanta);

    } santaTurn = !santaTurn;
  }
  print(visitedHouses.length);
}

class Coords extends Equatable {
  final int x;
  final int y;

  Coords(this.x, this.y);

  Coords move(String direction) {
    switch (direction) {
      case '^':
        return north();
      case 'v':
        return south();
      case '>':
        return east();
      case '<':
        return west();
      default:
        return null;
    }
  }

  Coords north() => Coords(x + 1, y);

  Coords south() => Coords(x - 1, y);

  Coords east() => Coords(x, y + 1);

  Coords west() => Coords(x, y - 1);

  @override
  List<Object> get props => [x, y];
}
