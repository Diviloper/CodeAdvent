import 'package:equatable/equatable.dart';

class Pair<F, S> extends Equatable {
  final F first;
  final S second;

  const Pair(this.first, this.second);

  @override
  List<Object> get props => [first, second];
}

extension MatrixManipulation<T> on List<List<T>> {
  List<List<T>> get rotateRight => [
        for (int j = 0; j < first.length; ++j)
          [
            for (int i = length - 1; i >= 0; --i) this[i][j],
          ],
      ];

  List<List<T>> get flipVertically => reversed.map((row) => List.of(row)).toList();

  List<List<T>> get flipHorizontally => map((row) => row.reversed.toList()).toList();

  List<List<List<T>>> get orientations => [
        this,
        rotateRight,
        rotateRight.rotateRight,
        rotateRight.rotateRight.rotateRight,
        rotateRight.flipVertically,
        rotateRight.flipHorizontally,
        flipHorizontally,
        flipVertically,
      ];
}

extension SubMatrix<T> on List<List<T>> {
  List<List<T>> subMatrix(int minI, int maxI, int minJ, int maxJ) =>
      sublist(minI, maxI + 1).map((e) => e.sublist(minJ, maxJ + 1)).toList();
}

extension StrinMatrix<T> on List<List<T>> {
  String toMatrixString() => map((row) => row.join()).join('\n');
}
