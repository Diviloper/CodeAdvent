import 'dart:collection';

import 'dart:io';

import 'dart:math';

void main() {
  first();
  second();
}

class Part {
  List<int> ports = List<int>(2);

  Part(int firstPort, int secondPort) {
    ports[0] = firstPort;
    ports[1] = secondPort;
  }

  bool canConnectToPort(int port) => ports.contains(port);

  int get strength => ports[0] + ports[1];

  @override
  String toString() => ports.join('/');
}

class Bridge {
  final Queue<int> ports = Queue<int>.from([0]);
  final Queue<Part> parts = Queue<Part>();

  int get nextPort => ports.last;

  bool canConnect(Part newPart) => newPart.canConnectToPort(nextPort);

  bool connect(Part newPart) {
    if (!canConnect(newPart)) return false;
    parts.addLast(newPart);
    ports.addLast(
        newPart.ports[0] == nextPort ? newPart.ports[1] : newPart.ports[0]);
    return true;
  }

  void removeLastPart() {
    parts.removeLast();
    ports.removeLast();
  }

  int get strength => parts.fold(0, (acc, nextPart) => acc + nextPart.strength);

  int get length => parts.length;

  @override
  String toString() => parts.join(' -- ');
}

void first() {
  final parts = File('src/Day 24/input.txt')
      .readAsLinesSync()
      .map((e) => e.split('/'))
      .map((e) => Part(int.parse(e.first), int.parse(e.last)))
      .toList();
  print(makeBridge(Bridge(), parts.toSet()));
}

int makeBridge(Bridge bridge, Set<Part> remainingParts) {
  int maxStrength = bridge.strength;
  for (final part in remainingParts) {
    if (bridge.connect(part)) {
      maxStrength = max(maxStrength,
          makeBridge(bridge, remainingParts.toSet()..remove(part)));
      bridge.removeLastPart();
    }
  }
  return maxStrength;
}

void second() {
  final parts = File('src/Day 24/input.txt')
      .readAsLinesSync()
      .map((e) => e.split('/'))
      .map((e) => Part(int.parse(e.first), int.parse(e.last)))
      .toList();
  final strengths = List<int>.filled(parts.length, 0);
  makeLongBridge(Bridge(), parts.toSet(), strengths);
  print(strengths.lastWhere((element) => element != 0));
}

int makeLongBridge(
    Bridge bridge, Set<Part> remainingParts, List<int> strengths) {
  int maxStrength = bridge.strength;
  strengths[bridge.length] = max(strengths[bridge.length], maxStrength);
  for (final part in remainingParts) {
    if (bridge.connect(part)) {
      maxStrength = max(
          maxStrength,
          makeLongBridge(
              bridge, remainingParts.toSet()..remove(part), strengths));
      bridge.removeLastPart();
    }
  }
  return maxStrength;
}
