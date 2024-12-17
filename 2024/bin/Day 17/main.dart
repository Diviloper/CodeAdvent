import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

void main() {
  final program =
      File('./input.txt').readAsStringSync().split(',').map(int.parse).toList();

  print(generateOutput(program, 30118712, 0, 0));

  const binaryDigits = [0, 1, 2, 3, 4, 5, 6, 7];

  final permutations = [
    for (final x in binaryDigits)
      for (final y in binaryDigits)
        for (final z in binaryDigits)
          for (final w in binaryDigits) [x, y, z, w],
  ];

  final generators = List.generate(8, (_) => <List<int>>[]);

  for (final permutation in permutations) {
    final input = binaryDigitsToInt(permutation);
    final output = generateOutput(program, input, 0, 0);
    final generatedDigit = output.first;
    generators[generatedDigit].add(permutation);
  }

  List<List<int>> candidates = generators[program.first];

  for (final outDigit in program.skip(1)) {
    final newCandidates = <List<int>>[];
    final digitCandidates = generators[outDigit];
    for (final candidate in candidates) {
      final candidateTail = candidate.slice(candidate.length - 3).join();
      for (final dCandidate in digitCandidates) {
        final dCandidateStart =
            dCandidate.slice(0, dCandidate.length - 1).join();
        if (candidateTail == dCandidateStart) {
          newCandidates.add([...candidate, dCandidate.last]);
        }
      }
    }
    candidates = newCandidates;
  }

  final second = candidates
      .map(binaryDigitsToInt)
      .where((candidate) =>
          generateOutput(program, candidate, 0, 0).join(',') ==
          program.join(','))
      .min;
  print(second);
}

int binaryDigitsToInt(List<int> digits) => int.parse(
      digits
          .map((d) => d.toRadixString(2).padLeft(3, "0"))
          .toList()
          .reversed
          .join(),
      radix: 2,
    );

List<int> generateOutput(List<int> program, int A, int B, int C) {
  int instructionPointer = 0;

  final output = <int>[];

  while (instructionPointer < program.length) {
    final instruction = program[instructionPointer];
    final operand = program[instructionPointer + 1];
    switch (instruction) {
      case 0: //adv
        A = (A / pow(2, getComboValue(operand, A, B, C))).truncate();
        break;
      case 1: // bxl
        B = B ^ operand;
        break;
      case 2: // bst
        B = getComboValue(operand, A, B, C) % 8;
        break;
      case 3: // jnz
        if (A != 0) {
          instructionPointer = operand;
          continue;
        }
        break;
      case 4: // bxc
        B = B ^ C;
        break;
      case 5: // out
        output.add(getComboValue(operand, A, B, C) % 8);
        break;
      case 6: // bdv
        B = (A / pow(2, getComboValue(operand, A, B, C))).truncate();
        break;
      case 7: //cdv
        C = (A / pow(2, getComboValue(operand, A, B, C))).truncate();
        break;
      default:
        throw Exception("Invalid instruction");
    }
    instructionPointer += 2;
  }
  return output;
}

int getComboValue(int value, int A, int B, int C) => switch (value) {
      0 => 0,
      1 => 1,
      2 => 2,
      3 => 3,
      4 => A,
      5 => B,
      6 => C,
      _ => throw Exception("Invalid value")
    };
