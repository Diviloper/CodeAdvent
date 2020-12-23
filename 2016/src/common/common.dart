import 'dart:io';

List<int> readListIntLines(String fileName) => File(fileName).readAsLinesSync().map(int.parse).toList();

List<int> readListInt(String fileName, {String separator = ' '}) =>
    File(fileName).readAsStringSync().split(separator).map(int.parse).toList();

extension EquatableList<T> on List<T> {
  bool equals(List<T> other) {
    if (length != other.length) return false;
    for (int i = 0; i < length; ++i) {
      if (this[i] != other[i]) return false;
    }
    return true;
  }

  bool allEqual() {
    for (int i = 0; i < length; ++i) {
      for (int j = 1; j < length; ++j) {
        if (this[i] != this[j]) return false;
      }
    }
    return true;
  }
}

bool Function(int, int) comparator(String symbol) {
  switch (symbol) {
    case '>':
      return (a, b) => a > b;
    case '<':
      return (a, b) => a < b;
    case '=>':
    case '>=':
      return (a, b) => a >= b;
    case '=<':
    case '<=':
      return (a, b) => a <= b;
    case '==':
      return (a, b) => a == b;
    case '!=':
      return (a, b) => a != b;
    default:
      throw 'Invalid symbol';
  }
}
