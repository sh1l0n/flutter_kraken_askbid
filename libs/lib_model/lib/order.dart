//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_model package
//

import 'dart:convert';

class OrderWrapper {
  const OrderWrapper(this.price, this.amount, this.timestamp);
  final double price;
  final double amount;
  final int timestamp;

  static String get idColumn => 'idColumn';
  static String get priceColumn => 'price';
  static String get amountColumn => 'amount';
  static String get timestampColumn => 'timestamp';

  Map<String, dynamic> toJson() =>
      {priceColumn: price, amountColumn: amount, timestampColumn: timestamp};

  static OrderWrapper fromMap(final Map<String, dynamic> data) {
    final price = data[OrderWrapper.priceColumn] as double;
    final amount = data[OrderWrapper.amountColumn] as double;
    final timestamp = data[OrderWrapper.timestampColumn] as int;
    return OrderWrapper(price, amount, timestamp);
  }

  static OrderWrapper fromJson(final List data) {
    if (data.length != 3) {
      return null;
    }
    if (!(data[0] is String) && !(data[1] is String)) {
      return null;
    }

    final price = data[0] as String;
    final amount = data[1] as String;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return OrderWrapper(
        double.tryParse(price) ?? 0, double.tryParse(amount) ?? 0, timestamp);
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}