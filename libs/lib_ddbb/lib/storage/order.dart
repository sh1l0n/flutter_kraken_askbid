//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_ddbb package
//

import 'package:lib_model/order.dart';

import 'database_helper.dart';

class OrderWrapperProvider {
  static String get table => '_order';

  static String get create => '''CREATE TABLE ${OrderWrapperProvider.table} (
    ${OrderWrapper.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${OrderWrapper.timestampColumn} INTEGER NOT NULL,
    ${OrderWrapper.priceColumn} REAL NOT NULL,
    ${OrderWrapper.amountColumn} REAL NOT NULL);
  ''';

  static Future<int> insert(final OrderWrapper todo) async {
    return await DatabaseHelper()
        .insert(OrderWrapperProvider.table, todo.toJson());
  }

  static Future<OrderWrapper> get(final int id) async {
    var _order = await DatabaseHelper().get(OrderWrapperProvider.table,
        where: '${OrderWrapper.idColumn} = ?', whereArgs: [id]);

    if (_order != null) {
      return OrderWrapper.fromMap(_order);
    }
    return null;
  }

  static Future<int> delete(final int id) async {
    return await DatabaseHelper().delete(OrderWrapperProvider.table,
        where: '${OrderWrapper.idColumn} = ?', whereArgs: [id]);
  }
}
