import 'dart:io';

extension on List<List<int>> {
  int countRec(int value) => fold(
      0, (current, next) => current + next.where((val) => val == value).length);
}

void main() {
  final input =
      File("input.txt").readAsStringSync().split('').map(int.parse).toList();
  final w = 25, h = 6, layerSize = w * h, numLayers = input.length ~/ layerSize;
  List<List<List<int>>> imageLayers = List.generate(
    h,
    (_) => List.generate(
      w,
      (_) => List.filled(numLayers, 0),
    ),
  );
  int i = 0;
  for (int layer = 0; layer < numLayers; ++layer) {
    for (int y = 0; y < h; ++y) {
      for (int x = 0; x < w; ++x) {
        imageLayers[y][x][layer] = input[i++];
      }
    }
  }
  final image = imageLayers.map(
    (row) => row.map(
      (pixel) => pixel.reduce((current, next) => current == 2 ? next : current),
    ),
  );
  for (var row in image) {
    for (var pix in row) {
      stdout.write(pix == 0 ? " " : "#");
    }
    print("");
  }
}
