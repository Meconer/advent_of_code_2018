import 'dart:math';

import '../util/util/util.dart';

class Problem {
  bool isExample;
  int dayNo;

  Problem({this.isExample = true, this.dayNo = 11});

  List<String> getInput() {
    String dirName = 'lib/day$dayNo/';
    String fileName = dirName + (isExample ? 'example.txt' : 'input.txt');
    return readInput(fileName);
  }
}

Problem problem = Problem(isExample: false);

int resultP1() {
  return 0;
}

int resultP2() {
  return 0;
}
