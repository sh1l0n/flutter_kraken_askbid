// Imports the Flutter Driver API.

import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lib_ddbb/storage/exchange.dart';
import 'package:lib_model/order.dart';
import 'package:flutter_kraken/main.dart' as app;

void main() {
  enableFlutterDriverExtension();
  
  group('Flutter Kraken App', () {
    test('Database create orders', () async {
        await app.initializeDatabase();
        final exchangeNameId = 'test-exchange';
        final id = await ExchangeWrapperProvider.insertWithName(exchangeNameId);
        expect(id, isNotNull, reason: 'cannot create exchange');
        var orderBook = await ExchangeWrapperProvider.getOrderBook(exchangeNameId);
        expect(orderBook, isNotNull, reason: 'cannot retrieve orderbook');
        expect(orderBook.bids, isNotNull, reason: 'cannot retrieve bids');
        expect(orderBook.asks, isNotNull, reason: 'cannot retrieve asks');
        expect(orderBook.bids.length, 0, reason: 'bids must be empty');
        expect(orderBook.asks.length, 0, reason: 'asks must be empty');

        final k = 5;
        for (var i=0; i<k; i++) {
          await ExchangeWrapperProvider.update(exchangeNameId, OrderWrapper(19.0, 10.0, 5), OrderWrapper(17.0, 20.0, 5));
        }
        orderBook =
            await ExchangeWrapperProvider.getOrderBook(exchangeNameId);
        expect(orderBook.bids.length, k, reason: 'bids length must be $k');
        expect(orderBook.asks.length, k, reason: 'asks length must be $k');

        await ExchangeWrapperProvider.cleanOrders(exchangeNameId);
        orderBook = await ExchangeWrapperProvider.getOrderBook(exchangeNameId);
        expect(orderBook.bids.length, 0, reason: 'bids must be empty');
        expect(orderBook.asks.length, 0, reason: 'asks must be empty');
    });
  });
}
