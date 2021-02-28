//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_model package
//

import 'dart:convert';

class ExchangeWrapper {
  const ExchangeWrapper(this.name, this.orderBook, [this.id = -1]);
  final String name;
  final int orderBook;
  final int id;

  static String get idColumn => 'id';
  static String get nameColumn => 'name';
  static String get orderBookColumn => 'order_book';

  Map<String, dynamic> toJson() => {
        ExchangeWrapper.nameColumn: name,
        ExchangeWrapper.orderBookColumn: orderBook
      };

  static ExchangeWrapper fromMap(final Map<String, dynamic> data) {
    final name = data[ExchangeWrapper.nameColumn] as String;
    final orderBook = data[ExchangeWrapper.orderBookColumn] as int;
    final id = data[ExchangeWrapper.idColumn] as int;
    return ExchangeWrapper(name, orderBook, id);
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}