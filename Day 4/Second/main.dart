extension on List<int> {
  bool has6Digits() => this.length == 6;
  bool has2EqualAdjacentDigits() {
    for (int i = 1; i < this.length; ++i) {
      if (this[i - 1] == this[i]){
        bool valid = true;
        if (i-2 >= 0) {
          valid = valid && this[i-2] != this[i-1];
        }
        if (i+1 < this.length) {
          valid = valid && this[i+1] != this[i];
        }
        if (valid) return true;
      }
    }
    return false;
  }

  bool isIncreasing() {
    for (int i = 1; i < this.length; ++i) {
      if (this[i - 1] > this[i]) return false;
    }
    return true;
  }

  bool isValid() =>
      this.has6Digits() &&
      this.has2EqualAdjacentDigits() &&
      this.isIncreasing();

  List<int> get next {
    List<int> n = List.from(this);
    for (int i = n.length - 1; i >= 0; --i) {
      if (n[i] == 9) {
        n[i] = 0;
      } else {
        n[i]++;
        break;
      }
    }
    return n;
  }

  bool equals(List<int> other) {
    for (int i = 0; i < this.length; ++i) if (this[i] != other[i]) return false;
    return true;
  }
}

extension on int {
  List<int> get digits =>
      this.toString().split('').map((char) => int.parse(char)).toList();
}

void main() {
  final min = 156218.digits;
  final max = 652527.digits;
  int counter = 0;
  for (var current = min; !current.equals(max); current = current.next) {
    if (current.isValid()) {
      ++counter;
      print(current.join(''));
    }
  }
  print(counter);

  print("112233: ${112233.digits.isValid()}");
  print("123444: ${123444.digits.isValid()}");
  print("111122: ${111122.digits.isValid()}");

}
