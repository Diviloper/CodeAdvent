import 'dart:io';
import '../common.dart';

void main() {
  Map<String, List<int>> sleeping = getData();

  strategyOne(sleeping);
  strategyTwo(sleeping);
}

void strategyOne(Map<String, List<int>> sleeping) {
  String sleepiestGuard = '';
  int mostMinutesSlept = 0;
  int mostSleptMinute = 0;
  for (final guard in sleeping.keys) {
    final sleptMinutes = sleeping[guard]!;
    final totalMinutesSlept = sleptMinutes.reduce((v, e) => v + e);
    if (totalMinutesSlept > mostMinutesSlept) {
      sleepiestGuard = guard;
      mostMinutesSlept = totalMinutesSlept;
      mostSleptMinute = sleptMinutes.getIndexOfLargestValue().first;
    }
  }

  print(int.parse(sleepiestGuard) * mostSleptMinute);
}

void strategyTwo(Map<String, List<int>> sleeping) {
  String sleepiestGuard = '';
  int timesSleptOnMinute = 0;
  int mostSleptMinute = 0;
  for (final guard in sleeping.keys) {
    final sleptMinutes = sleeping[guard]!;
    final currentMostSleptMinute = sleptMinutes.getIndexOfLargestValue();
    if (currentMostSleptMinute.second > timesSleptOnMinute) {
      sleepiestGuard = guard;
      mostSleptMinute = currentMostSleptMinute.first;
      timesSleptOnMinute = currentMostSleptMinute.second;
    }
  }

  print(int.parse(sleepiestGuard) * mostSleptMinute);
}

Map<String, List<int>> getData() {
  final lines = File("input.txt").readAsLinesSync()
    ..sort((a, b) => a.substring(1, 17).compareTo(b.substring(1, 17)));
  final sleeping = <String, List<int>>{};
  final guardIdRegexp = RegExp(r'#(\d+)');
  String currentGuard = '';
  int sleepingStart = 0;
  for (final line in lines) {
    if (line.contains('Guard')) {
      currentGuard = guardIdRegexp.firstMatch(line)![1]!;
    } else if (line.contains('falls')) {
      sleepingStart = int.parse(line.substring(15, 17));
    } else {
      int sleepingEnd = int.parse(line.substring(15, 17));
      if (!sleeping.containsKey(currentGuard)) sleeping[currentGuard] = List.filled(60, 0);
      for (int i = sleepingStart; i < sleepingEnd; ++i) {
        sleeping[currentGuard]![i]++;
      }
    }
  }
  return sleeping;
}
