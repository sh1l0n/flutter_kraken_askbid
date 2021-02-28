//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_ddbb package
//

import 'dart:math';

import 'package:lib_ddbb/storage/exchange.dart';

import 'package:lib_model/order.dart';

class KrakenMemoryCache {
  static final KrakenMemoryCache _singleton = KrakenMemoryCache._internal();
  factory KrakenMemoryCache() {
    return _singleton;
  }

  KrakenMemoryCache._internal() {
    _bids = [];
    _asks = [];
    _maxValueY = 0;
  }

  List<OrderWrapper> _bids;
  List<OrderWrapper> get bids => _bids;

  List<OrderWrapper> _asks;
  List<OrderWrapper> get asks => _asks;

  double _maxValueY;
  double get maxValueY => _maxValueY;

  void update({final OrderWrapper bid, final OrderWrapper ask}) {
    if (bid != null) {
      _bids += [bid];
    }
    if (asks != null) {
      _asks += [ask];
    }

    final kMax = max(bid.amount, ask.amount);
    if (kMax * 0.8 > _maxValueY) {
      _maxValueY = kMax * 1.3;
    }
  }

  Future<void> clean() async {
    await ExchangeWrapperProvider.cleanOrders('kraken');
    bids.clear();
    asks.clear();
    _maxValueY = 0;
  }
}
