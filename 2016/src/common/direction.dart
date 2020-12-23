enum Direction { north, south, east, west }

extension MoveDirection on Direction {
  Direction turnLeft() {
    switch (this) {
      case Direction.north:
        return Direction.east;
        break;
      case Direction.south:
        return Direction.west;
        break;
      case Direction.east:
        return Direction.south;
        break;
      case Direction.west:
        return Direction.north;
        break;
    }
    throw 'Invalid direction';
  }

  Direction turnRight() {
    switch (this) {
      case Direction.north:
        return Direction.west;
        break;
      case Direction.south:
        return Direction.east;
        break;
      case Direction.east:
        return Direction.north;
        break;
      case Direction.west:
        return Direction.south;
        break;
    }
    throw 'Invalid direction';
  }
}
