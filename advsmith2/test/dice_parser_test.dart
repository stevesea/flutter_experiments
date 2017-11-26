import "package:test/test.dart";
import 'package:mockito/mockito.dart';

import 'dart:math';

import "../lib/dice_parser.dart";
import "../lib/dice_roller.dart";

import 'package:petitparser/petitparser.dart';


class MockRandom extends Mock implements Random {}

void main() {
  var mockRandom = new MockRandom();
  var roller = new DiceRoller(mockRandom);
  var p = new DiceParser(roller).evaluator;

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
    var result = p.parse(input);
    expect(result.value, equals(2));
  });

  test ("asdf", () {
    var number = digit().plus().flatten().trim().map(int.parse);

    var dice = number.seq(char('d').trim()).seq(number).flatten().trim().map((values) {
      return roller.roll(int.parse(values[0]), int.parse(values[2]));
    });

    var numOrDice = number | dice;
    var parser = numOrDice.end();
    expect(parser.parse("6").value, 6);
    expect(parser.parse("1d6").value, 2);
  });
}