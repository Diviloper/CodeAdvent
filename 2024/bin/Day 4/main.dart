import 'dart:io';

import 'package:collection/collection.dart';

import '../common.dart';

void main() {
  final input = File('./input.txt')
      .readAsLinesSync()
      .map((line) => line.split(""))
      .toList();

  final first = input
      .indexedMap(
          (i, row) => row.indexedMap((j, _) => countXmas(input, i, j)).sum)
      .sum;
  print(first);

  final second = input
      .indexedMap(
          (i, row) => row.indexedMap((j, _) => countXMas(input, i, j)).sum)
      .sum;
  print(second);
}

int countXmas(List<List<String>> matrix, int i, int j) {
  int count = 0;
  try {
    if (matrix[i][j] == "X" &&
        matrix[i][j + 1] == "M" &&
        matrix[i][j + 2] == "A" &&
        matrix[i][j + 3] == "S") ++count;
  } on RangeError {/**/}
  try {
    if (matrix[i][j] == "X" &&
        matrix[i][j - 1] == "M" &&
        matrix[i][j - 2] == "A" &&
        matrix[i][j - 3] == "S") ++count;
  } on RangeError {/**/}
  try {
    if (matrix[i][j] == "X" &&
        matrix[i + 1][j] == "M" &&
        matrix[i + 2][j] == "A" &&
        matrix[i + 3][j] == "S") ++count;
  } on RangeError {/**/}
  try {
    if (matrix[i][j] == "X" &&
        matrix[i - 1][j] == "M" &&
        matrix[i - 2][j] == "A" &&
        matrix[i - 3][j] == "S") ++count;
  } on RangeError {/**/}
  try {
    if (matrix[i][j] == "X" &&
        matrix[i - 1][j - 1] == "M" &&
        matrix[i - 2][j - 2] == "A" &&
        matrix[i - 3][j - 3] == "S") ++count;
  } on RangeError {/**/}
  try {
    if (matrix[i][j] == "X" &&
        matrix[i - 1][j + 1] == "M" &&
        matrix[i - 2][j + 2] == "A" &&
        matrix[i - 3][j + 3] == "S") ++count;
  } on RangeError {/**/}
  try {
    if (matrix[i][j] == "X" &&
        matrix[i + 1][j + 1] == "M" &&
        matrix[i + 2][j + 2] == "A" &&
        matrix[i + 3][j + 3] == "S") ++count;
  } on RangeError {/**/}
  try {
    if (matrix[i][j] == "X" &&
        matrix[i + 1][j - 1] == "M" &&
        matrix[i + 2][j - 2] == "A" &&
        matrix[i + 3][j - 3] == "S") ++count;
  } on RangeError {/**/}

  return count;
}

int countXMas(List<List<String>> matrix, int i, int j) {
  int count = 0;

  try {
    if (matrix[i][j] == "A" &&
        matrix[i - 1][j - 1] == "M" &&
        matrix[i + 1][j + 1] == "S" &&
        matrix[i - 1][j + 1] == "M" &&
        matrix[i + 1][j - 1] == "S") count++;
  } on RangeError {/**/}
  try {
    if (matrix[i][j] == "A" &&
        matrix[i - 1][j - 1] == "M" &&
        matrix[i + 1][j + 1] == "S" &&
        matrix[i - 1][j + 1] == "S" &&
        matrix[i + 1][j - 1] == "M") count++;
  } on RangeError {/**/}
  try {
    if (matrix[i][j] == "A" &&
        matrix[i - 1][j - 1] == "S" &&
        matrix[i + 1][j + 1] == "M" &&
        matrix[i - 1][j + 1] == "M" &&
        matrix[i + 1][j - 1] == "S") count++;
  } on RangeError {/**/}
  try {
    if (matrix[i][j] == "A" &&
        matrix[i - 1][j - 1] == "S" &&
        matrix[i + 1][j + 1] == "M" &&
        matrix[i - 1][j + 1] == "S" &&
        matrix[i + 1][j - 1] == "M") count++;
  } on RangeError {/**/}

  return count;
}
