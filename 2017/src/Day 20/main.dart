import 'dart:io';

void main() {
  first();
  second();
}

class Particle {
  final int id;
  final List<int> _position = List<int>(3);
  final List<int> _velocity = List<int>(3);
  final List<int> _acceleration = List<int>(3);

  Particle.fromString(this.id, String s) {
    final match = RegExp(r'^p=<(\-?\d+),(\-?\d+),(\-?\d+)>, '
            r'v=<(\-?\d+),(\-?\d+),(\-?\d+)>, '
            r'a=<(\-?\d+),(\-?\d+),(\-?\d+)>$')
        .firstMatch(s);
    _position[0] = int.parse(match[1]);
    _position[1] = int.parse(match[2]);
    _position[2] = int.parse(match[3]);

    _velocity[0] = int.parse(match[4]);
    _velocity[1] = int.parse(match[5]);
    _velocity[2] = int.parse(match[6]);

    _acceleration[0] = int.parse(match[7]);
    _acceleration[1] = int.parse(match[8]);
    _acceleration[2] = int.parse(match[9]);
  }

  int get distance => _position.fold(0, (acc, next) => acc + next.abs());

  int get totalAcceleration =>
      _acceleration.fold(0, (acc, next) => acc + next.abs());

  void move() {
    _velocity[0] += _acceleration[0];
    _velocity[1] += _acceleration[1];
    _velocity[2] += _acceleration[2];

    _position[0] += _velocity[0];
    _position[1] += _velocity[1];
    _position[2] += _velocity[2];
  }

  bool collides(Particle other) =>
      _position[0] == other._position[0] &&
      _position[1] == other._position[1] &&
      _position[2] == other._position[2];

  @override
  String toString() => 'Particle $id';
}

void first() {
  int i = 0;
  final particles = File('src/Day 20/input.txt')
      .readAsLinesSync()
      .map((l) => Particle.fromString(i++, l))
      .toList();
  particles.sort((a, b) => a.totalAcceleration.compareTo(b.totalAcceleration));
  print(particles.first.id);
}

void second() {
  int i = 0;
  final particles = File('src/Day 20/input.txt')
      .readAsLinesSync()
      .map((l) => Particle.fromString(i++, l))
      .toList();
  for (int i = 0; i < 10000; ++i) {
    for (int j = 0; j < particles.length; ++j) {
      bool collided = false;
      for (int k = j + 1; k < particles.length; ++k) {
        if (particles[j].collides(particles[k])) {
          collided = true;
          particles.removeAt(k--);
        }
      }
      if (collided) {
        particles.removeAt(j--);
      }
    }
    for (final particle in particles) particle.move();
  }
  print(particles.length);
}
