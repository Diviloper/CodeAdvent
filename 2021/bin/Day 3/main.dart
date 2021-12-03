import 'dart:io';

void main() {
  final binaries = File('./input.txt').readAsLinesSync().map((e) => e.split('')).toList();
  getPowerConsumption(binaries);
  getLifeSupportRating(binaries);
}

void getLifeSupportRating(List<List<String>> binaries) {
  int oxygenGeneratorRating = getOxygenGeneratorRating(binaries, 0);
  int co2ScrubberRating = getCO2ScrubberRating(binaries, 0);
  print(oxygenGeneratorRating);
  print(co2ScrubberRating);
  print(oxygenGeneratorRating * co2ScrubberRating);
}

int getOxygenGeneratorRating(List<List<String>> binaries, int index) {
  if (binaries.length == 1) return int.parse(binaries.single.join(), radix: 2);
  final occurrence = getOccurrencesOf1(binaries)[index];
  if (occurrence >= binaries.length / 2) {
    return getOxygenGeneratorRating(binaries.where((element) => element[index] == '1').toList(), index + 1);
  } else {
    return getOxygenGeneratorRating(binaries.where((element) => element[index] == '0').toList(), index + 1);
  }
}

int getCO2ScrubberRating(List<List<String>> binaries, int index) {
  if (binaries.length == 1) return int.parse(binaries.single.join(), radix: 2);
  final occurrence = getOccurrencesOf1(binaries)[index];
  if (occurrence < binaries.length / 2) {
    return getCO2ScrubberRating(binaries.where((element) => element[index] == '1').toList(), index + 1);
  } else {
    return getCO2ScrubberRating(binaries.where((element) => element[index] == '0').toList(), index + 1);
  }
}

void getPowerConsumption(List<List<String>> binaries) {
  List<int> occurrences = getOccurrencesOf1(binaries);
  final gamma = [for (final occurrence in occurrences) occurrence > binaries.length ~/ 2 ? '1' : '0'];
  final epsilon = [for (final occurrence in occurrences) occurrence < binaries.length ~/ 2 ? '1' : '0'];
  final gammaValue = int.parse(gamma.join(), radix: 2);
  final epsilonValue = int.parse(epsilon.join(), radix: 2);
  print(gammaValue);
  print(epsilonValue);
  print(gammaValue * epsilonValue);
}

List<int> getOccurrencesOf1(List<List<String>> binaries) {
  final length = binaries.first.length;
  final occurrences = List.filled(length, 0);
  for (final binary in binaries) {
    for (int i = 0; i < length; ++i) {
      if (binary[i] == '1') occurrences[i]++;
    }
  }
  return occurrences;
}
