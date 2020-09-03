// import 'dart:io';
//
// void main() {
//   for (int i = 1; i <= 25; ++i) {
//     try {
//       File('src/Day $i/input.txt').deleteSync();
//     } on FileSystemException {}
//     File('src/Day $i/main.dart').writeAsStringSync('''void main() {
//     first();
//     second();
// }
//
// void first() {}
//
// void second() {}''');
//   }
// }
