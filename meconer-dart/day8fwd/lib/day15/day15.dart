import 'dart:math';

import '../util/util.dart';

class Problem {
  bool isExample;
  int dayNo;

  Problem({this.isExample = false, this.dayNo = 15});

  List<String> getInput() {
    String dirName = 'lib/day$dayNo/';
    String fileName = dirName + (isExample ? 'example6.txt' : 'input.txt');
    return readInput(fileName);
  }
}

Problem problem = Problem(isExample: false);

enum UnitType { elf, goblin }

class LPos {
  int row, col;
  LPos(this.row, this.col);
  int compareTo(LPos other) {
    int comp = row.compareTo(other.row);
    if (comp == 0) {
      return col.compareTo(other.col);
    }
    return comp;
  }

  List<LPos> neighbours() {
    return [
      LPos(row, col - 1),
      LPos(row, col + 1),
      LPos(row - 1, col),
      LPos(row + 1, col),
    ];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LPos && (col == other.col && row == other.row);
  }

  @override
  int get hashCode => (col * 100000 + row);
}

class Unit {
  UnitType type;
  LPos pos;
  int hp = 200;
  int attackForce = 3;

  Unit(this.type, this.pos);
}

class Board {
  late List<List<String>> grid;
  late List<Unit> units = [];
  late List<LPos> walls = [];
  late int width;
  late int height;

  Board(List<String> input) {
    grid = input.map((e) => e.split('')).toList();
    int row = 0;
    for (final line in grid) {
      int col = 0;
      for (var gridPoint in line) {
        if (gridPoint == 'G') {
          units.add(Unit(UnitType.goblin, LPos(row, col)));
          grid[row][col] = '.';
        }
        if (gridPoint == 'E') {
          units.add(Unit(UnitType.elf, LPos(row, col)));
          grid[row][col] = '.';
        }
        if (gridPoint == '#') {
          walls.add(LPos(row, col));
        }
        col++;
      }
      row++;
    }
    width = grid[0].length;
    height = grid.length;
  }

  String getCharAt(LPos pos) {
    if (!inRange(pos)) return '#';
    return grid[pos.row][pos.col];
  }

  void printBoard({Map<LPos, int>? dMap}) {
    print(dMap != null ? "DMap" : "Board");
    for (int row = 0; row < height; row++) {
      String lineToPrint = "";
      for (int col = 0; col < width; col++) {
        String char = grid[row][col];
        final unit = units.where((element) => element.pos == LPos(row, col));
        if (unit.isNotEmpty) {
          char = unit.first.type == UnitType.elf ? 'E' : 'G';
        }
        if (dMap != null) {
          var dist = dMap[LPos(row, col)];
          if (dist != null) {
            char = (dist >= 10) ? '@' : dist.toString();
          }
        }
        lineToPrint += char;
      }
      print(lineToPrint);
    }
    print("");
  }

  List<Unit> enemiesInRange(Unit unit) {
    List<Unit> inRange = [];
    for (final neighbour in unit.pos.neighbours()) {
      for (final enemy in units.where((element) => element.type != unit.type)) {
        if (enemy.pos == neighbour) inRange.add(enemy);
      }
    }
    return inRange;
  }

  int play({bool part2 = false, int elfAttackForce = 3}) {
    bool finished = false;
    int round = 0;
    while (!finished) {
      // print("Round : ${round + 1}");
      List<Unit> unitsInReadingOrder = getSortedUnits();
      for (final unit in unitsInReadingOrder) {
        if (unit.type == UnitType.elf && part2) {
          unit.attackForce = elfAttackForce;
        }
        if (unit.hp <= 0) continue;
        // Check if we are in attack position already

        if (enemiesInRange(unit).isEmpty) {
          // Get the preferred attack position
          LPos? wantedAttackPosition = getWantedAttackPosition(unit);
          // printBoard();
          // Move if we are not in attack position
          if (wantedAttackPosition != null &&
              unit.pos != wantedAttackPosition) {
            // Move towards attackPosition
            // Get a distance map from the wanted position
            final dMap = getDist(wantedAttackPosition);
            dMap[wantedAttackPosition] = 0;
            // printBoard(dMap: dMap);
            // The units free neighbours (where it is possible to move)
            final neighbours =
                unit.pos.neighbours().where((element) => isFree(element));

            // Find the moves possible
            List<DistMap> possibleMoves = [];
            for (final neighbour in neighbours) {
              if (dMap.keys.contains(neighbour)) {
                possibleMoves.add(DistMap(neighbour, dMap[neighbour]!));
              }
            }

            // Get the shortest distance to the chosen enemy unit
            possibleMoves.sort((a, b) => a.dist.compareTo(b.dist));
            int shortestDist = possibleMoves.first.dist;
            possibleMoves = possibleMoves
                .where((element) => element.dist == shortestDist)
                .toList();
            possibleMoves.sort((a, b) => a.pos.compareTo(b.pos));

            // Do the move
            unit.pos = possibleMoves.first.pos;
            // printBoard();
          }
        }
        // If we are in attack position we do the attack
        var inRange = enemiesInRange(unit);
        if (inRange.isNotEmpty) {
          inRange.sort((a, b) => a.hp.compareTo(b.hp));
          while (inRange.first.hp <= 0 && inRange.isNotEmpty) {
            inRange.removeAt(0);
          }
          if (inRange.isEmpty) continue; // There are no targets left

          int lowestHp = inRange.first.hp;
          inRange = inRange.where((element) => element.hp == lowestHp).toList();
          // Sort them in reading order if there are more than one with the same hp
          inRange.sort(
            (a, b) => a.pos.compareTo(b.pos),
          );
          final target = inRange.first;
          target.hp -= unit.attackForce;
          if (target.hp <= 0) {
            units.remove(target);
            int noOfElfs = countElfs();
            finished = noOfElfs == 0 || noOfElfs == units.length;
            if (finished && unit != unitsInReadingOrder.last) round--;
          }
        }
      }

      round++;
      // printBoard();
      // printUnits();
    }
    int sumOfHP = units.fold(0, (pHp, element) => pHp + max(0, element.hp));
    // print("Full rounds : $round");
    return round * sumOfHP;
  }

