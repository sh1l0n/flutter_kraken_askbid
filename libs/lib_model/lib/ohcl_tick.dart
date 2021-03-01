//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_model package
//

import 'dart:convert';

class OHCLDataWrapper {
  const OHCLDataWrapper(this.timestamp, this.open, this.high, this.low,
      this.close, this.vwap, this.volume, this.count);
  final int timestamp;
  final double open;
  final double high;
  final double low;
  final double close;
  final double vwap;
  final double volume;
  final int count;
  Map<String, dynamic> toJson() => {
        'open': open,
        'high': high,
        'low': low,
        'close': close,
        'vwap': vwap,
        'volume': volume,
        'count': count
      };

  static OHCLDataWrapper fromJson(final List data) {
    final timestamp = data[0] as int;
    final open = data[1] as String;
    final high = data[2] as String;
    final low = data[3] as String;
    final close = data[4] as String;
    final vwap = data[5] as String;
    final volume = data[6] as String;
    final count = data[7] as int;

    return OHCLDataWrapper(
        timestamp,
        int.tryParse(open) ?? 0,
        int.tryParse(high) ?? 0,
        int.tryParse(low) ?? 0,
        int.tryParse(close) ?? 0,
        int.tryParse(vwap) ?? 0,
        int.tryParse(volume) ?? 0,
        count);
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}