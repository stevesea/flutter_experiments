import 'package:dart_dice_parser/dart_dice_parser.dart';

class Shuffler {
  DiceParser diceParser;

  Shuffler([DiceParser dp]) {
    diceParser = dp ?? new DiceParser();
  }

  T pick<T>(Iterable<T> items) {
    // use modulo in case random is a mock that's configured to return
    // a nextInt which is longer than the total # of items in the collection
    var index = diceParser.roller.random.nextInt(items.length) % items.length;
    return items.elementAt(index);
  }

  List<T> pickN<T>(Iterable<T> items, int n) {
    if (n <= 0)
      return [];

    var shallowCopy = new List.from(items);
    shallowCopy.shuffle(diceParser.roller.random);
    return shallowCopy.take(n);
  }

  V pickMap<K,V>(Map<K,V> itemMap) {
    var keys = itemMap.keys;
    var index = diceParser.roller.random.nextInt(keys.length) % keys.length;

    var k = keys.elementAt(index);

    return itemMap[k];
  }
}