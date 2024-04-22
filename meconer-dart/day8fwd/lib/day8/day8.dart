import '../util/util.dart';

class Problem {
  bool isExample;
  int dayNo;

  Problem({this.isExample = false, this.dayNo = 8});

  String getInput() {
    if (isExample) return "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2";
    String dirName = 'lib/day$dayNo/';
    String fileName = dirName + (isExample ? 'example.txt' : 'input.txt');
    return readInputAsString(fileName);
  }
}

Problem problem = Problem(isExample: false);

int resultP1() {
  final input = problem.getInput();
  final numbers = input.split(' ').map((e) => int.parse(e)).toList();
  final sum = sumMetaData(numbers);
  return sum;
}

int sumMetaData(List<int> numbers) {
  int noOfChildNodes = numbers.removeAt(0);
  int noOfMetaDataEntries = numbers.removeAt(0);

  int metaDataSum = 0;

  for (int childNodeNo = 0; childNodeNo < noOfChildNodes; childNodeNo++) {
    metaDataSum += sumMetaData(numbers);
  }

  for (int metaDataNo = 0; metaDataNo < noOfMetaDataEntries; metaDataNo++) {
    metaDataSum += numbers.removeAt(0);
  }
  return metaDataSum;
}

int resultP2() {
  final input = problem.getInput();
  final numbers = input.split(' ').map((e) => int.parse(e)).toList();
  final val = calcValue(numbers);
  return val;
}

int calcValue(List<int> numbers) {
  int noOfChildNodes = numbers.removeAt(0);
  int noOfMetaDataEntries = numbers.removeAt(0);

  int value = 0;
  List<int> values = [];
  for (int childNodeNo = 0; childNodeNo < noOfChildNodes; childNodeNo++) {
    values.add(calcValue(numbers));
  }
  if (noOfChildNodes == 0) {
    for (int metaDataNo = 0; metaDataNo < noOfMetaDataEntries; metaDataNo++) {
      value += numbers.removeAt(0);
    }
  } else {
    for (int metaDataNo = 0; metaDataNo < noOfMetaDataEntries; metaDataNo++) {
      final index = numbers.removeAt(0) - 1;
      if (index < values.length) value += values[index];
    }
  }
  return value;
}
