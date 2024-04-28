import 'dart:math';

import 'package:day8fwd/util/linepos.dart';
import 'package:day8fwd/util/lprange.dart';

import '../util/util.dart';

class Problem {
  bool isExample;
  int dayNo;

  Problem({this.isExample = false, this.dayNo = 17});

  List<String> getInput() {
    String dirName = 'lib/day$dayNo/';
    String fileName = dirName + (isExample ? 'example.txt' : 'input.txt');
    return readInput(fileName);
  }
}

Problem problem = Problem(isExample: false);

enum SpotMtrl { sand, clay, water, reachable }

class Board {
  Map<LinePos, SpotMtrl> spots = {};
  LPRange range = LPRange();

  Board(List<String> lines) {
    for (final line in lines) {
      spots.addAll(getSpotsFromLine(line));
    }
  }

  Map<LinePos, SpotMtrl> getSpotsFromLine(String line) {
    Map<LinePos, SpotMtrl> spots = {};
    String axisS = line.split('=')[0];
    int start = int.parse(line.split('=')[2].split('..')[0]);
    int end = int.parse(line.split('=')[2].split('..')[1]);
    int axis = int.parse(line.split('=')[1].split(',')[0]);
    if (axisS == 'x') {
      for (int y = start; y <= end; y++) {
        addSpot(axis, y, SpotMtrl.clay);
      }
    } else {
      for (int x = start; x <= end; x++) {
        addSpot(x, axis, SpotMtrl.clay);
      }
    }
    return spots;
  }

  void printBoard(int minCol, int maxCol, [int maxRow = 0]) {
    print("Board");
    maxRow = maxRow != 0 ? maxRow : range.rowMax;
    int startRow = max(0, maxRow - 30);
    for (int row = startRow; row <= maxRow + 1; row++) {
      String lineToPrint = "";
      for (int col = minCol; col <= maxCol; col++) {
        if (!spots.containsKey(LinePos(col, row))) {
          lineToPrint += '.';
          continue;
        }
        String printChar = switch (spots[LinePos(col, row)]!) {
          SpotMtrl.sand => '.',
          SpotMtrl.clay => '#',
          SpotMtrl.water => '~',
          SpotMtrl.reachable => '|',
        };
        lineToPrint += printChar;
      }
      print(lineToPrint);
    }
    print("");
  }

  void addSpot(int x, int y, SpotMtrl mtrl) {
    spots[LinePos(x, y)] = mtrl;
    range.extend(LinePos(x, y));
  }

  bool isBlocked(LinePos lPos) {
    if (!spots.keys.contains(lPos)) {
      return false;
    }
    return spots[lPos] == SpotMtrl.clay || spots[lPos] == SpotMtrl.water;
  }

  int checkBlockedToRight(LinePos pos) {
    while (true) {
      if (!isBlocked(pos.moveRight().moveDown())) return -pos.col;
      if (isBlocked(pos.moveRight())) return pos.col;
      pos = pos.moveRight();
    }
  }

  int checkBlockedToLeft(LinePos pos) {
    while (true) {
      if (!isBlocked(pos.moveLeft().moveDown())) return -pos.col;
      if (isBlocked(pos.moveLeft())) return pos.col;
      pos = pos.moveLeft();
    }
  }

  int countReachable() {
    return spots.values
        .where((element) =>
            element == SpotMtrl.reachable || element == SpotMtrl.water)
        .length;
  }
}

int resultP1() {
  Board board = Board(problem.getInput());
  board.printBoard(board.range.colMin, board.range.colMax);
  bool ready = false;
  Set<LinePos> waterFront = {};
  waterFront.add(LinePos(500, 1));
  int lastCount = 0;
  int maxRow = 30;
  int minCol = 480;
  int maxCol = 520;
  while (!ready) {
    Set<LinePos> newFronts = {};
    for (var waterDrop in waterFront) {
      if (!board.spots.containsKey(waterDrop)) {
        board.spots[waterDrop] = SpotMtrl.reachable;
      }
      if (board.isBlocked(waterDrop.moveDown())) {
        int left = board.checkBlockedToLeft(waterDrop);
        int right = board.checkBlockedToRight(waterDrop);

        if (left > 0 && right > 0) {
          // Water is in a bucket so it can settle here
          for (int col = left; col <= right; col++) {
            LinePos pos = LinePos(col, waterDrop.row);
            board.spots[pos] = SpotMtrl.water;
          }
          newFronts.add(waterDrop.moveUp());
        }

        if (left < 0 && right > 0) {
          // Right column is blocked. Left is not. Water can reach from left
          // to right but not settle
          for (int col = -left; col <= right; col++) {
            LinePos pos = LinePos(col, waterDrop.row);
            board.spots[pos] = SpotMtrl.reachable;
          }
          newFronts.add(LinePos(-left - 1, waterDrop.row));
          minCol = min(minCol, -left - 1);
        }

        if (left > 0 && right < 0) {
          // Left column is blocked. Right is not. Water can reach from left
          // to right but not settle
          for (int col = left; col <= -right; col++) {
            board.spots[LinePos(col, waterDrop.row)] = SpotMtrl.reachable;
          }
          newFronts.add(LinePos(-right + 1, waterDrop.row));
          maxCol = max(maxCol, -right + 1);
        }

        if (left < 0 && right < 0) {
          // Neither left or right column are blocked. Water overflows both ends
          // to right but not settle
          for (int col = -left; col <= -right; col++) {
            board.spots[LinePos(col, waterDrop.row)] = SpotMtrl.reachable;
          }
          newFronts.add(LinePos(-right + 1, waterDrop.row));
          newFronts.add(LinePos(-left - 1, waterDrop.row));
          minCol = min(minCol, -left - 1);
          maxCol = max(maxCol, -right + 1);
        }
      } else {
        newFronts.add(waterDrop.moveDown());
      }
    }
    newFronts =
        newFronts.where((element) => element.row <= board.range.rowMax).toSet();
    waterFront = newFronts;

    int count = board.countReachable();
    ready = count == lastCount;
    lastCount = count;
    maxRow = waterFront.fold(
        maxRow, (previousValue, element) => max(previousValue, element.row));
    board.printBoard(minCol, maxCol, maxRow);
  }
  return lastCount; // 25524 too low
}

bool setEquals<T>(Set<T>? a, Set<T>? b) {
  if (a == null) {
    return b == null;
  }
  if (b == null || a.length != b.length) {
    return false;
  }
  if (identical(a, b)) {
    return true;
  }
  for (final T value in a) {
    if (!b.contains(value)) {
      return false;
    }
  }
  return true;
}

int resultP2() {
  return 0;
}
