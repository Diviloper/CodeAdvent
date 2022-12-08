import 'dart:io' as io;

import 'package:collection/collection.dart';

abstract class Element {
  final String name;

  int get size;

  Element(this.name);

  @override
  String toString() => '$name ($size)';
}

class Directory extends Element {
  List<Element> contents = [];
  Directory? parent;
  int _size = 0;

  Directory(super.name, [this.parent]);

  @override
  int get size => _size;

  int updateSize() {
    contents.whereType<Directory>().forEach((e) => e.updateSize());
    _size = contents.map((e) => e.size).sum;
    return _size;
  }
}

class File extends Element {
  File(super.name, this.size);

  @override
  final int size;
}

void main() {
  List<String> cli = io.File('./input.txt').readAsLinesSync();
  Directory root = Directory('/');

  exploreFileSystem(cli, root);

  foldersSmallerThan(root, 100000);
  smallestBigEnoughFolder(root, 70000000, 30000000);
}

void exploreFileSystem(List<String> cli, Directory root) {
  Directory current = root;
  for (int i = 0; i < cli.length; ++i) {
    final commandParts = cli[i].split(' ');
    if (commandParts[1] == 'cd') {
      current = changeDirectory(commandParts[2], current, root);
    } else {
      i = getContents(current, cli, i + 1);
    }
  }
  root.updateSize();
}

int getContents(Directory current, List<String> cli, int i) {
  if (current.contents.isNotEmpty){
    while (i < cli.length && !cli[i].startsWith(r'$')) {
      i++;
    }
    return i - 1;
  }
  while (i < cli.length && !cli[i].startsWith(r'$')) {
    List<String> parts = cli[i].split(' ');
    if (parts[0] == 'dir') {
      current.contents.add(Directory(parts[1], current));
    } else {
      current.contents.add(File(parts[1], int.parse(parts[0])));
    }
    i++;
  }
  return i - 1;
}

Directory changeDirectory(String newDir, Directory current, Directory root) {
  if (newDir == '..') return current.parent!;
  if (newDir == '/') return root;
  return current.contents
      .whereType<Directory>()
      .singleWhere((e) => e.name == newDir);
}

void foldersSmallerThan(Directory dir, int i) {
  final dirs = [dir];
  final smallDirs = <Directory>[];
  while (dirs.isNotEmpty) {
    final current = dirs.removeLast();
    if (current.size < i) {
      smallDirs.add(current);
    }
    dirs.addAll(current.contents.whereType<Directory>());
  }
  print(smallDirs.map((e) => e.size).sum);
}

void smallestBigEnoughFolder(Directory root, int total, int required) {
    final freeSpace = total - root.size;
    final missing = required - freeSpace;

    final dirs = [root];
    final bigEnoughDirs = <Directory>[];
    while (dirs.isNotEmpty) {
      final current = dirs.removeLast();
      if (current.size > missing) {
        bigEnoughDirs.add(current);
        dirs.addAll(current.contents.whereType<Directory>());
      }
    }
    print((bigEnoughDirs..sort((a, b) => a.size.compareTo(b.size))).first);
}


