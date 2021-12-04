import 'dart:io';

void main() {
  final input = File('./input.txt').readAsStringSync().split('\r\n\r\n');
  final numbers = input.first.split(',').map(int.parse).toList();
  final boards = <Board>[for (final board in input.skip(1)) Board.fromString(board.split('\r\n'))];
  findFirstBoardToWin(numbers, boards);
  findLastBoardToWin(numbers, boards);
}

void findFirstBoardToWin(List<int> numbers, List<Board> boards) {
  int number;
  Board winner;
  for (number in numbers) {
    for (final board in boards) {
      if (board.mark(number) && board.hasWon) {
        winner = board;
        break;
      }
    }
    if (winner != null) break;
  }
  print(winner.sum * number);
}

void findLastBoardToWin(List<int> numbers, List<Board> boards) {
  int number;
  Board last;
  for (number in numbers) {
    for (final board in boards) {
      if (!board.hasWon &&
          board.mark(number) && board.hasWon) {
        last = board;
      }
    }
    if (boards.every((element) => element.hasWon)) break;
  }
  print(last.sum * number);
}

class Board {
  List<Set<int>> rows;
  List<Set<int>> columns;

  Board.fromString(List<String> rows) {
    columns = List.generate(rows.length, (_) => {});
    this.rows = [];
    for (final row in rows.map((e) => e.trim().replaceAll('  ', ' ').split(' ').map(int.parse).toList())) {
      this.rows.add(row.toSet());
      for (int i = 0; i < row.length; ++i) {
        columns[i].add(row[i]);
      }
    }
  }

  bool get hasWon => rows.any((element) => element.isEmpty) || columns.any((element) => element.isEmpty);

  bool mark(int value) {
    bool removed = false;
    for (final row in rows) {
      if (row.remove(value)) removed = true;
    }
    for (final column in columns) {
      if (column.remove(value)) removed = true;
    }
    return removed;
  }

  int get sum => rows.map((row) => row.fold(0, (v, e) => v + e)).reduce((v, e) => v + e);
}
