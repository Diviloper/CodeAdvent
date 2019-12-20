import 'dart:io';
import '../../Common/IntCodeComputer/intCodeComputer.dart';

void main() async {
  final program =
      File("input.txt").readAsStringSync().split(',').map(int.parse).toList();
  IntCodeMachine machine = IntCodeMachine();
  machine.runProgram(program);
  final scaffoldMap =
      String.fromCharCodes(await machine.output.stream.toList()).split('\n');
  int sum = 0;
  for (int i = 1; i < scaffoldMap.length - 3; ++i) {
    for (int j = 1; j < scaffoldMap[i].length - 1; ++j) {
      if (isIntersection(scaffoldMap, i, j)) sum += i * j;
    }
  }
  print(sum);
}

bool isIntersection(List<String> scaffoldMap, int i, int j) {
  if ({'#'}.containsAll(
    [
      scaffoldMap[i][j],
      scaffoldMap[i - 1][j],
      scaffoldMap[i + 1][j],
      scaffoldMap[i][j - 1],
      scaffoldMap[i][j + 1],
    ],
  )) return true;
  return false;
}
