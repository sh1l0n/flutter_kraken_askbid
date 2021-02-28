//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_ddbb package
//

import 'package:lib_model/order_book.dart';

import 'database_helper.dart';

class OrderBookWrapperProvider {
  static String get table => '_order_book';

  static String get create =>
      '''CREATE TABLE ${OrderBookWrapperProvider.table} ( 
    ${OrderBookWrapper.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${OrderBookWrapper.bidsColumn} TEXT NOT NULL, 
    ${OrderBookWrapper.asksColumn} TEXT NOT NULL);
  ''';

  static Future<int> insert() async {
    return await DatabaseHelper().insert(
        OrderBookWrapperProvider.table, OrderBookWrapper([], []).toJson());
  }
}
