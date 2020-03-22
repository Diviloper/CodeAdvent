import 'dart:io';

extension RepetableList<T> on List<T> {
  List<T> repeat(int times) {
    List<T> newList = List.from(this);
    for (int i = 0; i < times; ++i) newList = newList.followedBy(this).toList();
    return newList;
  }

  List<T> repeatUntilLength(int newLength) {
    List<T> newList = List.from(this);
    for (int i = 0; i < newLength ~/ this.length; ++i) {
      newList = newList.followedBy(List.from(this)).toList();
    }
    return newList.followedBy(this.take(newLength % this.length)).toList();
  }

  List<T> zip(List<T> other, T Function(T, T) zipFunc) {
    return List.generate(this.length, (i) => zipFunc(this[i], other[i]));
  }
}

void main() {
  List<int> input = "03036732577212944063491565474664"
      .split('')
      .map(int.parse)
      .toList()
      .repeat(10000);
  final basePattern = [0, 1, 0, -1];
  final patterns = List.generate(
    input.length,
    (i) => basePattern
        .expand((elem) => List.filled(i + 1, elem))
        .toList()
        .repeatUntilLength(input.length + 1)
        .skip(1)
        .toList(),
  );
  for (int i = 0; i < 100; ++i) {
    input = List.generate(
        input.length,
        (i) =>
            List<int>.from(input)
                .zip(patterns[i], (a, b) => a * b)
                .reduce((current, next) => current + next)
                .abs() %
            10);
  }
  int offset = int.parse(input.take(7).join());
  print(input.sublist(offset, offset+ 8).join());
}
