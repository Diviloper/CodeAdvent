import 'dart:io';

class Moon {
  int x, y, z;
  int velX = 0, velY = 0, velZ = 0;

  Moon.fromString(String coords) {
    coords = coords.replaceAll(' ', '');
    coords = coords.substring(1, coords.length - 1);
    final splitCoords = coords.split(',');
    x = int.parse(splitCoords[0].substring(2));
    y = int.parse(splitCoords[1].substring(2));
    z = int.parse(splitCoords[2].substring(2));
  }

  @override
  String toString() =>
      "pos=<x=$x, y=$y, z=$z>, vel=<x=$velX, y=$velY, z=$velZ>";

  void advance() {
    x += velX;
    y += velY;
    z += velZ;
  }

  int get kineticEnergy => velX.abs() + velY.abs() + velZ.abs();

  int get potentialEnergy => x.abs() + y.abs() + z.abs();

  int get totalEnergy => kineticEnergy * potentialEnergy;

  void applyGravity(Moon other) {
    velX += other.x.compareTo(x);
    velY += other.y.compareTo(y);
    velZ += other.z.compareTo(z);
  }
}

void main() {
  final input = File("input.txt").readAsLinesSync();
  List<Moon> moons = input.map((coords) => Moon.fromString(coords)).toList();
  int numSteps = 1000;
  for (int i = 0; i < numSteps; ++i) {
    for (var moon in moons) {
      for (var moon2 in moons) {
        moon.applyGravity(moon2);
      }
    }
    for (var moon in moons) moon.advance();
  }
  print(moons
      .map((moon) => moon.totalEnergy)
      .reduce((current, next) => current + next));
}
