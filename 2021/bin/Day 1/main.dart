import 'dart:io';

void main() {
  final depths = File('./input.txt').readAsLinesSync().map(int.parse).toList();
  countDepthsIncreases(depths);
  countDepthWindowIncreases(depths);
}

void countDepthWindowIncreases(List<int> depths) {
  final windowDepths = Iterable.generate(depths.length - 2, (i) => depths[i] + depths[i + 1] + depths[i + 2]);
  countDepthsIncreases(windowDepths);
}

void countDepthsIncreases(Iterable<int> depths) {
  int previousDepth = depths.first;
  int count = 0;
  for (final currentDepth in depths.skip(1)) {
    if (currentDepth > previousDepth) ++count;
    previousDepth = currentDepth;
  }
  print(count);
}
