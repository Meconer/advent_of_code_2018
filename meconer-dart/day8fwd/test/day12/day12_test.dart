import 'package:day8fwd/day12/day12.dart';
import 'package:test/test.dart';

void main() {
  test('Count plants', () {
    expect(countPlants("...#..."), 1);
    expect(countPlants("..."), 0);
    expect(countPlants("...###"), 6);
    expect(countPlants("..#."), -1);
    expect(countPlants(".#.."), -2);
  });
}
