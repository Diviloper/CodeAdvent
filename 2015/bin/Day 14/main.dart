import 'dart:io';

import 'dart:math';

void main() {
  final input = File('input.txt').readAsLinesSync();
  final reindeer = input.map((s) => Reindeer.fromString(s)).toList();
  final seconds = 2503;
  for (int second = 0; second <= seconds; ++second) {
    reindeer.forEach((r) => r.move());
    leading(reindeer).forEach((r) => r.givePoint());
  }
  final maxPoints = reindeer.map((r) => r.points).reduce(max);
  print(maxPoints);
}

Iterable<Reindeer> leading(List<Reindeer> reindeer) {
  final maxDistance = reindeer.map((r) => r.position).reduce(max);
  return reindeer.where((r) => r.position == maxDistance);
}

class Reindeer {
  final String name;
  final int speed;
  final int duration;
  final int rest;
  bool running = true;
  int seconds = 0;
  int position = 0;
  int points = 0;

  Reindeer(this.name, this.speed, this.duration, this.rest);

  static final _regexp = RegExp(r'^([a-zA-Z]+)\ can\ fly\ ([0-9]+)\ km/s\ for\ ([0-9]+)\ seconds,'
      r'\ but\ then\ must\ rest\ for\ ([0-9]+)\ seconds\.$');

  factory Reindeer.fromString(String source) {
    final match = _regexp.firstMatch(source);
    return Reindeer(
      match.group(1),
      int.parse(match.group(2)),
      int.parse(match.group(3)),
      int.parse(match.group(4)),
    );
  }

  void move() {
    if (running) {
      position += speed;
    }
    if (++seconds == (running ? duration : rest)) {
      running = !running;
      seconds = 0;
    }
  }

  void moveNTimes(int n) {
    for (int i = 0; i < n; ++i) {
      move();
    }
  }

  void givePoint() => points++;
}
