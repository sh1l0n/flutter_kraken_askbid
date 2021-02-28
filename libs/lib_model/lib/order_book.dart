//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_model package
//

import 'dart:convert';

class OrderBookWrapper {
  const OrderBookWrapper(this.bids, this.asks, [this.id = -1]);
  final List<int> bids;
  final List<int> asks;
  final int id;

  static String get idColumn => 'id';
  static String get bidsColumn => 'bids';
  static String get asksColumn => 'asks';

  Map<String, dynamic> toJson([bool showId = false]) => {
        OrderBookWrapper.bidsColumn: jsonEncode(bids),
        OrderBookWrapper.asksColumn: jsonEncode(asks)
      };

  static OrderBookWrapper fromMap(final Map<String, dynamic> data,
      {final int id}) {
    final _bids = jsonDecode(data[OrderBookWrapper.bidsColumn]) as List;
    final _asks = jsonDecode(data[OrderBookWrapper.asksColumn]) as List;
    // ignore: omit_local_variable_types
    List<int> bids = [];
    _bids.forEach((element) {
      final d =
          (element is int) ? element : int.tryParse(element as String) ?? -1;
      if (d != -1) {
        bids += [d];
      }
    });
    // ignore: omit_local_variable_types
    List<int> asks = [];
    _asks.forEach((element) {
      final d =
          (element is int) ? element : int.tryParse(element as String) ?? -1;
      if (d != -1) {
        asks += [d];
      }
    });

    return OrderBookWrapper(bids, asks, id ?? -1);
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}