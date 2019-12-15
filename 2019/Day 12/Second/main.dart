import 'dart:io';

extension on List<Moon> {
  List<String> get xValues =>
      this.map((moon) => "${moon.x}:${moon.velX}").toList();

  List<String> get yValues =>
      this.map((moon) => "${moon.y}:${moon.velY}").toList();

  List<String> get zValues =>
      this.map((moon) => "${moon.z}:${moon.velZ}").toList();
}

extension on int {
  int lcm(int b) => (this * b) ~/ this.gcd(b);
}

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
  Set<String> statesX = {}, statesY = {}, statesZ = {};
  String currentStateX = moons.xValues.join('\n');
  String currentStateY = moons.yValues.join('\n');
  String currentStateZ = moons.zValues.join('\n');
  bool finished = false;
  bool x = false, y = false, z = false;
  while (!finished) {
    x = x || statesX.contains(currentStateX);
    y = y || statesY.contains(currentStateY);
    z = z || statesZ.contains(currentStateZ);
    if (!x) statesX.add(currentStateX);
    if (!y) statesY.add(currentStateY);
    if (!z) statesZ.add(currentStateZ);
    for (var moon in moons) {
      for (var moon2 in moons) {
        moon.applyGravity(moon2);
      }
    }
    for (var moon in moons) moon.advance();
    if (!x) currentStateX = moons.xValues.join('\n');
    if (!y) currentStateY = moons.yValues.join('\n');
    if (!z) currentStateZ = moons.zValues.join('\n');
    finished = x && y && z;
  }
  print("X: ${statesX.length}");
  print("Y: ${statesY.length}");
  print("Z: ${statesZ.length}");
  print("Total: ${statesX.length.lcm(statesY.length).lcm(statesZ.length)}");
}
