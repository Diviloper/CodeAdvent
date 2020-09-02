void main() {
  first();
  second();
}

class Generator {
  static const _divisionFactor = 2147483647;
  final int initial;
  final int factor;
  bool Function(int) condition;
  int current;

  Generator(this.initial, this.factor, {this.condition}) : current = initial {
    condition ??= (_) => true;
  }

  int getNext() {
    final next = (current * factor) % _divisionFactor;
    current = next;
    return condition(current) ? current : getNext();
  }
}

bool matches(int first, int second) {
  final firstString = first.toRadixString(2).padLeft(16, '0');
  final secondString = second.toRadixString(2).padLeft(16, '0');
  return firstString.substring(firstString.length - 16) ==
      secondString.substring(secondString.length - 16);
}

void first() {
  final A = Generator(783, 16807);
  final B = Generator(325, 48271);
  int count = 0;
  for (int i = 0; i < 40000000; ++i) {
    if (matches(A.getNext(), B.getNext())) count++;
  }
  print(count);
}

void second() {
  final A = Generator(783, 16807, condition: (i) => i % 4 == 0);
  final B = Generator(325, 48271, condition: (i) => i % 8 == 0);
  int count = 0;
  for (int i = 0; i < 5000000; ++i) {
    if (matches(A.getNext(), B.getNext())) count++;
  }
  print(count);}
