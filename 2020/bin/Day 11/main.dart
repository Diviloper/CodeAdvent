import 'dart:io';

extension on bool {
  int toInt() => this ? 1 : 0;
}

class Coords {
  final int i;
  final int j;

  const Coords(this.i, this.j);
}

class Layout {
  final List<List<String>> seats;

  Layout(this.seats);

  bool isOccupied(int i, int j) {
    if (i < 0 || i >= seats.length || j < 0 || j >= seats.first.length) return false;
    return seats[i][j] == '#';
  }

  bool isOccupiedCoords(Coords coords) => isOccupied(coords.i, coords.j);

  int get occupiedSeats {
    int count = 0;
    for (int i = 0; i < seats.length; ++i) {
      for (int j = 0; j < seats.first.length; ++j) {
        if (isOccupied(i, j)) count++;
      }
    }
    return count;
  }

  int adjacentOccupiedSeats(int i, int j) {
    return isOccupied(i - 1, j - 1).toInt() +
        isOccupied(i - 1, j).toInt() +
        isOccupied(i - 1, j + 1).toInt() +
        isOccupied(i, j - 1).toInt() +
        isOccupied(i, j + 1).toInt() +
        isOccupied(i + 1, j - 1).toInt() +
        isOccupied(i + 1, j).toInt() +
        isOccupied(i + 1, j + 1).toInt();
  }

  bool isOutside(int i, int j) => i < 0 || i >= seats.length || j < 0 || j >= seats.first.length;

  bool isSeat(int i, int j) => seats[i][j] == 'L' || seats[i][j] == '#';

  bool isSeatOrOutside(int i, int j) => isOutside(i, j) || isSeat(i, j);

  Coords firstSeat(int iOrigin, int jOrigin, int iDelta, int jDelta) {
    int i = iOrigin + iDelta, j = jOrigin + jDelta;
    while (!isSeatOrOutside(i, j)) {
      i += iDelta;
      j += jDelta;
    }
    return Coords(i, j);
  }

  int seenOccupiedSeats(int i, int j) {
    return isOccupiedCoords(firstSeat(i, j, -1, -1)).toInt() +
        isOccupiedCoords(firstSeat(i, j, -1, 0)).toInt() +
        isOccupiedCoords(firstSeat(i, j, -1, 1)).toInt() +
        isOccupiedCoords(firstSeat(i, j, 0, -1)).toInt() +
        isOccupiedCoords(firstSeat(i, j, 0, 1)).toInt() +
        isOccupiedCoords(firstSeat(i, j, 1, -1)).toInt() +
        isOccupiedCoords(firstSeat(i, j, 1, 0)).toInt() +
        isOccupiedCoords(firstSeat(i, j, 1, 1)).toInt();
  }

  Layout next() => Layout([
      for (int i = 0; i < seats.length; ++i)
        [
          for (int j = 0; j < seats.first.length; ++j)
            if (seats[i][j] == '.')
              '.'
            else if (isOccupied(i, j) && adjacentOccupiedSeats(i, j) >= 4)
              'L'
            else if (!isOccupied(i, j) && adjacentOccupiedSeats(i, j) == 0)
              '#'
            else
              seats[i][j]
        ]
    ]);

  Layout nextSecond() => Layout([
      for (int i = 0; i < seats.length; ++i)
        [
          for (int j = 0; j < seats.first.length; ++j)
            if (seats[i][j] == '.')
              '.'
            else if (isOccupied(i, j) && seenOccupiedSeats(i, j) >= 5)
              'L'
            else if (!isOccupied(i, j) && seenOccupiedSeats(i, j) == 0)
                '#'
              else
                seats[i][j]
        ]
    ]);

  bool equals(Layout other) {
    for (int i = 0; i < seats.length; ++i) {
      for (int j = 0; j < seats.length; ++j) {
        if (seats[i][j] != other.seats[i][j]) return false;
      }
    }
    return true;
  }

  @override
  String toString() => seats.map((e) => e.join()).join('\n');
}

void main() {
  final layout = Layout(File('./input.txt').readAsLinesSync().map((e) => e.split('')).toList());
  first(layout);
  second(layout);
}

void first(Layout layout) {
  Layout previous = layout;
  Layout current = layout.next();
  while (!current.equals(previous)) {
    previous = current;
    current = current.next();
  }
  print(current.occupiedSeats);
}


void second(Layout layout) {
  Layout previous = layout;
  Layout current = layout.next();
  while (!current.equals(previous)) {
    previous = current;
    current = current.nextSecond();
  }
  print(current.occupiedSeats);
}
