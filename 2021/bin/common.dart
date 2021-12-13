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
