import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final input = File('./input.txt')
      .readAsLinesSync()
      .map((line) => line.split(": "))
      .map((line) => (
            int.parse(line.first),
            line.last.split(' ').map(int.parse).toList(),
          ))
      .toList();

  final first = input.zippedWhere(canBeSolved).firsts.sum;
  print(first);

  final second = input.zippedWhere(canBeSolvedConcat).firsts.sum;
  print(second);
}

bool canBeSolved(int result, List<int> operands, [bool allowConcat = false]) {
  if (result < 0) return false;
  if (operands.length == 1) return operands.single == result;

  final slice = operands.slice(0, operands.length - 1);

  return (canBeSolved(result - operands.last, slice, allowConcat)) ||
      (result % operands.last == 0 &&
          canBeSolved(result ~/ operands.last, slice, allowConcat)) ||
      (allowConcat &&
          result.toString().endsWith(operands.last.toString()) &&
          canBeSolved(
              unconcatenateInts(result, operands.last), slice, allowConcat));
}

bool canBeSolvedConcat(int result, List<int> operands) =>
    canBeSolved(result, operands, true);

int unconcatenateInts(int from, int subtracted) {
  String f = from.toString();
  String s = subtracted.toString();
  if (f.length == s.length) return 0;
  return int.parse(f.substring(0, f.length - s.length));
}
