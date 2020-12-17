import 'dart:io';

void main() {
  final instructions = File('./input.txt').readAsLinesSync();
  first(instructions);
  second(instructions);
}

void first(List<String> instructions) {
  String mask;
  final memory = <int, int>{};
  final memRegexp = RegExp(r'^mem\[(\d+)\] = (\d+)$');
  for (final instruction in instructions) {
    if (instruction.startsWith('mask')) {
      mask = instruction.substring(7);
    } else {
      final match = memRegexp.firstMatch(instruction);
      final address = int.parse(match[1]);
      final value = int.parse(match[2]);
      memory[address] = applyMask(mask, value);
    }
  }
  print(memory.values.reduce((value, element) => value + element));
}

int applyMask(String mask, int value) {
  final oneMask = int.parse(mask.replaceAll('X', '0'), radix: 2);
  final zeroMask = int.parse(mask.replaceAll('X', '1'), radix: 2);
  return (value | oneMask) & zeroMask;
}

void second(List<String> instructions) {
  String mask;
  final memory = <int, int>{};
  final memRegexp = RegExp(r'^mem\[(\d+)\] = (\d+)$');
  for (final instruction in instructions) {
    if (instruction.startsWith('mask')) {
      mask = instruction.substring(7);
    } else {
      final match = memRegexp.firstMatch(instruction);
      final address = int.parse(match[1]);
      final value = int.parse(match[2]);
      final addresses = decodeMemoryAddress(mask, address);
      for (final decodedAddress in addresses) {
        memory[decodedAddress] = value;
      }
    }
  }
  print(memory.values.reduce((value, element) => value + element));
}

List<int> decodeMemoryAddress(String mask, int address) {
  final oneMask = int.parse(mask.replaceAll('X', '0'), radix: 2);
  final baseAddress = address | oneMask;
  final floatingIndexes = [for (int i = 0; i < mask.length; ++i) if (mask[i] == 'X') i];
  return computeCombinations(baseAddress.toRadixString(2).padLeft(36, '0'), floatingIndexes, 0)
      .map((e) => int.parse(e, radix: 2))
      .toList();
}

List<String> computeCombinations(String address, List<int> floatingIndexes, int currentIndex) {
  if (currentIndex == floatingIndexes.length - 1) {
    return [
      address.replaceRange(floatingIndexes[currentIndex], floatingIndexes[currentIndex] + 1, '0'),
      address.replaceRange(floatingIndexes[currentIndex], floatingIndexes[currentIndex] + 1, '1'),
    ];
  }
  return [
    ...computeCombinations(address.replaceRange(floatingIndexes[currentIndex], floatingIndexes[currentIndex] + 1, '0'),
        floatingIndexes, currentIndex + 1),
    ...computeCombinations(address.replaceRange(floatingIndexes[currentIndex], floatingIndexes[currentIndex] + 1, '1'),
        floatingIndexes, currentIndex + 1),
  ];
}
