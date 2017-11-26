import "package:test/test.dart";
import 'package:mockito/mockito.dart';

import 'dart:math';

import "../lib/dice_parser.dart";
import "../lib/dice_roller.dart";


class MockRandom extends Mock implements Random {}

void main() {
  var mockRandom = new MockRandom();
  var roller = new DiceRoller(mockRandom);
  var p = new DiceParser(roller).parser;

  when(mockRandom.nextInt(argThat(inInclusiveRange(1, 1000)))).thenReturn(1);

  test("dice parser - addition", () {
    var input = "1 + 20";
    expect(p.parse(input).value, equals(21));
  });

  test("dice parser - multi", () {
    var input = "3 * 2";
    expect(p.parse(input).value, equals(6));
  });

  test("dice parser - parens", () {
    var input = "(5 + 6) * 2";
    expect(p.parse(input).value, equals(22));
  });

  test("dice parser - order of operations", () {
    var input = "5 + 6 * 2";
    expect(p.parse(input).value, equals(17));
  });

  test("dice parser - simple roll", () {
    var input = "1d6";
    expect(p.parse(input).value, equals(2));
  });
}