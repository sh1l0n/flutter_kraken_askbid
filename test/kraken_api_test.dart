
//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of Flutter-Kraken project
//

import 'package:flutter_test/flutter_test.dart' as test;

import 'package:lib_requests/kraken_api.dart';
import 'package:lib_model/order.dart';

void main() async {

  test.test('Order book retrevieng', () async {
    final n = 1;
    final book = await KrakenApi().getBooks(KrakenAssetPair.xbtusd, n);   
     
    test.expect(book, test.isNotNull, reason: 'book is null');
    test.expect(book.bid, test.isNotNull, reason: 'bid is null');
    test.expect(book.ask, test.isNotNull, reason: 'ask is null');
  });

  test.test('Order book wrapper to json', () async {
      final json = ['123423901.1123', '1231239', '1822120200000'];
      final order = OrderWrapper.fromJson(json);
      test.expect(order.price, double.parse(json[0]), reason: 'Price not decoded');
      test.expect(order.amount, double.parse(json[1]), reason: 'Amount not decoded');
      test.expect(OrderWrapper.fromJson([]), test.isNull, reason: 'cannot create from empty json');
      test.expect(OrderWrapper.fromJson([123213, 12321, 'adasd']), test.isNull,
        reason: 'cannot create from wrong json');
         test.expect(OrderWrapper.fromJson(['adasd', 'adasd', 'adasd', 'adasd']), test.isNull,
        reason: 'cannot create from wrong json');
  });
}
