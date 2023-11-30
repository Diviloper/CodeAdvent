import 'dart:collection';
import 'dart:io';

import '../common.dart';

enum Rails { vertical, horizontal, intersection, cornerTopDown, cornerBottomUp }
enum Direction { up, down, left, right }

extension StringRails on Rails {
  static Rails fromString(String source) {
    switch (source) {
      case '^':
      case 'v':
      case '|':
        return Rails.vertical;
      case '<':
      case '>':
      case '-':
        return Rails.horizontal;
      case '+':
        return Rails.intersection;
      case '/':
        return Rails.cornerBottomUp;
      case r'\':
        return Rails.cornerTopDown;
    }
    throw 'Invalid string';
  }
}

extension DirectionExt on Direction {
  static Direction fromString(String source) {
    switch (source) {
      case '^':
        return Direction.up;
      case 'v':
        return Direction.down;
      case '<':
        return Direction.left;
      case '>':
        return Direction.right;
    }
    throw 'Invalid string';
  }

  Direction change(Rails rails, int counter) {
    switch (rails) {
      case Rails.vertical:
      case Rails.horizontal:
        return this;
      case Rails.intersection:
        final turns = [
          (Direction d) => d.turnLeft(),
          (Direction d) => d,
          (Direction d) => d.turnRight(),
        ];
        return turns[counter % 3](this);
      case Rails.cornerTopDown:
        switch (this) {
          case Direction.up:
          case Direction.down:
            return turnLeft();
          case Direction.left:
          case Direction.right:
            return turnRight();
        }
      case Rails.cornerBottomUp:
        switch (this) {
          case Direction.up:
          case Direction.down:
            return turnRight();
          case Direction.left:
          case Direction.right:
            return turnLeft();
        }
    }
  }

  Direction turnLeft() {
    switch (this) {
      case Direction.up:
        return Direction.left;
      case Direction.left:
        return Direction.down;
      case Direction.down:
        return Direction.right;
      case Direction.right:
        return Direction.up;
    }
  }

  Direction turnRight() {
    switch (this) {
      case Direction.up:
        return Direction.right;
      case Direction.left:
        return Direction.up;
      case Direction.down:
        return Direction.left;
      case Direction.right:
        return Direction.down;
    }
  }
}

extension on Point {
  Point move(Direction direction) {
    switch (direction) {
      case Direction.up:
        return Point(x, y - 1);
      case Direction.down:
        return Point(x, y + 1);
      case Direction.left:
        return Point(x - 1, y);
      case Direction.right:
        return Point(x + 1, y);
    }
  }
}

typedef Cart = Tuple<Direction, int>;

int pointComparison(Point a, Point b) {
  final first = a.y.compareTo(b.y);
  return first != 0 ? first : a.x.compareTo(b.x);
}

void main() {
  final map = File('input.txt').readAsLinesSync().map((e) => e.split('')).toList();
  final rails = <Point, Rails>{};
  Map<Point, Cart> carts = SplayTreeMap<Point, Cart>(pointComparison);
  readMap(map, carts, rails);

  findFirstCollision(pointComparison, carts, rails);
  findLastStandingCart(pointComparison, carts, rails);
}

void readMap(List<List<String>> map, Map<Point, Cart> carts, Map<Point, Rails> rails) {
  for (int y = 0; y < map.length; ++y) {
    final row = map[y];
    for (int x = 0; x < row.length; ++x) {
      final cell = row[x];
      if (cell == ' ') continue;
      final point = Point(x, y);
      if (cell == '<' || cell == '>' || cell == '^' || cell == 'v')
        carts[point] = Cart(DirectionExt.fromString(cell), 0);
      rails[point] = StringRails.fromString(cell);
    }
  }
}

void findFirstCollision(int pointComparison(Point a, Point b), Map<Point, Cart> carts, Map<Point, Rails> rails) {
  Point? cartCollision;
  while (cartCollision == null) {
    final nextCarts = SplayTreeMap<Point, Cart>(pointComparison);
    for (final cartPosition in carts.keys) {
      final cart = carts[cartPosition]!;
      final nextPosition = cartPosition.move(cart.first);
      final nextDirection = cart.first.change(rails[nextPosition]!, cart.second);
      final counter = cart.second + (rails[nextPosition] == Rails.intersection ? 1 : 0);
      if (nextCarts.containsKey(nextPosition)) {
        cartCollision = nextPosition;
        break;
      } else {
        nextCarts[nextPosition] = Cart(nextDirection, counter);
      }
    }
    carts = nextCarts;
  }
  print(cartCollision);
}

void findLastStandingCart(int pointComparison(Point a, Point b), Map<Point, Cart> carts, Map<Point, Rails> rails) {
  carts = SplayTreeMap.of(carts);
  while (carts.length > 1) {
    final nextCarts = SplayTreeMap<Point, Cart>(pointComparison);
    final removedPositions = <Point>{};
    for (final cartPosition in carts.keys) {
      if (removedPositions.contains(cartPosition)) continue;
      final cart = carts[cartPosition]!;
      final nextPosition = cartPosition.move(cart.first);
      if (carts.containsKey(nextPosition)) {
        removedPositions.add(nextPosition);
        carts.remove(nextPosition);
      } else if (nextCarts.containsKey(nextPosition)) {
        nextCarts.remove(nextPosition);
        removedPositions.add(nextPosition);
      } else {
        final nextDirection = cart.first.change(rails[nextPosition]!, cart.second);
        final counter = cart.second + (rails[nextPosition] == Rails.intersection ? 1 : 0);
        nextCarts[nextPosition] = Cart(nextDirection, counter);
      }
    }
    carts = nextCarts;
  }
  print(carts.keys.single.move(carts.values.single.first));
}
