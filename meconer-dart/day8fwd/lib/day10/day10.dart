import 'dart:math';

import '../util/util.dart';

class Problem {
  bool isExample;
  int dayNo;

  Problem({this.isExample = false, this.dayNo = 10});

  List<String> getInput() {
    String dirName = 'lib/day$dayNo/';
    String fileName = dirName + (isExample ? 'example.txt' : 'input.txt');
    return readInput(fileName);
  }
}

Problem problem = Problem(isExample: false);

const int dispWidth = 80;
const int dispHeight = 20;

class Point {
  int r, c;
  int vr, vc;
  Point(this.r, this.c, this.vr, this.vc);
}

class Range {
  late int cMin, cMax;
  late int rMin, rMax;
  late double cScale = 1.0, rScale = 1.0;

  Range.fromPoints(List<Point> points) {
    cMin = 999999999;
    cMax = -999999999;
    rMin = 999999999;
    rMax = -999999999;
    for (final point in points) {
      cMin = min(cMin, point.c);
      cMax = max(cMax, point.c);
      rMin = min(rMin, point.r);
      rMax = max(rMax, point.r);
    }
    cScale = (cMax - cMin) / dispWidth;
    rScale = (rMax - rMin) / dispHeight;
  }
}

void printPoints(List<Point> points, Range range) {
  for (int r = range.rMin; r <= range.rMax; r++) {
    String line = "";
    for (int c = range.cMin; c <= range.cMax; c++) {
      if (points.any((p) => p.c == c && p.r == r)) {
        line += "#";
      } else {
        line += '.';
      }
    }
    print(line);
  }
}

int resultP1() {
  final input = problem.getInput();
  pointFromLine(input.first);
  final points = getPointsFromInput(input);

  int minRange = 999999999;
  List<Point> bestPoints = [];
  int timeToMessage = 0;
  for (int i = 0; i < 20000; i++) {
    final range = Range.fromPoints(points);
    final totalRange = range.cMax - range.cMin + range.rMax - range.rMin;
    if (totalRange < minRange) {
      minRange = totalRange;

      bestPoints = [];
      timeToMessage = i;
      for (final point in points) {
        bestPoints.add(Point(point.r, point.c, point.vr, point.vc));
      }
    }

    movePoints(points);
  }
  final range = Range.fromPoints(bestPoints);
  printPoints(bestPoints, range);
  print(timeToMessage);
  return 0;
}

void movePoints(List<Point> points) {
  for (final point in points) {
    point.c += point.vc;
    point.r += point.vr;
  }
}

List<Point> getPointsFromInput(List<String> input) {
  final points = input.map((line) => pointFromLine(line)).toList();
  return points;
}

Point pointFromLine(String line) {
  const posRegExStr =
      "position=< *(-?\\d+), *(-?\\d+).*velocity=< *(-?\\d+), *(-?\\d+)";
  final posRe = RegExp(posRegExStr);
  final match = posRe.firstMatch(line);
  int c = int.parse(match!.group(1)!);
  int r = int.parse(match.group(2)!);
  int vc = int.parse(match.group(3)!);
  int vr = int.parse(match.group(4)!);
  return Point(r, c, vr, vc);
}

int resultP2() {
  return 0;
}
