import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final (files, freeSpace) =
      File('./input.txt').readAsStringSync().split("").map(int.parse).unzip();

  int checksum = compact(files.copy(), freeSpace.copy());
  print(checksum);

  int newChecksum = compactUnfragmented(files.copy(), freeSpace.copy());
  print(newChecksum);
}

int compact(List<int> files, List<int> freeSpace) {
  int leftFile = 0;
  int rightFile = files.length - 1;
  int currentPos = 0;
  int checksum = 0;
  bool file = true;

  while (leftFile <= rightFile) {
    if (file) {
      checksum += leftFile *
          Iterable<int>.generate(files[leftFile], (x) => currentPos + x).sum;
      currentPos += files[leftFile];
      if (leftFile == rightFile) break;
    } else {
      for (int i = 0; i < freeSpace[leftFile]; ++i) {
        if (files[rightFile] == 0) {
          rightFile--;
        }
        checksum += currentPos * rightFile;
        files[rightFile]--;
        currentPos++;
      }
      leftFile++;
    }
    file = !file;
  }
  return checksum;
}

int compactUnfragmented(List<int> files, List<int> freeSpace) {
  final filePositions = <(int, int, int)>[]; // index, size, id
  final freeSpaces = <(int, int)>[]; // index, size
  int currentIndex = 0;
  for (int i = 0; i < files.length; ++i) {
    filePositions.add((currentIndex, files[i], i));
    currentIndex += files[i];
    freeSpaces.add((currentIndex, freeSpace.at(i, 0)));
    currentIndex += freeSpace.at(i, 0);
  }
  // print(filePositions.join(Platform.lineTerminator));
  // print(freeSpaces.join(Platform.lineTerminator));

  for (int i = files.length - 1; i >= 0; --i) {
    // print("Handling file $i");
    final (indF, (index, size, id)) =
        filePositions.indexed.firstWhere((e) => e.$2.$3 == i);
    final (indS, (spaceIndex, spaceSize)) = freeSpaces.indexed.firstWhere(
        (space) => space.$2.$2 >= size,
        orElse: () => (-1, (index + 1, 0)));
    if (spaceIndex > index) continue;
    // print("Moving $id from $index to $spaceIndex");

    filePositions[indF] = (spaceIndex, size, id);
    if (size == spaceSize) {
      freeSpaces.removeAt(indS);
    } else {
      freeSpaces[indS] = (spaceIndex + size, spaceSize - size);
    }

    final spaceBefore = freeSpaces.indexed
        .firstWhereOrNull((space) => space.$2.$1 + space.$2.$2 == index);
    final spaceAfter = freeSpaces.indexed
        .firstWhereOrNull((space) => index + size == space.$2.$1);
    if (spaceBefore != null && spaceAfter != null) {
      freeSpaces.removeAt(spaceAfter.$1);
      final newSpace =
          (spaceBefore.$2.$1, spaceBefore.$2.$2 + size + spaceAfter.$2.$2);
      // print("Merging spaces $spaceBefore and $spaceAfter into $newSpace");
      freeSpaces[spaceBefore.$1] = newSpace;
    } else if (spaceBefore != null) {
      // print("Enlarging space before $spaceBefore");
      freeSpaces[spaceBefore.$1] =
          (spaceBefore.$2.$1, spaceBefore.$2.$1 + size);
    } else if (spaceAfter != null) {
      // print("Enlarging space after $spaceAfter");
      freeSpaces[spaceAfter.$1] = (index, size + spaceAfter.$2.$2);
    }
  }

  return filePositions
      .map((x) => x.$3 * Iterable.generate(x.$2, (i) => i + x.$1).sum)
      .sum;
}
