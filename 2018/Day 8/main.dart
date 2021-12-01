import 'dart:io';
import '../common.dart';

void main() {
  final license = File('input.txt').readAsStringSync().split(' ').map(int.parse).toList();

  getMetadata(license);
  getValue(license);
}

void getValue(List<int> license) {
  Tuple<int, int> getValueOfCurrentNode(List<int> license, int currentIndex) {
    int numberOfSubNodes = license[currentIndex++];
    int numberOfMetadata = license[currentIndex++];
    int value = 0;
    if (numberOfSubNodes > 0) {
      final childValues = List.filled(numberOfSubNodes, 0);
      for (int i = 0; i < numberOfSubNodes; ++i) {
        final indexValue = getValueOfCurrentNode(license, currentIndex);
        currentIndex = indexValue.first;
        childValues[i] = indexValue.second;
      }
      for (int i = 0; i < numberOfMetadata; ++i) {
        final childIndex = license[currentIndex++];
        if (childIndex > 0 && childIndex <= numberOfSubNodes) {
          value += childValues[childIndex - 1];
        }
      }
    } else {
      for (int i = 0; i < numberOfMetadata; ++i) {
        value += license[currentIndex++];
      }
    }
    return Tuple(currentIndex, value);
  }

  final value = getValueOfCurrentNode(license, 0).second;
  print(value);
}

void getMetadata(List<int> license) {
  int getMetadataOfCurrentNode(List<int> license, int currentIndex, List<int> metadata) {
    int numberOfSubNodes = license[currentIndex++];
    int numberOfMetadata = license[currentIndex++];
    for (int i = 0; i < numberOfSubNodes; ++i) {
      currentIndex = getMetadataOfCurrentNode(license, currentIndex, metadata);
    }
    for (int i = 0; i < numberOfMetadata; ++i) {
      metadata.add(license[currentIndex++]);
    }
    return currentIndex;
  }

  final metadata = <int>[];
  getMetadataOfCurrentNode(license, 0, metadata);
  print(metadata.reduce((value, element) => value + element));
}
