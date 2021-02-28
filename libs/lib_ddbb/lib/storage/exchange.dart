//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_ddbb package
//

import 'package:lib_model/order.dart';
import 'package:lib_model/order_book.dart';
import 'package:lib_model/exchange.dart';

import 'database_helper.dart';
import 'order.dart';
import 'order_book.dart';

class ExchangeWrapperProvider {
  static String get table => '_exchanges';

  static String get create =>
      '''CREATE TABLE ${ExchangeWrapperProvider.table} ( 
    ${ExchangeWrapper.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${ExchangeWrapper.nameColumn} TEXT UNIQUE NOT NULL,
    ${ExchangeWrapper.orderBookColumn} INTEGER NOT NULL);
  ''';

  static Future<int> insert(ExchangeWrapper todo) async {
    return await DatabaseHelper()
        .insert(ExchangeWrapperProvider.table, todo.toJson());
  }

  static Future<bool> insertWithName(final String name) async {
    var exists = await DatabaseHelper().get(ExchangeWrapperProvider.table,
        where: '${ExchangeWrapper.nameColumn} = ?', whereArgs: [name]);

    if (exists == null) {
      final orderBookId = await OrderBookWrapperProvider.insert();
      final exchange = ExchangeWrapper(name, orderBookId);
      await ExchangeWrapperProvider.insert(exchange);
    }
    return false;
  }

  static Future<void> update(
      final String name, final OrderWrapper bid, final OrderWrapper ask) async {
    var realId = name;

    // Create exchange if not found
    var exists = await DatabaseHelper().get(ExchangeWrapperProvider.table,
        where: '${ExchangeWrapper.nameColumn} = ?', whereArgs: [realId]);

    ExchangeWrapper exchange;
    if (exists == null) {
      await ExchangeWrapperProvider.insertWithName(name);
    } else {
      exchange = ExchangeWrapper.fromMap(exists);
    }

    // Update orderbook
    final bidId = await OrderWrapperProvider.insert(bid);
    final askId = await OrderWrapperProvider.insert(ask);

    final current = await ExchangeWrapperProvider.getOrderBook(name);
    final newBook =
        OrderBookWrapper(current.bids + [bidId], current.asks + [askId]);

    await DatabaseHelper().update(
        OrderBookWrapperProvider.table, newBook.toJson(),
        where: '${OrderBookWrapper.idColumn} = ?',
        whereArgs: [exchange.orderBook]);
  }

  static Future<OrderBookWrapper> getOrderBook(final String name) async {
    final _exchange = await DatabaseHelper().get(ExchangeWrapperProvider.table,
        where: '${ExchangeWrapper.nameColumn} = ?', whereArgs: [name]);
    if (_exchange == null) {
      return null;
    }
    final exchange = ExchangeWrapper.fromMap(_exchange);
    ;
    var _current = await DatabaseHelper().get(OrderBookWrapperProvider.table,
        where: '${OrderBookWrapper.idColumn} = ?',
        whereArgs: [exchange.orderBook]);

    final current = OrderBookWrapper.fromMap(_current, id: exchange.orderBook);
    return current;
  }

  static Future<void> cleanOrders(final String name) async {
    final orderbook = await getOrderBook(name);
    for (final orderId in orderbook.asks) {
      await OrderWrapperProvider.delete(orderId);
    }
    for (final orderId in orderbook.bids) {
      await OrderWrapperProvider.delete(orderId);
    }

    await DatabaseHelper().update(
        OrderBookWrapperProvider.table, OrderBookWrapper([], []).toJson(true),
        where: '${OrderBookWrapper.idColumn} = ?', whereArgs: [orderbook.id]);
  }

  static Future<List<OrderWrapper>> getBids(final String name) async {
    final orderbook = await getOrderBook(name);
    // ignore: omit_local_variable_types
    List<OrderWrapper> values = [];
    for (final int orderId in orderbook.bids) {
      final data = await OrderWrapperProvider.get(orderId);
      if (data != null) {
        values += [data];
      }
    }
    return values;
  }

  static Future<List<OrderWrapper>> getAsks(final String name) async {
    final orderbook = await getOrderBook(name);
    // ignore: omit_local_variable_types
    List<OrderWrapper> values = [];
    for (final orderId in orderbook.asks) {
      final data = await OrderWrapperProvider.get(orderId);
      if (data != null) {
        values += [data];
      }
    }
    return values;
  }
}
