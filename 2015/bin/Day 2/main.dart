import 'dart:io';

import 'dart:math';

void main() {
  final presents = File('input.txt').readAsLinesSync().map((s) => Cuboid.fromString(s));
  final paper =
      presents.fold<int>(0, (currentPaper, nextPresent) => currentPaper + nextPresent.paperSize);
  final ribbon =
      presents.fold<int>(0, (currentPaper, nextPresent) => currentPaper + nextPresent.ribbonSize);
  print('Paper: $paper\nRibbon: $ribbon');
}

class Cuboid {
  int x, y, z;

  Cuboid(this.x, this.y, this.z);

  Cuboid.fromString(String s) {
    final sizes = s.split('x').map(int.parse).toList();
    x = sizes[0];
    y = sizes[1];
    z = sizes[2];
  }

  int get xy => x * y;

  int get xz => x * z;

  int get yz => y * z;

  int get volume => x * y * z;

  int get paperSize => 2 * xy + 2 * xz + 2 * yz + min(xy, min(xz, yz));

  int get ribbonSize => 2 * min(x, y) + 2 * min(z, max(x, y)) + volume;
}
