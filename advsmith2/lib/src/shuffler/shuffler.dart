import 'package:dart_dice_parser/dart_dice_parser.dart';
import 'package:quiver/check.dart';

import 'dart:math';

//
class Shuffler {
  Random _random;
  DiceParser diceParser;

  Shuffler([DiceParser dp]) {
    diceParser = dp ?? new DiceParser();
    _random = diceParser.roller.random;
  }

  /// pick an item at random from the iterable
  T pick<T>(Iterable<T> items) {
    checkNotNull(items);
    // use modulo in case random is a mock that's configured to return
    // a nextInt which is longer than the total # of items in the collection
    var index = _random.nextInt(items.length) % items.length;
    return items.elementAt(index);
  }

  /// pick N unique items from the iterable. if n > items.length, will only returned items.length items
  List<T> pickN<T>(Iterable<T> items, int n) {
    checkNotNull(items);
    if (n <= 0)
      return [];

    var shallowCopy = new List.from(items);
    shallowCopy.shuffle(_random);
    return shallowCopy.take(n);
  }

  /// pick an item from the iterable, use the submitted dice expression to pick the item
  T pickD<T>(String diceStr, Iterable<T> items) {
    // dice are 1-based, list indexes are 0-based so subtract 1.
    var ind = diceParser.roll(diceStr) - 1;
    // then clamp the dice roll to the acceptable range
    ind = min(items.length - 1, ind);
    ind = max(0, ind);
    return items.elementAt(ind);
  }

  /// pick an value at random from the map
  V pickMap<K,V>(Map<K,V> itemMap) {
    checkNotNull(itemMap);
    var keys = itemMap.keys;
    var index = _random.nextInt(keys.length) % keys.length;

    var k = keys.elementAt(index);

    return itemMap[k];
  }

  List<V> pickMapN<K,V>(Map<K,V> itemMap, int n) {
    checkNotNull(itemMap);
    if (n <= 0)
      return [];
    var keys = itemMap.keys;
    // pick N unique keys from map

    var pickedKeys = pickN(itemMap.keys, n);
    return pickedKeys.map((key) => itemMap[key]);
  }


}