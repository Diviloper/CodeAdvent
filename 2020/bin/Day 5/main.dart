import 'dart:io';

class Seat {
  final String rowCode;
  final String columnCode;

  Seat(String code)
      : rowCode = code.substring(0, 7),
        columnCode = code.substring(7);

  int get row =>
      int.parse(rowCode.replaceAll('F', '0').replaceAll('B', '1'), radix: 2);

  int get column =>
      int.parse(columnCode.replaceAll('L', '0').replaceAll('R', '1'), radix: 2);

  int get id => row * 8 + column;
}

void main() {
  final seats =
      File('./input.txt').readAsLinesSync().map((e) => Seat(e)).toList();
  first(seats);
  second(seats);
}

void first(List<Seat> seats) {
  int max = 0;
  for (final seat in seats) {
    if (seat.id > max) {
      max = seat.id;
    }
  }
  print(max);
}

void second(List<Seat> seats) {
  final ids = seats.map((e) => e.id).toSet();
  for (int i = 0; i < 128 * 8; ++i) {
    if (!ids.contains(i) && ids.contains(i - 1) && ids.contains(i + 1)) {
      print(i);
    }
  }
}