  List<Unit> getSortedUnits() {
    List<Unit> sortedUnits = List.from(units);
    sortedUnits.sort((a, b) => a.pos.compareTo(b.pos));
    return sortedUnits;
  }

  List<LPos> getEnemyAttackPositions(UnitType type) {
    List<LPos> enemyPositions = units
        .where((element) => element.type != type)
        .map((e) => e.pos)
        .toList();
    List<LPos> attackPositions = [];
    for (final enPos in enemyPositions) {
      for (final pos in enPos.neighbours()) {
        if (!(grid[pos.row][pos.col] == '#') &&
            !units.any((unitPos) =>
                unitPos.pos.row == pos.row && unitPos.pos.col == pos.col)) {
          attackPositions.add(pos);
        }
      }
    }
    return attackPositions;
  }

  Map<LPos, int> getDist(LPos startPos) {
    Map<LPos, int> distMap = {};
    for (final nPos in startPos.neighbours()) {
      if (isFree(nPos)) distMap[nPos] = 1;
    }

    bool stopped = false;
    int currDist = 1;
    while (!stopped) {
      List<DistMap> dMapsToCheck = [];
      for (final dMap
          in distMap.entries.where((cdMap) => cdMap.value == currDist)) {
        dMapsToCheck.add(DistMap(dMap.key, dMap.value));
      }
      stopped = true;
      for (final dMapToCheck in dMapsToCheck) {
        // print("c: ${dMapToCheck.pos.col} r: ${dMapToCheck.pos.row}");
        final currPos = dMapToCheck.pos;
        for (final neighbour in currPos.neighbours()) {
          if (isFree(neighbour) &&
              !distMap.containsKey(neighbour) &&
              neighbour != startPos) {
            stopped = false;
            distMap[neighbour] = currDist + 1;
          }
        }
      }
      currDist++;
    }
    return distMap;
  }

  bool inRange(LPos pos) {
    return pos.col >= 0 && pos.col < width && pos.row >= 0 && pos.row < height;
  }

  isFree(LPos pos) {
    final hasUnit = units.any((unit) => unit.pos == pos);
    final hasWall = getCharAt(pos) != '.';
    return !hasWall && !hasUnit;
  }

  LPos? getWantedAttackPosition(Unit unit) {
    // Get the positions neighbouring to all enemies
    List<LPos> enemyAttackPositions = getEnemyAttackPositions(unit.type);

    // Find the distances to all empty spaces on the board
    Map<LPos, int> distances = getDist(unit.pos);

    // Get the distance to all attack positions. (The positions neighbouring
    // the enemies)
    List<DistMap> positions = [];
    for (final enemyAttackPos in enemyAttackPositions) {
      if (distances.keys.contains(enemyAttackPos)) {
        positions.add(DistMap(enemyAttackPos, distances[enemyAttackPos]!));
      }
    }
    // Sort them by distance and reading order
    positions.sort((a, b) {
      int compDist = a.dist.compareTo(b.dist);
      if (compDist != 0) return compDist;
      return a.pos.compareTo(b.pos);
    });
    if (positions.isEmpty) return null;
    return positions.first.pos;
  }

  int countElfs() {
    return units.where((element) => element.type == UnitType.elf).length;
  }

  void printUnits() {
    print("Type  R   C   Hp");
    for (final unit in getSortedUnits()) {
      final typeS = unit.type == UnitType.elf ? "Elf" : "Gob";
      print("$typeS ${unit.pos.row}  ${unit.pos.col}  ${unit.hp}");
    }
  }
}

class DistMap {
  LPos pos;
  int dist;
  DistMap(this.pos, this.dist);
}

int resultP1() {
  final board = Board(problem.getInput());
  return board.play();
}

int resultP2() {
  var board = Board(problem.getInput());
  int elfAttackForce = 4;
  int initialElfCount = board.countElfs();
  bool finished = false;
  while (!finished) {
    // print("Elf attack force : $elfAttackForce");
    int result = board.play(part2: true, elfAttackForce: elfAttackForce);
    // print("Result : $result");
    // board.printBoard();
    // board.printUnits();

    int elfCount = board.countElfs();
    if (elfCount == initialElfCount) {
      return result;
    }
    board = Board(problem.getInput());
    elfAttackForce++;
  }
}
