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
extension ListSplitter<T, K> on Iterable<(T, K)> {
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


// Copy
extension Copy<T> on List<T> {
  List<T> copy() => List<T>.from(this);
}