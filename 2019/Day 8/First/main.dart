import 'dart:io';

extension on List<List<int>> {
  int countRec(int value) => fold(
      0, (current, next) => current + next.where((val) => val == value).length);
}

void main() {
  final input =
      File("input.txt").readAsStringSync().split('').map(int.parse).toList();
  final w = 25, h = 6, layerSize = w * h, numLayers = input.length ~/ layerSize;
  List<List<List<int>>> image = [];
  int i = 0;
  for (int layer = 0; layer < numLayers; ++layer) {
    image.add([]);
    for (int y = 0; y < h; ++y) {
      image[layer].add([]);
      for (int x = 0; x < w; ++x) {
        image[layer][y].add(input[i++]);
      }
    }
  }
  final layer = image.reduce((current, next) =>
      current.countRec(0) < next.countRec(0) ? current : next);
  print(layer.countRec(1) * layer.countRec(2));
}
