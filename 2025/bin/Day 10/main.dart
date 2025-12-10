import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final input = File('./input.txt').readAsLinesSync();

  first(input);
  second(input);
}

int xor(int a, int b) => a ^ b;

void first(List<String> input) {
  final rows = input.map(parseLineFirst).toList();
  int totalButtons = 0;
  for (final (light, buttons) in rows) {
    for (final combination in buttons.powerSet().skip(1)) {
      if (combination.reduce(xor) == light) {
        totalButtons += combination.length;
        break;
      }
    }
  }
  print(totalButtons);
}

(int, List<int>) parseLineFirst(String line) {
  final [lightS, ...buttonsS, _] = line.split(" ");
  final numLights = lightS.length - 2;
  final light = int.parse(
    lightS.remove("[").remove("]").replaceAll(".", "0").replaceAll("#", "1"),
    radix: 2,
  );
  final buttons = buttonsS
      .map(
        (button) => button
            .remove("(")
            .remove(")")
            .split(",")
            .map(int.parse)
            .map((value) => pow(2, numLights - 1 - value) as int)
            .sum,
      )
      .toList();
  return (light, buttons);
}

void second(List<String> input) async {
  int presses = 0;
  for (final line in input) {
    final result = await solveSystem(line);
    presses += result;
  }
  print(presses);
}

Future<int> solveSystem(String line) async {
  final [_, ...buttonsS, countersS] = line.split(" ");
  final counters = countersS
      .substring(1, countersS.length - 1)
      .split(',')
      .map(int.parse)
      .toList();
  final buttons = buttonsS
      .map(
        (button) =>
            button.remove("(").remove(")").split(",").map(int.parse).toList(),
      )
      .toList();
  final nButtons = buttons.length;
  final nCounters = counters.length;
  final matrix = List.generate(
    counters.length,
    (i) => List.filled(buttons.length, 0),
  );
  for (int col = 0; col < buttons.length; ++col) {
    for (final equation in buttons[col]) {
      matrix[equation][col] = 1;
    }
  }
  final file = File("./data.dzn");
  final sink = file.openWrite();
  sink.writeln("Counters = $nCounters;");
  sink.writeln("Buttons = $nButtons;");

  sink.writeln("b = $counters;");
  sink.writeln(
    "A = [|${Platform.lineTerminator}"
    "${matrix.map((row) => row.join(", ")).join("|${Platform.lineTerminator}")}"
    "|];",
  );
  await sink.flush();
  await sink.close();
  final process = await Process.run("minizinc", [
    "--solver",
    "gecode",
    r".\model.mzn",
    r".\data.dzn",
  ]);
  final result = int.parse(
    (process.stdout as String)
        .split(Platform.lineTerminator)[1]
        .split(" = ")
        .last,
  );
  return result;
}
