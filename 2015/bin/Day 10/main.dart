void main() {
  final start = '3113322113';
  final n = 50;
  print(lookAndSay(start, n).length);
}

String lookAndSay(String start, int n) {
  if (n == 0) {
    return start;
  }
  final chars = start.split('');
  final joined = [];
  String current = chars.first;
  int count = 1;
  for (final char in chars.skip(1)) {
    if (char == current) {
      ++count;
    } else {
      joined.add('$count$current');
      current = char;
      count = 1;
    }
  }
  joined.add('$count$current');
  return lookAndSay(joined.join(), n-1);
}