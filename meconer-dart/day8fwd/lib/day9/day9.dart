import 'dart:io';
import 'dart:math';

class Problem {
  bool isExample;
  int dayNo;

  int noOfPlayers;
  int valueOfLastMarble;

  Problem(this.noOfPlayers, this.valueOfLastMarble,
      {this.isExample = false, this.dayNo = 9});
}

Problem problem = Problem(413, 71082);

class CircleNode {
  CircleNode? next;
  CircleNode? prev;
  int value;
  CircleNode(this.value) {
    next = this;
    prev = this;
  }

  CircleNode add(int value) {
    final newNode = CircleNode(value);
    newNode.next = next;
    newNode.prev = this;
    next!.prev = newNode;
    next = newNode;
    return newNode;
  }

  CircleNode moveRight(int steps) {
    var node = this;
    for (int i = 0; i < steps; i++) {
      node = node.next!;
    }
    return node;
  }

  CircleNode moveLeft(int steps) {
    var node = this;
    for (int i = 0; i < steps; i++) {
      node = node.prev!;
    }
    return node;
  }

  (CircleNode, int) remove() {
    prev!.next = next;
    next!.prev = prev;
    return (next!, value);
  }

  printCircle() {
    CircleNode first = this;
    while (first.value != 0) {
      first = first.next!;
    }
    stdout.write('${first.value} ');
    first = first.next!;
    while (first.value != 0) {
      stdout.write('${first.value} ');
      first = first.next!;
    }
    print("");
  }
}

int resultP1() {
  List<int> players = List.generate(problem.noOfPlayers, (_) => 0);
  CircleNode circle = CircleNode(0);
  int nextMarble = 1;
  int nextPlayer = 0;
  while (nextMarble <= problem.valueOfLastMarble) {
    int playerPoints;
    (circle, playerPoints) = placeMarble(circle, nextMarble);
    // circle.printCircle();
    players[nextPlayer] += playerPoints;
    nextPlayer++;
    nextPlayer %= problem.noOfPlayers;
    nextMarble++;
  }

  return players.fold(0, (a, el) => max(a, el));
}

(CircleNode, int) placeMarble(CircleNode circle, int nextMarble) {
  if (nextMarble % 23 == 0) {
    circle = circle.moveLeft(7);
    int pointsForRemoved;
    (circle, pointsForRemoved) = circle.remove();
    return (circle, pointsForRemoved + nextMarble);
  }

  circle = circle.moveRight(1);

  circle = circle.add(nextMarble);

  return (circle, 0);
}

int resultP2() {
  problem.valueOfLastMarble *= 100;

  return resultP1();
}
