import 'package:equatable/equatable.dart';

class Tuple<X, Y> extends Equatable {
  final X first;
  final Y second;

  Tuple(this.first, this.second);

  Tuple.fromList(List list)
      : assert(list.length == 2),
        first = list.first,
        second = list.last;

  @override
  List<Object?> get props => [first, second];

  @override
  String toString() => '($first, $second)';
}

extension Frequencies<T> on Iterable<T> {
  Map<T, int> get frequencies {
    final frequencies = <T, int>{};
    for (final element in this) {
      frequencies.update(element, (value) => value + 1, ifAbsent: () => 1);
    }
    return frequencies;
  }
}

extension Hex on int {
  static int parse(String source) => int.parse(source, radix: 16);
}

extension Bin on int {
  static int parse(String source) => int.parse(source, radix: 2);
}
