import 'dart:io';

import 'package:equatable/equatable.dart';

class Coords extends Equatable {
  final int x;
  final int y;

  Coords(this.x, this.y);

  Coords right() => Coords(x + 1, y);

  Coords left() => Coords(x - 1, y);

  Coords top() => Coords(x, y + 1);

  Coords bottom() => Coords(x, y - 1);

  int get distance => x.abs() + y.abs();

  List<Coords> get neighbors => [
        this.top(),
        this.top().left(),
        this.left(),
        this.left().bottom(),
        this.bottom(),
        this.bottom().right(),
        this.right(),
        this.right().top()
      ];

  @override
  String toString() => '[$x, $y]';

  @override
  List<Object> get props => [x, y];
}

List<int> readListIntLines(String fileName) => File(fileName).readAsLinesSync().map(int.parse).toList();

List<int> readListInt(String fileName, {String separator = ' '}) =>
    File(fileName).readAsStringSync().split(separator).map(int.parse).toList();

extension EquatableList<T> on List<T> {
  bool equals(List<T> other) {
    if (length != other.length) return false;
    for (int i=0; i<length; ++i) {
      if (this[i] != other[i]) return false;
    }
    return true;
  }
}