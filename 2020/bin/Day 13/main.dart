import 'dart:io';

void main() {
  final notes = File('./input.txt').readAsLinesSync();
  final earliestTimestamp = int.parse(notes.first);
  final busIds = notes.last.split(',');
  first(earliestTimestamp, busIds);
  second(busIds);
}

void first(int earliestTimestamp, List<String> busIds) {
  final buses = busIds.where((element) => element != 'x').map(int.parse);
  int departureTime = earliestTimestamp * 2;
  int earliestBus;
  for (final bus in buses) {
    final busDepartureTime = (earliestTimestamp / bus).ceil() * bus;
    if (busDepartureTime < departureTime) {
      departureTime = busDepartureTime;
      earliestBus = bus;
    }
  }
  print(earliestBus * (departureTime - earliestTimestamp));
}

void second(List<String> busIds) {
  Map<int, int> busDelays = {
    for (int i = 0; i < busIds.length; ++i) if (busIds[i] != 'x') int.parse(busIds[i]): i,
  };
  final n = busDelays.keys.reduce((value, element) => value * element);
  BigInt x = BigInt.zero;
  for (final ni in busDelays.keys) {
    final niHat = n ~/ ni;
    final vi = niHat.modInverse(ni);
    final ei = BigInt.from(niHat) * BigInt.from(vi);
    final ai = BigInt.from((ni - busDelays[ni]) % ni);
    x += ai * ei;
  }
  print(x % BigInt.from(n));
}
