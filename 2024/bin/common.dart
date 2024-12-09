// COUNTER

extension type Counter<T>._(Map<T, int> map) {
  factory Counter(Iterable<T> elements) {
    final map = <T, int>{};
    for (final element in elements) {
      map[element] = (map[element] ?? 0) + 1;
    }
    return Counter._(map);
  }

  int operator [](T key) => map[key] ?? 0;
}

extension CountableIterable<T> on Iterable<T> {
  Counter<T> get count => Counter(this);
}

// Splitter
extension ListSplitter<T> on Iterable<T> {
  (List<T>, List<T>) unzip() {
    final left = <T>[];
    final right = <T>[];
    bool l = true;
    for (final e in this) {
      if (l) {
        left.add(e);
      } else {
        right.add(e);
      }
      l = !l;
    }
    return (left, right);
  }
}

extension ListUnzipper<T, K> on Iterable<(T, K)> {
  Iterable<T> get firsts => map((e) => e.$1);

  Iterable<K> get seconds => map((e) => e.$2);

  (List<T>, List<K>) unzip() {
    return fold(
      ([], []),
      (acc, record) {
        acc.$1.add(record.$1);
        acc.$2.add(record.$2);
        return acc;
      },
    );
  }
}

extension ZippedMap<T, K> on Iterable<(T, K)> {
  Iterable<J> zippedMap<J>(J Function(T, K) mapping) =>
      map((e) => mapping(e.$1, e.$2));

  Iterable<(T, K)> zippedWhere(bool Function(T, K) test) =>
      where((e) => test(e.$1, e.$2));
}

// IndexedMap
extension IndexedMap<T> on Iterable<T> {
  Iterable<K> indexedMap<K>(K Function(int, T) mapping) =>
      indexed.zippedMap(mapping);
}

// Accessor
extension ListAccessor<T> on List<T> {
  T at(int index, T defaultValue) =>
      (index >= 0 && index < length) ? this[index] : defaultValue;
}

// Copy
extension Copy<T> on List<T> {
  List<T> copy() => List<T>.from(this);
}

// OutOfBounds
extension OutOfBounds<T> on List<List<T>> {
  bool isOutOfBounds(int i, int j) =>
      i < 0 || i >= length || j < 0 || j >= this[i].length;
}
