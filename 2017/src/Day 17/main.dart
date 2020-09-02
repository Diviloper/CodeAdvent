void main() {
  first();
  second();
}

void first() {
  final buffer = [0];
  final int steps = 328;
  int currentPosition = 0;
  for (int i = 1; i <= 2017; ++i) {
    currentPosition = (currentPosition + steps) % buffer.length;
    buffer.insert(++currentPosition, i);
  }
  print(buffer[currentPosition + 1]);
}

void second() {
  final int steps = 328;
  int currentPosition = 1;
  int positionOfZero = 0;
  int numberAfterZero = 1;
  for (int i = 2; i <= 50000000; ++i) {
    currentPosition = (currentPosition + steps) % i;
    if (currentPosition < positionOfZero) {
      positionOfZero++;
    } else if (currentPosition == positionOfZero) {
      numberAfterZero = i;
    }
    currentPosition++;
  }
  print(numberAfterZero);
}
