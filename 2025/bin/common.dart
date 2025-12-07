// COUNTER

extension type Counter<T>._(Map<T, int> map) {
  factory Counter() {
    return Counter._({});
  }

  factory Counter.fromIterable(Iterable<T> elements) {
    final map = <T, int>{};
    for (final element in elements) {
      map[element] = (map[element] ?? 0) + 1;
    }
    return Counter._(map);
  }

  bool get isEmpty => map.isEmpty;

  Iterable<int> get values => map.values;

  int operator [](T key) => map[key] ?? 0;

  void operator []=(T key, int value)  => map[key] = value;

  void increase(T key, int amount) => this[key] += amount;

  Iterable<(T, int)> records() => map.toRecords();
}

extension CountableIterable<T> on Iterable<T> {
  Counter<T> get count => Counter.fromIterable(this);
}

extension ListZipper<T, K> on Iterable<T> {
  Iterable<(T, K)> zip(Iterable<K> other) sync* {
    final iter = other.iterator;
    for (final i in this) {
      if (!iter.moveNext()) return;
      yield (i, iter.current);
    }
  }
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
    return fold(([], []), (acc, record) {
      acc.$1.add(record.$1);
      acc.$2.add(record.$2);
      return acc;
    });
  }
}

extension ZippedMap<T, K> on Iterable<(T, K)> {
  Iterable<J> zippedMap<J>(J Function(T, K) mapping) =>
      map((e) => mapping(e.$1, e.$2));

  Iterable<(T, K)> zippedWhere(bool Function(T, K) test) =>
      where((e) => test(e.$1, e.$2));

  Iterable<J> zippedExpand<J>(Iterable<J> Function(T, K) mapping) =>
      expand((e) => mapping(e.$1, e.$2));
}

// IndexedMap
extension IndexedMap<T> on Iterable<T> {
  Iterable<K> indexedMap<K>(K Function(int, T) mapping) =>
      indexed.zippedMap(mapping);

  Iterable<K> indexedExpand<K>(Iterable<K> Function(int, T) mapping) =>
      indexed.zippedExpand(mapping);
}

// Accessor
extension ListAccessor<T> on List<T> {
  T at(int index, T defaultValue) =>
      (index >= 0 && index < length) ? this[index] : defaultValue;
}

// Copy
extension Copy<T> on List<T> {
  List<T> copy() => List<T>.of(this);
}

// OutOfBounds
extension OutOfBounds<T> on List<List<T>> {
  bool isOutOfBounds(int i, int j) =>
      i < 0 || i >= length || j < 0 || j >= this[i].length;
}

// Printable
extension IterablePrinter<T> on Iterable<T> {
  Iterable<T> printIterable() => map((e) {
    print(e);
    return e;
  });
}

// Num of digits
extension NumDigits on int {
  int get numDigits => toString().length;
}

// ToMap
extension IterableToMap<K, V> on Iterable<(K, V)> {
  Map<K, V> toMap() {
    final m = <K, V>{};
    for (final (k, v) in this) {
      m[k] = v;
    }
    return m;
  }

  Map<K, List<V>> toMapGroup() {
    final m = <K, List<V>>{};
    for (final (k, v) in this) {
      if (!m.containsKey(k)) m[k] = <V>[];
      m[k]!.add(v);
    }
    return m;
  }
}

// ToRecords
extension MapToRecords<K, V> on Map<K, V> {
  Iterable<(K, V)> toRecords() sync* {
    for (final k in keys) {
      yield (k, this[k]!);
    }
  }
}

// SetIterable
extension Union<T> on Iterable<Set<T>> {
  Set<T> get union => reduce((acc, curr) => acc.union(curr));

  Set<T> get intersection => reduce((acc, curr) => acc.intersection(curr));
}

// BoolIterable
extension BoolIterable on Iterable<bool> {
  bool get everyTrue => every((t) => t);
}

// CrossIterable
extension CrossIterable<T> on Iterable<T> {
  Iterable<(T, P)> cross<P>(Iterable<P> other) sync* {
    for (final i in this) {
      for (final j in other) {
        yield (i, j);
      }
    }
  }
}
