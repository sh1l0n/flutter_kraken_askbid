//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_ddbb package
//

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import 'exchange.dart';
import 'order.dart';
import 'order_book.dart';

class DatabaseHelper {
  static final String name = 'books.db';

  static final DatabaseHelper _singleton = DatabaseHelper._internal();
  factory DatabaseHelper() {
    return _singleton;
  }

  DatabaseHelper._internal() {
    _isOpen = false;
  }

  Database _db;
  bool _isOpen;

  Future<void> initialize() async {
    await deleteDatabase(await databasePath());
    await _openDatabase();
    await _db.execute(OrderWrapperProvider.create);
    await _db.execute(OrderBookWrapperProvider.create);
    await _db.execute(ExchangeWrapperProvider.create);
    await close();
  }

  Future<String> databasePath() async {
    var databasesPath = await getDatabasesPath();
    final path = databasesPath + '/' + DatabaseHelper.name;
    return path;
  }

  Future<void> _openDatabase() async {
    var completer = Completer<void>();
    _db = await openDatabase(await databasePath(), version: 1,
        onOpen: (Database db) async {
      _isOpen = true;
      completer.complete(null);
    });

    return completer.future;
  }

  Future<bool> close() async {
    if (_isOpen) {
      await _db.close();
      _isOpen = false;
    }
    return !_isOpen;
  }

  Future<bool> _checkDatabaseState() async {
    if (!_isOpen) {
      await _openDatabase();
    }
    return _isOpen;
  }

  Future<int> insert(
      final String table, final Map<String, dynamic> values) async {
    if (await _checkDatabaseState()) {
      return await _db.insert(table, values);
    }
    return -1;
  }

  Future<bool> exists(final String table,
      {@required final String where, @required final List whereArgs}) async {
    if (await _checkDatabaseState()) {
      final e = await _db.query(table, where: where, whereArgs: whereArgs);
      return e.isNotEmpty;
    }
    return false;
  }

  Future<Map<String, dynamic>> get(final String table,
      {@required final String where, @required final List whereArgs}) async {
    if (await _checkDatabaseState()) {
      final items = await _db.query(table, where: where, whereArgs: whereArgs);
      if (items.isNotEmpty) {
        return items.first;
      }
    }
    return null;
  }

  Future<int> update(final String table, final Map<String, dynamic> values,
      {@required final String where, @required final List whereArgs}) async {
    if (await _checkDatabaseState()) {
      return await _db.update(table, values,
          where: where, whereArgs: whereArgs);
    }
    return -1;
  }

  Future<int> delete(final String table,
      {@required final String where, @required final List whereArgs}) async {
    if (await _checkDatabaseState()) {
      return await _db.delete(table, where: where, whereArgs: whereArgs);
    }
    return -1;
  }
}
