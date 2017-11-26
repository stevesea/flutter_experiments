import 'package:petitparser/petitparser.dart';
import 'dice_roller.dart';

class DiceExpressionGrammar extends GrammarParser {
  DiceExpressionGrammar() : super(const DiceExpressionGrammarDefinition());
}

class DiceExpressionParser extends GrammarParser {
  DiceExpressionParser() : super(const DiceExpressionParserDefinition());
}

class DiceExpressionGrammarDefinition extends GrammarDefinition {
  const DiceExpressionGrammarDefinition();

  start() => ref(terms).end();
  terms() => ref(addition) | ref(factors);

  addition() => ref(factors).separatedBy(token(char('+') | char('-')));
  factors() => ref(multiplication) | ref(power);

  multiplication() => ref(power).separatedBy(token(char('*') | char('/')));
  power() => ref(primary).separatedBy(char('^').trim());

  primary() => ref(number) | ref(parentheses);
  number() => token(digit().plus());

  parentheses() => token('(') & ref(terms) & token(')');
  token(value) => value is String ? char(value).trim() : value.flatten().trim();
}

/// JSON parser definition.
class DiceExpressionParserDefinition extends DiceExpressionGrammarDefinition {
  const DiceExpressionParserDefinition();

  number() => super.number().map(int.parse);
}

class DiceParser {
  DiceRoller _roller;
  Parser parser;

  DiceParser(DiceRoller roller) {
    if (roller == null)
      _roller = new DiceRoller.secure();
    else
      _roller = roller;

    parser = new DiceExpressionParser();
  }
}
