import 'dart:io';

enum Direction { north, south, east, west }

extension on Direction {
  Direction operator +(int degrees) {
    if (degrees % 90 != 0) throw Exception('Degrees must be a multiple of 90');
    if (degrees == 0) return this;
    if (degrees < 0) return this + (degrees + 360);
    switch (this) {
      case Direction.north:
        return Direction.west + (degrees - 90);
        break;
      case Direction.south:
        return Direction.east + (degrees - 90);
        break;
      case Direction.east:
        return Direction.north + (degrees - 90);
        break;
      case Direction.west:
        return Direction.south + (degrees - 90);
        break;
      default:
        throw Exception('Operator error');
    }
  }

  Direction operator -(int degrees) => this + (-degrees);
}

class Coords {
  final int x;
  final int y;

  const Coords(this.x, this.y);

  static const origin = Coords(0, 0);

  Coords move(int distance, Direction direction) {
    switch (direction) {
      case Direction.north:
        return Coords(x, y + distance);
        break;
      case Direction.south:
        return Coords(x, y - distance);
        break;
      case Direction.east:
        return Coords(x + distance, y);
        break;
      case Direction.west:
        return Coords(x - distance, y);
        break;
      default:
        throw Exception('Direction must not be null');
    }
  }

  Coords rotateLeft(int degrees, {Coords rotationOrigin = Coords.origin}) {
    if (degrees % 90 != 0) throw Exception('Degrees must be a multiple of 90');
    if (degrees == 0) return this;
    if (degrees < 0) return rotateLeft(degrees + 360, rotationOrigin: rotationOrigin);
    final relativePosition = this - rotationOrigin;
    final newX = rotationOrigin.x - relativePosition.y;
    final newY = rotationOrigin.y + relativePosition.x;
    return Coords(newX, newY).rotateLeft(degrees - 90, rotationOrigin: rotationOrigin);
  }

  Coords rotateRight(int degrees, {Coords rotationOrigin = Coords.origin}) =>
      rotateLeft(-degrees, rotationOrigin: rotationOrigin);

  Coords operator +(Coords other) => Coords(x + other.x, y + other.y);

  Coords operator -(Coords other) => Coords(x - other.x, y - other.y);

  Coords operator *(int times) => Coords(x * times, y * times);

  int get manhattanDistanceFromOrigin => x.abs() + y.abs();

  @override
  String toString() => '($x, $y)';
}

void main() {
  final instructions = File('./input.txt').readAsLinesSync();
  first(instructions);
  second(instructions);
}

void first(List<String> instructions) {
  Direction currentDirection = Direction.east;
  Coords currentPosition = Coords.origin;
  for (final instruction in instructions) {
    final order = instruction[0];
    final value = int.parse(instruction.substring(1));
    switch (order) {
      case 'N':
        currentPosition = currentPosition.move(value, Direction.north);
        break;
      case 'S':
        currentPosition = currentPosition.move(value, Direction.south);
        break;
      case 'E':
        currentPosition = currentPosition.move(value, Direction.east);
        break;
      case 'W':
        currentPosition = currentPosition.move(value, Direction.west);
        break;
      case 'L':
        currentDirection += value;
        break;
      case 'R':
        currentDirection -= value;
        break;
      case 'F':
        currentPosition = currentPosition.move(value, currentDirection);
    }
  }
  print(currentPosition.manhattanDistanceFromOrigin);
}

void second(List<String> instructions) {
  Coords shipPosition = Coords.origin;
  Coords waypointDistance = Coords(10, 1);
  for (final instruction in instructions) {
    final order = instruction[0];
    final value = int.parse(instruction.substring(1));
    switch (order) {
      case 'N':
        waypointDistance = waypointDistance.move(value, Direction.north);
        break;
      case 'S':
        waypointDistance = waypointDistance.move(value, Direction.south);
        break;
      case 'E':
        waypointDistance = waypointDistance.move(value, Direction.east);
        break;
      case 'W':
        waypointDistance = waypointDistance.move(value, Direction.west);
        break;
      case 'L':
        waypointDistance = waypointDistance.rotateLeft(value);
        break;
      case 'R':
        waypointDistance = waypointDistance.rotateRight(value);

        break;
      case 'F':
        shipPosition += waypointDistance * value;
    }
  }
  print(shipPosition.manhattanDistanceFromOrigin);
}
