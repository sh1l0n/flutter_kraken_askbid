//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_model package
//

import 'dart:convert';

import 'order.dart';

class OrderBookUpdateWrapper {
  const OrderBookUpdateWrapper(this.bid, this.ask);
  final OrderWrapper bid;
  final OrderWrapper ask;
  Map<String, dynamic> toJson() => {'bid': bid.toJson(), 'ask': ask.toJson()};

  static OrderBookUpdateWrapper fromMap(final Map<String, dynamic> data) {
    final bid = OrderWrapper.fromMap(data['bid'] as Map<String, dynamic>);
    final ask = OrderWrapper.fromMap(data['ask'] as Map<String, dynamic>);
    return OrderBookUpdateWrapper(bid, ask);
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
