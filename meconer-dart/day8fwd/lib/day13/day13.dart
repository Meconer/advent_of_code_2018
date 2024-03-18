import '../util/util/util.dart';

class Problem {
  bool isExample;
  int dayNo;

  Problem({this.isExample = false, this.dayNo = 13});

  List<String> getInput() {
    String dirName = 'lib/day$dayNo/';
    String fileName = dirName + (isExample ? 'example2.txt' : 'input.txt');
    return readInput(fileName);
  }
}

Problem problem = Problem(isExample: false);

enum Turn { left, straight, right }

class Cart {
  Map<(String, String), String> nextDirs = {
    ('\\', '>'): 'v',
    ('\\', '<'): '^',
    ('\\', '^'): '<',
    ('\\', 'v'): '>',
    ('/', '>'): '^',
    ('/', '<'): 'v',
    ('/', '^'): '>',
    ('/', 'v'): '<',
    ('-', '>'): '>',
    ('-', '<'): '<',
    ('|', '^'): '^',
    ('|', 'v'): 'v',
  };
  Map<(String, Turn), String> intersectionTurns = {
    ('>', Turn.left): '^',
    ('>', Turn.straight): '>',
    ('>', Turn.right): 'v',
    ('^', Turn.left): '<',
    ('^', Turn.straight): '^',
    ('^', Turn.right): '>',
    ('<', Turn.left): 'v',
    ('<', Turn.straight): '<',
    ('<', Turn.right): '^',
    ('v', Turn.left): '>',
    ('v', Turn.straight): 'v',
    ('v', Turn.right): '<',
  };
  String dir;
  int col, row;
  List<Turn> turnQueue = [Turn.left, Turn.straight, Turn.right];
  Cart(this.row, this.col, this.dir);

  void setNewDir(String gridSymbol) {
    if (gridSymbol == '+') {
      final nextTurn = getNextIntersectionTurn();
      dir = intersectionTurns[(dir, nextTurn)]!;
    } else {
      dir = nextDirs[(gridSymbol, dir)]!;
    }
  }

  Turn getNextIntersectionTurn() {
    final turn = turnQueue.removeAt(0);
    turnQueue.add(turn);
    return turn;
  }
}

const directions = ['v', '<', '^', '>'];

class Board {
  List<String> grid;
  late List<Cart> carts;
  Board(this.grid) {
    carts = [];
    int lineNo = 0;
    for (final line in grid) {
      for (final dir in directions) {
        int pos = line.indexOf(dir);
        while (pos >= 0) {
          carts.add(Cart(lineNo, pos, dir));
          String s = grid[lineNo];
          String trackChar = (dir == '<' || dir == '>') ? '-' : '|';

          s = '${s.substring(0, pos)}$trackChar${s.substring(pos + 1)}';
          grid[lineNo] = s;
          pos = line.indexOf(dir, pos + 1);
        }
      }
      lineNo++;
    }
  }

  (int, int) findCrashPos() {
    // Sort the carts by position so we always pick the cart that
    // is in row closest to the top. Or leftmost if both are on the same row
    while (true) {
      carts.sort((a, b) {
        int c = a.row.compareTo(b.row);
        return c != 0 ? c : a.col.compareTo(b.col);
      });

      // Move the carts
      for (final cart in carts) {
        moveCart(cart);
        if (isCrash(cart)) {
          return (cart.row, cart.col);
        }
      }
    }
  }

  void moveCart(Cart cart) {
    switch (cart.dir) {
      case '>':
        cart.col++;
      case '^':
        cart.row--;
      case '<':
        cart.col--;
      case 'v':
        cart.row++;
    }
    cart.setNewDir(grid[cart.row][cart.col]);
  }

  bool collides(Cart cart1, Cart cart2) {
    return cart1.col == cart2.col && cart1.row == cart2.row;
  }

  bool isCrash(Cart cart) {
    for (final cartToCheck in carts) {
      if (cart != cartToCheck) {
        if (cartToCheck.col == cart.col && cartToCheck.row == cart.row) {
          return true;
        }
      }
    }
    return false;
  }

  findPosOfLastRemainingCart() {
    // Sort the carts by position so we always pick the cart that
    // is in row closest to the top. Or leftmost if both are on the same row
    while (true) {
      carts.sort((a, b) {
        int c = a.row.compareTo(b.row);
        return c != 0 ? c : a.col.compareTo(b.col);
      });

      // Move the carts
      List<Cart> movedCarts = [];
      while (carts.isNotEmpty) {
        final currentCart = carts.removeAt(0);
        moveCart(currentCart);

        // Check if it collides with the carts not yet moved
        final collidingNotMovedCart = findCollision(currentCart, carts);
        if (collidingNotMovedCart == null) {
          // No collision. Check if it is colliding with the already moved carts
          final collidingMovedCart = findCollision(currentCart, movedCarts);
          if (collidingMovedCart == null) {
            // No collision with the remaining carts either. Keep this cart
            movedCarts.add(currentCart);
          } else {
            movedCarts.remove(collidingMovedCart);
          }
        } else {
          // Collision with not yet moved carts
          carts.remove(collidingNotMovedCart);
        }
        // Add the cart to the moved carts list
      }

      if (movedCarts.length == 1) {
        return (movedCarts.first.row, movedCarts.first.col);
      } else {
        carts = movedCarts;
      }
    }
  }

  Cart? findCollision(Cart cart, List<Cart> cartsToCheck) {
    // First check the carts that hasnt moved yet
    for (final cartToCheck in cartsToCheck) {
      if (cartToCheck.col == cart.col && cartToCheck.row == cart.row) {
        return cartToCheck;
      }
    }

    return null;
  }
}

String resultP1() {
  final board = Board(problem.getInput());
  final (row, col) = board.findCrashPos();
  return "$col,$row";
}

String resultP2() {
  final board = Board(problem.getInput());
  final (row, col) = board.findPosOfLastRemainingCart();
  return "$col,$row";
}
